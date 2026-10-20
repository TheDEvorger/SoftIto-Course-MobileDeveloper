# Threat model: initial requirements

Protect identity files, exact location, financial data, image evidence, org boundaries, vehicle remote commands and audit log integrity.

## Threats
- Cross-tenant access to other fleet vehicles or users.
- Replay of unlock commands or forged GPS data.
- Booking race causing double allocations.
- Forged payment callbacks or duplicate charges.
- Edited photo evidence or misleading EXIF timestamps.
- AI false positives causing unfair damage claims.
- Leaking identity and location through client logging or analytics.

## Controls to design
Server-side scoped RBAC/ABAC, idempotency keys, transactional booking locking, webhook signature verification, evidence hashing, restricted storage, retention rules, human appeal pathway, vehicle integration attestation and fail-closed status.

Before deployment: dedicated security review, privacy/legal audit, incident and recovery rehearsals, OWASP MASVS cross-check.

## TASK-009 review
See `risk-register.md`, `auth-and-data-boundaries.md` and
`acceptance-signoff.md` for the reviewed prototype controls, residual risks,
retention status, required audit events and explicit unsigned production gates.
The local sample app has no server-side security boundary or production approval.
