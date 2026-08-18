# DawamX V13

V13 is an incremental extension of the tested DawamX baseline. The existing login/navigation code is preserved; new behavior is added through a safe extension layer.

## Added
- Employee number as a first-class identifier.
- Search by employee number or employee name without losing input focus.
- Employee 360 profile.
- Residency/passport/contract fields.
- Management approval center for leave and advance requests.
- Audit log foundation.
- Country-policy foundation for Kuwait, Egypt, Saudi Arabia and UAE.
- Bulk attendance button removed from the UI.

## Important
The current browser demo remains a prototype using local data. The included SQL is a production-oriented Supabase/Postgres draft. Do not treat the demo's local role checks as security. Production authorization must be enforced with Supabase Auth + PostgreSQL RLS.
