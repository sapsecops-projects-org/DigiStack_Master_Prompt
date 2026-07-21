# DigiStack Health Enterprise — Application Coding Standards & Concept-Coverage Map

Companion to `01_MASTER_CONTEXT.md`. Purpose: every module's code gets written consistently, and
deliberately exercises the WebSphere concept it exists to teach — not just the business feature.
This file governs *how* code is written at every module-build sprint (2.1, 2.2, 2.10–2.15, 2.17);
it does not contain the code itself (see the Versioning note at the bottom for where that lives).

---

## General coding conventions

- **Stack:** Java 8, Servlet 3.x, JSP, JDBC, DAO pattern — **no frameworks** (no Spring, no
  Hibernate, no ORM). Keeps the focus on WebSphere administration, not framework mastery, per
  Master Context Section 4.
- **Package structure** (fixed at Sprint 1.2, do not deviate): `com.digistack.health.{controller,
  service, dao, model, filter, util}`.
- **Maven standard layout from day one** (`src/main/java`, `src/main/webapp`) — anticipates
  Sprint 2.24's packaging so there's no late restructure.
- **One Service class + one DAO class per business capability**, roughly 1:1 with modules.
- **No SQL outside the DAO layer.** Controllers never touch JDBC; Services never touch JDBC.
- **Logging:** a single small logger utility class from the very first module (2.1) — never
  `System.out.println` — even though centralized/cross-cutting logging isn't formally taught
  until Sprint 2.22. Having every module already log through the same utility is what makes
  2.22 a consolidation exercise instead of a rewrite.
- **Exceptions:** business-rule violations throw custom checked exceptions (e.g.
  `CancellationWindowException`), not generic `RuntimeException` — starting at Sprint 2.12,
  the first sprint that actually needs one.
- **Data:** all test/demo data synthetic, matching `schema.sql` exactly — never real PHI, no
  exceptions, per the project's data-hygiene rule.

---

## Concept-coverage map — what each module's code must actually demonstrate

| Sprint | Module | Concept the code must expose | Non-negotiable detail |
|---|---|---|---|
| 2.1 | Login | First-ever deployment | Deployable as-is, no shortcuts that only work "in theory" |
| 2.2 | Dashboard | Session attributes (JSESSIONID) | Real session data stored — Sprint 2.9's failover test needs something to lose or keep |
| 2.10 | Patient Registration | JDBC pool behavior under concurrency | DAO structured so a connection leak can be deliberately toggled in later for Sprint 3.7 |
| 2.11 | Book Appointment | Transactions — commit/rollback | An explicit transaction boundary in the Service layer, not per-statement auto-commit |
| 2.12 | Cancel/Reschedule | Business-rule exception handling | Real custom checked exception, not a generic catch-all |
| 2.13 | Profile | Multi-module routing | No IDOR — every lookup scoped to the logged-in user's own ID, not a request parameter |
| 2.14 | Visit History | Query tuning for larger result sets | Written unpaginated first, on purpose, so tuning it later is a genuine before/after |
| 2.15 | Logout | Session invalidation, deep dive | Explicit `session.invalidate()` + a real, configured timeout — not left to framework defaults |
| 2.17 | Lab Order & Referral | MQ / MDB / async status | A real JMS producer and a real MDB consumer — not a simulated queue |

---

## Deliberate weaknesses reserved for Phase 3 (`09_REALISM_ENHANCEMENTS.md` Section 3)

These get added **on purpose**, at normal build time, then "discovered" cold at Phase 3 —
matching the Lab Challenge Bank's "injection, not disclosure" rule. Not accidents; not
retrofitted after the fact.

- One unbounded in-memory cache (e.g. a `HashMap` that's never evicted) — reachable code path,
  for the OutOfMemoryError lab (3.6).
- One DAO method written without closing its connection in a `finally` block, easy to
  toggle/revert — for the connection-leak lab (3.7).
- One `synchronized` block sized so it actually contends under load — for the hung-threads
  lab (3.6).

---

## Versioning

This file governs coding **standards**. The actual application source code lives in a
**separate Git repository** (`digistack-health/`), managed via **Claude Code**, not pasted into
claude.ai chat sessions — decided 2026-07-15 (see `03_PROGRESS_LOG.md`'s Key Decisions Log).

- The repo is a **full, buildable Maven project** (`mvn clean package` produces a real WAR) —
  not illustrative snippets. Skeleton (pom.xml, package structure, web.xml, a copy of
  `schema.sql`) was created and committed as of Sprint 1.10.
- `schema.sql` is duplicated in both places (this claude.ai project and the repo) and must be
  kept identical — if one changes, update both, same session.
- Commit messages reference the sprint's ticket ID, e.g. `SR000011 (Sprint 2.1): Login servlet,
  service, DAO`.
- **Going forward:** the simulation/planning layer (Recap, Manager's Assignment, Learning
  Session, Production Incident, Documentation, Interview Questions, Handover) still runs here
  in claude.ai chat exactly as before. When a module-build sprint's Hands-on Task calls for
  actual code (2.1, 2.2, 2.10–2.15, 2.17), that part happens in a Claude Code session against
  this repo — bring the resulting commit(s) back to this chat for the Documentation phase,
  Dev Handoff Package, and Progress Log entry.
