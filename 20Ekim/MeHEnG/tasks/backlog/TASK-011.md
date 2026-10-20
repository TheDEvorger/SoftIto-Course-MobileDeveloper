# TASK-011: Budget and scenario planning

Status: blocked
Depends: TASK-009
Priority: P1

## Goal
Add venture-scoped currencies, cost/revenue assumptions, totals and break-even simulation.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Decimal/currency policy documented; calculations tested; no misleading profits.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; numerical fixtures
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
