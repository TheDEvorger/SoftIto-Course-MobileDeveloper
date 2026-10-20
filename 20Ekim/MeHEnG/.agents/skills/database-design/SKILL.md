---
name: database-design
description: Evolve local SQLite migrations and repositories without data loss.
---

# Database change
1. Read current schema/migrations and targeted repository.
2. Add an ordered migration; never silently recreate/drop user data.
3. Keep SQL parameterized; enable foreign keys.
4. Add migration tests for empty and existing v1 databases.
5. Backup/export strategy precedes destructive migration.
6. Consider background isolates when operations can stall rendering.
