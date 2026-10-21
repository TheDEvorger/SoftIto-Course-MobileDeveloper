import hmac
import json
import sqlite3
import secrets
import hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlparse
from .validation import ApiError
from .pricing import sign_quote, read_quote


class Server(ThreadingHTTPServer):
    daemon_threads = True

    def __init__(self, address, database, operator_key, web_origin, *, examples=None, quote_secret=None):
        if address[0] not in {'127.0.0.1', 'localhost'}:
            raise ValueError('Local server must bind to loopback.')
        if len(operator_key) < 32:
            raise ValueError('Operator key must contain at least 32 characters.')
        self.database, self.operator_key, self.web_origin = database, operator_key, web_origin
        self.examples, self.examples_key = examples, secrets.token_urlsafe(32)
        self.quote_secret = quote_secret or secrets.token_urlsafe(32)
        super().__init__(address, Handler)


class Handler(BaseHTTPRequestHandler):
    server_version = 'PrecisionLocal/1'

    def log_message(self, *_):
        pass

    def do_GET(self):
        self._dispatch()

    def do_POST(self):
        self._dispatch()

    def do_PUT(self):
        self._dispatch()

    def do_OPTIONS(self):
        self._dispatch()

    def _dispatch(self):
        try:
            host = urlparse('http://' + self.headers.get('Host', '')).hostname
            if host not in {'127.0.0.1', 'localhost', '10.0.2.2'}:
                raise ApiError(403, 'host_rejected', 'Geçersiz sunucu adresi.')
            origin = self.headers.get('Origin')
            if origin and origin != self.server.web_origin:
                raise ApiError(403, 'origin_rejected', 'Bu uygulama kaynağına izin verilmiyor.')
            if self.command == 'OPTIONS':
                self._respond(204, None)
                return
            parsed = urlparse(self.path)
            parts = parsed.path.strip('/').split('/')
            if parts[:2] != ['api', 'v1']:
                raise ApiError(404, 'not_found', 'Adres bulunamadı.')
            route = parts[2:]
            if route == ['examples', 'session'] and self.command == 'POST':
                if self.server.examples is None:
                    raise ApiError(404, 'not_found', 'Örnek çalışma alanı etkin değil.')
                self._respond(200, {'workspace_key': self.server.examples_key, 'example': True})
                return
            example = bool(route and route[0] == 'examples')
            if example:
                route = route[1:]
            self.database = self.server.examples if example else self.server.database
            access_key = self.server.examples_key if example else self.server.operator_key
            self.signing_key = hmac.new(self.server.quote_secret.encode(),
                b'examples' if example else b'workspace', hashlib.sha256).hexdigest()
            if self.database is None:
                raise ApiError(404, 'not_found', 'Çalışma alanı bulunamadı.')
            public = self.command == 'GET' and route in [['health'], ['vehicles']]
            if not public and not hmac.compare_digest(self.headers.get('Authorization', ''), 'Bearer ' + access_key):
                raise ApiError(401, 'unauthorized', 'Çalışma alanı anahtarı gerekli veya geçersiz.')
            status, result = self._route(route, parse_qs(parsed.query))
            self._respond(status, result)
        except ApiError as error:
            self._respond(error.status, {'error': {'code': error.code, 'message': error.message}})
        except sqlite3.OperationalError:
            self._respond(503, {'error': {'code': 'database_busy', 'message': 'Sunucu meşgul; yeniden deneyin.'}})
        except (ValueError, TypeError, UnicodeError):
            self._respond(400, {'error': {'code': 'invalid_input', 'message': 'Geçersiz istek.'}})
        except Exception:
            self._respond(500, {'error': {'code': 'server_error', 'message': 'İşlem tamamlanamadı.'}})

    def _body(self):
        if self.headers.get('Transfer-Encoding') or self.headers.get_content_type() != 'application/json':
            raise ApiError(415, 'content_type', 'JSON gövdesi gerekli.')
        length = int(self.headers.get('Content-Length', '0'))
        if not 0 < length <= 16384:
            raise ApiError(413, 'body_size', 'İstek boyutu geçersiz.')
        self.connection.settimeout(5)
        body = json.loads(self.rfile.read(length))
        if not isinstance(body, dict):
            raise ApiError(400, 'invalid_input', 'JSON nesnesi gerekli.')
        return body

    def _route(self, route, query):
        db, method = self.database, self.command
        if route == ['health'] and method == 'GET':
            return 200, {'status': 'ok', 'service': 'precision-local', 'version': 1}
        if route == ['workspace'] and method == 'GET':
            return 200, {'vehicles': db.vehicles(include_maintenance=True)}
        if route == ['vehicles']:
            if method == 'GET':
                return 200, {'vehicles': db.vehicles(start=query.get('start', [None])[0], end=query.get('end', [None])[0])}
            if method == 'POST':
                return 201, {'vehicle': db.save_vehicle(self._body())}
        if len(route) == 2 and route[0] == 'vehicles' and method == 'PUT':
            return 200, {'vehicle': db.save_vehicle(self._body(), route[1])}
        if len(route) >= 3 and route[0] == 'vehicles':
            identity = route[1]
            if len(route) == 3 and route[2] == 'publication' and method == 'PUT':
                return 200, db.publish(identity, self._body())
            if len(route) == 3 and route[2] == 'calendar':
                if method == 'GET':
                    return 200, db.calendar(identity)
                if method == 'POST':
                    return 201, {'block': db.block(identity, self._body())}
            if len(route) == 5 and route[2] == 'calendar' and route[4] == 'release' and method == 'POST':
                return 200, db.release_block(identity, route[3])
        if route == ['quotes'] and method == 'POST':
            quote = db.quote(self._body())
            return 200, {'quote': dict(quote, token=sign_quote(quote, self.signing_key))}
        if route == ['reservations']:
            if method == 'GET':
                return 200, {'reservations': db.reservations()}
            if method == 'POST':
                body = self._body()
                quote = read_quote(body.pop('quote_token', None), body, self.signing_key)
                return 201, {'reservation': db.reserve(body, self.headers.get('Idempotency-Key'), quote=quote)}
        if len(route) == 3 and route[0] == 'reservations' and route[2] == 'cancel' and method == 'POST':
            return 200, {'reservation': db.cancel(route[1])}
        raise ApiError(404, 'not_found', 'Adres bulunamadı.')

    def _respond(self, status, payload):
        body = b'' if payload is None else json.dumps(payload, ensure_ascii=False).encode()
        self.send_response(status)
        if self.headers.get('Origin') == self.server.web_origin:
            self.send_header('Access-Control-Allow-Origin', self.server.web_origin)
            self.send_header('Vary', 'Origin')
        for key, value in {'Access-Control-Allow-Methods': 'GET,POST,PUT,OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,Authorization,Idempotency-Key',
            'Content-Type': 'application/json; charset=utf-8', 'Content-Length': str(len(body)),
            'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff'}.items():
            self.send_header(key, value)
        self.end_headers()
        self.wfile.write(body)
