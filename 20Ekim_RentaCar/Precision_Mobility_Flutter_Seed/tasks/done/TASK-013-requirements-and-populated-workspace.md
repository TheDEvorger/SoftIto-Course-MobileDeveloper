# TASK-013: Requirements, populated workspace and local operations

## Goal and authorization
2026-10-21: user requested the three proposed steps (MD gap inventory, complete
user flows, improve/test those flows) plus an application populated with server
data. Use labelled fictional records stored by the real SQLite API. Preserve
existing operational records/key. Identity/payment providers remain deferred.

## Scope
- Map product MD requirements to current, delivered and deferred capabilities.
- Populate an isolated example SQLite workspace: mixed ownership, categories,
  maintenance, active/cancelled reservations and availability windows.
- Open the example workspace without disclosing the real operator credential;
  allow switching to the existing private workspace and back.
- Complete local listing publication, operator calendar blocks and server quotes.
- Improve discovery, inventory, booking and account content around actual records.

## Acceptance
- No generated examples are inserted into or overwrite the existing private DB.
- Every example screen is labelled; example mutations persist across restarts.
- Example credentials cannot read/write the real workspace. Real credentials
  cannot accidentally route to the example database after switching.
- Unpublishing preserves vehicle/history; blocked dates prevent quotes/bookings
  atomically; overlapping existing reservations prevent new blocks.
- Quotes use server prices; changed prices require a new confirmation.
- Every menu has useful content and functioning actions with populated data.
- Narrow/wide, both themes and large text work; meaningful client/server tests,
  analyzer, real HTTP checks, release build and quality gate pass.

## Exclusions and dependencies
Depends on TASK-012. No provider selection, customer identity, card processing,
production RBAC, real photo evidence, trip authorization or vehicle commands.
These require the explicit integrations/decisions listed in the requirement map.
No retention schedule/deletion policy is introduced.

## Output
docs/product/requirements-status.md and docs/verification/TASK-013.md.

## Verification
Completed 2026-10-21: 67 Flutter tests, 14 backend tests, analyzer, actual HTTP/SQLite
restart/scope checks, web build, 16 real Chrome captures and quality gate passed.
Original private records/key preserved. The requirement map explicitly retains
missing production integrations; these are not claimed as delivered.
