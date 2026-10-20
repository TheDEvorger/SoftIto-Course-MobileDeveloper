# TASK-006: Hybrid handover

Date: 2026-10-20. Status: DONE.

## Implementation
Added pure fail-closed handover model, physical/digital demo UI and route from
confirmed session bookings. Shared prerequisites: confirmed booking, simulated
pickup window, driver permission, vehicle condition, inspection and readings.
Physical path requires parties and mutual acceptance; digital path requires
compatibility and an explicit simulated positive acknowledgement. Negative or
uncertain status blocks completion. Connection loss invalidates preflight;
rechecking and a new demo acknowledgement are required. Booking confirmation is
rechecked at completion, not captured as a permanently trusted initial value.
Mode/prerequisite changes invalidate the previous demo result.

## Evidence
`flutter test test/handover_test.dart`: 4 passed; every missing prerequisite,
inspection/readings/acceptance gates, duplicate finish, invalidation, unsupported
hardware, rejected acknowledgement, connection loss and error UI are covered.
`flutter analyze`: no issues. Python quality gate: passed.
Test scrolling corrected for lazily constructed ListView children.
Logs: logs/TASK-006/.

## Files and limits
Added handover/domain/demo_handover.dart, presentation/handover_demo_screen.dart,
and test/handover_test.dart. Updated app router and bookings list; task registry
and this report. No SDK, key, network or hardware operation; no real trip starts.
Pickup eligibility/permissions/readings use clearly labelled simulation inputs,
not production checks. No native/device verification.
Next: TASK-007 replaces the inspection checkbox with a 20-slot checklist.
