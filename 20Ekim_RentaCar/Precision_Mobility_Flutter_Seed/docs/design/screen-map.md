# Screen map

## Renter
Welcome -> guest discovery -> vehicle search/filter -> vehicle details -> availability/quote -> sign-in/eligibility -> booking -> checkout -> pickup -> inspection -> trip -> return -> review.

## Owner
Profile context -> vehicle registration -> listing -> availability and rates -> booking decisions -> handover -> evidence and earnings.

## Fleet
Organization switcher -> overview -> vehicles -> branches -> calendar -> reservations -> checkouts/returns -> maintenance -> claims -> reports.

## Support/admin
Verification queue -> claims review -> appeals -> operational audit (strict RBAC).

## Current default application (TASK-014)
Keşfet → search/city/category/date/sort → vehicle details → local price summary →
confirmation → device receipt → Planlarım → details/copy/cancellation.
Favoriler → saved vehicles or actionable suggestions → details.
Profil → plan/favorite links, persisted city/theme, privacy/help/licenses.
All catalog artwork/fonts are bundled. No workspace/key/connection screen is on
the normal path. Empty user plans/favorites do not hide the car collection.

The previous SQLite inventory/operator workspace is explicitly at main_api.dart;
the original simulation remains main_demo.dart. Identity/payment are deferred.
