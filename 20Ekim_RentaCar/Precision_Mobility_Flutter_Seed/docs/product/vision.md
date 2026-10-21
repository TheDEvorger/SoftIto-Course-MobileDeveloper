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

## Current serverless application (TASK-014)
User explicitly requested a functioning rental app without a server after API
errors blocked the interface. Normal main.dart now starts the renter experience:
bundled collection, search/filter, favorites, details, local quote, reservation,
cancellation and profile/preferences. Device storage preserves user actions.
No API startup, workspace session, key or provider is required for these flows.
The existing SQLite/operator implementation is preserved at main_api.dart;
main_demo.dart remains the historical simulation. Identity/payment providers
remain deferred. Local plans do not claim supplier confirmation, vehicle allocation,
payment or handover. Catalog information and labelled concept images are examples.
