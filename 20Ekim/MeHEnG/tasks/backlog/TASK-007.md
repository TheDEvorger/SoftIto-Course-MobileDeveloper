# TASK-007: Experiment method and success rule

Status: blocked
Depends: TASK-006
Priority: P1

## Goal
Introduce measurable experiment target and success criteria with confidence limits, without artificial success scoring.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Experiment plan and measured outcome are distinct; thresholds persisted.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; domain tests
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
