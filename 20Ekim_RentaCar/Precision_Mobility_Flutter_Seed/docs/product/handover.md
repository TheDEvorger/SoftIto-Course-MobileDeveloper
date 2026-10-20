# Hybrid handover specification

## Shared prerequisites
- Booking confirmed and in eligible pickup window.
- Driver permission and required vehicle conditions checked server-side.
- Booking linked to a single vehicle and inspection template version.

## Physical key path
Meet contact at agreed point -> verify handover parties -> standard inspection -> take required photos -> record mileage and energy/fuel -> mutual acceptance -> grant trip start.

## Digital key path
Check actual OEM/device compatibility -> authenticated authorized user -> proximity and safety prerequisites -> signed command with replay defense -> explicit lock status acknowledgement -> inspection -> trip start.

## Failure behavior
- No unlock? Do NOT start trip or claim success.
- Lost connection? Show uncertain state, reconcile status on server.
- Fallback only if operator supports it; never assume a physical contact is available.
- Any claim of vehicle damage is provisional pending review and appeal.

## Image evidence
Versioned template, initially 20 slots by location; stored photo hash, server receipt timestamp, upload audit and per-slot completion state. EXIF alone is not proof. AI findings have confidence and human review status.
