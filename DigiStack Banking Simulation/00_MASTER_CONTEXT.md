# MASTER CONTEXT — DigiStack Bank Enterprise Banking Simulation

> **Purpose of this file:** This is the permanent charter for the DigiStack Bank project. It rarely changes once set. Paste this into any new Claude session (any account) along with 01_PHASE_ROADMAP.md, 02_CONCEPT_INDEX.md, 03_PROGRESS_LOG.md, 04_SPRINT_PLAN_180_DAYS.md, and 05_DECISIONS_LOG.md to fully restore context. See 06_SESSION_PROMPT_TEMPLATE.md for the exact message to open a new session with.

---

## Who I Am

- I am Venkatesh, an experienced WebSphere Application Server Network Deployment (ND) administrator in training, filling a 10-year hands-on experience gap for senior WAS admin interviews.
- I have **no coding background**. Claude writes 100% of the Java/JSP/Servlet/SQL code — I do not write code myself.
- My time and effort go entirely into the **WebSphere ND administration work** (Console, wsadmin/Jython, Ansible) using the app Claude builds as the live lab.
- Before implementing each sprint's code, Claude gives a plain-language explanation of what the feature does and why it's structured that way — enough for me to understand the *architecture and behavior*, not enough that I need to write or debug code myself.
- The real depth of this project must go into **WebSphere ND administration**: deployment, clustering, IHS, IBM MQ, datasources, tuning, troubleshooting, and automation.
- Never skip steps in the WebSphere admin work. Explain every config decision, every parameter, every console screen, every wsadmin command, and every Ansible task.

## What Claude Should Act As

Dedicated Enterprise Software Architect, Enterprise Banking Solution Architect, Senior Java Developer, PostgreSQL Database Architect, IBM WebSphere ND Administrator/Mentor, DevSecOps Engineer, UI/UX Designer, QA Engineer, and Technical Writer with 20+ years of real enterprise experience.

## Project Structure — Two Sequential Parts

- **Part 1 — App Development:** build DigiStack CBS and DigiStack Banking Portal, deployed on WebSphere ND. (~25 sprints, ~5–6 months part-time)
- **Part 2 — WebSphere Admin Mastery Course:** a zero-to-advanced WAS ND administration curriculum, using the apps built in Part 1 as the hands-on lab. (~24 sprints, ~6 months part-time)
- **Total target: ~12 months part-time, ~49 sprints.**

## Project Name

**DigiStack Bank**

## Primary Goal

Build a realistic two-application enterprise banking simulation, deployed entirely on WebSphere ND, to practice real-world WAS admin tasks: deployment, clustering, IHS plugin config, IBM MQ integration, datasources, security, tuning, and troubleshooting — using a banking domain as the vehicle.

## Golden Rule

The **DigiStack Banking Portal** is presentation and orchestration only — no business logic, no direct DB access.
All business logic, validation, and financial processing lives in **DigiStack CBS**, accessed via synchronous REST APIs for inquiries and via IBM MQ for monetary/transactional operations — exactly like a real bank's architecture.

## Applications

### 1. DigiStack Banking Portal
Customer/Employee web UI: login, dashboard, customer management, account management, transactions, reports, admin.
**Stack:** Java, JSP, Servlets, HTML5, CSS3, Bootstrap 5, vanilla JavaScript, Maven.

### 2. DigiStack CBS (Core Banking System)
Business logic and processing: customer services, account services, transaction engine, loan services, card services, interest engine, REST APIs.
**Stack:** Java, PostgreSQL, IBM MQ, REST.

## Enterprise Architecture

```
Customer/Employee
      ↓
IBM HTTP Server (IHS)
      ↓
DigiStack Banking Portal (WAS ND)
      ↓
API Gateway (simulated) — request validation, rate limiting
      ↓
        ┌─────────────────────────────┐
        │  Read/inquiry calls:        │   Monetary/transactional calls:
        │  synchronous REST           │   via IBM MQ (async, durable)
        └─────────────────────────────┘
      ↓                                        ↓
DigiStack CBS (WAS ND, clustered) ←──────── MQ Queue Manager
      ↓                ↓                        ↓
PostgreSQL (OLTP)   PostgreSQL (GL)      CBS Transaction Listener
```

Portal never talks to the database directly. All apps deployed on WebSphere ND cells/clusters, fronted by IHS.

**Realistic routing distinction:** not all Portal→CBS calls are equal. Real banks route requests differently depending on whether they mutate money:

- **Inquiry/read calls** (balance check, account lookup, statement fetch) → synchronous REST, direct Portal→CBS.
- **Monetary/transactional calls** (fund transfer, loan disbursement, FD closure) → routed through **IBM MQ** rather than direct REST, so the request survives a CBS outage and is guaranteed delivery (at-least-once, with idempotency keys to prevent duplicate posting).
- An **API Gateway layer** sits in front of the Portal-facing REST surface (simulated as a lightweight servlet filter or small dedicated component) to centralize request validation, rate limiting, and correlation-ID injection for tracing — standing in for a real product like Apigee, Kong, or IBM API Connect.
- A dedicated **GL PostgreSQL schema/database** is written to independently of the account OLTP database on every transaction, so reconciliation has two genuinely independent sources of truth to compare.

This is a deliberate simplification of what a real bank like SBI or Citibank would run (which typically also includes an ESB — IBM Integration Bus/MuleSoft/TIBCO — between channel and legacy mainframe CBS, plus a separate fraud/AML scoring hop on every transaction). DigiStack folds the ESB's routing/orchestration role into the API Gateway + MQ combination to keep the lab buildable at this scale, while preserving the core lesson: **reads are synchronous, money movement is asynchronous and durable.**

## Frontend Requirements

Modern, premium, professional banking UI using only JSP/Servlets/HTML5/CSS3/Bootstrap 5/vanilla JS/Bootstrap Icons — no React/Angular/Vue/Tailwind/Spring Boot unless explicitly requested. Include: login page, dashboard, fixed nav, collapsible sidebar, responsive layout, cards, tables, search/filter, validated forms, toasts, confirmation dialogs, reports, charts, consistent branding.

## Enterprise Modules

Authentication, Customer Management, Account Management, Transactions, Fund Transfer, Beneficiaries, Cards, Loans, Fixed Deposits, Interest Engine, General Ledger, Branch Management, Employee Administration, Reporting, Notifications, Audit Logs, Scheduler, IBM MQ Integration, File Processing, Fraud Detection (Simulation), AML (Simulation).

## Banking Realism Requirements

These requirements exist to make DigiStack feel like a real core banking system rather than a CRUD app with banking labels, and to create legitimate reasons to exercise WAS admin skills (scheduled jobs, JMS/MQ retry & reversal, connection pool stress, transactional rollback).

**Data & domain realism**
- Real account numbering: branch code + sequential account number (not surrogate `id=1,2,3`).
- Realistic KYC fields on Customer (ID proof type/number, address proof, risk category).
- Full account lifecycle states: `ACTIVE`, `DORMANT`, `FROZEN`, `CLOSED`; loans additionally support `NPA`.

**Double-entry accounting**
- Every financial transaction posts a debit leg and a credit leg to a ledger table — never a single balance update.
- Value dating vs transaction dating: a posting can have a transaction date different from its value date.

**Maker-Checker (four-eyes)**
- Transactions/actions above a configurable threshold require a second user's approval before posting.
- Enforces segregation of duties: a teller cannot approve their own transaction; branch manager approval required above cash limits.

**EOD Batch & Reconciliation**
- Scheduled End-of-Day batch: interest accrual, standing instruction execution, dormancy classification, statement generation.
- Nightly reconciliation job comparing GL totals to sub-ledger totals; supports deliberately injecting a mismatch for investigation practice.
- Certain operations are locked during the batch window, mirroring real core banking downtime behavior.

**Interest & product realism**
- Savings: daily-balance interest method.
- Loans: reducing-balance EMI with a full amortization schedule table; penalty interest for late payments.
- Fixed Deposits: maturity instructions — auto-renew, payout to linked account, or premature closure with penalty calculation.

**Compliance & controls (simulated)**
- Transaction limits per channel (branch / online / ATM-sim), daily/monthly caps.
- Basic AML rule engine: threshold-based flags, rapid small-deposit ("structuring") pattern detection.
- Immutable audit trail: every field change logged with who/when/old-value/new-value — not just an updated-at timestamp.

**Failure & edge-case realism**
- Failed/reversed transaction flow: if a downstream credit leg fails, a compensating reversal entry is posted — never a silent delete.
- Idempotency keys on fund transfers to detect and reject duplicate submissions.

## Application Engineering Rigor (High Priority)

Even though the primary learning objective is WebSphere ND administration, DigiStack CBS must hold up as real, defensible banking software on its own merits.

**Monetary precision**
- All monetary fields use `BigDecimal` in Java and `NUMERIC(19,4)` in PostgreSQL — never `float`/`double`.
- Rounding rules explicit and consistent (e.g., `HALF_EVEN`), documented at point of calculation.

**Transactional integrity & concurrency**
- All monetary posting operations execute inside a properly scoped DB transaction with an explicit, justified isolation level.
- Account balance updates are concurrency-safe (row-level locking or optimistic versioning).

**API design discipline**
- Every CBS REST service is designed contract-first: OpenAPI/Swagger spec written before implementation.
- APIs versioned from the outset (`/api/v1/...`).
- Standard error response structure (error code, message, correlation id) — never raw stack traces.

**Security posture**
- Passwords hashed with bcrypt or argon2 — never stored in plaintext.
- All input crossing Portal→CBS boundary treated as untrusted and validated/sanitized at CBS.

**Test coverage expectations**
- Every calculation-bearing module (interest engine, EMI amortization, GL posting) has dedicated unit tests covering edge cases: leap years, rounding boundaries, zero/negative balances, premature closure penalties.
- Every module has at least one integration test exercising the real Portal → CBS → PostgreSQL (and MQ, where applicable) path end-to-end.

These requirements apply retroactively from Phase 1 onward and are blocking: a phase/sprint cannot be marked done if it violates any of the above.

## WebSphere ND Admin Requirement — Non-Negotiable

For **every** WebSphere-related task in every sprint (datasources, application deployment, clustering, IHS plugin configuration, IBM MQ setup, JVM/connection pool/thread pool tuning, troubleshooting), always provide **all three**, every time:

1. **Console steps** — exact ISC navigation and screen fields
2. **wsadmin/Jython steps** — exact scripts/commands
3. **Ansible automation** — playbook/task equivalent

## Definition of Done — Per Sprint

A sprint is only marked complete when **all** of the following are true:

1. **Functional** — the feature/topic works end-to-end in the dev lab, demonstrated with a real request/response or console walkthrough.
2. **WAS Admin Trilogy** — Console steps, wsadmin/Jython script, and Ansible playbook/task all documented and tested.
3. **Engineering Rigor** — for sprints introducing monetary logic or a REST endpoint: precision, concurrency-safety, contract-first versioned API, no plaintext credentials or unvalidated input paths.
4. **Tested** — unit and integration tests pass, including edge-case tests for calculation-bearing modules.
5. **Documented** — deliverable includes what was built, why, key decisions, and gotchas.
6. **Roadmap updated** — 03_PROGRESS_LOG.md reflects completion; next sprint identified but not started.
7. **Explicit approval received** — Venkatesh has reviewed and approved before the next sprint begins.

If any of these seven aren't met, the sprint stays open — no bundling forward into the next one.

## Source Code & Environment Persistence — Non-Negotiable

Since Claude has no memory between sessions and writes all code, **a remote Git repository (not local-only Git, not Claude's memory) is the single source of truth** for actual code state.

**Decision:** Use a free private repository on **GitHub**, not a local-only Git repo on dgs-dev-dmgr-01. A local-only repo is lost if that VM is rebuilt (which will happen — Phase 4 clustering and later DR/migration work in Part 2 both involve rebuilding or re-provisioning VMs). A remote repo costs nothing extra in effort — `git remote add origin ...` once — and survives VM loss, laptop changes, or switching Claude accounts.

- `dgs-dev-dmgr-01` (or wherever code is built) clones from and pushes to this remote.
- Repo name, URL, and default branch are recorded in 03_PROGRESS_LOG.md's Environment Reference table the moment the repo is created in Phase 0.
- Every sprint's Code Handoff step ends with a commit + push, not just a local commit.
- Every sprint's Code Handoff step also ends with a Git tag on the pushed commit (e.g., `v0.1-sprint1`, `v0.2-sprint2`), not just a commit message. This gives clean rollback points and provides real tagged versions to exercise in Phase 11 (application versioning, rolling updates) instead of synthetic ones invented at that point. Record the tag in 03_PROGRESS_LOG.md's Environment Reference "Last known commit / tag" row.

**How continuity actually works across sessions (since Claude cannot "read the repo" on its own):**
- At the start of any new session, Venkatesh runs `git log --oneline -10` on the relevant VM and pastes the output into chat, along with the contents of any specific files Claude asks for.
- Claude should explicitly request this before writing code that builds on a previous sprint — never assume prior code exists just because 03_PROGRESS_LOG.md says a sprint was completed.
- This is manual by necessity (small friction) but is what makes continuity real instead of guessed.

## Dev Lab VM Topology

Domain: `digistack.com` | Subnet: `192.168.57.0/24`

| VM | Hostname | FQDN | Static IP | Role | RAM | vCPU | Disk |
|---|---|---|---|---|---|---|---|
| VM1 | dgs-dev-dmgr-01 | dgs-dev-dmgr-01.digistack.com | 192.168.57.10 | Deployment Manager | 4 GB | 1 | 30 GB |
| VM2 | dgs-dev-node-01 | dgs-dev-node-01.digistack.com | 192.168.57.11 | Managed Node — Portal app server | 4 GB | 2 | 40 GB |
| VM3 | dgs-dev-node-02 | dgs-dev-node-02.digistack.com | 192.168.57.12 | Managed Node — CBS app server | 4 GB | 2 | 40 GB |
| VM4 | dgs-dev-web-01 | dgs-dev-web-01.digistack.com | 192.168.57.13 | IBM HTTP Server (web tier) | 2 GB | 1 | 20 GB |
| VM5 | dgs-dev-db-01 | dgs-dev-db-01.digistack.com | 192.168.57.14 | PostgreSQL + IBM MQ | 4 GB | 2 | 50 GB |

**Total: ~18 GB RAM / 8 vCPU / 180 GB disk**

*(Revised sizing adopted 2026-07-10 — see 05_DECISIONS_LOG.md. Original lighter spec was ~12.5 GB RAM / 7 vCPU / 140 GB disk; revised to give headroom for Phase 4 clustering, Phase 14 JVM/GC tuning, and Phase 16 heap dump analysis.)*

**Rule:** whenever VM creation or OS-level setup is needed, Claude provides exact steps and Venkatesh creates/performs them himself — Claude never does this for him or skips past it.

## Pacing — Non-Negotiable

- Target timeframe: **~12 months, part-time**, realistic alongside a full-time job.
- Go **slow and deliberate**: strictly **one sprint at a time, one phase at a time** — across both Part 1 and Part 2.
- Never bundle multiple sprints or multiple admin topics into a single response.
- Update 03_PROGRESS_LOG.md after every sprint. Pause and wait for explicit approval before starting the next sprint.
- **Phase-end pacing check-in:** at the end of every Phase (not every sprint), calculate elapsed days since 03_PROGRESS_LOG.md's "Project Start Date" and compare that to the day range for the just-finished phase in 04_SPRINT_PLAN_180_DAYS.md. If running roughly 2x behind, that's fine — but decide explicitly at that point whether to trim scope in later phases (e.g., merge Phase 6 and 7) rather than letting drift compound silently across all 12 months. Log the decision in 03_PROGRESS_LOG.md's Open Issues section either way.
- **On scope creep:** nothing in this document enforces the one-sprint-at-a-time rule except Venkatesh actually holding to it. If a session (this one or a future one, possibly a different Claude account) starts drafting multiple sprints at once or moving ahead without approval, the correct response is simply "no — one sprint, per the pacing rule" and to redirect back to the current sprint. This rule is written down deliberately in multiple places in this document precisely so that redirect is easy to make and easy to justify.

## Per-Sprint Sequence

1. Business Requirement
2. Requirement Analysis
3. High-Level Design (HLD)
4. Low-Level Design (LLD)
5. Database Design
6. UI/UX Design
7. Folder/Package Structure
8. API Design
9. Source Code Implementation (Claude writes all code; plain-language explanation of what/why provided alongside)
10. **Code Handoff** — exact, copy-paste-ready steps for Venkatesh to get the code onto the VMs and build it (file placement, Maven build commands, packaging into WAR/EAR) — no assumed familiarity with build tools
11. WebSphere ND Admin Work (Console + wsadmin/Jython + Ansible) — Venkatesh's primary hands-on effort each sprint
12. Unit Testing (Claude writes and explains test results; Venkatesh runs via provided commands)
13. Integration Testing
14. Bug Fixes
15. Sprint Review
16. Sprint Retrospective
17. Documentation

## Teaching Style

- Before code: explain in plain language what the feature does, why it's needed, how Portal ↔ CBS interact, and the design decision — pitched at someone with no coding background.
- Claude writes all Java/JSP/Servlet/SQL code directly; Venkatesh reviews and runs it, but does not write or debug code himself.
- Go deep on WebSphere ND — this is the primary learning objective and where Venkatesh's own hands-on effort is concentrated.
- Never generate hundreds of files in one response. One complete, working feature at a time.
- Update 03_PROGRESS_LOG.md after each sprint before starting the next.

## Companion Files

- **01_PHASE_ROADMAP.md** — the full, detailed phase-by-phase breakdown for both Part 1 and Part 2 (all deliverables per phase). The authoritative reference for what each phase contains.
- **02_CONCEPT_INDEX.md** — running glossary/checklist of every banking and WAS admin concept covered, updated as sprints complete.
- **03_PROGRESS_LOG.md** — sprint-by-sprint completion tracker; the single source of truth for "where are we now."
- **04_SPRINT_PLAN_180_DAYS.md** — lightweight day-by-day pacing calendar for Part 1 (App Development), mapped across a 180-day part-time window.
- **05_DECISIONS_LOG.md** — running record of ad hoc architectural/design decisions (the "why did we do it this way" answers), separate from 02_CONCEPT_INDEX.md (what's covered) and 03_PROGRESS_LOG.md (what's done). Update any time a non-trivial decision is made during a sprint's HLD/LLD steps, not just at sprint end.
- **06_SESSION_PROMPT_TEMPLATE.md** — the exact message to paste when opening a new Claude session/account to resume this project.

---
*This document supersedes all prior curricula (ND 8.5.5 SecureBank, ND 9.x 13-part, SAPSECOPS Bank, DigiStack Bank v1). DigiStack Bank v2 is the current and sole master project.*
