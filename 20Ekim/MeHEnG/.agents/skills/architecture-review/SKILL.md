---
name: architecture-review
description: Review modular monolith boundaries, SOLID, KISS and change scope.
---

# Architecture review
1. Draw existing dependency direction only for touched features.
2. Identify cycles, god classes, god providers, leaky repositories.
3. Prefer composition to inheritance and real contracts to wrappers.
4. Split by responsibility, not arbitrary line numbers.
5. DDD-lite, CQRS-lite and events are optional after evidence of need.
6. Record significant decision in one short ADR.
