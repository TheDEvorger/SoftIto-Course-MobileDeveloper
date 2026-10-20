# Architecture
Flutter + Dart, feature-first modular monolith, pragmatic Clean Architecture.

## Dependency direction
UI -> Riverpod presentation providers/viewmodels -> domain contracts
<- repository implementations -> SQLite or future remote service.

## Modules
- `ventures`: Venture aggregate and ID authority.
- `discover`: Hypothesis, Experiment, Evidence, Decision domain.
- `workspace`: plan/task/canvas/finance (later).
- `network`: member/public listing/collaboration (later backend).
- `growth`: launch/metrics (later).
- `core`: shared infra only; no catch-all utilities.

## Conventions
- Domain classes have no Flutter imports.
- Each module owns its storage. No direct cross-module SQL reads.
- External references use IDs or narrow interfaces.
- Riverpod is the UI dependency/state boundary.
- Use Case class only for multi-repo business orchestration.
- SQLite is synchronous in v0.1, refactor to isolate if measurements require.
- No fake authentication or insecure production network calls.

## Controls
- <=250 lines on every authored file; test it.
- Unit tests for domain and repository, widget tests for critical flows.
- Every data schema change increments PRAGMA user_version safely.
- Never rewrite/destroy user DB on migration failure.
