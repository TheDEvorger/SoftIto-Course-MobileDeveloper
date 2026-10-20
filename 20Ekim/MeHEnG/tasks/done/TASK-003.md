# TASK-003: Design system and accessibility

Status: done
Depends: TASK-001
Priority: P0

## Goal
Extract only truly shared UI components, add dark theme tokens, desktop/Android keyboard/focus and empty states.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- 360/600/900/1440 layouts readable; contrast and semantics manually reviewed.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; flutter analyze; manual viewport review
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
