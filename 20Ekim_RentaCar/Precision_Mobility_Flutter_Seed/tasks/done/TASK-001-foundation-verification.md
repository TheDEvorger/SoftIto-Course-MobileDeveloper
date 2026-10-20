# TASK-001: Verify Flutter foundation

## Goal
Generate platform runners if missing and verify project builds/tests locally.

## Scope
- Check Flutter toolchain and host support.
- Run `flutter create --project-name precision_mobility --platforms=android,ios,web,windows,macos,linux .` if platform scaffolding is absent; never blindly overwrite existing code.
- Run pub get, analyzer, widget tests, Python quality gate.
- Fix compile issues only and record exact evidence.

## Exclusions
No new domain features, payment, real map, remote vehicle commands or packages without approval.

## Acceptance
- Flutter dependency resolution succeeds.
- Flutter analyzer has no errors.
- Existing widget test passes.
- `python tools/quality_gate.py` exits 0.
- Known unsupported platform toolchains are honestly documented.

## Output
Changed files, commands, outputs, risks and which task to do next.

## Verification
Completed on 2026-10-20 with Flutter 3.47.7 / Dart 3.13.5.
Dependency resolution, analysis (no issues), existing widget test (1/1) and
Python quality gate (exit 0) passed. All six platform runners generated.
See `docs/verification/TASK-001.md` for host limitations and evidence.
