---
name: flutter-feature
description: Implement a small Flutter feature using domain ports and testable Riverpod UI.
---

# Feature workflow
1. Identify domain aggregate and its owner feature.
2. Add domain model/contract only if required.
3. Implement data repository and conversion with parameterized SQL.
4. Expose narrow Riverpod provider or view model.
5. Add adaptive UI with empty/loading/error states.
6. Add unit and widget tests; do not leak implementation imports.
7. Run limit checker, formatter, analyzer, tests.
