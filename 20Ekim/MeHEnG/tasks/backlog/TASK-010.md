# TASK-010: Lean canvas workspace

Status: blocked
Depends: TASK-009
Priority: P1

## Goal
Typed lean canvas sections, revision history and private drafts tied to Venture.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Sections independently editable; state persists and is not networked.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter test; flutter analyze
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
