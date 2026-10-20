# TASK-017: Offline sync feasibility study

Status: blocked
Depends: TASK-014
Priority: P2

## Goal
Compare local/remote source-of-truth, conflict policy and deletion handling. Prototype separately before launch.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Conflict tests documented; no production sync without sign-off.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- design review; conflict tests
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
