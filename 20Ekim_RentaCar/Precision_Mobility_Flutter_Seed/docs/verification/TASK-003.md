# TASK-003: Responsive discovery

Date: 2026-10-20. Status: DONE.

## Implemented
- Below 900 logical pixels of discovery content width: list/map toggle.
- At or above 900: independently scrollable vehicle list and schematic map
  side by side. App navigation width is excluded from this breakpoint.
- Local fixtures drive both views; no additional providers or dependencies.
- Combined case-insensitive, trimmed name search and fleet-only filtering.
- Filtered schematic markers retain stable fixture positions; marker selection
  shows an explicitly labelled sample vehicle with tooltip/selection semantics.
- Filter changes clear marker selection; empty results have a textual hint.
- Vehicle cards now use content height rather than a fixed grid extent to
  accommodate long text and accessibility text scaling without clipping.
- Map explains that locations are illustrative and GPS/live data are absent.

## Validation
Flutter 3.47.7 / Dart 3.13.5. Existing platform runners were retained.
Commands use `/tmp/flutter/bin` tools with `CI=true` and analytics suppressed.

| Command | Outcome |
| --- | --- |
| `flutter doctor` | Toolchain limitations below |
| `flutter pub get --offline` | Passed using cached dependencies |
| `dart format` on modified/new Dart files | Passed |
| `flutter analyze` | Passed: no issues found |
| `flutter test` | Passed: all 24 tests |
| `flutter build web --release` | Passed: built build/web in 33.4 seconds |
| `python tools/quality_gate.py` | Passed; authored files <=300 lines |

13 new widget tests supplement the 11 existing tests:
- Widths 320, 600, 899, 900 and 1440 in light and dark themes: adaptive
  layout, mobile toggle, initial markers, selection, filter reset, combined
  filters, trimmed/case-insensitive search, empty state and card results.
- Widths 320, 900 and 1440 at 200% text scale: list layout without overflow.
- Existing shell tests additionally exercise actual navigation at 320/1200.

Initial test failures exposed fixed-height card overflow at 200% text scale,
which was fixed using content-sized card rows. Two narrow-map interaction tests
also needed to scroll to the empty-state message and settle scrolling before
clicking the filter. The final suite passed without hit-test warnings.

## Changed files
- `lib/features/discovery/presentation/discovery_screen.dart`: adaptive layout.
- `lib/features/discovery/presentation/discovery_map.dart`: new schematic map.
- `lib/features/discovery/presentation/vehicle_card.dart`: content-sized layout.
- `test/discovery_test.dart`: 13 new widget tests.
- Task moved from backlog to done; registry, README, first prompt updated.
- This report, command-results and changes logs updated; raw execution logs
  included under `docs/verification/logs/TASK-003/`.

## Limits and next task
Web build emitted a CupertinoIcons font-family advisory; MaterialIcons were
found and the build succeeded. No icon dependency was added for this advisory.
No browser/device visual signoff, native builds or screen-reader certification.
Android SDK and Linux build tools are absent; iOS/macOS/Windows require their
host toolchains. Chrome is missing. Doctor's proxy check also reports an
interface-listing exception. Flutter/Dart were invoked via absolute SDK paths.
The map is schematic, not geographic, and does not capture location or make
network requests. Prices/distances remain existing example fixture values.
No new product rules, payments, identity, retention or vehicle unlock behavior.
Next: TASK-004 vehicle details, fixture attributes and routing/state tests.
