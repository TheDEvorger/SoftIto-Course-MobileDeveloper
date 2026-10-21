import base64
import hashlib
import hmac
import json
from .validation import ApiError


def sign_quote(quote, key):
    data = base64.urlsafe_b64encode(json.dumps(quote, sort_keys=True).encode()).decode()
    signature = hmac.new(key.encode(), data.encode(), hashlib.sha256).hexdigest()
    return data + '.' + signature


def read_quote(token, body, key):
    try:
        if not isinstance(token, str) or len(token) > 4096:
            raise ValueError()
        data, signature = token.split('.')
        expected = hmac.new(key.encode(), data.encode(), hashlib.sha256).hexdigest()
        if not hmac.compare_digest(signature, expected):
            raise ValueError()
        quote = json.loads(base64.urlsafe_b64decode(data))
        if any(quote[k] != body.get(k) for k in ['vehicle_id', 'starts_on', 'ends_on']):
            raise ValueError()
        return quote
    except (ValueError, KeyError, TypeError, UnicodeError):
        raise ApiError(409, 'quote_required', 'Güncel fiyat teklifini yeniden alın.') from None
