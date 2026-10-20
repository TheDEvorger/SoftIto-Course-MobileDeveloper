---
trigger: glob
globs: "**/*.dart"
description: "Flutter architecture, small files, testability and adaptive UI."
---
# Flutter development boundaries
- Presentation has no direct sqlite3 or filesystem imports.
- State flows through Riverpod providers and small view models.
- Domain models have no Flutter dependency.
- Shared widget must be reused in at least two places before extraction.
- Every widget has loading/empty/error semantics where applicable.
- Android and Windows adaptive behavior, semantic labels, keyboard access.
- Do not add `!` assertions where validated type or `if` suffices.
- One public responsibility per file; 250 lines hard max.
