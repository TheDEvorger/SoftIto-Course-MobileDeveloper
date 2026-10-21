# Authorization and data boundaries

## Current local application (TASK-012/013)
User approved SQLite persistence and explicitly requested restoring it after the
workspace reverted. Default entrypoint uses that local API; the prototype section
below describes only main_demo.dart. Existing records/operator key are preserved.

The server binds to loopback. Public reads expose published inventory; private
reads/writes require the local operator key on every request. The generated key
is stored in ignored .local storage with mode 0600, is not printed/compiled into
Flutter and is held only in client memory. Disconnect clears private UI state.
This key is a single local workspace credential, not customer identity verification.

Foreign origins/Host headers are rejected; CORS permits one configured origin.
Input sizes/types, integer money, date windows and HTTPS photo URLs are validated.
SQL is parameterized and reservation allocation is serialized with BEGIN IMMEDIATE.
The server owns totals; request keys deduplicate retries. Cancelled records persist
as history. TASK-013 adds a separate example database with fictional inventory/reservations,
never seeds the private database and never copies private data into examples.
Example session returns only a separate example bearer key; cross-scope access
is rejected server-side. All UI menus identify the example context. No customer
identity/card/GPS records are added. Offers use a separate server-only signing
secret, scoped signatures and expiry/current-price checks inside allocation.
Publication records preserve vehicle/history; calendar blocks and bookings share
a serialized write boundary. This does not introduce customer auth or RBAC.
No production retention schedule or provider was selected. Identity/payment,
hardware and public release remain deferred; production gates below are not signed.

## Historical prototype boundary
Flutter is an untrusted client. All data is fictional and session-local.
App composition owns routing and one booking controller/inspection store per
app session. Discovery sends an ID; app wiring resolves fixture attributes.
Booking owns quote/confirm/cancel records. Handover receives a read callback
that rechecks confirmation at completion. Inspection owns snapshots keyed by
booking ID; unsupported template versions and mixed booking contexts fail.
Fleet owns separate fictional organization/branch records and rejects mutations
outside the selected scope. Its role picker is an explicit simulation.

No route grants real authority. Inspection route is available for confirmed
sample bookings only. Unknown listing IDs show an empty state. Domain errors
are textual and no external resource is read. No arbitrary path/file import,
HTML execution, camera/GPS capture, network request, secret, token or provider
configuration is added by TASK-004–009.

## Required server boundary before any live use
- Authenticate actors; derive membership and scopes on the server. Never trust
  client organization, branch, role, price, driver or pickup-window flags.
- Authorize every object read and write, including evidence download URLs.
- Use expiring sessions and revocation; separate customer/operator/admin scopes.
- Atomically enforce vehicle/time reservation invariants; use idempotent writes.
- Keep card data at a suitable payment provider; verify callback signatures and
  reconcile lifecycle events. Client success is not payment confirmation.
- Vehicle commands require authenticated authorization, hardware compatibility,
  proximity/safety checks, signed expiry/nonces and explicit status acknowledgement.
  Uncertain status must block trip start until server reconciliation.
- Evidence requires controlled storage, server receipt/hash and reviewer access.
  Photos/AI cannot assign financial liability; preserve human review and appeals.

## Audit requirements (design, not implemented server behavior)
Record actor/resource scope, request/correlation ID, server timestamp, action,
result and policy/template version for authorization decisions, booking state,
payment reconciliation, evidence review, ownership and handover changes.
Do not include identity images, precise locations, payment details, raw tokens
or unrestricted photo URLs in logs. Protect audit integrity and restrict access.
No append-only audit guarantee is claimed by the in-memory prototype.

## Retention decisions
The following session-only statement describes the historical prototype. Current
local records persist as documented above; no deletion/expiry schedule is added.

Historical prototype: only fictional fixtures and session-memory demo records; no new
persistent storage, retention job, personal data or remote analytics. Closing
the app discards demo bookings, inspection snapshots and fleet edits. A demo
receipt timestamp is device-local, never a server or integrity attestation.

Production retention periods, deletion/export rules, legal holds, regional
storage and backup expiry remain UNDECIDED pending product/privacy/legal approval.
No proposed numeric retention schedule has been activated or silently approved.
This preserves the AGENTS.md approval boundary around retention and identity.
