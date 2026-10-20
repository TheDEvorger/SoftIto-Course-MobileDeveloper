# TASK-016: Optional AI research assistant

Status: blocked
Depends: TASK-007
Priority: P2

## Goal
Optional AI-assisted hypothesis critique; explicit privacy opt-in; no automatic external data sending.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Offline flows unchanged; output visibly labeled suggestion, never evidence.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- privacy and prompt-injection tests
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
