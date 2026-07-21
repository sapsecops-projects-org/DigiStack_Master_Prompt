# DigiStack Health Enterprise — Progress Log

A running journal of what's actually been done, sprint by sprint. Unlike the checkbox tracker in Master Context (Section 11), this file captures **what happened** — decisions made, problems hit, things to revisit. Append one entry per completed sprint; never delete old entries.

**How to use this with a new Claude session:** paste this whole file in, along with Master Context. It tells Claude exactly where you stopped and what's already been decided, so it doesn't re-teach or re-litigate anything.

---

## How to log a sprint

**Minimum viable entry — use this every time, no excuses, takes under a minute:**

```
### Sprint X.X — [Date] — DONE
What: [1 line]
Ticket(s): [optional — e.g. "CHG000004, INC000002" or "skip if not tracked"]
Commit(s): [optional — e.g. "digistack-health@a1b2c3d" or "skip if not tracked, or if no code changed this sprint"]
Time spent: [optional — rough hrs, e.g. "~3.5 hrs" or "skip if not tracked"]
Issues/deviations: [1 line, or "none"]
```

**Fuller entry — use when the sprint was a milestone, or something genuinely interesting happened:**

```
### Sprint X.X — [Sprint Name] — [Date completed]
**Status:** Complete
**Ticket(s):** [optional — e.g. "CHG000004 (build), INC000002 (incident)" or "skip if not tracked"]
**Commit(s):** [optional — e.g. "digistack-health@a1b2c3d" — the repo commit(s) this sprint produced, if it was a module-build sprint; skip if no code changed]
**Time spent:** [optional — rough hrs across all sessions for this sprint]
**What was covered:** [1-2 lines]
**Decisions/deviations from the plan:** [anything that changed from the master doc, or "none"]
**Issues hit + resolution:** [anything that went wrong and how it was fixed, or "none"]
**Carry-forward notes for later sprints:** [anything future sprints need to know, or "none"]
```

The 3-line version logged immediately beats the 5-line version logged never. Upgrade an entry later if there's time, but don't let the fuller format become a reason to skip logging altogether. **Time spent and Ticket(s) are both optional, not blockers** — Time spent's only purpose is giving Sprint 4.8 (Capacity Planning, which validates the Sprint 1.3 NFR baseline against real measured data) and `04_SPRINT_PLAN_180_DAYS.md`'s pace checks something concrete to look back on; Ticket(s) just keeps the INC/CHG/SR/PRB numbering (Master Context Section 10d) moving forward without needing a separate registry file. Skip either on any sprint where tracking it would slow you down.

**Not optional:** bump the "Current Status" section above after every sprint — Last completed sprint, Next sprint, Phase, and now also Current day/cycle and Probation stage (Master Context Section 1c) — so a new session can tell where things stand and what stage of probation/autonomy applies without recomputing it from the sprint number.

**When a Phase closes:** add a divider and a one-line phase summary *above* that phase's entries, so scanning months of history later doesn't mean re-reading every individual sprint:

```
---
## PHASE 2 COMPLETE — [Date] — [one-line summary, e.g. "cluster live, all 9 modules deployed, no major blockers"]
---
```

This keeps the log skimmable once it's 70+ entries deep — jump to the phase summary first, drill into individual sprint entries only when needed.

---

## Current Status

**Last completed sprint:** 1.6 — Lab Environment Bring-Up
**Next sprint:** 1.7 — Linux Users, Groups & Permissions (lightweight)
**Phase:** 1 — Foundations
**Current day / cycle:** Day 6 of Cycle 1 (lands on Weekly Revision day per `04_SPRINT_PLAN_180_DAYS.md`)
**Probation stage:** Trainee (Days 1–30 / Cycle 1–2, Section 1c) — tickets are SR-only, matches Sprints 1.1–1.6 (all SR + two INCs opened during sprints, none CHG)
**Blockers:** none — VM1 (vm1-dmgr-02, .10) and VM4 (vm4-pg-01, .13) live and verified per Sprint 1.6; VM2/VM3/VM5 deliberately deferred to Phase 2 per Section 6 staging

---

## Document Version Map

Tracks which version of each file is current, so a new session can sanity-check
consistency in one glance instead of reading all files end to end.

| File | Version / Last Updated | Notes |
|---|---|---|
| 01_MASTER_CONTEXT.md | v18 — 2026-07-12 | Quick Reference "Departments" row fixed — said "9 total" while listing all 10 (Middleware + 9 others); corrected to "10 total" |
| 02_CONCEPT_INDEX.md | v1.1 — 2026-07-11 | Added a note distinguishing informal Day-1 ticket/ITIL/department practice from the formal ITIL teaching at Sprints 4.5–4.6 |
| 03_PROGRESS_LOG.md | live | This file — always current by definition. Log entry templates now include optional Time spent and Ticket(s) fields; Current Status now also tracks Day/Cycle and Probation stage. |
| 04_SPRINT_PLAN_180_DAYS.md | v9 — 2026-07-12 | Removed a dangling "Part 26 advanced topics" reference in the Pace Deviation Policy (this project has no "Parts," only Phases/Sprints) — repointed the "drop a lower-priority topic" fallback to Phase 6, already flagged lowest-priority |
| 05_SESSION_PROMPT_TEMPLATE.md | v6 — 2026-07-15 | Notes that source code is deliberately NOT pasted into chat — lives in the separate `digistack-health` repo via Claude Code instead; a new session should be told what the repo's latest commit covers |
| 06_LAB_CHALLENGE_BANK.md | v1.4 — 2026-07-11 | Added a general department-ownership note to the intro so Section 1a's "every ticket names a department" rule applies file-wide without needing to edit every individual challenge line |
| 07_DEV_HANDOFF_TEMPLATE.md | v1.2 — 2026-07-11 | Added a CAB APPROVAL field alongside TICKET ID(S), for consistency with the new CAB rule (Master Context Section 10) |
| 08_TEST_CASE_SUITE_TEMPLATE.md | v1.1 — 2026-07-11 | Added an optional Linked Ticket field to the test case field table, same reason as 07 |
| 09_REALISM_ENHANCEMENTS.md | v1 — 2026-07-10 | Reviewed again — still no changes needed; it's pure technical/domain-design content, and the ticket/department wrapper applies automatically at runtime via Section 10 when its sprints are actually delivered |
| schema.sql | v1 — 2026-07-12 | Created at Sprint 1.4 — FHIR-aligned DDL (service_types, clinicians, patients, appointments, service_requests), validated live against a scratch PostgreSQL instance. **Must be updated in place** whenever a later sprint changes the schema — not just described in a Log Entry below. Required session attachment as of 05's v4. |
| 10_CODING_STANDARDS_AND_CONCEPT_COVERAGE.md | v2 — 2026-07-15 | Versioning section resolved: actual source code lives in a separate Git repo (`digistack-health/`) managed via Claude Code, not pasted into chat — full buildable Maven project, not snippets. See its own Versioning section for the split-workflow detail. |
| digistack-health/ (Git repo, external to this chat) | Skeleton committed 2026-07-15 | Full Maven project — pom.xml, package structure (controller/service/dao/model/filter/util), web.xml, a synced copy of schema.sql. No module code yet (Sprint 2.1 writes the first). Lives outside claude.ai entirely — managed via Claude Code. Not re-attached to new chat sessions; instead, mention what its latest commit covers when starting a new session. |

**Rule:** any time a file is edited, bump its version/date here in the same sitting —
don't let this table go stale. If two files reference each other and one has moved
on without the other being checked, log it as an open deviation below until reconciled.

---

## Log Entries

### Sprint 1.1 — Business Analysis & Requirements — 2026-07-12
**Status:** Complete
**Ticket(s):** SR000001, PRB000001
**Time spent:** ~1.5 hrs
**What was covered:** SDLC/Agile primer, user story + acceptance criteria format, full requirements table for all 9 modules, healthcare domain framing (patient/clinician roles, appointment lifecycle, async lab orders).
**Decisions/deviations from the plan:** None — matches Master Context Sprint 1.1 scope exactly.
**Issues hit + resolution:** Simulated requirements conflict (24-hr cancellation window vs. "any time") — resolved in favor of the 24-hr rule.
**Carry-forward notes for later sprints:** Requirements table is the direct input to Sprint 1.4's schema design — traced through cleanly.

### Sprint 1.2 — Architecture & MVC Design — 2026-07-12 — DONE
What: Defined layered architecture (Controller→Service→DAO→Model), package structure for all 9 modules, sanity-checked against OpenMRS module-boundary approach.
Ticket(s): SR000002
Issues/deviations: none

### Sprint 1.3 — Capacity & NFR Baseline — 2026-07-12 — DONE
What: Set lightweight NFR baseline — concurrent users (~50 typical / ~150 peak), response time (P95 <2s pages, <3s forms, <1s status polling), availability (99.9%).
Ticket(s): SR000003
Issues/deviations: none — flagged as a placeholder pending Sprint 4.8's real validation against Sprint 3.9 load-test data.

### Sprint 1.4 — Database Design (FHIR-Aligned Schema) — 2026-07-12
**Status:** Complete
**Ticket(s):** SR000004, INC000001
**Time spent:** ~2 hrs
**What was covered:** Full FHIR-aligned PostgreSQL schema (patients, clinicians, appointments, service_requests, service_types concept-dictionary table) — designed, DDL validated live in a scratch instance, FKs and CHECK constraints proven to hold (including a live duplicate-key incident, diagnosed and fixed with ON CONFLICT).
**Decisions/deviations from the plan:** Added a `clinicians` table and a `service_types` concept-dictionary lookup beyond the 3 core FHIR tables named in `09_REALISM_ENHANCEMENTS.md` Section 1 — both explicitly sanctioned there ("adjusting as needed") and by Sprint 1.2's OpenMRS check, which flagged the concept-dictionary idea specifically for this sprint. No separate `visits` table — Visit History reuses `appointments` where `status = 'fulfilled'`.
**Issues hit + resolution:** INC000001 — duplicate synthetic_mrn on a simulated load-script retry, resolved via idempotent `ON CONFLICT` insert pattern, now the standing practice for future batch scripts.
**Carry-forward notes for later sprints:** `schema.sql` (see Document Version Map above) is the living reference for every module-build sprint's DAO layer starting at 2.1. Password-hash-on-table simplification flagged by the Database Team as worth revisiting only if real SSO/MFA is ever added.

### Sprint 1.5 — UI Design — 2026-07-13 — DONE
What: Wireframed Login, Dashboard, and Book Appointment (auth/summary/transactional-form patterns); mapped remaining 6 modules onto the same 3 patterns; confirmed Sprint 1.4 schema needs no changes against real screens.
Ticket(s): SR000005
Issues/deviations: none

### Sprint 1.6 — Lab Environment Bring-Up — 2026-07-13
**Status:** Complete
**Ticket(s):** SR000006, INC000002
**Time spent:** [not yet logged — fill in once available]
**What was covered:** VM1 (vm1-dmgr-02, .10) and VM4 (vm4-pg-01, .13) created, RHEL 8 installed, static IPs set persistently via nmcli, hostnames set, baseline snapshots taken. VM2/VM3/VM5 deliberately deferred to Phase 2 per Section 6 staging.
**Decisions/deviations from the plan:** None — matches Section 6 exactly.
**Issues hit + resolution:** INC000002 — static IP reverting to DHCP after reboot, caused by a non-persistent nmcli config; fixed via a proper persistent connection profile, verified with an actual reboot test.
**Carry-forward notes for later sprints:** Baseline snapshots of VM1/VM4 exist — restore point before any Advanced/Expert lab challenge (per `06_LAB_CHALLENGE_BANK.md`'s snapshot-discipline rule). VM2/VM3/VM5 come online at Sprint 2.4–2.7 (cluster/IHS) and Sprint 2.16 (MQ) respectively.

---

## Key Decisions Log

*(Programme-level decisions that change the shape of the plan itself — as opposed to day-to-day deviations logged below. Referenced by `04_SPRINT_PLAN_180_DAYS.md`'s Pace Deviation Policy for the "2+ phases behind" case, and used any time a structural change to the plan is made mid-stream.)*

### Decision — 2026-07-15 — Application source code moved to a separate Git repo via Claude Code; full buildable Maven project confirmed (resolves the 2026-07-13 open question)
**Decision:** Resolved the persistence question flagged two days ago. Confirmed with the user: (1) the actual application source code lives in a **separate Git repository** (`digistack-health/`), managed via **Claude Code**, not pasted into or re-uploaded through claude.ai chat sessions; (2) the code is a **full, buildable Maven project** — `mvn clean package` produces a real WAR — not illustrative snippets. Built and committed a starter skeleton as of today: `pom.xml` (Java 8, Servlet 3.1/JSP 2.3 as provided-scope, PostgreSQL JDBC driver, JMS API for Sprint 2.16/2.17, JUnit), the full `com.digistack.health.{controller,service,dao,model,filter,util}` package structure from Sprint 1.2 (each package documented via `package-info.java`), a minimal `web.xml`, a `.gitignore`, a `README.md` explaining the split, and a synced copy of `schema.sql`. First commit made. No module code yet — Sprint 2.1 (Login) writes the first real source file, same concept-before-build rule as everywhere else in this project.
**Going forward:** this claude.ai chat continues running the simulation/planning layer (Recap, Manager's Assignment, Learning Session, Production Incident, Documentation, Interview Questions, Handover) exactly as before. When a module-build sprint's Hands-on Task calls for actual code (2.1, 2.2, 2.10–2.15, 2.17), that step happens in a Claude Code session against the repo; the resulting commit(s) get reported back here for the Documentation phase, Dev Handoff Package, Test Case Suite, and Progress Log entry. Both Log Entry templates below gained an optional **Commit(s)** field, same treatment as the existing optional Ticket(s)/Time spent fields. `schema.sql` now exists in two places (this project and the repo) and must be kept identical — update both in the same sitting if either changes.
**Reason:** A zip re-uploaded every session was the same mechanic as `schema.sql` but scaled to dozens of files across 9 modules — a real Git repo with actual version history is a better match for something meant to grow across roughly 13 more sprints, and Claude Code is built for exactly this kind of persistent, file-based work.
**Files affected:** `10_CODING_STANDARDS_AND_CONCEPT_COVERAGE.md` (v2 — Versioning section resolved), `05_SESSION_PROMPT_TEMPLATE.md` (v6 — notes the split, tells a new session not to expect source code pasted in), `03_PROGRESS_LOG.md` (this entry + Document Version Map + both Log Entry templates + parking-lot item resolved), `digistack-health/` (new external repo — skeleton committed, outside this project's own file set).

### Decision — 2026-07-13 — Coding standards + concept-coverage map added; application source-code persistence flagged as an open decision
**Decision:** Added `10_CODING_STANDARDS_AND_CONCEPT_COVERAGE.md` — coding conventions (package structure, no frameworks, logging/exception rules) plus a per-module map of which WebSphere concept each module's code must expose (e.g. Book Appointment's Service layer needs a real transaction boundary, not just a working booking feature) and which deliberate weaknesses get built in on purpose for Phase 3's troubleshooting labs (an unbounded cache, one DAO method missing its `finally` block, one contend-able `synchronized` block). Added as required attachment #10 in `05_SESSION_PROMPT_TEMPLATE.md`, same pattern as `schema.sql`.
**Left deliberately open:** unlike `schema.sql` (one file, easy to re-attach each session), the actual application source code will eventually span many files across 9 modules over roughly 13 sprints (2.1, 2.2, 2.10–2.17ish) — a much bigger version of the same "will a new session actually see this" problem. Two real options on the table: (a) keep everything in claude.ai chat, with the growing codebase zipped and re-uploaded each new session, same mechanic as schema.sql; or (b) move the actual codebase into a real Git repo managed via Claude Code, so it persists on disk instead of depending on any one chat, while the 10 markdown files + schema.sql stay in chat for the simulation/planning layer. Not decided yet — pending user input. Whichever is chosen, this file's own "Versioning" section and the Document Version Map's row for it need updating to say where the code actually lives.
**Reason:** Same class of gap the schema.sql fix caught — a real, growing artifact with no wiring into the file set a new session actually receives — caught proactively this time, before Sprint 2.1 produces the first real source file, rather than after.
**Files affected:** `10_CODING_STANDARDS_AND_CONCEPT_COVERAGE.md` (new), `05_SESSION_PROMPT_TEMPLATE.md` (v5 — new attachment #10, file-count bump), `03_PROGRESS_LOG.md` (this entry + Document Version Map + parking-lot entry below).

### Decision — 2026-07-13 — schema.sql promoted to a tracked, required companion file
**Decision:** Sprint 1.4 produced `schema.sql` — the actual, validated PostgreSQL DDL (service_types, clinicians, patients, appointments, service_requests) — as a real downloadable artifact, but it had not been added anywhere a new session would know to look for it: not in `05_SESSION_PROMPT_TEMPLATE.md`'s attachment list, and not in this file's Document Version Map. A fresh session pasted the full template plus the eight original companion files would have had zero visibility into what the schema actually looks like — only Sprint 1.4's prose summary, which will drift from reality the moment any later sprint (2.17's status lifecycle, a Phase 4 migration, etc.) changes a column. Fixed: `schema.sql` added as required attachment #9 in `05_SESSION_PROMPT_TEMPLATE.md` (file count bumped from eight to nine throughout), and added as its own row in the Document Version Map below, with an explicit rule that it must be updated in place whenever the schema changes — not just described in a future Log Entry.
**Reason:** This is the same class of gap the project's own prior audits exist to catch (a real artifact created but not wired into the file set a new session actually receives) — just the first time it's happened to a generated code/schema file rather than one of the nine original markdown companions.
**Files affected:** `05_SESSION_PROMPT_TEMPLATE.md` (v4 — new attachment #9, file-count bump), `03_PROGRESS_LOG.md` (this entry + Document Version Map + Current Status + backfilled Log Entries for Sprints 1.1–1.4, which had never actually been written in despite being completed).

### Decision — 2026-07-12 — Fourth full-file audit: department count fixed, dangling "Part 26" reference removed
**Decision:** Reviewed all nine files a fourth time, focused specifically on cross-checking numbers and cross-references against each other rather than re-reading for narrative consistency (already covered by the prior three audits). Found and fixed two small but real gaps: (1) **Department count mismatch** — Master Context's Quick Reference table said "9 total" for Departments while listing all 10 (Middleware + the 9 others) in the same row; Section 1a's own table and `05_SESSION_PROMPT_TEMPLATE.md` both correctly say "9 departments beyond mine (Middleware)," i.e. 10 total — only the Quick Reference row had the wrong number. Corrected to "10 total." (2) **Dangling "Part 26" reference** — `04_SPRINT_PLAN_180_DAYS.md`'s Pace Deviation Policy referenced dropping "Part 26 advanced topics" as a lower-priority-topic fallback, but this project has no "Parts" anywhere — it's organized entirely into 6 Phases / 70 Sprints, and no sprint/phase is flagged as "pullable/optional" except Phase 6 (Modernization), which Master Context already calls lowest-priority/conceptual-only. Likely a leftover reference from before the project's current Phase/Sprint structure was finalized. Repointed the fallback to Phase 6 explicitly.
**Reason:** Numeric/reference drift of exactly this kind (a stale count, a reference to something that no longer exists in the current structure) is the same class of gap the third audit's "Section 12 that didn't exist" bug was — worth a dedicated pass specifically for numbers and cross-references, separate from reviewing for narrative/logic consistency.
**Files affected:** `01_MASTER_CONTEXT.md` (v18 — Quick Reference Departments row), `04_SPRINT_PLAN_180_DAYS.md` (v9 — Pace Deviation Policy fix), `03_PROGRESS_LOG.md` (this entry + Document Version Map).

### Decision — 2026-07-10 — Revised weekly rhythm (explicit revision day + two-part Weekly LAB)
**Decision:** Changed the 7-day study rhythm from "6 days learning → 1 lab day" to "5 days learning → 1 Weekly Revision day → 1 Weekly LAB day (Part 1: Basic Setup & Config, Part 2: tiered Advanced LAB)." Total 15-day cycle length is unchanged.
**Reason:** Wanted an explicit consolidation day before the lab, and wanted the lab day itself split into a guided-repeat half and a cold, tiered-difficulty incident/scenario half.
**Files affected:** `04_SPRINT_PLAN_180_DAYS.md` (rhythm redefined), `06_LAB_CHALLENGE_BANK.md` (new — supplies the tiered Advanced LAB content), `01_MASTER_CONTEXT.md` Section 4 (updated to match).

### Decision — 2026-07-10 — Developer Handoff Package & Test Case Suite promoted to per-module cadence
**Decision:** The Developer Handoff Package and formal test case suite, previously produced only once at Sprint 2.24, are now produced per module at the end of every module-build sprint (2.1, 2.2, 2.10–2.15, 2.17), then reconciled/consolidated at 2.24 as before.
**Reason:** Catch integration and documentation gaps as each module ships rather than all at once at the end of Phase 2.
**Files affected:** `07_DEV_HANDOFF_TEMPLATE.md` (new), `08_TEST_CASE_SUITE_TEMPLATE.md` (new), `01_MASTER_CONTEXT.md` Section 9/10 (updated to reference per-module cadence).

---

### Decision — 2026-07-10 — Realism enhancements added (FHIR-aligned schema, real-time referral status, realistic incident seeding, OpenMRS reference)
**Decision:** Added four realism upgrades, folded into existing sprints rather than new ones: (1) Sprint 1.4's schema loosely aligned to HL7 FHIR resource shapes; (2) Sprint 2.17's Lab Order & Referral Routing gains a real-time status lifecycle + polling status badge; (3) Phase 3 troubleshooting incidents (3.5–3.8) seeded from a realistic public-pattern menu instead of invented from scratch; (4) OpenMRS referenced as an architecture-inspiration-only reading for Sprint 1.2's module-boundary check.
**Reason:** Make the practice app and its incidents feel closer to a real hospital system without adding scope, new modules, or new sprints.
**Files affected:** `09_REALISM_ENHANCEMENTS.md` (new — full detail), `01_MASTER_CONTEXT.md` (v9 — Sprints 1.2, 1.4, 2.17, and Phase 3 milestone note updated to reference it).

### Decision — 2026-07-11 — Third full-file audit: department-naming parity across ticket types, Quarterly DR Drill departments, CAB probation precision
**Decision:** Reviewed all nine files a third time. Found smaller but real inconsistencies, all now fixed: (1) **Manager's Assignment vs. Production Incident parity** — Phase 2 required naming a department per ticket, but Phase 5 (where INC/PRB/ECHG tickets are opened) didn't say the same thing, even though an incident ticket is still a ticket under Section 1a's rule. Added the matching bullet to Phase 5. (2) **Quarterly DR Drill** was the only Recurring Operational Cadence row without named departments, despite being the most multi-department event in the whole simulation in reality (DB restore, MQ, network, security/business sign-off) — added. (3) **CAB probation precision** — the Manager's Assignment CAB bullet said "before Day 90 (Section 1c), Venkatesh observes or co-presents," which blurred Section 1c's actual two distinct stages (Days 1–30 observe-only vs. 31–90 presents routine changes himself); re-pinned to match exactly. (4) **`06_LAB_CHALLENGE_BANK.md`** — rather than hand-editing a department onto every one of the ~15 challenge topics, added one general rule to the intro mapping each technical layer to its owning department, so Section 1a's "every ticket names a department" rule applies file-wide. (5) Re-reviewed `09_REALISM_ENHANCEMENTS.md` and `08_TEST_CASE_SUITE_TEMPLATE.md` deliberately rather than skipping them — both confirmed still fine: 09 is pure technical/domain design that gets the ticket/department wrapper automatically at runtime, and 08's existing Linked Ticket field already covers what a department field would add.
**Reason:** The department-naming rule (Section 1a) was introduced alongside Manager's Assignment specifically, then never propagated to the other places tickets get opened (incidents) or the other file that hands out ticket-shaped work (the Lab Challenge Bank) — the same class of gap as the probation/on-call conflict caught last pass, just smaller in blast radius.
**Files affected:** `01_MASTER_CONTEXT.md` (v17 — Phase 5 department bullet, CAB precision fix), `04_SPRINT_PLAN_180_DAYS.md` (v8 — Quarterly DR Drill departments), `06_LAB_CHALLENGE_BANK.md` (v1.4 — intro department-ownership note), `03_PROGRESS_LOG.md` (this entry + Document Version Map, including re-confirming 09 and 08 needed no changes).

### Decision — 2026-07-11 — Second full-file audit: fixed a real probation/on-call conflict, re-synced the Session Prompt Template, added Current Status day/probation tracking
**Decision:** Reviewed all nine files again against the induction/probation/cadence additions from the prior session. Found and fixed one substantive logic conflict plus several smaller gaps: (1) **Probation vs. Weekly LAB conflict** — the Weekly LAB day's ticket queue and after-hours page were written to assume full solo ownership from Cycle 1, which directly contradicted the Trainee ("no on-call," "SR-only") and Supervised Contributor ("still no solo on-call") stages added afterward in Section 1c. Fixed in `04_SPRINT_PLAN_180_DAYS.md`: ticket composition and after-hours-page ownership now explicitly scale by cycle, and the Monthly Patching cadence row got the same staging note (Cycle 2's patching window falls inside Trainee and should be Priya-driven). (2) **`05_SESSION_PROMPT_TEMPLATE.md`** — despite being rewritten last session, it predated Departments, ECHG, Communication Artifacts, Day 0 Induction, Probation, and Recurring Cadences entirely (all added afterward); rewritten a second time to catch up. (3) **`02_CONCEPT_INDEX.md`** — added a short note distinguishing informal Day-1 ticket/ITIL/department practice from the formal ITIL theory still taught at Sprints 4.5–4.6, so "have I learned CAB yet" has an unambiguous answer. (4) **`07_DEV_HANDOFF_TEMPLATE.md`** — added a CAB APPROVAL field alongside the existing TICKET ID(S) field. (5) **This file's "Current Status"** — added Current day/cycle and Probation stage fields, plus an explicit reminder to bump them every sprint, since a new session now needs that to know what level of autonomy/ticket complexity applies. `08_TEST_CASE_SUITE_TEMPLATE.md` and `09_REALISM_ENHANCEMENTS.md` reviewed again, still no changes needed.
**Reason:** Layering probation/cadence rules on top of an already-built ticketing system created exactly the kind of drift this project's own consistency discipline exists to catch — a rule added later silently contradicting a mechanic built earlier, not just a stale cross-reference.
**Files affected:** `04_SPRINT_PLAN_180_DAYS.md` (v7 — probation-staged ticket queue/on-call/patching), `05_SESSION_PROMPT_TEMPLATE.md` (v3 — second full rewrite), `02_CONCEPT_INDEX.md` (v1.1 — informal-vs-formal ITIL note), `07_DEV_HANDOFF_TEMPLATE.md` (v1.2 — CAB APPROVAL field), `03_PROGRESS_LOG.md` (this entry + Document Version Map + Current Status fields + logging reminder).

### Decision — 2026-07-11 — Company induction, 90-day probation with staged responsibility, and recurring operational cadences (sprint planning, CAB, maintenance windows, patching, DR drills, performance reviews)
**Decision:** A full HR/ops layer added on top of the existing simulation: (1) **Day 0 — Company Induction (new Master Context Section 1b)** — a one-time, lightly-played pre-Sprint-1.1 day covering HR, IT account setup, security training (incl. a HIPAA/PHI briefing), and environment access. (2) **90-Day Probation (new Section 1c)** — Days 1–90 (Cycles 1–6), three staged-responsibility levels (Trainee → Supervised Contributor → Independent Contributor), ending in a Day 90 End-of-Probation Review; post-probation growth ties to Section 10a's existing full-weight/lightweight scaling rather than a fixed schedule. (3) **CAB approval rule (Section 10)** — CHG/ECHG tickets tied to full-weight sprints or production cutovers now require explicit Business + Security sign-off before Hands-on Task starts; routine CHGs on lightweight sprints are pre-approved "standard changes"; ECHGs get expedited/retroactive approval. (4) **Production deployment framing (Section 10, Hands-on Task)** — once the cluster + IHS are live (Sprint 2.7+), every deployment is explicitly a production deployment, CAB rules included. (5) **Recurring Operational Cadences (new section in `04_SPRINT_PLAN_180_DAYS.md`)** — Weekly Sprint Planning (Day 1/8), Weekend Maintenance Window (Day 7/14, now explicitly the in-fiction Sunday — this is also where the existing ticket-queue/after-hours-page content already lived, just reframed and given weekday labels), Monthly Patching (Day 14 of even cycles), Monthly Performance Review (Day 15 of even cycles), and Quarterly DR Drill (Day 15 of every 6th cycle, scaling from a lighter readiness check to a full drill once Phase 4's DR sprints are taught). Milestone checkpoints gained an End-of-Probation gate at Cycle 6.
**Reason:** A real WebSphere admin job isn't just daily tickets — it's a full employment lifecycle: getting hired, being on probation, sitting through CAB, and living inside recurring ops cadences (patching windows, DR drills, performance reviews) that have nothing to do with any single day's technical topic. Anchoring all of it to existing cycle boundaries (rather than inventing a separate calendar) keeps it from becoming a second, competing schedule.
**Files affected:** `01_MASTER_CONTEXT.md` (v16 — new Sections 1b/1c, Section 10 Manager's Assignment/Hands-on Task/10e updates), `04_SPRINT_PLAN_180_DAYS.md` (v6 — weekday labels, new Recurring Operational Cadences section, Milestone checkpoints update), `03_PROGRESS_LOG.md` (this entry + Document Version Map).

### Decision — 2026-07-11 — Added a 9-department roster, a 5th ticket type (Emergency Change), and a formal Communication Artifacts list
**Decision:** Three additions, all cross-referenced from Master Context Section 10: (1) **Departments (new Section 1a)** — DigiStack Technologies is now explicitly organized into 9 departments (Middleware/Venkatesh's own team, Java Development, Database/PostgreSQL, IBM MQ, Linux, Network, Security, DevOps, Service Desk, Business); every ticket must now name at least one department beyond Middleware as requester, approver, or dependency, voiced briefly by Claude rather than as a full scene. (2) **Emergency Change / `ECHG` (Section 10d)** — a 5th ticket prefix alongside SR/CHG/INC/PRB, for changes that can't wait for the normal CAB cycle because production is down or about to be; used mainly for the once-a-week after-hours page and severe Phase 4/5 incidents. (3) **Communication Artifacts (new Section 10e)** — six named deliverables practiced from Day 1, each tied to a specific phase and ticket type: Change Implementation Plan + Rollback Plan (Manager's Assignment, every CHG/ECHG), Incident Update (Production Incident, every INC/ECHG), Deployment Summary (Documentation, every CHG/ECHG), Root Cause Analysis (Documentation, every PRB), and Shift Handover Note (Handover & Reflection, every day). Section 10's phases 2, 5, 6, and 8 and both 10c sign-off checklists were updated to point at these explicitly; `06_LAB_CHALLENGE_BANK.md`'s ITIL tier and `04_SPRINT_PLAN_180_DAYS.md`'s after-hours page description were updated to match.
**Bugs found and fixed during this pass (pre-existing, not introduced today):** Section 10's Manager's Assignment phase and the Communication Artifacts table both cited a nonexistent "Section 12" for the departments roster — corrected to Section 1a. Separately, Section 10b still described full/lightweight sprints in terms of "all 12 steps" and "Concept→Build/Configure→Lab→Interview Qs only" — leftover language from before Section 10 was restructured into seven, then eight, phases; corrected to match the current eight-phase framing.
**Reason:** A WebSphere admin's job is as much about who you coordinate with and what you write up as what you configure — the department roster and ticket/artifact system make that explicit and practiced from Day 1, rather than only surfacing formally at Sprint 4.5's ITIL coverage.
**Files affected:** `01_MASTER_CONTEXT.md` (v15 — new Section 1a, Section 10d/10e, Section 10 phases 2/5/6/8, 10b/10c fixes, Quick Reference, header), `04_SPRINT_PLAN_180_DAYS.md` (v5 — after-hours page description), `06_LAB_CHALLENGE_BANK.md` (v1.3 — ITIL tier and intro bullet), `03_PROGRESS_LOG.md` (this entry + Document Version Map).

### Decision — 2026-07-11 — Full cross-file consistency audit; Session Prompt Template rewritten, ticket-ID fields added to both per-module templates
**Decision:** Reviewed all nine companion files against the cumulative changes made this session (employment simulation, 9-to-5/eight-phase/ticketed daily structure, ~464-day pacing). Found and fixed two real gaps: (1) `05_SESSION_PROMPT_TEMPLATE.md` — the actual bootstrap prompt pasted into new sessions — was still describing the original plain-course framing (no DigiStack Technologies, no Priya, no tickets, no 8 phases, still said "180 days"); rewritten in full so a brand-new session gets the current picture immediately instead of relying on Master Context alone to carry it. (2) `07_DEV_HANDOFF_TEMPLATE.md` and `08_TEST_CASE_SUITE_TEMPLATE.md` had no way to record which ticket a module's build or test case belonged to; added a **TICKET ID(S)** field to 07's header block (plus its illustrative example) and an optional **Linked Ticket** field to 08's test case field table. `02_CONCEPT_INDEX.md` and `09_REALISM_ENHANCEMENTS.md` were reviewed too and needed no changes — both are pure reference/domain-design content that the employment-simulation and ticketing framing doesn't touch.
**Reason:** A multi-session project like this drifts exactly the way `04_SPRINT_PLAN_180_DAYS.md`'s stale "v8 Master Context" reference drifted before (see the 2026-07-10 cross-file consistency patch) — the fix there was to check every companion file after a structural change, not just the ones that were the obvious target of the edit. This was that same check applied to everything added in this session's three changes (Daily Session Structure, employment simulation, ticketing/pacing).
**Files affected:** `05_SESSION_PROMPT_TEMPLATE.md` (v2 — full rewrite), `07_DEV_HANDOFF_TEMPLATE.md` (v1.1 — TICKET ID(S) field), `08_TEST_CASE_SUITE_TEMPLATE.md` (v1.1 — Linked Ticket field), `03_PROGRESS_LOG.md` (this entry + Document Version Map). `02_CONCEPT_INDEX.md` and `09_REALISM_ENHANCEMENTS.md` reviewed, no changes needed.

### Decision — 2026-07-11 — Total program duration extended from 180 to ~464 days (31 cycles), same 70 sprints spread more slowly
**Decision:** Confirmed with the user (single-select clarifying question, since this materially changes the pacing math) that "464 Days" was an intentional request, not a typo. Extended the overall program from 180 days / 12 cycles to **~464 days / 31 cycles** (15-day cycle shape unchanged) — same 70 sprints, same phase order, just spread across roughly 2.6x the calendar time. Rebuilt `04_SPRINT_PLAN_180_DAYS.md`'s Projected Cycle Map, buffer sizing, and Milestone checkpoints table proportionally by sprint count per phase (Phase 1: cycles 1–4, Phase 2: cycles 5–11, Phase 3: cycles 12–14, Phase 4: cycles 15–17, Phase 5: cycles 18–20, Phase 6: cycle 21, Buffer: cycles 22–31), preserving the original plan's roughly 1-in-3 buffer share. Rounds to 465 days (31 × 15) rather than exactly 464 — a 1-day rounding difference the file's own "target rhythm, not a contract" rule treats as immaterial. `01_MASTER_CONTEXT.md` Section 4's duration line, Section 5's "pinning keeps all X days accurate" line, and a new Quick Reference "Duration" row were updated to match. The file `04_SPRINT_PLAN_180_DAYS.md` keeps its filename as-is (renaming it would touch cross-references in four other companion files for no functional benefit) — a footnote under its title now explains the mismatch, the same pattern already used for the "DigiStack Health Enterprise" title surviving the earlier banking→healthcare domain change.
**Reason:** The richer 9-to-5 daily structure (ticket queue, recap, hands-on work, incident, documentation, interview questions, handover/reflection, plus weekly on-call) genuinely takes longer per sprint than the original leaner Concept→Build→Lab format: a slower calendar pace matches the heavier daily format that was just added, rather than compressing 70 sprints' worth of that richer content into the original 180-day window.
**Files affected:** `04_SPRINT_PLAN_180_DAYS.md` (v4 — Projected Cycle Map, buffer, checkpoints, title footnote), `01_MASTER_CONTEXT.md` (v14 — Section 4, Section 5, Quick Reference), `03_PROGRESS_LOG.md` (this entry + Document Version Map + parking-lot resolution note).

### Decision — 2026-07-11 — Formalized as a 9-to-5 simulation: eight-phase workday, ITSM ticketing, weekly on-call
**Decision:** Three additions on top of the existing employment-simulation framing: (1) **Eight-phase workday** — Master Context Section 10 gains an 8th phase, **Handover & Reflection**, closing every day with a short end-of-shift handover note plus a couple of reflection questions; Phase 1 is renamed Recap & Stand-up to make the opening recap explicit. (2) **Ticketing system mindset** — every Manager's Assignment now carries a real ticket ID and a one-line business-context note, using standard ITSM prefixes (SR/CHG/INC/PRB), formalized in new Section 10d; the numbering convention increments per prefix across the whole simulation, with an optional "Ticket(s)" field added to both Progress Log entry templates so it's easy to track without a separate registry file. (3) **Weekly on-call simulation** — Weekly LAB days (Day 7/14) in `04_SPRINT_PLAN_180_DAYS.md` now open with a queue of 3–5 tickets spanning multiple types instead of a single day's topic, and close with a once-a-week "after-hours page" — a cold, out-of-hours incident (e.g. "It's 2:15 AM, the patient portal is unavailable...") drawn from the same Advanced/Expert pool in `06_LAB_CHALLENGE_BANK.md` but delivered with no daytime build-up, the way a real page arrives. The illustrative after-hours example was adapted from "banking portal" to "patient portal" to stay consistent with this project's already-established healthcare domain (see the 2026-07-10 banking→healthcare decision above) — flagging this in case a banking-domain example was actually intended.
**Reason:** Wanted the simulation to build real workplace habits, not just technical knowledge — a recap-to-handover daily shape, tickets instead of topics, and a standing on-call obligation are exactly the muscle memory a real junior WebSphere admin needs, on top of the concept-before-build technical rigor that was already in place.
**Files affected:** `01_MASTER_CONTEXT.md` (v13 — Section 10 phases 1/6/7/8 updated, new Section 10d, Section 4 weekly-rhythm line, Quick Reference, Section 1 premise), `04_SPRINT_PLAN_180_DAYS.md` (v3 — Weekly LAB Structure rewritten, stale version reference fixed again), `06_LAB_CHALLENGE_BANK.md` (v1.2 — intro cross-references updated to match), `03_PROGRESS_LOG.md` (this entry + Document Version Map + optional Ticket(s) field in both log templates).
**Open question carried to the parking lot below:** the user's message referenced "464 Days" for the overall program length, which doesn't match this project's existing 180-day / 70-sprint plan (12 cycles × 15 days). Left unresolved pending confirmation — see parking lot. **Resolved 2026-07-11** — confirmed as intentional; see the newer "Total program duration extended to ~464 days" decision entry above.

### Decision — 2026-07-11 — Whole project reframed as an employment simulation at "DigiStack Technologies"
**Decision:** Instead of a traditional course, the project is now run as a workplace simulation. Venkatesh has just joined **DigiStack Technologies** (an enterprise IT services company) as a **Junior IBM WebSphere ND Administrator**, staffed onto the **DigiStack Health Enterprise** account — a healthcare application built for a hospital-network client. He reports to a **Team Lead, Priya Nair**, who is Claude's primary persona and who hands over the day's ticket in the Manager's Assignment phase and the day's status in the Morning Stand-up phase (both from Section 10's Daily Session Structure). Claude still switches into whichever specialist voice a given Learning Session topic needs (DBA, Security Architect, etc.), framed in-fiction as Priya looping in a colleague rather than as a mode switch. Sprint 1.1 is now explicitly Venkatesh's first day on the job / onboarding. No technical content changed — the triad rule, concept-before-build order, the 70-sprint roadmap, and sprint weighting/sign-off all apply exactly as before, just delivered in character.
**Reason:** Wanted the "go to work, get a task, do it, get pulled into an incident, gain practical experience" feel to be explicit and named, not just implied by the seven-phase structure — a real company, a real job title, and a real manager to report to makes the daily framing concrete instead of abstract.
**Files affected:** `01_MASTER_CONTEXT.md` (v12 — Section 1 rewritten and renamed, Section 3 and Sprint 1.1 updated, Section 10 phases 1–2 updated, Quick Reference and Contents updated), `03_PROGRESS_LOG.md` (this entry + Document Version Map).

### Decision — 2026-07-11 — Sprint delivery reframed as a seven-phase Daily Session Structure (Stand-up, Manager's Assignment, Learning Session, Hands-on Task, Production Incident, Documentation, Interview Questions)
**Decision:** Replaced Master Context Section 10's flat 12-step sprint checklist with a seven-phase daily-workday structure: (1) Morning Team Stand-up — what happened overnight + today's priorities; (2) Manager's Assignment — a realistic work ticket, expected outcome, and soft deadline; (3) Learning Session — concepts taught beginner→advanced with real-world examples and enterprise best practices folded in; (4) Hands-on Task — build/configure the piece just taught, full Console/wsadmin/Automation triad where applicable, then Lab/Verification; (5) Production Incident — something breaks (seeded per sprint weight), diagnosed and **fully resolved** via Symptoms→Investigation→Logs→Commands→Root Cause→Resolution→Prevention; (6) Documentation — record what changed, write change notes, fill Developer Handoff/Test Suite where applicable, close with the Progress Log entry; (7) Interview Questions — scenario-based, tied to that day's ticket and incident. No content was dropped — every old step (Theory, Enterprise Scenario, Architecture, Build/Configure, Admin Console, wsadmin, Automation, Lab/Verification, Monitoring & Observability, Troubleshooting, Interview Questions, Best Practices) still happens, just regrouped into the seven phases above. Section 10a (full-weight vs. lightweight) and 10c (sign-off checklists) were updated to describe depth-per-phase instead of depth-per-step; Section 10b's actual sprint-by-sprint designations are unchanged.
**Reason:** Wanted every sprint to read and feel like a real day on an enterprise middleware team — arriving as a ticket with a deadline, not a syllabus topic — while keeping the concept-before-build discipline, the triad rule, and the requirement that every troubleshooting/incident section end in an actual applied fix rather than an open question.
**Files affected:** `01_MASTER_CONTEXT.md` (v11 — Section 10, 10a, 10c rewritten), `03_PROGRESS_LOG.md` (this entry + Document Version Map).

### Decision — 2026-07-10 — Document Version Map added; every sprint assigned an explicit full-weight/lightweight designation; sprint sign-off checklists added
**Decision:** (1) Added a Document Version Map to this file so a new session can check file-consistency at a glance. (2) Master Context Section 10a's "example" full-weight/lightweight split was expanded into Section 10b — a complete, explicit list covering all 70 sprints, with rationale for the borderline calls (2.9, 2.11, 3.2–3.4, 4.7). (3) Added Section 10c — a short sign-off checklist for full-weight sprints and a separate one for lightweight sprints, so sprint approval isn't purely ad hoc.
**Reason:** Reduce the chance of cross-file drift going unnoticed, remove ambiguity about how much depth a given sprint deserves, and give "explicit approval" a concrete checklist to point to instead of just a feeling.
**Files affected:** `03_PROGRESS_LOG.md` (this entry + new Version Map section), `01_MASTER_CONTEXT.md` (v10 — new Sections 10b, 10c).

---

## Running list of deviations from Master Context

*(If any sprint is executed differently than the master document describes — a different tool, a skipped sub-step, a renamed field — log it here too, so Master Context and reality don't quietly drift apart.)*

- **2026-07-10** — Weekly rhythm changed from the original "6 learning + 1 lab" 7-day pattern to "5 learning + 1 revision + 1 lab." See Key Decisions Log above. Master Context Section 4 has been updated to match as of v8 — no outstanding conflict.
- **2026-07-10** — Developer Handoff Package (07) and Test Case Suite (08) now required per module-build sprint, not just at Sprint 2.24. See Key Decisions Log above. Master Context Sections 9/10 updated to match as of v8 — no outstanding conflict.
- **2026-07-10** — Realism enhancements (09) folded into Sprints 1.2, 1.4, 2.17, and Phase 3. See Key Decisions Log above. Master Context updated to v9 to match — no outstanding conflict.

---

### Deviation — 2026-07-10 — Cross-file consistency patch (pre-Sprint-1.1)
**What changed:** (1) `04_SPRINT_PLAN_180_DAYS.md` had a stale hardcoded "Master Context (v8)" reference in its rhythm-revision note; Master Context had since moved to v10. Changed to point at this file's Document Version Map instead of a hardcoded number, so it can't go stale the same way again. (2) `06_LAB_CHALLENGE_BANK.md`'s Cell/DMGR/Node Federation Expert challenge ("DMGR is unrecoverable, restore from backupConfig") depends on `backupConfig`/`restoreConfig`, which per `02_CONCEPT_INDEX.md` isn't taught until Sprint 4.4 — but the challenge was tagged as usable from 2.3/2.4. Re-tagged as a Sprint 4.4 forward-reference with an explicit note not to attempt it early. (3) Removed a stray leftover "ENDOFFILE" line at the end of `06_LAB_CHALLENGE_BANK.md`.
**Reason:** Caught during a pre-Sprint-1.1 review pass; both violated the project's own stated rules (version references should stay current; Advanced/Expert challenges shouldn't draw on untaught concepts).
**Files affected:** `04_SPRINT_PLAN_180_DAYS.md`, `06_LAB_CHALLENGE_BANK.md`.

### Deviation — 2026-07-10 — VM snapshot discipline + optional time-tracking added
**What changed:** (1) Added an explicit rule to `06_LAB_CHALLENGE_BANK.md`: snapshot VM1/VM2 (and VM4/VM5 where relevant) before running any Advanced/Expert challenge that injects failure into cluster/cell/DMGR state, so a drill that goes further sideways than intended doesn't cost an unplanned rebuild. Cross-referenced from `01_MASTER_CONTEXT.md` Section 6 (Lab Prerequisites). (2) Added an optional "Time spent" field to both Progress Log entry templates (3-line and 5-line), to give Sprint 4.8's capacity-planning retrospective and the 180-Day Plan's pace checks real data to work from — explicitly marked optional so it never becomes a reason to skip logging.
**Reason:** Neither practice existed anywhere in the eight companion files despite the Lab Challenge Bank leaning heavily on deliberate failure injection (up to full-site failure drills), and despite Sprint 4.8 being framed as validating against "real measured data" with no data-capture mechanism in place.
**Files affected:** `06_LAB_CHALLENGE_BANK.md`, `01_MASTER_CONTEXT.md`, `03_PROGRESS_LOG.md` (this entry + template + Version Map).

---

## Running list of open questions / parking lot

*(Anything raised mid-sprint that's deliberately deferred — e.g. "revisit whether to add a 10th module" — goes here so it isn't lost.)*

- *(No open items right now — the source-code persistence question from 2026-07-13 was resolved 2026-07-15; see the Key Decisions Log above.)*

- **2026-07-11** — User's message mentioned "464 Days" as the program length while introducing the 9-to-5/ticketing/on-call changes (see Key Decisions Log above). This doesn't match the existing 180-day / 12-cycle / 70-sprint plan in `04_SPRINT_PLAN_180_DAYS.md`. Not changed pending confirmation of whether this was a typo (keep 180 days) or an intentional request to stretch the same 70 sprints over a much longer calendar (which would need the Projected Cycle Map and buffer math rebuilt).
