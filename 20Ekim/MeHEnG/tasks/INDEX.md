# MeHEnG task index

Status source of truth is each task card, not this summary.
Move completed card into `tasks/done/`, change its status to `done`,
and update `tasks/HANDOFF.md`. A blocked task becomes ready only after
its dependencies are completed; never change states blindly.

| ID | Milestone | Initial status | Depends |
|---|---|---|---|
| TASK-001 | Toolchain and baseline quality | done | none |
| TASK-002 | Repository and provider tests | done | 001 |
| TASK-003 | Design system and accessibility | done | 001 |
| TASK-004 | Venture edit archive | done | 002 |
| TASK-005 | Evidence source and provenance | done | 002 |
| TASK-006 | Decision log | done | 005 |
| TASK-007 | Experiment method and success rule | ready | 006 |
| TASK-008 | Data export and safe backup | ready | 005 |
| TASK-009 | Workspace tasks and milestones | ready | 004 |
| TASK-010 | Lean canvas workspace | blocked | 009 |
| TASK-011 | Budget and scenario planning | blocked | 009 |
| TASK-012 | Growth launch and metrics | blocked | 010 |
| TASK-013 | Network security architecture | blocked | 008 |
| TASK-014 | Opt-in public venture projection | blocked | 013 |
| TASK-015 | Collaboration and moderation | blocked | 014 |
| TASK-016 | Optional AI research assistant | blocked | 007 |
| TASK-017 | Offline sync feasibility study | blocked | 014 |
| TASK-018 | Release candidate security and UX | blocked | 012 |

Use `/meheng-grow` or `python tool/next_task.py` for next task selection.
