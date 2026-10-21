import tempfile
import time
import unittest
from concurrent.futures import ThreadPoolExecutor
from datetime import date, timedelta
from pathlib import Path
from .database import Database
from .examples import initialize_examples
from .pricing import read_quote, sign_quote
from .test_workspace import vehicle
from .validation import ApiError


class OperationsTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.db = Database(Path(self.temp.name) / 'real.sqlite3')
        self.v = self.db.save_vehicle(vehicle())
        first = date.today() + timedelta(days=1)
        self.body = dict(vehicle_id=self.v['id'], starts_on=first.isoformat(),
                         ends_on=(first + timedelta(days=2)).isoformat())

    def test_publication_preserves_history_and_prevents_booking(self):
        reservation = self.db.reserve(self.body, 'first')
        self.db.publish(self.v['id'], {'published': False})
        self.assertEqual(self.db.vehicles(), [])
        self.assertEqual(len(self.db.vehicles(include_maintenance=True)), 1)
        self.assertEqual(self.db.reservations()[0]['id'], reservation['id'])
        self.db.cancel(reservation['id'])
        with self.assertRaises(ApiError):
            self.db.quote(self.body)
        with self.assertRaises(ApiError):
            self.db.reserve(self.body, 'unpublished')
        self.db.publish(self.v['id'], {'published': True})
        self.assertEqual(len(self.db.vehicles()), 1)

    def test_blocks_enforce_availability_release_and_object_scope(self):
        block = self.db.block(self.v['id'], {k: v for k, v in dict(self.body, reason='Bakım').items() if k != 'vehicle_id'})
        self.assertEqual(self.db.vehicles(start=self.body['starts_on'], end=self.body['ends_on']), [])
        with self.assertRaises(ApiError):
            self.db.quote(self.body)
        with self.assertRaises(ApiError):
            self.db.reserve(self.body, 'blocked')
        other = self.db.save_vehicle(vehicle())
        with self.assertRaises(ApiError):
            self.db.release_block(other['id'], block['id'])
        self.db.release_block(self.v['id'], block['id'])
        self.assertEqual(self.db.calendar(self.v['id'])['blocks'], [])
        self.db.reserve(self.body, 'open')
        with self.assertRaises(ApiError):
            self.db.block(self.v['id'], dict(starts_on=self.body['starts_on'], ends_on=self.body['ends_on'], reason='Bakım'))

    def test_block_and_reservation_race_has_exactly_one_winner(self):
        def attempt(index):
            try:
                if index % 2:
                    self.db.reserve(self.body, f'race-{index}')
                else:
                    self.db.block(self.v['id'], dict(starts_on=self.body['starts_on'],
                        ends_on=self.body['ends_on'], reason='Bakım'))
                return True
            except ApiError as error:
                self.assertEqual(error.code, 'conflict')
                return False
        with ThreadPoolExecutor(max_workers=6) as pool:
            self.assertEqual(sum(pool.map(attempt, range(6))), 1)

    def test_quote_price_change_expiry_and_idempotent_retry(self):
        quote = self.db.quote(self.body)
        self.assertEqual(quote['total_minor'], 246912)
        expired = dict(quote, expires_at=int(time.time()) - 1)
        with self.assertRaises(ApiError):
            self.db.reserve(self.body, 'expired', quote=expired)
        self.db.save_vehicle(dict(vehicle(), rate_minor=300000), self.v['id'])
        with self.assertRaises(ApiError):
            self.db.reserve(self.body, 'changed', quote=quote)
        new = self.db.quote(self.body)
        record = self.db.reserve(self.body, 'new', quote=new)
        self.assertEqual(record['total_minor'], 600000)
        self.assertEqual(self.db.reserve(self.body, 'new', quote=expired)['id'], record['id'])

    def test_quote_signature_body_and_workspace_binding(self):
        quote = self.db.quote(self.body)
        token = sign_quote(quote, 'workspace-one')
        self.assertEqual(read_quote(token, self.body, 'workspace-one'), quote)
        for bad_token, body, key in [(token + '0', self.body, 'workspace-one'),
                (token, dict(self.body, vehicle_id='other'), 'workspace-one'),
                (token, self.body, 'workspace-two'), ('bad', self.body, 'workspace-one')]:
            with self.assertRaises(ApiError):
                read_quote(bad_token, body, key)

    def test_examples_are_separate_persistent_and_never_reseed_mutations(self):
        path = Path(self.temp.name) / 'examples.sqlite3'
        examples = initialize_examples(path)
        self.assertEqual(len(examples.vehicles(include_maintenance=True)), 10)
        self.assertEqual(len(examples.vehicles()), 8)
        self.assertEqual(len(examples.reservations()), 6)
        self.assertTrue(all(v['example'] for v in examples.vehicles()))
        examples.publish('example-aster', {'published': False})
        examples.cancel('example-plan-1')
        restored = initialize_examples(path)
        self.assertEqual(len(restored.vehicles()), 7)
        record = next(r for r in restored.reservations() if r['id'] == 'example-plan-1')
        self.assertEqual(record['status'], 'cancelled')
        self.assertEqual(len(self.db.vehicles()), 1)
        self.assertEqual(self.db.reservations(), [])
