---
trigger: model_decision
description: "Apply on auth, sharing, community, external APIs, sensitive data, filesystem, or backups."
---
# Privacy and security
- A venture is private by default. Public summaries are separate projections.
- Access control happens on server, never only in Flutter UI.
- Never log sensitive payloads or include secrets in repository.
- No third-party sharing without explicit per-field consent.
- Threat model before Network and messaging; abuse reporting and moderation.
- Never claim SQLite is encrypted; design key management before sensitive release.
- Use parameterized SQL; forbid user-input SQL string interpolation.
- Data deletion is previewed and reversible where practical.
