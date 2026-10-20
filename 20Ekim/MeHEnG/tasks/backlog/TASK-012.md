# TASK-012: Growth launch and metrics

Status: blocked
Depends: TASK-010
Priority: P1

## Goal
Introduce launch milestones and locally entered metrics (unit, period, provenance).

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Metrics show sources/date and never imply causal success.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; sample metric test
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
