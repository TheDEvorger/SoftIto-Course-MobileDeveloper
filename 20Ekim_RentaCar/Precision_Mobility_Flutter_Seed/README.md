# Precision Mobility | Flutter prototype v0.1.0

A premium hybrid P2P + fleet mobility prototype. **All 9 planned prototype tasks
are complete.** This is a local sample demonstration, not a real rental service.

## Run
1. Extract and open the project directory in your editor/Antigravity.
2. Install Flutter stable and the SDK for your target; run `flutter doctor`.
3. `flutter pub get`
4. `flutter analyze`
5. `flutter test`
6. `python tools/quality_gate.py`
7. `flutter run -d chrome` or choose a configured native device.

All six platform runners are included. Generate only missing platform files:
`flutter create --project-name precision_mobility --platforms=android,ios,web,windows,macos,linux .`
Inspect diffs before replacing existing files. iOS/macOS require macOS/Xcode;
Windows requires Windows tooling and Android requires an Android SDK.

## Available
- Responsive discovery list/map, working search/fleet filters, schematic markers.
- Light/dark/system themes, approved palette and reusable accessible controls.
- Vehicle showroom with fixture attributes, owner/fleet label and back navigation.
- Sample quotes, expiry, confirmation, cancellation and conflict prevention.
- Physical/digital handover simulations with fail-closed prerequisites.
- 20-angle evidence checklist with sample upload failure/retry, human-review
  simulation and session-only resume. No camera or actual photo upload.
- Fleet organizations/branches, viewer/operator/manager simulation and
  adaptive tables/cards with sample maintenance actions and keyboard support.
- Explicit security risk register, auth boundaries and unsigned production gates.

## Try
Keşfet → Aracı incele → Rezervasyon demosunu aç → Örnek teklif oluştur →
Demo onayı ver. Return to Sürüşlerim → Teslim demosunu aç. Complete demo
prerequisites, preflight, all 20 inspection uploads/reviews, readings and mutual
acceptance. Digital mode additionally requires simulated compatible hardware
and a positive sample lock acknowledgement. No real trip starts.
Araçlar opens the fleet workspace; select a demo operator role to edit fixtures.

## Architecture and safety
Feature-first modules; app composition owns routes and session lifetime.
Domain logic is pure Dart. No new dependencies were added for tasks 004–009.
All authored text files stay <=300 physical lines. No secrets, personal data,
real payments, GPS capture, server calls, vehicle keys or hardware commands.
Records are fictional and memory-only. Client state/roles never grant real
permissions. See docs/security/acceptance-signoff.md for blocked production gates.

## Verified
Flutter 3.47.7 / Dart 3.13.5: analyzer clean, all 45 tests passed, Python quality
gate and web release build passed. See docs/verification/FINAL.md and per-task reports for build
results, command logs and limitations. Native builds were not verified here.
Antigravity continuation: docs/agent/first-prompt.md. Registry: tasks/INDEX.md.
