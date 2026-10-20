# TASK-008: Data export and safe backup

Status: ready
Depends: TASK-005
Priority: P1

## Goal
Implement private JSON export/import with schema version, validation, preview and file chooser. No upload.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Roundtrip restoration works; corrupt import never overwrites original.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; manual file import/export
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
