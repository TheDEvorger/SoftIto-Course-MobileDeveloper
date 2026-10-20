# TASK-013: Network security architecture

Status: blocked
Depends: TASK-008
Priority: P2

## Goal
Design real auth/backend, ownership and membership authorization; threat-model public projection; get owner approval for provider.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- ADR and threat model approved; no credentials hardcoded or data leaked.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- security review; owner approval
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
