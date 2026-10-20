# TASK-004: Venture edit archive

Status: done
Depends: TASK-002
Priority: P1

## Goal
Implement edit and reversible archive for a venture; preserve child records; write migration if necessary.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Edit persisted; archive excluded by default; restoring works; no silent deletion.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; manual restart persistence check
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
