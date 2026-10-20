# TASK-006: Decision log

Status: ready
Depends: TASK-005
Priority: P1

## Goal
Add decisions linked to explicit selected evidence IDs, rationale and decision outcome: continue/pivot/stop.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- User can trace a decision to supporting and contradicting observations.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; widget decision test
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
