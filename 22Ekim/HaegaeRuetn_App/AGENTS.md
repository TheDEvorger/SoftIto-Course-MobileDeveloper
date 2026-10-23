# HægæRûetn — AI Agent Contract

## Do not negotiate the canon

- Brand name exactly: `HægæRûetn`; ASCII Dart package: `haegaruuetn`.
- 6 ages, 4 main ranks each, **24 levels total**. Level 23 `Kral Naibi`, level 24 `Taç Giyen`.
- 24 distinct earnable achievement badges; no `Ulu Kral` rank. No existing title may be silently changed.
- Ałek’ryŧhæ lore: avoid fake local-language etymologies. UI-readable Turkish and world words can coexist.
- Five bottom-navigation screens, no forced sign-in, optimistic uplifting art, not gloomy, not generic game assets.
- Original artwork only: generated in-house, commissioned with rights, or coded originally. Do not download/repackage unlicensed third-party art.
- Humor is warm and whimsical. Never mock someone struggling or weaponize penalties.

## Coding contract

- Flutter/Dart. Modular monolith, feature-first and simple shared core.
- SOLID / KISS / DRY / YAGNI. Prefer files under 200–300 lines; refactor when too long.
- Persist changes locally. Keep business logic out of giant widget files.
- No hardcoded tokens/secrets, no backend claims without a real backend.
- Do not silently erase the user’s local progress; migrate formats with versioning.
- Do not claim a tool passed unless it actually ran. Report exact commands and failures.
- Respect user-controlled rest days, accessibility, motion reduction, notifications consent.
- Never connect a paid AI service or publish community content without explicit user control.

## Workflow

1. Read `docs/agent/first-prompt.md`, `docs/roadmap/tasks.md`, `docs/design/art-direction.md`, `docs/lore/world-and-vocabulary.md`.
2. Ensure Flutter platform folders exist via documented bootstrap, WITHOUT replacing `lib/`.
3. Run `flutter pub get`, `dart format lib test`, `flutter analyze`, `flutter test`.
4. Fix compile, lint and test failures before adding more features.
5. Do not pretend the fictional demo plaza is a real online community; do not pretend scripted replies are an LLM.
6. Work in small tested increments and append a brief report to `docs/roadmap/progress.md`.
7. When tests pass, continue tasks in order unless a security or architectural blocker needs user input.
