# TASK-009: Workspace tasks and milestones

Status: ready
Depends: TASK-004
Priority: P1

## Goal
Feature-owned local tasks and milestone links per venture; status and due date with timezone handling.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Tasks persist; ventures isolated; responsive task UI; empty state.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; manual create and complete flow
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
