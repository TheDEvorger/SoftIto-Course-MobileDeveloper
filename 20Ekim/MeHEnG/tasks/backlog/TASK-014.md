# TASK-014: Opt-in public venture projection

Status: blocked
Depends: TASK-013
Priority: P2

## Goal
Only after backend approval: server-authoritative public profile with explicit per-field preview and revocation.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Private evidence/finance never serialized to public API; ACL tests pass.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- API contract + unauthorized-access tests
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
