# Task registry

Do tasks in order; one active task at a time. Move to done only with verified acceptance.

1. `done/TASK-001-foundation-verification.md` • setup and checks
2. `done/TASK-002-design-system.md` • theme and reusable controls
3. `done/TASK-003-responsive-discovery.md` • adaptive discovery and mock map
4. `done/TASK-004-vehicle-details.md` • model and details
5. `done/TASK-005-booking-state.md` • quote + booking state machine
6. `done/TASK-006-hybrid-handover.md` • handover simulations
7. `done/TASK-007-inspection-evidence.md` • 20-shot checklist prototype
8. `done/TASK-008-fleet-workspace.md` • dashboard and tenant context
9. `done/TASK-009-security-design.md` • threat model review

Every task must specify goal, scope, exclusions, acceptance tests, dependencies and output report.

Historical tasks 001–009 are complete. Earlier session work expanded the menus
and introduced a user-approved local SQLite server (TASK-010/011). The workspace
was externally reverted; user explicitly authorized restoring the server.

12. `done/TASK-012-interface-rebuild.md` • restore SQLite and rebuild the interface

TASK-012 is complete within its historical local application/interface scope.
TASK-014 supersedes its default entrypoint; SQLite/API remains optional.

Identity/payment providers and public release remain deferred by the user.

13. `done/TASK-013-requirements-and-populated-workspace.md` • complete: requirement
    map, isolated populated SQLite workspace and local listing/calendar/quote flows.

14. `TASK-014-serverless-rental-app.md` • active: serverless renter app and device persistence.

Full product gaps remain visible in
`docs/product/requirements-status.md`; external integrations are not marked done.
