# TASK-012: Rebuild the interface

## Authorization and baseline
2026-10-21: user requested a new interface from scratch and explicitly requested
restoring/preserving the previously approved SQLite/API implementation after
the workspace reverted during inspection. Existing `.local` records must survive.
Earlier authorization allows coordinated varied colors; identity/payment stay deferred.

## Scope
Restore the local server/client contracts and build a new presentation: editorial
automotive hero, desktop top navigation, mobile dock, discovery search, inventory
workspace, reservation timeline, settings, detailed booking and grouped forms.

## Acceptance
- Default entrypoint uses actual API/SQLite data with no fixture fallback.
- Existing operational records and operator key are not replaced or exposed.
- All four menus have distinct responsive layouts and actionable states.
- Search/filter, vehicle create/edit, date selection, reservation and cancellation work.
- AI hero is labelled decorative and never used as inventory photography.
- Narrow/wide, both themes, large text, analyzer, server/client tests, web build
  and Python quality gate pass. All authored text files remain <=300 lines.

## Exclusions
No identity/payment/hardware integration or business/retention policy changes.
No fake inventory, ratings, locations, sales counts or service-provider claims.

## Output
Changed-file manifest, commands/evidence, asset provenance and remaining limitations
in docs/verification/TASK-012.md. Existing historical simulations remain explicit.

## Verification
Completed 2026-10-21. All 57 Flutter tests, 6 server tests, real HTTP/SQLite
restart check, analyzer, web release build and quality gate passed. Target-device
visual acceptance remains the next review. See docs/verification/TASK-012.md.
