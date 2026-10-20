# Prototype risk register — TASK-009

Review date: 2026-10-20. Scope: local fixture prototype TASK-001–008.
Severity is potential production impact; no production risk acceptance is implied.

| ID | Threat / impact | Current prototype control | Required production gate / owner |
| --- | --- | --- | --- |
| R01 Critical | Cross-tenant reads/writes | Fictional records; scoped domain mutation and branch tests | Server-scoped RBAC/ABAC on every resource; tenant isolation tests / backend security |
| R02 Critical | Forged authorization or identity | No identity files; role and driver inputs labelled demo | Verified identity/eligibility, least privilege, session revocation / identity owner |
| R03 Critical | Double allocation | Single-process synchronous overlap checks; unit tests | Atomic database reservation constraint/locking and concurrency tests / booking owner |
| R04 Critical | Forged price or duplicate charge | Fixture pricing; no payment SDK, charge or card input | Server quotes, signed callbacks, idempotency, reconciliation / payments owner |
| R05 Critical | Unauthorized/replayed unlock | No commands or integration; acknowledgement is a simulation | Attested hardware, signed expiring commands, replay defense, explicit status reconciliation / vehicle integration owner |
| R06 High | False success after connectivity loss | Uncertain state clears preflight and blocks completion | Durable server state, reconciliation, operational fallback validation / handover owner |
| R07 High | Forged/edited evidence | Synthetic records, receipt labels; no integrity claim | Server receipt, content hashing, restricted object storage and audit / inspection owner |
| R08 High | Unfair AI damage penalty | No AI or penalty; 20 per-slot human-review simulations | Human adjudication, evidence access and appeal process / operations owner |
| R09 High | Identity/location leak via logs | No identity/photo/GPS input or analytics integration | Redacted logs, purpose limitation, access review and incident procedure / privacy owner |
| R10 High | Lost or tampered client session | Memory only; restore validates version/context/shape | Server persistence, integrity and recovery; client state never trusted / backend owner |
| R11 High | Malicious client role selector | Explicit role simulation, no actual authorization | Remove demo controls from production builds; server derives roles / client and backend owners |
| R12 Medium | Dependency/toolchain or platform gap | Locked dependencies; analyzer, tests and web build | Native builds, dependency provenance/vulnerability review, signed releases / release owner |
| R13 Medium | Inaccessible or misleading UI | Demo labels, narrow/wide and keyboard tests | Device/browser/screen-reader and localization audit / accessibility owner |
| R14 High | Excessive retention or deletion errors | No durable user data; app-session memory lifecycle | Approved schedule, deletion/export, legal holds and backup handling / privacy and legal owners |

Residual exposure: anyone controlling this client can alter all simulated data.
The prototype must not be used for real bookings, payments, eligibility, evidence,
or vehicle control. Owners above are required roles, not assigned people or approvals.
