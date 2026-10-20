# TASK-005: Booking state

Date: 2026-10-20. Status: DONE.

## Implementation
Pure Dart ledger, immutable records and explicit quote/confirm/cancel/expire
transitions. Five-minute expiry and interval conflict prevention. App-session
controller exposes demo quotes in Sürüşlerim; details route opens quote form.
No providers, charges or actual reservations; rules in architecture/demo-bookings.md.

## Evidence
`flutter test test/booking_ledger_test.dart test/booking_flow_test.dart`:
6 passed. Covers inclusive expiry, invalid input/IDs, contained/enclosing overlap,
adjacent bookings, different vehicles, cancellation releasing slots, terminal
states and end-to-end widget quote/confirm/cancel navigation.
`flutter analyze`: no issues. Python quality gate: passed.
Logs: logs/TASK-005/.

## Files and limits
Added bookings/domain/booking_ledger.dart, application/demo_booking_scope.dart,
presentation/booking_demo_screen.dart, test/booking_ledger_test.dart and
booking_flow_test.dart. Updated app/precision_app.dart, BookingsScreen,
VehicleDetailsScreen, registry, lifecycle document and this report.
Local synchronous conflict checks do not solve server concurrency. No fees,
server quote validation, payment, durable storage or native verification.
Next: TASK-006 hybrid handover simulations.
