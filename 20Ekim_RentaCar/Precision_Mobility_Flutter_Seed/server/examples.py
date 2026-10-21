from contextlib import closing
from datetime import date, datetime, timedelta, timezone
from .database import Database
from .validation import vehicle_data

# Fictional names, prices and operational records. Never seeded into the real DB.
COLLECTION = [
    ('aster', 'Aster GT', 'Grand Touring', 'Hibrit', 4, 425000, 'private', 'silver'),
    ('luma', 'Luma E', 'Elektrikli Sedan', 'Elektrik', 5, 285000, 'fleet', 'blue'),
    ('vela', 'Vela SUV', 'Premium SUV', 'Hibrit', 5, 365000, 'fleet', 'olive'),
    ('miro', 'Miro City', 'Şehir Otomobili', 'Elektrik', 4, 165000, 'private', 'coral'),
    ('sora', 'Sora Touring', 'Station Wagon', 'Benzin', 5, 245000, 'fleet', 'sand'),
    ('arden', 'Arden Executive', 'Business Sedan', 'Hibrit', 5, 395000, 'private', 'plum'),
    ('noma', 'Noma Cross', 'Kompakt SUV', 'Elektrik', 5, 225000, 'fleet', 'blue'),
    ('alto', 'Alto Sport', 'Spor Coupé', 'Benzin', 2, 465000, 'private', 'coral'),
    ('vela-service', 'Vela Atelier', 'Premium SUV', 'Hibrit', 5, 345000, 'fleet', 'olive'),
    ('luma-draft', 'Luma Studio', 'Elektrikli Sedan', 'Elektrik', 5, 275000, 'private', 'silver'),
]
ART = {f'example-{v[0]}': ('touring' if v[0] in {'aster', 'alto'}
       else 'suv' if v[0] in {'vela', 'vela-service', 'noma', 'sora'}
       else 'electric') for v in COLLECTION}


class ExampleDatabase(Database):
    def vehicles(self, **kwargs):
        return [dict(v, example=True, artwork=ART.get(v['id'], ''))
                for v in super().vehicles(**kwargs)]


def initialize_examples(path):
    db = ExampleDatabase(path)
    today = date.today()
    now = datetime.now(timezone.utc).isoformat()
    with closing(db.connect()) as conn:
        conn.execute('CREATE TABLE IF NOT EXISTS example_seed (version INTEGER PRIMARY KEY)')
        conn.execute('BEGIN IMMEDIATE')
        try:
            if conn.execute('SELECT version FROM example_seed WHERE version=1').fetchone():
                conn.commit()
                return db
            for slug, name, category, energy, seats, rate, ownership, _ in COLLECTION:
                body = vehicle_data(dict(name=name, category=category, energy=energy,
                    seats=seats, rate_minor=rate, ownership=ownership, photo_url='',
                    status='maintenance' if slug == 'vela-service' else 'active',
                    description=f'{name}: konforlu günlük rotalar ve uzun yol planları için kurgusal koleksiyon aracı. '
                    'Bu kayıt, fiyatı ve görseli örnek veridir; gerçek bir kiralama ilanı değildir.'))
                body.update(id='example-' + slug, currency='TRY', created_at=now)
                columns, marks = ','.join(body), ','.join('?' for _ in body)
                conn.execute(f'INSERT INTO vehicles ({columns}) VALUES ({marks})', list(body.values()))
            conn.execute('INSERT INTO listings VALUES (?,0)', ['example-luma-draft'])
            for index, (slug, offset, days, cancelled) in enumerate([
                    ('aster', 2, 3, False), ('luma', 0, 2, False),
                    ('vela', 6, 2, False), ('sora', 10, 4, False),
                    ('miro', 3, 2, True), ('arden', 8, 3, True)]):
                first, last = today + timedelta(days=offset), today + timedelta(days=offset + days)
                rate = next(v[5] for v in COLLECTION if v[0] == slug)
                conn.execute('INSERT INTO reservations VALUES (?,?,?,?,?,?,?,?,?,?)',
                    [f'example-plan-{index+1}', 'example-' + slug, first.isoformat(), last.isoformat(),
                     rate * days, rate, 'TRY', 'cancelled' if cancelled else 'reserved',
                     f'example-seed-{index}', now])
            conn.execute('INSERT INTO availability_blocks VALUES (?,?,?,?,?,?)',
                ['example-block-1', 'example-noma', (today + timedelta(days=4)).isoformat(),
                 (today + timedelta(days=6)).isoformat(), 'Planlı kontrol · örnek kayıt', 'active'])
            conn.execute('INSERT INTO example_seed VALUES (1)')
            conn.commit()
        except Exception:
            conn.rollback()
            raise
    return db
