import http.client
import json
import tempfile
import threading
import unittest
from concurrent.futures import ThreadPoolExecutor
from datetime import date, timedelta
from pathlib import Path
from .database import Database
from .http_server import Server
from .validation import ApiError


def vehicle():
    return dict(name='Test vehicle', category='Sedan', energy='Elektrik', seats=5,
                rate_minor=123456, ownership='private', description='Test-only record.',
                photo_url='', status='active')


class DatabaseTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.db = Database(Path(self.temp.name) / 'test.sqlite3')
        self.v = self.db.save_vehicle(vehicle())
        first = date.today() + timedelta(days=1)
        self.body = dict(vehicle_id=self.v['id'], starts_on=first.isoformat(),
                         ends_on=(first + timedelta(days=2)).isoformat())

    def test_existing_records_survive_reinitialization(self):
        record = self.db.reserve(self.body, 'original')
        restored = Database(self.db.path)
        self.assertEqual(restored.vehicles()[0], self.v)
        self.assertEqual(restored.reservations()[0]['id'], record['id'])
        self.assertEqual(record['total_minor'], 246912)

    def test_concurrent_allocation_is_atomic(self):
        def attempt(i):
            try:
                return self.db.reserve(self.body, str(i))['id']
            except ApiError as error:
                self.assertEqual(error.code, 'conflict')
                return None
        with ThreadPoolExecutor(max_workers=6) as pool:
            results = list(pool.map(attempt, range(6)))
        self.assertEqual(sum(r is not None for r in results), 1)
        self.assertEqual(len(self.db.reservations()), 1)

    def test_idempotency_cancel_and_availability(self):
        record = self.db.reserve(self.body, 'stable-key')
        self.assertEqual(self.db.reserve(self.body, 'stable-key')['id'], record['id'])
        self.assertEqual(self.db.vehicles(start=self.body['starts_on'], end=self.body['ends_on']), [])
        changed = dict(self.body, ends_on=(date.fromisoformat(self.body['ends_on']) + timedelta(days=1)).isoformat())
        with self.assertRaises(ApiError):
            self.db.reserve(changed, 'stable-key')
        self.assertEqual(self.db.cancel(record['id'])['status'], 'cancelled')
        self.assertEqual(self.db.cancel(record['id'])['status'], 'cancelled')
        self.assertEqual(len(self.db.vehicles(start=self.body['starts_on'], end=self.body['ends_on'])), 1)
        self.db.reserve(self.body, 'second')
        self.assertEqual(len(self.db.reservations()), 2)

    def test_maintenance_money_and_dates_fail_closed(self):
        body = vehicle()
        body['status'] = 'maintenance'
        self.db.save_vehicle(body, self.v['id'])
        self.assertEqual(self.db.vehicles(), [])
        self.assertEqual(len(self.db.vehicles(include_maintenance=True)), 1)
        with self.assertRaises(ApiError):
            self.db.reserve(self.body, 'maintenance')
        for invalid in [dict(self.body, total_minor=1), dict(self.body, ends_on=self.body['starts_on'])]:
            with self.assertRaises(ApiError):
                self.db.reserve(invalid, 'invalid')
        for money in [True, -1, 0, 12.4]:
            body = vehicle()
            body['rate_minor'] = money
            with self.assertRaises(ApiError):
                self.db.save_vehicle(body)


class HttpTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.key = 'test-only-key-012345678901234567890'
        self.server = Server(('127.0.0.1', 0), Database(Path(self.temp.name) / 'http.sqlite3'),
                             self.key, 'http://localhost:8080')
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.stop)

    def stop(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=2)

    def request(self, method, path, body=None, headers=None):
        conn = http.client.HTTPConnection('127.0.0.1', self.server.server_port, timeout=3)
        headers = dict(headers or {})
        raw = None
        if body is not None:
            raw = json.dumps(body)
            headers['Content-Type'] = 'application/json'
        conn.request(method, '/api/v1/' + path, raw, headers)
        response = conn.getresponse()
        data = response.read()
        result = response.status, dict(response.headers), json.loads(data) if data else None
        conn.close()
        return result

    def test_inventory_is_empty_and_private_routes_require_key(self):
        self.assertEqual(self.request('GET', 'vehicles')[2], {'vehicles': []})
        self.assertEqual(self.request('GET', 'workspace')[0], 401)
        self.assertEqual(self.request('GET', 'reservations')[0], 401)
        self.assertEqual(self.request('POST', 'vehicles', vehicle())[0], 401)
        status, headers, body = self.request('POST', 'vehicles', vehicle(), {'Authorization': 'Bearer ' + self.key})
        self.assertEqual(status, 201)
        self.assertEqual(headers['Cache-Control'], 'no-store')
        self.assertNotIn(self.key, json.dumps(body))

    def test_origin_host_and_malformed_body(self):
        self.assertEqual(self.request('GET', 'vehicles', headers={'Origin': 'https://untrusted.invalid'})[0], 403)
        self.assertEqual(self.request('GET', 'vehicles', headers={'Host': 'untrusted.invalid'})[0], 403)
        self.assertEqual(self.request('POST', 'vehicles', [], {'Authorization': 'Bearer ' + self.key})[0], 400)
        status, headers, _ = self.request('OPTIONS', 'vehicles', headers={'Origin': 'http://localhost:8080'})
        self.assertEqual(status, 204)
        self.assertEqual(headers['Access-Control-Allow-Origin'], 'http://localhost:8080')


if __name__ == '__main__':
    unittest.main()
