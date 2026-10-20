# Demo booking lifecycle v1

The fixture ledger is local, synchronous and memory-only. It is not a production
reservation or pricing service. App wiring owns one controller per app session.
Discovery supplies the ID to the app router; app wiring resolves the sample
vehicle and passes a read-only snapshot to booking presentation.

`quoted → confirmed → cancelled`
`quoted → cancelled` or `quoted → expired`
Cancelled/expired are terminal. Confirmation requires a nonexpired quote.
Quote expiry is inclusive at five minutes, or earlier if pickup time arrives.
UI has an explicit status refresh action; expiry is always checked at confirm.
Prices use started 24-hour periods and fixture daily rates, no charges/taxes.
The UI offers next-day 10:00 device-local pickup and 1/2/3/7 elapsed days.
A new quote does not cancel previous quotes; the session list exposes them.

Confirmed intervals use [start, end); adjacency is valid. Confirmation checks
all confirmed allocations for the same vehicle in one synchronous operation.
Cancellation releases allocation. Invalid IDs/transitions fail without creating
allocations. Production must replace this with server pricing, transactional
locking, verified eligibility and idempotency. Client state is never authority.
Policy version demo-v1 has no fees and makes no commercial policy decision.
