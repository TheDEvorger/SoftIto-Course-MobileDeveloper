# Platform strategy

- Share domain rules and design tokens across Flutter targets.
- Mobile: bottom navigation, map-first discovery, guided camera inspection.
- Web: browser-safe workflows and accessible fleet workspace.
- Desktop: split panes, denser tables, keyboard/mouse affordances.
- Responsive breakpoints are implementation heuristics, not domain behavior.
- Not all native plugins support all targets; use capability detection and safe fallbacks.
- On Apple targets, build/signing requires macOS/Xcode. Windows runners need Windows toolchains.
- Keep service secrets on backend, never compiled into Flutter clients.
