from datetime import date
from urllib.parse import urlparse


class ApiError(Exception):
    def __init__(self, status, code, message):
        super().__init__(message)
        self.status, self.code, self.message = status, code, message


def vehicle_data(body):
    allowed = {'name', 'category', 'energy', 'seats', 'rate_minor', 'ownership',
               'description', 'photo_url', 'status'}
    if set(body) - allowed:
        raise ApiError(400, 'invalid_input', 'Bilinmeyen araç alanı.')
    result = {}
    for key in ['name', 'category', 'energy', 'description']:
        value = body.get(key)
        maximum = 1200 if key == 'description' else 120
        if not isinstance(value, str) or not value.strip() or len(value) > maximum:
            raise ApiError(400, 'invalid_input', f'{key}: geçerli bir metin gerekli.')
        result[key] = value.strip()
    for key, low, high in [('seats', 1, 9), ('rate_minor', 1, 100_000_000)]:
        value = body.get(key)
        if type(value) is not int or not low <= value <= high:
            raise ApiError(400, 'invalid_input', f'{key}: geçerli bir sayı gerekli.')
        result[key] = value
    for key, choices in [('ownership', {'fleet', 'private'}), ('status', {'active', 'maintenance'})]:
        if body.get(key) not in choices:
            raise ApiError(400, 'invalid_input', f'{key}: geçersiz seçenek.')
        result[key] = body[key]
    photo = body.get('photo_url', '')
    if not isinstance(photo, str) or len(photo) > 2048:
        raise ApiError(400, 'invalid_input', 'Geçersiz fotoğraf adresi.')
    if photo:
        url = urlparse(photo)
        if url.scheme != 'https' or not url.hostname or url.username or url.password:
            raise ApiError(400, 'invalid_input', 'Fotoğraf adresi HTTPS olmalı.')
    result['photo_url'] = photo
    return result


def date_range(start, end):
    try:
        first, last = date.fromisoformat(start), date.fromisoformat(end)
        if first.isoformat() != start or last.isoformat() != end:
            raise ValueError()
    except (TypeError, ValueError):
        raise ApiError(400, 'invalid_dates', 'Geçerli bir tarih aralığı seçin.') from None
    if first < date.today() or not 1 <= (last - first).days <= 7:
        raise ApiError(400, 'invalid_dates', 'Bugünden itibaren 1–7 günlük bir aralık seçin.')
    return first, last
