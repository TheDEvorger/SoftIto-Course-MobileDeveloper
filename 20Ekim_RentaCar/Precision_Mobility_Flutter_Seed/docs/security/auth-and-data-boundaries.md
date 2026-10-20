# Authorization and data boundaries

## Implemented prototype boundary
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
Implemented: only fictional fixtures and session-memory demo records; no new
persistent storage, retention job, personal data or remote analytics. Closing
the app discards demo bookings, inspection snapshots and fleet edits. A demo
receipt timestamp is device-local, never a server or integrity attestation.

Production retention periods, deletion/export rules, legal holds, regional
storage and backup expiry remain UNDECIDED pending product/privacy/legal approval.
No proposed numeric retention schedule has been activated or silently approved.
This preserves the AGENTS.md approval boundary around retention and identity.
