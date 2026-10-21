import sqlite3
import uuid
import time
from contextlib import closing
from datetime import datetime, timezone
from .validation import ApiError, date_range, vehicle_data
from .operations import Operations, SCHEMA as OPERATIONS_SCHEMA

# Compatible with the approved private database. No drops or private data seeds.
SCHEMA = """
CREATE TABLE IF NOT EXISTS vehicles (
 id TEXT PRIMARY KEY, name TEXT NOT NULL, category TEXT NOT NULL,
 energy TEXT NOT NULL, seats INTEGER NOT NULL CHECK(seats BETWEEN 1 AND 9),
 rate_minor INTEGER NOT NULL CHECK(rate_minor > 0),
 ownership TEXT NOT NULL CHECK(ownership IN ('fleet','private')),
 description TEXT NOT NULL, photo_url TEXT NOT NULL DEFAULT '',
 status TEXT NOT NULL CHECK(status IN ('active','maintenance')),
 currency TEXT NOT NULL DEFAULT 'TRY', created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS reservations (
 id TEXT PRIMARY KEY, vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
 starts_on TEXT NOT NULL, ends_on TEXT NOT NULL,
 total_minor INTEGER NOT NULL, rate_minor INTEGER NOT NULL,
 currency TEXT NOT NULL DEFAULT 'TRY',
 status TEXT NOT NULL CHECK(status IN ('reserved','cancelled')),
 request_key TEXT NOT NULL UNIQUE, created_at TEXT NOT NULL,
 CHECK(ends_on > starts_on)
);
CREATE INDEX IF NOT EXISTS reservation_window
 ON reservations(vehicle_id, status, starts_on, ends_on);
"""


class Database(Operations):
    def __init__(self, path):
        self.path = str(path)
        with closing(self.connect()) as conn:
            conn.execute('PRAGMA journal_mode=WAL')
            conn.executescript(SCHEMA)
            conn.executescript(OPERATIONS_SCHEMA)

    def connect(self):
        conn = sqlite3.connect(self.path, timeout=5, isolation_level=None)
        conn.row_factory = sqlite3.Row
        conn.execute('PRAGMA foreign_keys=ON')
        return conn

    def vehicles(self, *, start=None, end=None, include_maintenance=False):
        sql, args = '''SELECT v.*,COALESCE(l.published,1) AS published FROM vehicles v
            LEFT JOIN listings l ON l.vehicle_id=v.id WHERE 1=1''', []
        if not include_maintenance:
            sql += " AND v.status='active' AND COALESCE(l.published,1)=1"
        if start is not None or end is not None:
            date_range(start, end)
            sql += """ AND NOT EXISTS (SELECT 1 FROM reservations r
                WHERE r.vehicle_id=v.id AND r.status='reserved'
                AND r.starts_on < ? AND r.ends_on > ?)"""
            args = [end, start]
            sql += """ AND NOT EXISTS (SELECT 1 FROM availability_blocks b
                WHERE b.vehicle_id=v.id AND b.status='active'
                AND b.starts_on < ? AND b.ends_on > ?)"""
            args += [end, start]
        with closing(self.connect()) as conn:
            return [dict(row) for row in conn.execute(sql + ' ORDER BY name,id', args)]

    def save_vehicle(self, body, vehicle_id=None):
        data = vehicle_data(body)
        with closing(self.connect()) as conn:
            if vehicle_id:
                sets = ','.join(f'{key}=?' for key in data)
                cursor = conn.execute(f'UPDATE vehicles SET {sets} WHERE id=?', [*data.values(), vehicle_id])
                if not cursor.rowcount:
                    raise ApiError(404, 'not_found', 'Araç bulunamadı.')
            else:
                vehicle_id = str(uuid.uuid4())
                data.update(id=vehicle_id, created_at=datetime.now(timezone.utc).isoformat())
                columns, marks = ','.join(data), ','.join('?' for _ in data)
                conn.execute(f'INSERT INTO vehicles ({columns}) VALUES ({marks})', list(data.values()))
            result = dict(conn.execute('SELECT * FROM vehicles WHERE id=?', [vehicle_id]).fetchone())
            listing = conn.execute('SELECT published FROM listings WHERE vehicle_id=?', [vehicle_id]).fetchone()
            return dict(result, published=listing['published'] if listing else 1)

    @staticmethod
    def _record(conn, identity):
        row = conn.execute("""SELECT r.*,v.name AS vehicle_name FROM reservations r
            JOIN vehicles v ON v.id=r.vehicle_id WHERE r.id=?""", [identity]).fetchone()
        if not row:
            raise ApiError(404, 'not_found', 'Rezervasyon bulunamadı.')
        return dict(row)

    def reservations(self):
        with closing(self.connect()) as conn:
            return [dict(row) for row in conn.execute("""SELECT r.*,v.name AS vehicle_name
                FROM reservations r JOIN vehicles v ON v.id=r.vehicle_id
                ORDER BY r.created_at DESC,r.id""")]

    def reserve(self, body, request_key, *, quote=None):
        if set(body) != {'vehicle_id', 'starts_on', 'ends_on'}:
            raise ApiError(400, 'invalid_input', 'Araç ve tarih aralığı gerekli.')
        vehicle_id, start, end = body.get('vehicle_id'), body['starts_on'], body['ends_on']
        if not isinstance(vehicle_id, str) or not vehicle_id:
            raise ApiError(400, 'invalid_input', 'Araç kimliği gerekli.')
        if not request_key or len(request_key) > 100:
            raise ApiError(400, 'idempotency_required', 'İşlem anahtarı gerekli.')
        with closing(self.connect()) as conn:
            conn.execute('BEGIN IMMEDIATE')
            try:
                previous = conn.execute('SELECT * FROM reservations WHERE request_key=?', [request_key]).fetchone()
                if previous:
                    if (previous['vehicle_id'], previous['starts_on'], previous['ends_on']) != (vehicle_id, start, end):
                        raise ApiError(409, 'key_reused', 'İşlem anahtarı başka bir istek için kullanılmış.')
                    conn.commit()
                    return self._record(conn, previous['id'])
                first, last = date_range(start, end)
                vehicle = self._available(conn, vehicle_id, start, end)
                if quote and (quote['rate_minor'] != vehicle['rate_minor'] or quote['expires_at'] < time.time()):
                    raise ApiError(409, 'quote_changed', 'Fiyat teklifi değişti veya süresi doldu. Yeniden onaylayın.')
                identity = str(uuid.uuid4())
                conn.execute('INSERT INTO reservations VALUES (?,?,?,?,?,?,?,?,?,?)', [identity, vehicle_id,
                    start, end, vehicle['rate_minor'] * (last-first).days, vehicle['rate_minor'],
                    vehicle['currency'], 'reserved', request_key, datetime.now(timezone.utc).isoformat()])
                conn.commit()
                return self._record(conn, identity)
            except Exception:
                conn.rollback()
                raise

    def cancel(self, identity):
        with closing(self.connect()) as conn:
            conn.execute("UPDATE reservations SET status='cancelled' WHERE id=?", [identity])
            return self._record(conn, identity)
