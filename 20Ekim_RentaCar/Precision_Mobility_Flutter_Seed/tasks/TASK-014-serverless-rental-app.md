# TASK-014: Serverless rental application

## Authorization / problem
User explicitly requested a complete application that works without a server,
after screenshots showed unreachable API banners and empty operator workspaces.
This supersedes the default API dependency. Preserve previous SQLite data/code.

## Scope
Default Flutter entrypoint becomes a renter application: immediately populated
discovery, search/category/date filters, vehicle details, favorites, local quote,
reservation confirmation/receipt/cancellation and useful personal settings.
Persist user actions on the device, not in a separate Python/API process.
Use bundled labelled representative imagery and catalog data. No operator key,
workspace session, API URL or connection banner in the normal experience.

## Acceptance
- `flutter run` alone opens the populated renter app; no backend is needed.
- No HTTP/API calls are made by the default application's data layer.
- Favorite, reserve, cancel and preferences persist after app/browser restart.
- Conflicting local reservations are prevented; totals use integer minor units.
- Storage failures do not display a false successful reservation or erase data.
- All four menus have working customer actions; search/filter/detail/back work.
- Narrow/wide, light/dark and large text layouts work, including error states.
- Analyzer, meaningful tests, web build, real browser with API blocked and Python
  quality gate pass; authored text files remain <=300 lines.

## Boundaries
Local rental planning does not claim an actual supplier confirmation, customer
identity verification, payment, handover or unlocking. Existing provider decisions
remain deferred. No identity documents, card, GPS or new retention policy.
The old API workspace remains an explicitly optional alternate entrypoint.

## Output
Updated startup/product docs and docs/verification/TASK-014.md with changed files,
evidence, limits and next task.
