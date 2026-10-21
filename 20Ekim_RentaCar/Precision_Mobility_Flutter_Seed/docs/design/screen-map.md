# Screen map

## Renter
Welcome -> guest discovery -> vehicle search/filter -> vehicle details -> availability/quote -> sign-in/eligibility -> booking -> checkout -> pickup -> inspection -> trip -> return -> review.

## Owner
Profile context -> vehicle registration -> listing -> availability and rates -> booking decisions -> handover -> evidence and earnings.

## Fleet
Organization switcher -> overview -> vehicles -> branches -> calendar -> reservations -> checkouts/returns -> maintenance -> claims -> reports.

## Support/admin
Verification queue -> claims review -> appeals -> operational audit (strict RBAC).

## Current default application
Keşfet → API inventory → date availability → vehicle details → server quote → reservation record →
Sürüşlerim → cancellation. Araçlar → workspace connection → create/edit/rate/maintenance → publication/date blocks.
Hesabım → example/private connection, actual record overview, appearance and help.
The default isolated example workspace is populated through SQLite, not a client
fixture fallback. A persistent banner identifies fictional records in every menu. Desktop uses top navigation and a vehicle
table; mobile uses the dock and cards. Identity/payment remain deferred.
The original seed is explicitly retained through main_demo.dart.
