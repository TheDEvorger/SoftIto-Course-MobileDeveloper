# TASK-013: Populated workspace and MD requirement delivery

Completed 2026-10-21 within the local scope below. User requested the three
proposed steps plus populated server-style data. SQLite storage and preserving
the previous workspace were already authorized; providers remain deferred.

## Outcome
- Requirement map records completed, missing and explicitly deferred capabilities
  in docs/product/requirements-status.md. Historical simulations are not counted
  as production identity, inspections, trips or payments.
- Normal startup opens an explicitly labelled example workspace through the real
  HTTP API. It contains 10 fictional vehicles (8 published, 1 maintenance,
  1 unpublished), 6 reservations (4 reserved, 2 cancelled) and a calendar block.
- Examples have their own SQLite file and scoped credential. The private database
  is never seeded/copied/overwritten; example credentials fail on private routes.
  Server restarts do not regenerate examples or erase subsequent edits.
- Vehicle publication is separate from the canonical vehicle; unpublishing
  preserves history. Operators can close/reopen 1–7 day calendar windows.
- Quote, block and booking rules use server-owned prices/availability. Signed
  five-minute quotes require fresh confirmation after expiry/price changes.
  Signing secrets are independent of client credentials and scoped per workspace.
  BEGIN IMMEDIATE prevents concurrent block/reservation allocation conflicts.
- Account overview derives counts from records. Failed private login preserves
  the example session; successful switching clears private client state before
  loading the new context. Real API errors do not trigger a sample fallback.
- Three bundled AI concept photographs improve sample cards and are labelled;
  they never become operational listing photos. See design/collection-assets.md
  for exact prompts, saved asset paths and built-in generation mode.

## Evidence
| Check | Result |
| --- | --- |
| flutter analyze | No issues |
| flutter test --reporter expanded | All 67 passed |
| python3 -m unittest discover -s server -t . -v | All 14 passed |
| dart run tools/check_local_api.dart | Real HTTP/SQLite quotes, booking, conflicts, cancellation, isolated examples, switching and restart persistence passed |
| flutter build web --release | Passed, including bundled collection artwork |
| python3 tools/quality_gate.py | Passed; all authored text files <=300 physical lines |
| git diff --check | Passed |

Widget checks cover 320/1440 widths, both themes and 100%/180% text, plus
publication, reopening dates, invalid/valid scope switching and quote failure/retry.
Server tests include simultaneous block/booking writes, quote tampering with an
access credential, price changes/expiry, object scope and seed-once persistence.
The real HTTP tool creates/deletes only its temporary workspace, not actual .local.

Real headless Chrome used a temporary clean browser profile against the running
API, with accessibility enabled. It traversed all four menus at 1440/390 widths
in light/dark mode and checked record-backed content; no JS exceptions occurred.
Sixteen screenshots are in /tmp/precision-populated-{desktop|mobile}-{light|dark}-*.png.
Selected captures were visually inspected. No personal browser profile was used.
Private vehicle/reservation rows and the operator key were fingerprinted before
restart and verified unchanged afterward, without logging records or key values.

Initial narrow/large-text tests found notice and status-row overflows. Both layouts
were corrected; no assertions were disabled. The first Chrome helper assumed a
specific WebSocket reason phrase; accepting the valid 101 status fixed the helper.
Web build retains the existing nonfatal CupertinoIcons font-family advisory.

## Changed files in this task
- README.md; pubspec.yaml; .github/workflows/quality.yml.
- server/{__main__,database,http_server,operations,pricing,examples}.py;
  server/{test_operations,test_example_http}.py; server/README.md.
- lib/app/{mobility_app,mobility_shell}.dart; core/network/api_client.dart;
  shared/design/workspace_notice.dart.
- features/discovery/domain/vehicle.dart;
  features/discovery/presentation/{catalog_vehicle_card,collection_artwork}.dart.
- features/garage/application/vehicle_operations_controller.dart;
  features/garage/presentation/{inventory_screen,vehicle_operations_screen}.dart.
- features/bookings/application/reservation_controller.dart;
  features/bookings/domain/price_quote.dart;
  features/bookings/presentation/booking_panel.dart.
- features/profile/presentation/{workspace_screen,workspace_access_panel,workspace_overview}.dart.
- test/{studio_interface_test,populated_workspace_test}.dart;
  test/support/workspace_api.dart; tools/check_local_api.dart.
- assets/images/sample-{touring,electric,suv}.png.
- docs/product/{requirements-status,vision}.md; docs/architecture/boundaries.md;
  docs/design/{screen-map,collection-assets}.md;
  docs/security/auth-and-data-boundaries.md; docs/verification/{FINAL,TASK-013}.md;
  tasks/INDEX.md; tasks/done/TASK-013-requirements-and-populated-workspace.md.

Paths under features/core/shared above are relative to lib/. Previously modified
TASK-012 files remain intact; the original ZIP archive is untouched. There are no
new package dependencies, outbound messages, commits, pushes or public deployments.

## Limits and next acceptance
This completes the local task, not every capability in the product vision.
Customer verification/payment providers remain deferred by the user. Actual
handover, photo evidence/AI review, vehicle commands, production RBAC, commercial
policy, reviews/support/notifications and public release still require the
dependencies/decisions recorded in the requirement map. No such success is faked.
Next: visual/device acceptance on the target physical phone, then the explicitly
selected real integrations. Native signing/runtime and screen-reader certification
have not been verified by these browser/widget checks.
