---
name: meheng-grow
description: Grow the MeHEnG Flutter seed one verified task at a time. Use to continue development.
---

# Controlled growth loop
1. Read `tasks/INDEX.md` and `tasks/HANDOFF.md` only, then select earliest ready task.
2. Read its task card and only directly referenced docs/skills.
3. Verify toolchain and baseline tests; if broken, record blockers first.
4. Deliver one vertical slice, smallest sensible patch and tests.
5. Run `python tool/check_limits.py`, `flutter analyze`, `flutter test`.
6. Update task status, handoff, optional ADR after verification.
7. Report touched files, evidence, risk, next task; repeat only while authorized.
8. Stop for sensitive/network/irreversible decisions or user-required review.
9. Never run indefinitely, claim background execution or spend paid credits blindly.

See `references/definition-of-done.md` only at completion.
