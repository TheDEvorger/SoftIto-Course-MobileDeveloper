# ADR-0001: Feature-first modular monolith
Status: accepted | 2026-10-20

Context: Four large product domains share venture identity, but are not
separate deployable backends in first release.

Decision: One Flutter package, narrow domain modules, repository ports,
separate presentation/data, local-first persistence.

Consequences: Lower operations and token overhead, simpler builds/tests.
Cross-domain imports must be explicit. Service split only on proven needs.
