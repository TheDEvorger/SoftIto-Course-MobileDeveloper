import time
import uuid
from contextlib import closing
from .validation import ApiError, date_range

SCHEMA = """
CREATE TABLE IF NOT EXISTS listings (
 vehicle_id TEXT PRIMARY KEY REFERENCES vehicles(id), published INTEGER NOT NULL
 CHECK(published IN (0,1)) DEFAULT 1
);
CREATE TABLE IF NOT EXISTS availability_blocks (
 id TEXT PRIMARY KEY, vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
 starts_on TEXT NOT NULL, ends_on TEXT NOT NULL, reason TEXT NOT NULL,
 status TEXT NOT NULL CHECK(status IN ('active','released')),
 CHECK(ends_on > starts_on)
);
CREATE INDEX IF NOT EXISTS availability_window
 ON availability_blocks(vehicle_id,status,starts_on,ends_on);
"""


class Operations:
    @staticmethod
    def _available(conn, vehicle_id, start, end):
        row = conn.execute("""SELECT v.*,COALESCE(l.published,1) AS published
            FROM vehicles v LEFT JOIN listings l ON l.vehicle_id=v.id WHERE v.id=?""",
                           [vehicle_id]).fetchone()
        if not row:
            raise ApiError(404, 'not_found', 'Araç bulunamadı.')
        if row['status'] != 'active' or not row['published']:
            raise ApiError(409, 'unavailable', 'Araç şu anda rezervasyona açık değil.')
        for table, state in [('reservations', 'reserved'), ('availability_blocks', 'active')]:
            found = conn.execute(f"SELECT id FROM {table} WHERE vehicle_id=? AND status=? "
                                 'AND starts_on < ? AND ends_on > ?',
                                 [vehicle_id, state, end, start]).fetchone()
            if found:
                raise ApiError(409, 'conflict', 'Araç seçilen tarihlerde müsait değil.')
        return row

    def quote(self, body):
        if set(body) != {'vehicle_id', 'starts_on', 'ends_on'}:
            raise ApiError(400, 'invalid_input', 'Araç ve tarih aralığı gerekli.')
        first, last = date_range(body['starts_on'], body['ends_on'])
        if not isinstance(body['vehicle_id'], str):
            raise ApiError(400, 'invalid_input', 'Araç kimliği gerekli.')
        with closing(self.connect()) as conn:
            # One read snapshot for listing, price and availability.
            conn.execute('BEGIN')
            row = self._available(conn, body['vehicle_id'], body['starts_on'], body['ends_on'])
            return dict(body, rate_minor=row['rate_minor'], days=(last-first).days,
                        total_minor=row['rate_minor'] * (last-first).days,
                        currency=row['currency'], expires_at=int(time.time()) + 300)

    def publish(self, vehicle_id, body):
        if set(body) != {'published'} or type(body['published']) is not bool:
            raise ApiError(400, 'invalid_input', 'Yayın durumu gerekli.')
        with closing(self.connect()) as conn:
            if not conn.execute('SELECT id FROM vehicles WHERE id=?', [vehicle_id]).fetchone():
                raise ApiError(404, 'not_found', 'Araç bulunamadı.')
            conn.execute('INSERT INTO listings VALUES (?,?) ON CONFLICT(vehicle_id) '
                         'DO UPDATE SET published=excluded.published', [vehicle_id, int(body['published'])])
        return {'published': body['published']}

    def calendar(self, vehicle_id):
        with closing(self.connect()) as conn:
            if not conn.execute('SELECT id FROM vehicles WHERE id=?', [vehicle_id]).fetchone():
                raise ApiError(404, 'not_found', 'Araç bulunamadı.')
            blocks = [dict(r) for r in conn.execute("""SELECT * FROM availability_blocks
                WHERE vehicle_id=? AND status='active' ORDER BY starts_on,id""", [vehicle_id])]
            bookings = [dict(r) for r in conn.execute("""SELECT id,starts_on,ends_on,status
                FROM reservations WHERE vehicle_id=? AND status='reserved'
                ORDER BY starts_on,id""", [vehicle_id])]
            return {'blocks': blocks, 'reservations': bookings}

    def block(self, vehicle_id, body):
        if set(body) != {'starts_on', 'ends_on', 'reason'}:
            raise ApiError(400, 'invalid_input', 'Tarih aralığı ve açıklama gerekli.')
        date_range(body['starts_on'], body['ends_on'])
        reason = body['reason']
        if not isinstance(reason, str) or not 1 <= len(reason.strip()) <= 160:
            raise ApiError(400, 'invalid_input', '1–160 karakterlik bir açıklama girin.')
        with closing(self.connect()) as conn:
            conn.execute('BEGIN IMMEDIATE')
            try:
                if not conn.execute('SELECT id FROM vehicles WHERE id=?', [vehicle_id]).fetchone():
                    raise ApiError(404, 'not_found', 'Araç bulunamadı.')
                for table, state in [('reservations', 'reserved'), ('availability_blocks', 'active')]:
                    if conn.execute(f'SELECT id FROM {table} WHERE vehicle_id=? AND status=? '
                                    'AND starts_on < ? AND ends_on > ?',
                                    [vehicle_id, state, body['ends_on'], body['starts_on']]).fetchone():
                        raise ApiError(409, 'conflict', 'Bu aralıkta rezervasyon veya kapalı tarih var.')
                identity = str(uuid.uuid4())
                conn.execute('INSERT INTO availability_blocks VALUES (?,?,?,?,?,?)',
                             [identity, vehicle_id, body['starts_on'], body['ends_on'], reason.strip(), 'active'])
                conn.commit()
                return {'id': identity, **body, 'status': 'active'}
            except Exception:
                conn.rollback()
                raise

    def release_block(self, vehicle_id, identity):
        with closing(self.connect()) as conn:
            cursor = conn.execute("UPDATE availability_blocks SET status='released' WHERE id=? AND vehicle_id=?",
                                  [identity, vehicle_id])
            if not cursor.rowcount:
                raise ApiError(404, 'not_found', 'Kapalı tarih bulunamadı.')
            return {'status': 'released'}
