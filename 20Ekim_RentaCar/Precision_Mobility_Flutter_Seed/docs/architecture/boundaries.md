# Modular boundaries

## Client
`lib/app`: app wiring, shell, navigation and top-level settings.
`lib/core`: theme and transversal primitives, no feature-specific business logic.
`lib/shared`: genuinely reusable widgets. Don't prematurely abstract.
`lib/features/<feature>`: feature presentation, domain and data folders only as needed.

## Future server modules
IdentityAccess, Verification, Organizations, VehicleRegistry, Listings, Availability, Pricing, Bookings, Trips, Handover, Inspections, Payments, Payouts, Reviews, Notifications, Support, Audit.

## Default serverless renter application
main.dart → app/rental_app.dart → features/rental. Domain owns vehicle/calendar
money values and local quote/reservation contracts; data owns bundled catalog,
versioned snapshot serialization, device storage and serialized writes. Application
controller owns notifications/loading; presentation contains customer workflows.
Device writes commit before success is shown. Corrupt storage is preserved and
reported, never replaced silently. No HTTP import is reachable from the normal
renter data layer. SharedPreferencesAsync is used only for noncommercial local
planning, favorites and preferences, not verified rental contracts/critical data.

## Optional local API workspace
`server/validation.py` owns input validation; `operations.py` owns listing,
calendar and pricing rules; `pricing.py` signs/verifies quote payloads; `database.py` owns persistent records
and transactional allocation; `http_server.py` owns routes and authorization.
`examples.py` initializes only the isolated example DB; scope selection occurs
server-side before authorization/routing. The existing SQLite records/key are preserved. `main_api.dart` starts the optional API app;
`main_demo.dart` starts the historical simulation. Catalog/reservation controllers
own client state; app composition injects them into the new presentation.
`shared/design` and `core/theme/studio_*` own the rebuilt visual primitives.

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
