# TASK-018: Release candidate security and UX

Status: blocked
Depends: TASK-012
Priority: P2

## Goal
Run build, accessibility, licensing, backup, privacy, QA and distribution readiness; require explicit publish approval.

## Non-goals
Unrelated refactors, new infrastructure, blind package upgrades.

## Acceptance
- Windows/Android release builds verified; documented known gaps and rollback.
- All authored files <=250 lines; maintain testable module boundaries.
- No private user data sent externally without opt-in.

## Verify
- flutter build windows; flutter build apk; manual QA
- `python tool/check_limits.py`
- Record real pass/fail output in `tasks/HANDOFF.md`.
