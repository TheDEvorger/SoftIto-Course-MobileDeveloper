---
name: testing
description: Build evidence for behavior and regression safety.
---

# Tests
1. Domain validation and error states with deterministic inputs.
2. SQLite repository tests (use in-memory SQLite).
3. Widget tests with fake repository overrides.
4. Integration tests for the critical vertical slice.
5. Run `flutter analyze`, `flutter test`, limits check.
6. Report skipped tests as skipped, never as passed.
