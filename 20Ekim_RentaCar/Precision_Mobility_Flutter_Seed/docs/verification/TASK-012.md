# TASK-012: Interface rebuild and SQLite restoration

Date: 2026-10-21. User authorized a complete interface rebuild and explicitly
chose preserving/restoring the previous SQLite implementation when the workspace
reverted during inspection. Existing local records/key were not replaced.

## Delivered
- New desktop top navigation and mobile floating dock; separate legacy demo shell.
- Editorial automotive hero, responsive headline, search/date panel, ownership
  filters and real price/name sorting. No made-up listing, rating or location data.
- Distinct inventory workspace: lilac/mint/peach metrics, desktop table, mobile cards,
  status filters and create/edit forms grouped into identity, rate/publication and image.
- Fixed form save action, split vehicle details/booking summary, reservation cards,
  active/cancelled filters and confirmation dialog. No payment behavior changed.
- Split connection/settings panels, contextual help and working appearance controls.
- New paper/ink/forest foundations with teal/coral/violet complements, both themes,
  responsive typography and readable selected-state text.

## Restoration and data
Restored the API client, catalog/reservation models/controllers and Python server
with the previously used schema and HTTP contracts. Existing tables are created
only if missing; no drop, seed or data import was executed on the actual workspace.
Server retains loopback binding, per-request key checks, Host/origin controls,
integer pricing, atomic overlap prevention and idempotency. Disconnect clears
private client views; the key is held only in memory. Normal entrypoint uses API
data and never falls back to fixtures. `main_demo.dart` is explicitly historical.
Actual preserved key successfully authenticated to the existing workspace; no
key or vehicle content was printed by that check.

## Checks
- `flutter analyze`: no issues.
- `flutter test --reporter expanded`: all 57 passed. Includes original 45 tests,
  eight new menu scenarios (320/1440px, both themes, 100%/180% text), two workflow
  tests and two theme contrast tests. Create/reserve/cancel/disconnect/appearance
  were exercised; desktop table versus card adaptation was checked.
- `python3 -m unittest server.test_workspace -v`: all 6 passed, covering concurrent
  allocation, schema reinitialization without losing records, retry/cancel/date
  availability, price/input validation, authorization and origin/Host boundaries.
- `dart run tools/check_local_api.dart`: passed, real HTTP → Python → SQLite
  create/reserve/retry/conflict/cancel/restart using isolated temporary records.
- `flutter build web --release`: passed, including Wasm dry run.
- `python3 tools/quality_gate.py`: passed; all authored text files <=300 lines.
- `git diff --check`: passed. New Dart files formatted; unrelated legacy formatting
  was reverted. Existing ZIP archive and local state directory were not replaced.
- Inspected temporary 390/1440px captures of all four menus in both themes.
  Captures use test-only records/fonts, not user inventory or device certification.
  Temporary capture harness was removed before the final test run.

Initial tests caught narrow sorting controls and a fixed-height hero overflow.
Both were fixed with flexible layout. Visual review caught vertically centered
short pages and chip font inheritance; both were corrected. A Center/Align API
mistake introduced during that correction was fixed before the final clean build.

## Changed files
Paths relative to the project root. Restoration is included because it was
explicitly requested during this task.
- `lib/main.dart`, `lib/main_demo.dart`
- `lib/app/mobility_app.dart`, `lib/app/mobility_shell.dart`
- `lib/core/network/api_client.dart`
- `lib/core/theme/studio_colors.dart`, `lib/core/theme/studio_theme.dart`
- `lib/shared/design/studio_page.dart`, `lib/shared/design/page_heading.dart`, `lib/shared/design/action_state.dart`
- `lib/features/discovery/domain/vehicle.dart`
- `lib/features/discovery/application/catalog_controller.dart`
- `lib/features/discovery/presentation/catalog_screen.dart`, `catalog_vehicle_card.dart`, `editorial_hero.dart`
- `lib/features/garage/presentation/inventory_screen.dart`, `vehicle_editor_screen.dart`
- `lib/features/bookings/domain/reservation.dart`
- `lib/features/bookings/application/reservation_controller.dart`
- `lib/features/bookings/presentation/reservations_screen.dart`, `reserve_vehicle_screen.dart`, `booking_panel.dart`
- `lib/features/profile/presentation/workspace_screen.dart`
- `server/__init__.py`, `server/__main__.py`, `server/validation.py`, `server/database.py`, `server/http_server.py`
- `server/test_workspace.py`, `server/README.md`, `tools/check_local_api.dart`
- `test/studio_interface_test.dart`, `test/studio_theme_test.dart`, `test/support/workspace_api.dart`
- `assets/images/precision-editorial-hero.png`
- `pubspec.yaml`, `pubspec.lock`, `.gitignore`, `.github/workflows/quality.yml`
- `android/app/src/main/AndroidManifest.xml`, `android/app/src/debug/AndroidManifest.xml`
- `android/app/src/debug/res/xml/development_network_security.xml`
- `macos/Runner/DebugProfile.entitlements`, `macos/Runner/Release.entitlements`
- `README.md`, `docs/design/palette.md`, `docs/design/asset-provenance.md`, `docs/design/screen-map.md`
- `docs/product/vision.md`, `docs/architecture/boundaries.md`, `docs/security/auth-and-data-boundaries.md`
- `docs/verification/FINAL.md`, this report, `tasks/INDEX.md`, `tasks/done/TASK-012-interface-rebuild.md`

## Asset and limits
Hero saved at `assets/images/precision-editorial-hero.png`, generated with the
built-in image_gen tool under the imagegen skill. Full prompt and usage are in
[asset provenance](../design/asset-provenance.md). It is labelled AI-generated
brand imagery, not an actual vehicle photo, and never attached to a listing.

User deferred identity/payment providers; customer verification, charges/refunds,
real photo evidence, vehicle handover/hardware and secured public multi-user
deployment remain outside this UI task. No new retention/business policy was
activated. Native runtime/signing and screen-reader certification were not checked.
Web build retains its pre-existing nonfatal CupertinoIcons font advisory.
Next: visual acceptance on the user's target devices and further requested UI refinements.
