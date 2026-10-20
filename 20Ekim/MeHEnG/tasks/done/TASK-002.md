# TASK-002: Repository and provider tests

Status: done
Depends: TASK-001
Priority: P0

## Goal
Broaden domain and Riverpod provider tests for venture, hypothesis, experiment, evidence; inject fakes and isolate data.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Positive, negative, invalid input and refresh paths covered; no real network needed.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; flutter analyze
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
