# TASK-015: Collaboration and moderation

Status: blocked
Depends: TASK-014
Priority: P2

## Goal
Team invitations, mentor matching, user blocking/reporting, abuse controls, rate limits and audit.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Unauthorized users see nothing private; reports and blocks functional.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- integration tests; threat model
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
