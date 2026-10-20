# ADR-0002: Local-first core, network later
Status: accepted | 2026-10-20

The Discover core needs private offline-first drafts and evidence.
Decision: SQLite in app support directory, no account prerequisite.
The app's initial native targets are Windows and Android.

Limits: DB files are not encrypted. No cross-device sync. Backups not yet
implemented. Do not store trade secrets or sensitive customer data yet.

Future: backup, encryption feasibility, asynchronous SQL, opt-in sync,
server-authoritative authorization for public/network features.
