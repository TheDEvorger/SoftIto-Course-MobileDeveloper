# Core business invariants

BR-001: Vehicle has exactly one effective ownership relationship at a time.
BR-002: Vehicle ownership never implies driving authorization.
BR-003: Listing is distinct from vehicle; unpublished listings retain vehicle history.
BR-004: No conflicting confirmed reservations for the same vehicle/time.
BR-005: Price quotes are calculated and validated by the server.
BR-006: Payment attempts are idempotent; webhook reconciliation is audited.
BR-007: A booking can exist without ever starting a trip.
BR-008: A trip cannot start until required handover is valid and recorded.
BR-009: Neither photos nor AI determine liability automatically.
BR-010: Identity documents, precise location history and payment info are access limited.
BR-011: All chargebacks, refunds, decisions and ownership changes are auditable.
BR-012: Organizations and branches are separate authorization contexts.
BR-013: A digitally unlocked vehicle must be compatible, eligible and confirmed unlocked before claiming success.
BR-014: Cancellation, extensions and penalties follow an explicit policy version.

## Explicit serverless local scope (TASK-014)
The user requested that the normal app work without any server. Its quotes and
plans are calculated/validated on the device, do not claim supplier allocation
or commercial confirmation and cannot enforce availability across devices.
BR-004/005 remain required server invariants before live supplier bookings. Local
writes are serialized, prices use integer minor units, retries are idempotent and
cancellation preserves history. Identity/payment/handover constraints still apply.
