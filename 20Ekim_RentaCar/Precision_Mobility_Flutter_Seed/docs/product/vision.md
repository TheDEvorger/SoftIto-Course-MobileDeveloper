# Product vision

A cross-platform, premium automotive mobility platform for private vehicle owners, fleets, and renters.

## Nonnegotiable decisions
- Business model: HYBRID peer-to-peer and fleet.
- Handover: HYBRID in-person key handover and secure digitally enabled handover.
- Platforms: Flutter mobile, web, desktop. Adaptive layout, shared business rules.
- Visual direction: Precision Automotive Luxury, not boutique hotel and not neon gamer UI.
- Themes: light/dark/system with coordinated complementary colors. User withdrew
  the five-color restriction and requested a full interface rebuild on 2026-10-21.
- Core flows: identity/verification, vehicle discovery, availability, pricing, booking, check-in/out, photo evidence, AI-assisted inspection, payments, owner/fleet console.

## Explicit constraints
- Verification and payment service providers require actual integration and regulatory review.
- AI must not automatically assign damage liability or financial penalties.
- No live unlocking without verified vehicle hardware, authorization and safety reviews.
- Start with an honest mock flow, then real integrations behind interfaces.

## Definition of prototype success
An operator can demonstrate all key flows with labelled example data, accessible screens and passing automated checks; nobody mistakes a simulation for a real rental agreement.

## Current local application
User explicitly authorized a SQLite-backed local application and restoring that
implementation after the workspace reverted. Default entrypoint now uses real
inventory/reservation records. User additionally requested populated screens:
TASK-013 opens a labelled isolated SQLite example workspace with functioning
listing/calendar/quote/booking actions. Private records remain separate. Identity/payment providers remain deferred; the
historical prototype definition above applies only to main_demo.dart.
