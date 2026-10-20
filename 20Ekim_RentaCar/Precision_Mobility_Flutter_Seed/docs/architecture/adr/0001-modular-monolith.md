# ADR-0001: Modular monolith as initial backend

Status: Proposed

## Context
Need reliable reservation, handover and payment correctness before scaling independent teams/services.

## Decision
Start with one deployable backend separated into bounded modules, strict ownership and contracts.

## Consequences
+ Simpler transactions, operations and testing.
+ Can isolate high-volume integrations later.
- Modules require explicit dependency enforcement to avoid degenerating into shared table access.

Revisit on measured operational needs, not predicted scale.
