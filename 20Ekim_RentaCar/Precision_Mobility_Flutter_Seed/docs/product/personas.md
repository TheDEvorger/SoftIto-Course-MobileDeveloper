# Personas and role contexts

- Renter: discovers vehicles, checks eligibility, books, documents collection and return.
- Individual owner: lists own cars, controls availability and handover, views earnings.
- Fleet organization: manages fleet, branches, roles, maintenance, operations.
- Fleet employee: operates only within explicitly assigned organization permissions.
- Reviewer: inspects claims and evidence under restricted access.
- Platform admin: moderates, handles audit and support; highly privileged actions require audit.

A person may hold multiple contexts. Authentication identity is not equivalent to authorization role. Role checks always occur server-side.
