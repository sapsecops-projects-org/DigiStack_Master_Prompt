# DigiStack Bank — MASTER ROADMAP (Index)

**Purpose:** Real-time banking simulation application built version by version to practice IBM WebSphere Application Server ND administration and fill a 10-year career gap.

**Environment:** VMware VM, IBM WebSphere Application Server ND installed.

**Two-app architecture (applies across ALL parts):**
- **DigiStack Banking Portal** — JSP, Servlets, HTML5, CSS3, Bootstrap 5, vanilla JS. Presentation layer ONLY. Must never contain business logic.
- **DigiStack CBS (Core Banking System)** — Core banking logic, EJB, REST APIs, JTA/XA transactions, JMS/SIBus, PostgreSQL, IBM MQ. All business logic lives here.

**Teaching style:** Assume zero prior programming knowledge. Explain every concept, file, class, method, and line before/while writing code.

**Development process:** Each version = one full sprint: Requirements → Development → Deployment/Admin in WAS → Testing → Documentation → **pause for approval** before the next version.

**Tech constraints:** No React, Angular, Vue, Tailwind, or Spring Boot unless explicitly requested.

**Command workflow:** Full instructions with expected output shown inline. No "run this and paste output back" checkpoints.

---

## ⚠️ HOW TO USE THIS DOCUMENT (READ THIS IN EVERY NEW CHAT)

This is an **index only** — it does not contain version details. When starting a new Claude chat to continue this project:

1. **Upload this MASTER INDEX file** + **the Engineering Standards file** + **the specific Part file(s) you're working on** (e.g., `Digistack Bank Roadmap - Part-1.md`).
2. Tell Claude which Part and Version number you're resuming at (check the Progress Tracker below).
3. Claude should read the relevant Part file for exact features/request flow/WebSphere topics for that version, apply the Engineering Standards file for VM setup/Git/tests/DB/docs, and follow the sprint process — not invent new scope.
4. If a Part file doesn't exist yet (you haven't sent it to me), Claude should ask you for it rather than guessing its content.

---

## Governing Standards Document

| File | Purpose | Status |
|---|---|---|
| `Digistack Bank Roadmap - Engineering Standards.md` | VM setup, Git branching, test case template, DB/SQL migration standard, Dev→UAT→Prod promotion process, end-to-end setup doc template — applies to EVERY version in EVERY part | ✅ Ready — applies from Version 1 onward |

## Standing Process Standards (apply to EVERY version, from v1 onward)

> Upload these alongside the Master Index in every new chat. These define *how* each version is built, not *what* — the Part files define what; these define the enterprise-grade process wrapped around it.

| # | File | Governs |
|---|---|---|
| 01 | `Digistack Bank - 01 VM Setup Standards.md` | VM inventory, sizing, snapshot discipline — per version |
| 02 | `Digistack Bank - 02 Git Standards.md` | Branching, commits, tags, PRs — organization-style |
| 03 | `Digistack Bank - 03 Test Case Standards.md` | `TestCases-v<N>.md` template — required before any version is "Approved" |
| 04 | `Digistack Bank - 04 Environment Promotion Standards.md` | Dev → UAT → Prod promotion, done once per completed Part |
| 05 | `Digistack Bank - 05 DB and SQL Deployment Standards.md` | Migration script naming, structure, environment discipline |
| 06 | `Digistack Bank - 06 End-to-End Setup Documentation Standards.md` | `SetupDoc-v<N>.md` template — build any version from a blank VM |
| 07 | `Digistack Bank - 07 Configuration and Cross-Cutting Standards.md` | EAR/deployable naming, DB-authority-after-CBS-split, deployment dependency/startup-order matrix, per-environment config standard, port matrix, certificate inventory, monitoring ownership — required alongside docs 01–06 from **Part-3 onward** (doc07 itself is unnecessary before the single-EAR world ends at v23) |

**Per-version deliverables from now on (every version, every part):**
1. VM Setup section (per doc 01)
2. Code, committed per Git Standards (per doc 02)
3. `TestCases-v<N>.md` (per doc 03)
4. `SetupDoc-v<N>.md` (per doc 06)
5. SQL migration script(s) if schema changes (per doc 05)
6. Dev-only — promotion to UAT/Prod happens once per completed **Part**, not per version (per doc 04)
7. From Version 23 onward, cross-reference doc 07 for deployable naming, dependency order, and per-environment config — don't restate it inline (per doc 07)

---

## Part Index

| Part | Title | Versions | File | Status |
|---|---|---|---|---|
| 1 | Enterprise Banking Application Development (Simple Banking) | 1–14 | `Digistack Bank Roadmap - Part-1.md` | ✅ Roadmap ready |
| 2 | Enterprise Middleware Integration | 15–22 | `Digistack Bank Roadmap - Part-2.md` | ✅ Roadmap ready |
| 3 | Enterprise Banking Systems (CBS, Payments, Channel Simulators, Loans) | 23–30 | `Digistack Bank Roadmap - Part-3.md` | ✅ Roadmap ready |
| 4 | Enterprise Observability, SRE & Production Operations | 31–35 | `Digistack Bank Roadmap - Part-4.md` | ✅ Roadmap ready |
| 5 | Enterprise High Availability (HA), Disaster Recovery (DR) & Business Continuity | 36–38 | `Digistack Bank Roadmap - Part-5.md` | ✅ Roadmap ready |
| 6 | Multi-Region Enterprise Banking & Middleware Architecture | 39–43 | `Digistack Bank Roadmap - Part-6.md` | ✅ Roadmap ready |
| 7 | Enterprise WebSphere Migration & Modernization | 44–48 | `Digistack Bank Roadmap - Part-7.md` | ✅ Roadmap ready |
| 8 | Enterprise DevOps & End-to-End Automation | 49–53 | `Digistack Bank Roadmap - Part-8.md` | ✅ Roadmap ready |
| 9 | Enterprise Hybrid Cloud & AWS Migration | 54–73 | `Digistack Bank Roadmap - Part-9.md` | ✅ Roadmap ready |
| 10 | Containerization (proposed) | TBD (would begin at Version 74) | `Digistack Bank Roadmap - Part-10.md` | ⏳ Awaiting content |

> **Part-8 retitle — resolved.** Part-8 was previously placeholder-listed as "AWS Migration (proposed)," TBD versions. It is now confirmed as **Enterprise DevOps & End-to-End Automation**, Versions 49–53 (CI/CD, infrastructure-as-code, deployment automation, and a region-aware automation capstone). AWS Migration and Containerization are each bumped one slot to **Part-9** and **Part-10** respectively.
>
> **Part-8 numbering note:** Part-8's source draft numbered its versions 48–52, colliding with Part-7's frozen 44–48 (v48 is already "Enterprise Migration Capstone"). Per Engineering Standards §7, renumbered to **49–53** — a clean pre-implementation +1 shift with no internal reordering, documented with a full mapping table in the Part-8 file itself.
>
> **Part-9 scope — resolved.** Part-9 is confirmed as **Enterprise Hybrid Cloud & AWS Migration**, Versions 54–73 (AWS Foundation & Hybrid Connectivity → Lift & Shift → Platform Modernization → Full AWS Migration, across four phases). Containerization is bumped one further slot to **Part-10**, still awaiting content.
>
> **Part-9 numbering note:** Part-9's source draft numbered its versions 53–72, colliding with Part-8's frozen 49–53 (v53 is already "End-to-End Automation & Operational Readiness Capstone"). Per Engineering Standards §7, renumbered to **54–73** — a clean pre-implementation +1 shift with no internal reordering, documented with a full mapping table in the Part-9 file itself. Part-9 adds **zero new banking functionality**; it moves the existing 9 applications from on-premises to a fully AWS-native platform. It is also the first Part promoted via the Part-8 v53 automated pipeline rather than manually, per Part-8's closing note. **Its Dev→UAT→Prod promotion model is the "Phased Cloud Migration Promotion" section added to doc 04 — see that file for the exact gating rules (phase capstones are Dev-only gates; UAT/Prod promotion happens once, at the end, across all three regions).**

> **Part-6 title conflict — resolved.** Part-6 is confirmed as **Multi-Region Enterprise Banking & Middleware Architecture** (Option (a) from the prior open decision), matching Part-5's existing "Carried forward into Part-6" note — no edit was needed there. **WebSphere Migration was deferred to Part-7 and has since been built out.**
>
> **Part-6 numbering note:** Part-6's source draft numbered its versions 38–42, colliding with Part-5's frozen 36–38. Per Engineering Standards §7, this was resolved with a uniform +1 offset (39–43) rather than a full renumbering table, since no version had been implemented and no internal reordering occurred. Full detail in the Part-6 file's own numbering-correction section.
>
> **Part-7 numbering note:** Part-7's source draft numbered its versions 43–47, colliding with Part-6's frozen 39–43 (v43 is already "Enterprise Middleware Architect Capstone"). Per Engineering Standards §7, renumbered to **44–48** — a clean pre-implementation +1 shift with no internal reordering, documented with a full mapping table in the Part-7 file itself. Part-7 adds **zero new banking functionality**; it migrates and upgrades the WebSphere platform underneath the existing 9 applications.

---

## Progress Tracker

> This table is a **high-level, at-a-glance summary only** (Part-level). The detailed, version-by-version implementation history — status per version, dates, notes/issues, environment specifics — lives exclusively in `Digistack Bank Roadmap - Progress Log.md`, which is the single source of truth for implementation detail. Update both after each version is approved: this table for the Part-level snapshot, the Progress Log for the detailed row. Don't let detail accumulate here — if it needs more than "last approved / next up," it belongs in the Progress Log.
>
> **Sync rule (added per audit, 2026-07-19):** every row's "Next Version To Build" column shows the actual next version number for that Part, even if the Part hasn't started yet — it should never be left blank while a sibling Part shows a number. This table and the Progress Log's Current Status Summary must always show identical values for every Part.

| Part | Last Approved Version | Next Version To Build | Notes |
|---|---|---|---|
| 1 | — (none yet) | Version 1 | Roadmap reviewed & gap-filled. Not started. |
| 2 | — | Version 15 | Roadmap reviewed & gap-filled. Not started. |
| 3 | — | Version 23 | Roadmap reviewed & gap-filled (v23–v30 renumbering pass documented in Part-3 file). Not started. |
| 4 | — | Version 31 | Roadmap reviewed & gap-filled (renumbered 28–32 draft → 31–35). Not started. |
| 5 | — | Version 36 | Roadmap reviewed & gap-filled (renumbered 36–38). Not started. |
| 6 | — | Version 39 | Roadmap reviewed & gap-filled (offset 38–42 draft → 39–43). Title conflict resolved. Not started. |
| 7 | — | Version 44 | Roadmap reviewed & gap-filled (renumbered 43–47 draft → 44–48). Not started. |
| 8 | — | Version 49 | Roadmap reviewed & gap-filled (renumbered 48–52 draft → 49–53). Retitled from "AWS Migration" placeholder. Not started. |
| 9 | — | Version 54 | Roadmap reviewed & gap-filled (renumbered 53–72 draft → 54–73). MySQL→PostgreSQL inconsistency in source draft corrected. Not started. |
| 10 | — | — | Not started — awaiting content (Containerization, bumped from former Part-9 slot). Would begin at Version 74 once roadmapped. |

---

## Open Decisions Pending Your Confirmation

> Carried over from Part reviews — resolve these so future chats don't have to re-ask.

*(None currently open at the Master Index level. See the Progress Log's "Open Questions / Decisions Pending" section for the one standing open item — Fixed/Recurring Deposits scoping — which is tracked there rather than duplicated here.)*

**Resolved decisions (kept for historical record):**

- **Part-6 title conflict:** "Multi-Region Enterprise Banking & Middleware Architecture" (original index) vs. "WebSphere Migration" (proposed progression) — **resolved as Option (a): Multi-Region is Part-6** (Versions 39–43), matching Part-5's existing forward-reference text with no edit needed there. WebSphere Migration deferred to Part-7. Part-6's own numbering was also corrected: its source draft (versions 38–42) collided with Part-5's frozen 36–38 and was shifted forward by a uniform +1 offset to 39–43 — documented in full in the Part-6 file itself, per Engineering Standards §7.

- **Part-2, Version 22 — Database standard:** original source specified MySQL in the end-to-end request flow. **Resolved: PostgreSQL selected as the standard database for the DigiStack Bank Enterprise project across all environments** (Dev/UAT/Prod, all Parts) — matches the project-wide standard stated under Standing Preferences below and in the DB Deployment Standards doc. MySQL will not be used anywhere in this project unless explicitly requested in a future chat.
- **Part-8 scope (resolved):** Part-8 was a placeholder ("AWS Migration," TBD) in earlier index versions. It is now scoped as **Enterprise DevOps & End-to-End Automation** (Versions 49–53): Git/branch governance, Jenkins CI/CD, Ansible infrastructure-as-code, automated deployment (plugin regen/node sync/health-check/rollback), and a region-aware end-to-end capstone that chains commit → verified production readiness across India/Singapore/Dubai sequentially. Adds **zero new banking functionality** — automates steps performed manually since Part-1. AWS Migration moves to Part-9, Containerization to Part-10.
- **Part-9 numbering and scope (resolved):** Part-9's source drafting material numbered its versions 53–72, colliding with Part-8's frozen 49–53 range (53 was already "End-to-End Automation & Operational Readiness Capstone"). Renumbered to **54–73** before implementation — a clean pre-implementation uniform +1 shift with no internal reordering, splitting, or renaming, documented with a full mapping table in the Part-9 file (same precedent as Part-6/Part-8's own offset passes). A second correction was also made: the source draft specified MySQL as the database engine for the EC2-hosted stack (v59, old "58") and for the Phase-3 database modernization step (v64, old "63"), conflicting with the project-wide PostgreSQL standard set at Part-2 v22. Corrected throughout the Part-9 file to PostgreSQL / Amazon RDS for PostgreSQL — no new database engine is introduced anywhere in this project. Part-9 adds **zero new banking functionality**; it moves the existing 9 applications from on-premises to a fully AWS-native platform in four phases (Foundation/Hybrid Connectivity, Lift & Shift, Platform Modernization, Full AWS Migration), and is the first Part promoted via the Part-8 v53 automated pipeline rather than manually. **A cross-file audit (2026-07-19) additionally added an explicit "Phased Cloud Migration Promotion" model to doc 04, since Part-9's combination of multi-region + phased cutover + pipeline automation wasn't covered by any single existing doc 04 section.**
- **Part-3's earlier open decisions** have all been resolved and reflected directly in the Part-3 file: Loan Management added as Version 30; CBS given its own dedicated database (`digistack_cbs`) with an explicit v23 data migration and ownership-matrix documentation; Payment Hub, Notification Service, and Reporting Service each built as independent WebSphere EARs rather than modules inside CBS; Branch Portal built as its own separate WebSphere application (v29); Mobile Banking and ATM rebuilt as separate small Tomcat apps under their own subdomains — `mobile.digistack.com` (v26), `atm.digistack.com` (v27); Card Portal rebuilt as its own WebSphere EAR (not Tomcat) under `card.digistack.com` (v28), since card lifecycle operations are treated as a bank-owned enterprise function rather than an external customer channel. By end of Part-3 there are 7 WebSphere EARs + 2 Tomcat apps = 9 distinct deployables, all governed by a single rule: only CBS writes to `digistack_cbs`.
- **Part-4 numbering and scope (resolved):** Part-4's source drafting material had numbered its versions 28–32, colliding with Part-3's frozen 23–30 range. Renumbered to **31–35** before implementation (clean pre-implementation renumbering, documented with a full mapping table in the Part-4 file, same precedent as Part-3's own renumbering pass). Scope was also gap-filled: Business Monitoring, SRE Golden Signals/RED/USE, Alert Engineering, Dashboard Engineering, Synthetic Monitoring, Production Runbooks, Chaos Engineering (fulfilling Part-3's forward reference), Capacity Management, and formal SLO/SLI/SLA/Error Budget tracking — all flagged as missing from the original source material — are now folded into Versions 31–35 rather than left as an unmerged wishlist. Three new VMs added to the standing inventory (doc 01): `digistack-monitoring-01`, `digistack-elk-01`, `digistack-tracing-01`. Part-4 adds **zero new banking functionality**; it instruments and operationally hardens the 9 applications built in Part-3. **A cross-file audit (2026-07-19) additionally clarified that Version 31's Prometheus/Grafana foundation formally supersedes and retires Part-2 v18's earlier custom PMI/JMX Operations Dashboard — see Part-4's Version 31 for the added note.**
- **Part-5 numbering and scope (resolved):** Part-5's source drafting material numbered its versions 33–34, colliding with Part-4's frozen 31–35 range (33 and 34 were already "APM/Tracing" and "Alerting/Dashboards"). Renumbered to **36–38** before implementation (clean pre-implementation renumbering, documented with a full mapping table in the Part-5 file). A 12-item gap-analysis review (application continuity, database continuity, MQ continuity, monitoring integration, planned maintenance, HA/DR failure-type taxonomy, expanded backup inventory, DR runbook, RPO/RTO worked examples, updated 9-service architecture diagram, business continuity process, production exercises) was folded into the three versions rather than left as a floating wishlist or fragmented into extra versions: v36 (HA) absorbed the failure taxonomy and drill scenarios; v37 (DR) absorbed RPO/RTO examples, the updated architecture diagram, and DR-specific storage/DNS concepts; a new v38 (Business Continuity & Application Resilience) was added to hold transaction integrity/idempotency, database and MQ continuity specifics, zero-downtime maintenance, the expanded backup inventory, the DR runbook, and business-continuity process items. A follow-up refinement pass added WebSphere Core Groups detail (Core Group Bridge, Core Group Policies, DCS), plugin generation/propagation/refresh, node/repository synchronization, enterprise storage concepts (SAN/NAS/snapshot), DNS failover/VIP/GSLB concepts, load-balancer session affinity, and a standard recovery-record template (Failure Time/Detection Time/Recovery Time/Root Cause/Resolution/Lessons Learned) for every production exercise. Part-5 adds **no new banking functionality**, with one narrow exception: idempotency-key handling retrofitted onto the existing Fund Transfer flow (v38).

---

## Licensing/Tooling Notes (applies across parts)

- **IBM MQ** (Part-2, Version 19): use the free **IBM MQ Advanced for Developers** (non-production license).
- **Enterprise Load Balancers — F5 / Citrix ADC** (Part-2, Version 21): simulate with **NGINX or HAProxy** (free/open-source); the admin concepts transfer even though the product UI differs. Requires a second small VM/container.
- Full detail on both lives in Part-2's own licensing note — this entry just flags it so it's visible from the index.
- **IBM WebSphere on AWS EC2** (Part-9, Version 59): licensing/support terms (PVU-based or BYOL entitlement rules, cloud-deployment coverage) must be verified before any production deployment — treated as a documented planning consideration, not a blocking gate on the lab itself. Full detail in Part-9's own licensing note.
- **License lifecycle reminder (added per 2026-07-19 architect review, Finding #15):** developer/trial license terms — IBM MQ Advanced for Developers (Part-2 v19), any WAS trial media — are assumed usable indefinitely from their introduction, but real trial/developer licenses commonly carry non-production-only restrictions or time-bound trial periods that were never re-checked anywhere after their Part-1/Part-2 introduction. Given this project's realistic wall-clock span (Parts 1–9 alone represent a multi-year build), re-verify these terms periodically — at minimum, at each Part boundary — rather than assuming a license checked once in Part-2 still applies unchanged by Part-9.

---

## Standing Preferences (apply to all parts/versions)

- Database: **PostgreSQL** (standardized — do not switch to MySQL unless explicitly requested)
- Each version must include: Banking Features, Request Flow diagram, WebSphere Topics Covered, Sprint Deliverable
- One small, complete feature per sprint — no combining versions
- Pause for explicit approval before starting the next version
- Beginner-level code explanation throughout

---

*This MASTER INDEX file should be re-uploaded at the start of every new chat, alongside the Part file(s) relevant to the work session.*

---

**Change log for this revision (2026-07-19 cross-file audit):**
- Fixed Progress Tracker table: Parts 2, 3, 4 now show their actual next version numbers (15, 23, 31) instead of a blank dash, resolving a sync mismatch against the Progress Log.
- Part 10 row now notes it would begin at Version 74 once roadmapped.
- Added a "Sync rule" note above the Progress Tracker table to prevent this drift from recurring.
- Cross-referenced the new doc 04 "Phased Cloud Migration Promotion" section under the Part-9 resolved-decision note.
- Cross-referenced the new Part-4 v18/v31 relationship note under the Part-4 resolved-decision note.
