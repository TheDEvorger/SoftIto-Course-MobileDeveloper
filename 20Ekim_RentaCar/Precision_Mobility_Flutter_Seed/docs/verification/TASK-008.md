# TASK-008: Fleet workspace

Date: 2026-10-20. Status: DONE.

## Implementation
Two fictional organizations, scoped branches, immutable sample vehicle records,
and viewer/operator/manager role simulation. Organization changes reset branch
and role to viewer. Viewer cannot edit; operations reject vehicles outside the
selected organization/branch even if invoked directly on the domain object.
Wide view uses a horizontally scrollable DataTable, narrow view uses cards.
Overview counts reflect the current organization/branch. Sample maintenance
status is session-local. No employees, PII, real tenants or server are present.
App wiring supplies the fleet workspace to the garage host.

## Evidence
`flutter test test/fleet_test.dart`: 4 passed: tenant/branch mutation isolation,
viewer denial, context reset, 320/1200 layouts, UI role switching and editing,
plus desktop Tab traversal and Enter activating the sample maintenance action.
`flutter analyze`: no issues. Python quality gate: passed.
Narrow dropdown overflow fixed with expanded controls; one missing-brace lint
corrected. Logs: logs/TASK-008/.

## Files and limits
Added fleet/domain/demo_fleet_workspace.dart, presentation/fleet_workspace_screen.dart
and test/fleet_test.dart. Updated app/shell.dart, garage host and task registry.
Role selector intentionally simulates privilege; it is not access control.
Fictional fleet inventory is separate from discoverable sample listings;
maintenance does not create or cancel bookings. No cross-module writes.
No native/device verification. Next: TASK-009 documented security review.
