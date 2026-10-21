import http.client
import json
import tempfile
import threading
import unittest
from pathlib import Path
from .database import Database
from .examples import initialize_examples
from .http_server import Server
from .pricing import sign_quote
from .test_workspace import vehicle


class ExampleHttpTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        root = Path(self.temp.name)
        self.db = Database(root / 'real.sqlite3')
        self.real_vehicle = self.db.save_vehicle(vehicle())
        self.key = 'test-real-workspace-key-0123456789012'
        self.server = Server(('127.0.0.1', 0), self.db, self.key, 'http://localhost:8080',
                             examples=initialize_examples(root / 'examples.sqlite3'))
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.stop)

    def stop(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=2)

    def request(self, method, path, key='', body=None, request_key=None):
        conn = http.client.HTTPConnection('127.0.0.1', self.server.server_port, timeout=3)
        headers = {'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'}
        if request_key:
            headers['Idempotency-Key'] = request_key
        conn.request(method, '/api/v1/' + path, json.dumps(body) if body is not None else None, headers)
        response = conn.getresponse()
        result = response.status, json.loads(response.read())
        conn.close()
        return result

    def test_sample_credential_cannot_access_operational_records_or_quote_tokens(self):
        status, session = self.request('POST', 'examples/session')
        self.assertEqual(status, 200)
        sample_key = session['workspace_key']
        self.assertNotEqual(sample_key, self.key)
        for path in ['workspace', 'reservations', 'vehicles/' + self.real_vehicle['id'] + '/calendar']:
            self.assertEqual(self.request('GET', path, sample_key)[0], 401)
        self.assertEqual(self.request('POST', 'vehicles', sample_key, vehicle())[0], 401)
        self.assertEqual(self.request('GET', 'examples/workspace', self.key)[0], 401)
        self.assertEqual(len(self.request('GET', 'examples/workspace', sample_key)[1]['vehicles']), 10)
        self.assertEqual(len(self.request('GET', 'workspace', self.key)[1]['vehicles']), 1)
        self.assertNotIn(self.key, json.dumps(session))

    def test_quotes_are_required_and_tampering_or_private_object_access_is_denied(self):
        key = self.request('POST', 'examples/session')[1]['workspace_key']
        from datetime import date, timedelta
        first = date.today() + timedelta(days=1)
        body = {'vehicle_id': 'example-miro', 'starts_on': first.isoformat(),
                'ends_on': (first + timedelta(days=1)).isoformat()}
        self.assertEqual(self.request('POST', 'examples/reservations', key, body, 'a')[0], 409)
        quote = self.request('POST', 'examples/quotes', key, body)[1]['quote']
        forged = sign_quote({k: v for k, v in dict(quote, expires_at=9999999999).items() if k != 'token'}, key)
        self.assertEqual(self.request('POST', 'examples/reservations', key,
            dict(body, quote_token=forged), 'forged')[0], 409)
        self.assertEqual(self.request('POST', 'examples/reservations', key,
            dict(body, quote_token=quote['token'] + 'x'), 'a')[0], 409)
        status, result = self.request('POST', 'examples/reservations', key,
            dict(body, quote_token=quote['token']), 'a')
        self.assertEqual(status, 201)
        self.assertEqual(result['reservation']['total_minor'], quote['total_minor'])
        self.assertEqual(self.db.reservations(), [])
