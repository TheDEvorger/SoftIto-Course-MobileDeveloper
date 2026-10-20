# TASK-001: Toolchain and baseline quality

Status: done
Depends: none
Priority: P0

## Goal
Create Android and Windows scaffolds locally; run flutter doctor, pub get, dart format, analyze, tests, limits; fix seed compile issues without feature creep.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Flutter apps start on Windows + Android emulator; no analyzer error; all authored files <=250 lines.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter doctor -v; flutter analyze; flutter test; python tool/verify_seed.py
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
