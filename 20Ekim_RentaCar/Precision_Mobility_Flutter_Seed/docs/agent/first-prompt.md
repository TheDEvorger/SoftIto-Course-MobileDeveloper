# Antigravity continuation prompt

Read AGENTS.md, tasks/INDEX.md, docs/product/vision.md, docs/architecture/boundaries.md,
docs/verification/FINAL.md and docs/security/acceptance-signoff.md.

TASK-001 through TASK-009 are complete. Do not repeat them or invent a TASK-010.
The current deliverable is a local-data Flutter prototype, not a real rental
service. Await a new scoped requirement for additional implementation.

To verify: flutter doctor, flutter pub get, flutter analyze, flutter test and
python tools/quality_gate.py. Web build: flutter build web --release.
Platform runners for all six targets are included; generate only missing runners
with flutter create --project-name precision_mobility
--platforms=android,ios,web,windows,macos,linux . after inspecting existing files.
Native builds require their host SDKs; never fabricate passed checks.

All authored text files: hard max 300 physical lines. Preserve feature ownership,
SOLID, KISS, DRY and YAGNI. No sweeping refactor, new major dependencies, live
providers, charges, identity collection or vehicle commands without new scope.
Production identity, payments, retention and unlock decisions require approval.
Keep simulation labels; preserve human review and fail-closed handover states.
