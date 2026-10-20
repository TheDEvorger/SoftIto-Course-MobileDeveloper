# Agent entrypoint

Your job is to build the Precision Mobility Flutter application incrementally and safely.

## Always read
- `docs/product/vision.md`
- `docs/architecture/boundaries.md`
- `tasks/INDEX.md`
- `.agent/rules/file-limits.md`
- `.agent/rules/token-budget.md`

## Load only as needed
- UI tasks: `.agent/skills/flutter-ui/SKILL.md`, `docs/design/palette.md`
- Feature work: `.agent/skills/feature-builder/SKILL.md`
- Reviews: `.agent/skills/architecture-review/SKILL.md`
- Tests: `.agent/skills/testing/SKILL.md`
- Safety: `.agent/skills/security-review/SKILL.md`

## Contract
1. Work on one task at a time; read its acceptance criteria.
2. Make minimal scoped edits; avoid sweeping refactors and unnecessary deps.
3. Never exceed 300 lines in an authored text file.
4. Run relevant analyzer/tests if Flutter is installed, and Python quality gate.
5. Report changed files, evidence, caveats, next task.
6. Never silently fabricate real providers, live vehicle data, AI accuracy or permissions.
7. Ask approval for changes to product model, payments, identity, retention and vehicle unlock.
