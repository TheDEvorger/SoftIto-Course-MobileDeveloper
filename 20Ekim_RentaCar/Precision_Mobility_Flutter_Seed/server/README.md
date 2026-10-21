# Local SQLite workspace

Run `python3 -m server` from the project directory. It binds only to
`127.0.0.1:8765` and reuses `.local/mobility.sqlite3` and `.local/operator.key`.
Existing tables/records are preserved; there is no private inventory seed or destructive migration. A separate
`.local/examples.sqlite3` is initialized once with labelled fictional records.
Subsequent changes survive restarts; private data is never copied into examples.
The key is generated only when absent, stored with mode 0600 and never logged.
Enter it in Hesabım to manage this single local workspace. It is not customer identity.

## API contract

All paths below are relative to `/api/v1/`. JSON is UTF-8; errors contain
`error.code` and `error.message`.

| Method | Path | Access |
| --- | --- | --- |
| GET | health | public |
| GET | vehicles | public; active published inventory; optional start/end filters |
| POST | examples/session | public local example credential; no private access |
| GET | workspace | operator; includes maintenance/unpublished inventory |
| POST | vehicles | operator; new vehicle |
| PUT | vehicles/:id | operator; replace editable fields |
| GET | reservations | operator |
| POST | quotes | operator; five-minute signed server offer |
| PUT | vehicles/:id/publication | operator; published boolean |
| GET/POST | vehicles/:id/calendar | operator; read/create date blocks |
| POST | vehicles/:id/calendar/:block/release | operator; release block |
| POST | reservations | operator; Idempotency-Key and quote_token required |
| POST | reservations/:id/cancel | operator; idempotent |

Private routes require `Authorization: Bearer <workspace key>` on every request.
Vehicle fields: name, category, energy, seats, rate_minor (integer TRY kuruş),
ownership (private/fleet), description, photo_url (optional HTTPS), status
(active/maintenance). Quote body: vehicle_id, starts_on, ends_on (ISO dates).
Reservation adds quote_token from the server offer; publication uses a separate
listing record and never deletes vehicle/history. Blocks use starts_on, ends_on,
reason (1–160 characters); conflicting reservations/blocks are rejected.
The allowed window remains 1–7 calendar days from today; end is exclusive.
Server computes totals from its stored rate and rejects client totals, forged,
expired or changed-price offers. `.local/quotes.key` signs offers independently
of bearer credentials; it is never returned to clients. Idempotent successful
retries replay the saved reservation even after quote expiry.

SQLite BEGIN IMMEDIATE serializes allocation/checks/inserts. Duplicate request
keys replay the same reservation; a changed payload with that key is rejected.
Cancellation releases dates and keeps history. Parameters, foreign keys, JSON
size/type, dates, money and photo URLs are validated. Maintenance, unpublished listings and calendar blocks prevent new bookings.
Block creation and booking allocation share the same serialized write boundary.

## Example scope

`POST examples/session` returns only an example bearer credential, rotated at
server restart. Prefix the same feature routes with `examples/` to operate on the
example database. Private and example bearer keys are not interchangeable; quote
signatures are scoped too. Example session does not return the real operator key.
Example data has fictional vehicle names/prices and no real customers/providers.

## Local boundary

This is the user-approved local operating mode, not a public multi-user service.
No customer identity/card/GPS data is collected. Providers and production retention
policy remain deferred. No payment, refund or vehicle command is executed.
Origin/Host checks and workspace key checks protect the local HTTP boundary.
Default allowed browser origin is exactly http://localhost:8080; use --web-origin
for another local development origin. Public binds are refused.

## Tests

`python3 -m unittest discover -s server -t . -v`

`dart run tools/check_local_api.dart` creates only temporary isolated state,
exercises real HTTP, server pricing, conflicts, cancellation and restart persistence,
plus isolated example switching and persistence, and removes its own state. It never deletes or seeds the actual .local directory.
