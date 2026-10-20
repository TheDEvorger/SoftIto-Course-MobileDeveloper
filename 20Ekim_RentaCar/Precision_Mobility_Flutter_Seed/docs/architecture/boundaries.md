# Modular boundaries

## Client
`lib/app`: app wiring, shell, navigation and top-level settings.
`lib/core`: theme and transversal primitives, no feature-specific business logic.
`lib/shared`: genuinely reusable widgets. Don't prematurely abstract.
`lib/features/<feature>`: feature presentation, domain and data folders only as needed.

## Future server modules
IdentityAccess, Verification, Organizations, VehicleRegistry, Listings, Availability, Pricing, Bookings, Trips, Handover, Inspections, Payments, Payouts, Reviews, Notifications, Support, Audit.

## Ownership examples
- VehicleRegistry owns the canonical vehicle record.
- Listings owns what can be discovered; cannot own VIN registration.
- Availability owns calendar/block windows, Booking owns booking state.
- Trips owns usage session; Handover owns inspection and release decisions.
- Inspection owns evidence and findings, not final penalty calculation.
- Payments owns transaction state, not personal card number storage.

## Dependency direction
UI -> use cases/domain contracts -> data adapters (implement domain contracts).
Domain never imports Flutter, HTTP clients, SDKs, or databases.
Cross-module writes must go through owner contracts. Use events only where async consistency is acceptable; reserve synchronous invariants for transactional boundaries.

## Avoid
Microservices, blanket CQRS/event sourcing, repository interfaces for trivial local-only screens, a universal god-service, feature-specific logic in app shell.
