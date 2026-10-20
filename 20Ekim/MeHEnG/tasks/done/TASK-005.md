# TASK-005: Evidence source and provenance

Status: done
Depends: TASK-002
Priority: P1

## Goal
Add optional source, recorded date, note provenance and consent warning to evidence; maintain old DB compatibility.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Migration v1->v2 preserves all records; source is optional; consent UI visible.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; migration tests
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
