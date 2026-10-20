# Agent handoff
Last updated: 2026-10-20

## Seed snapshot
- Hand-authored Flutter source, small domain models, SQLite v2 and providers.
- Toolchain, platform scaffolds, test suites, accessible design, venture archive, and evidence provenance verified.
- No backend, accounts, encryption, AI or network communication yet.

## Handoff format
- Last task and status: TASK-005 (Evidence source and provenance) - done
- Commands run and outputs:
  - `flutter test`: 38/38 tests passed (database migration v1->v2, data preservation, evidence source provenance, consent checkbox, and repository persistence).
  - `flutter analyze`: 0 issues found.
  - `python tool/check_limits.py`: 117 authored files checked, 0 over limit (all <=250 lines).
  - `python tool/verify_seed.py`: passed (9 skills, 13 backlog tasks, required files).
  - `python tool/next_task.py`: Next eligible: tasks/backlog/TASK-006.md
- Files touched:
  - `lib/features/discover/domain/evidence.dart` (source, recordedAt, hasConsent)
  - `lib/core/database/schema_v2.dart` (schema v2 definition and migrateV1ToV2)
  - `lib/core/database/app_database.dart` (v1->v2 transactional migration handler)
  - `lib/features/discover/data/sqlite_discover_reader.dart` (reading v2 columns)
  - `lib/features/discover/data/sqlite_discover_repository.dart` (inserting v2 columns)
  - `lib/features/discover/presentation/discover_view_model.dart` (addEvidence with provenance)
  - `lib/features/discover/presentation/dialogs/evidence_dialog.dart` (source input and consent checkbox)
  - `lib/features/discover/presentation/experiment_tile.dart` (provenance display in ListTile)
  - `test/core/database/database_migration_v1_v2_test.dart` (real disk migration test)
  - `test/sqlite_repositories_test.dart` (user_version expectation updated to 2)
  - `tasks/done/TASK-005.md` (moved from backlog, Status: done)
  - `tasks/INDEX.md` (marked TASK-005 done, TASK-006 & TASK-008 ready)
  - `tasks/backlog/TASK-006.md` (Status: ready)
  - `tasks/backlog/TASK-008.md` (Status: ready)
  - `tasks/HANDOFF.md`
- Remaining blockers:
  - None.
- Next task: TASK-006 (Decision log)
