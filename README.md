\# Tripora — Smart Trip Planner



\*\*Plan. Explore. Book. Remember.\*\*



A Flutter travel planning and booking application built as part of the CODIORA House Mobile Application Development internship (Batch 3).



\## Features



\### Trip Planning

\- Create, edit, and view trips with day-by-day itineraries

\- Add/edit activities per trip day, categorized by type

\- Dashboard with trip stats (total trips, planned days, activities)



\### Travel Services \& Booking

\- Browse travel services across 4 categories: Hotels, Tours, Transportation, Activities

\- Search by name, location, or category with live filtering

\- Detailed service view with features, ratings, and availability

\- Full booking flow: form → validation → dynamic pricing → summary → confirmation

\- Auto-generated unique booking IDs (e.g. `TRP-2026-8F42A1`)

\- My Bookings with Upcoming/Previous tabs

\- Booking cancellation with confirmation dialog (status preserved, not deleted)

\- All bookings persisted locally via Hive



\### Reviews, Ratings \& Community

\- Star-based rating and review submission for any travel service

\- Average rating and star-distribution summary (5★ down to 1★)

\- Review filtering by star rating

\- "Helpful" voting on individual reviews

\- Embedded review summary + top reviews on Service Details, plus a full standalone Reviews screen

\- All reviews persisted locally via Hive, seeded with sample data on first launch



\### Smart Recommendations \& Travel Assistant

\- Guided preference form (travel style, budget, trip duration, category, travelers)

\- Rule-based recommendation engine — scores services by category match, style-implied category, and budget tier

\- Match tiers (Best/Good/Fair Match) with a percentage indicator and "why recommended" reasoning

\- Save/favorite recommended services, persisted locally via Hive

\- Travel Assistant with predefined questions and data-driven, rule-based answers



\## Technologies



\- \*\*Flutter\*\* \& \*\*Dart\*\* (null safety)

\- \*\*Riverpod\*\* — state management

\- \*\*Hive\*\* — local persistence

\- \*\*GoRouter\*\* — declarative navigation

\- \*\*Equatable\*\* — value equality for immutable models

\- \*\*Google Fonts\*\* (Poppins) — typography

\- \*\*Intl\*\* — date \& currency formatting

\- \*\*UUID\*\* — unique ID generation

\- Material 3 design system



\## Architecture



Feature-based structure under `lib/features/`, with shared code in `lib/core/`:

