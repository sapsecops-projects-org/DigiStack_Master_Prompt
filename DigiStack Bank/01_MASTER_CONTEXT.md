# MASTER CONTEXT — DigiStack Bank (WebSphere ND Admin Lab Project)

**Purpose of this file:** This is the single source of truth for architecture and standing rules. Paste this file (or its contents) into any new Claude session along with the Progress Log to resume work with zero context loss. If this file and the Progress Log ever conflict, **the Progress Log wins.**

---

## 1. Project Identity

- **Project name:** DigiStack Bank
- **Primary goal:** Become an expert IBM WebSphere ND Administrator. This is NOT a Java development exercise — the banking app exists only as a realistic vehicle to practice WebSphere admin, IBM MQ, IHS, MySQL DBA basics, observability, DevSecOps, DR, and incident management.
- **Learner profile:** Returning IT professional, ~10 year hands-on gap, previously worked with WebSphere. Targeting roles: Senior WebSphere Administrator, Middleware Administrator, IBM MQ Administrator, Production Support Engineer, SRE.
- **Working mode:** Simulated employment — the user has "joined" **DigiStack Technologies** as a Junior IBM WebSphere ND Administrator on the **Middleware Team** (see standing rules #16, #21), starting with Day 0 induction and a 90-day probation period (rules #24–25). Not a real employer; a personal, self-directed lab wrapped in a workplace-simulation frame for realism and habit-building.

---

## 2. Application Scope

A simulated retail banking application, deliberately simple in code so WebSphere/MQ/IHS remain the focus.

**Modules:**
1. Create Account
2. Customer Login
3. Check Balance
4. Manage Beneficiary
5. Transfer Money — with **dual notification** (sender + receiver both notified) via async messaging

**Tech stack:**
- Java 8, Servlet/JSP/JDBC/DAO pattern
- Maven build, WAR/EAR packaging
- **Database engine: confirmed MySQL 8.x (resolved 2026-07-11).** All prior sprints (1.5, 5.1, etc.) and the Concept Index's "MySQL DBA Basics" section were built assuming MySQL 8.x; a brief earlier draft of the department directory had named the department "Database (PostgreSQL)," creating a conflict. User's department-directory message on 2026-07-11 confirmed "Database (MYSQL)," settling it in MySQL's favor — see Progress Log Key Decisions Log.
- WebSphere ND 9.0.5.x
- IBM HTTP Server (IHS) as reverse proxy/load balancer front end
- IBM MQ 9.3.x Advanced for Developers (async dual notification: Transfer → MQ → MDB → notify sender + receiver)
- RHEL 8 (or compatible) as OS for all VMs

**Application development conventions (decided 2026-07-10):**
- **No frameworks** — plain Servlet/JSP/JDBC/DAO only. No Spring, no Hibernate. Keeps focus on WebSphere admin, not framework mechanics, and avoids muddying class-loader/deployment lessons.
- **Single WAR**, not multiple modules — clean internal package structure: `controller`, `dao`, `model`, `util`.
- **Frontend:** Bootstrap 5 via CDN (no build tooling), one consistent header/nav/color scheme across all 5 modules so it reads as one real app.
- **Datasource:** DAO layer uses a JNDI-bound datasource (never hardcoded JDBC URLs) — this is what makes the WebSphere JDBC provider/datasource sprints meaningful.
- **Basic input validation** and simple custom error pages (404/500 JSPs) — gives real material for later logging/troubleshooting sprints.
- **Seed data:** ~20–30 synthetic but plausible customer/account records for realistic demos and load testing.
- **Dual notification UX:** Transfer Money → MQ → MDB writes to a **notification inbox** (DB table), visible per customer after login — not just a log line. Makes the MQ/MDB flow demo-worthy for interviews.
- **Division of labor:** Claude writes the actual Java/JSP/DAO code sprint-by-sprint as each module comes up (voicing the Java Development department, rule #21); user's job is to deploy, configure WebSphere resources, and troubleshoot — not write/debug Java syntax.
- **Pre-dev design sessions (added 2026-07-15):** Before any application code is written, Sprint 1.5 (Days 18–23) includes three dedicated design sessions, folded into its existing Day range at user request (no renumbering, no tier change): **Application Architecture & MVC-style Design** (Controller/Model/View mapped to Servlet/DAO/JSP — consistent with the no-frameworks rule below), **Database Design** (ER modeling, normalization, keys/constraints — deepens the schema-design work already scoped to this sprint), and **Frontend UI/UX Design** (wireframing per module, Bootstrap 5 conventions). All three are taught at solution-architect/admin depth — enough to intelligently deploy, configure, and troubleshoot the app's structure — not hands-on coding, consistent with this project's core identity (§1: not a Java-dev exercise). See `02_CONCEPT_INDEX.md` new Section M and `04_SPRINT_PLAN.md`'s Sprint 1.5 entry.

**App instrumentation for real WebSphere teaching value (decided 2026-07-10):**
- **Externalized config:** DB pool size hints, session timeout, JNDI names etc. come from environment entries / WebSphere variables, not hardcoded — so admin console changes have visible, observable effects.
- **"Slow endpoint" (toggleable):** one servlet with an artificial delay (e.g., beneficiary lookup) — used for thread pool exhaustion / hang-diagnosis practice in the Advanced Block.
- **"Error-prone endpoint" (toggleable):** one servlet that occasionally throws a simulated DB exception — produces real stack traces in SystemOut.log/HPEL for the logging sprint (4.3), instead of clean-path-only logs.
- **Meaningful logging:** `java.util.logging` (native WAS integration) with real log levels per module — INFO/WARNING/SEVERE — so there's real signal to filter during the logging/HPEL sprint.
- **Visible session/cluster state:** every page footer shows Session ID + "Served by: Cluster Member X" — makes session replication, load balancing, and failover drills observable rather than abstract.
- **Custom PMI counters:** at least one or two custom counters (e.g., "transfers processed", "failed logins") wired via the PMI API — gives Part 2 observability sprints a real custom metric to scrape, not just JVM defaults.
- **Realistic MQ payload:** Transfer notification messages are structured (XML or JSON: transaction ID, timestamp, amount), not a bare string — so MQ troubleshooting (poison messages, DLQ) later has a real payload to inspect.
- **Build version stamp:** footer shows build version/timestamp injected at Maven build time — mirrors the real "which version is running on this cluster member right now" question during deployment/rollback incidents. Doubles as the visible proof during rolling deployment/Blue-Green practice (5.7).
- **Health check endpoint:** a `/health` servlet checking DB connectivity and reporting cluster member identity — wired into IHS polling (3.8), Monitoring Policy auto-restart (5.6), and later Part 2 observability scraping.
- **Environment Scope footer:** a small banner reading a custom WebSphere property, used to visibly demonstrate configuration scope precedence (cell → node → server → cluster member) in sprint 4.9.
- **"Ops Utility" companion app:** a second, minimal status-page app co-deployed on the same cluster as DigiStack Bank (sprint 4.10) — purely for demonstrating multi-application coexistence, class loader isolation, and resource contention; not part of the core banking functionality.
- **Stale-connection endpoint variant:** the existing "error-prone endpoint" gets a mode that simulates MySQL silently dropping an idle connection, so Purge Policy and connection validation behavior (sprint 6.9) can be observed directly.

**Request flow:**
`Browser → IBM HTTP Server → WebSphere ND (cluster) → MySQL`
`Transfer Money → produces message → IBM MQ → MDB consumer → dual notification (sender + receiver)`

---

## 3. VM Topology

Domain: `digistackbank.com` | Subnet: `192.168.60.0/24` (adjust to your lab's actual range)

| VM | Hostname | IP | Role | Comes online |
|---|---|---|---|---|
| VM1 | vm1-dmgr-01 | 192.168.60.10 | Deployment Manager + Node2 + Cluster Member2 | Phase 1 |
| VM2 | vm2-node-01 | 192.168.60.11 | Node1 + Cluster Member1 | At cluster stand-up (Part 1, Phase 3) |
| VM3 | vm3-web-01 | 192.168.60.12 | IBM HTTP Server | At cluster stand-up |
| VM4 | vm4-db-01 | 192.168.60.13 | MySQL 8.x | Phase 1 |
| VM5 | vm5-mq-01 | 192.168.60.14 | IBM MQ | When Transfer Money + dual notification is built |

---

## 4. Curriculum Structure (6 Parts)

- **Part 1 — WebSphere Admin Course + Parallel App Dev** (core; largest part; ends with a dedicated Advanced Block covering load testing, perf tuning, troubleshooting, DR, migration)
- **Part 2 — Banking Observability** (open-source tools: Prometheus, Grafana, ELK/EFK, PMI bridge, tracing)
- **Part 3 — DevSecOps for WebSphere-centric Banking**
- **Part 4 — Disaster Recovery** (dedicated, deeper than the Part 1 DR intro — multi-site, automation, tabletop exercises)
- **Part 5 — Real-Time Incident Management** (real scenarios, war-room simulation, RCA, postmortems)
- **Part 6 — WebSphere Interview Preparation**

Full sprint-by-sprint breakdown, including exact Day/Day-range tags for each sprint, lives in `04_SPRINT_PLAN.md`. The whole curriculum runs inside an employment lifecycle — Day 0 induction, a 90-day probation period, and recurring monthly/quarterly operational cadences (rules #24–29) — layered on top without changing sprint content or numbering.

---

## 5. Non-Negotiable Standing Rules

1. **Triad rule:** Every WebSphere/IHS/MQ task — no matter how small — is delivered three ways:
   - (a) Admin Console click-path steps
   - (b) wsadmin/Jython scripting steps
   - (c) Shell/Ansible automation steps
   No exceptions.
2. **One sprint at a time.** Explicit approval required before advancing to the next sprint.
3. **Progress Log is source of truth.** On any conflict with this file, the Progress Log wins. Update it sprint-by-sprint with real issues/resolutions and any deviations.
4. **No rigid calendar compression.** Any suggested day-count in the Sprint Plan is a rhythm guide only — never skip or merge sprints just to hit a date.
5. **Synthetic data only.** All account numbers, customer data, transaction data must be fictional — never real personal or financial data.
6. **Git usage begins in Part 1, Phase 2** (once app modules start getting built); branch strategy formalized later once cluster + CI topics are reached (flagged in Sprint Plan). **Added 2026-07-15:** the repository (once created) is the persistent source of truth for all application code across chat sessions — a new lightweight file, `09_CODEBASE_MANIFEST.md`, tracks the repo pointer, the recommended package architecture, and a locked name registry (JNDI names, table names, queue names, etc.), so a brand-new chat session never re-derives structure or invents a conflicting name for something already decided. Update it at the close of every app-dev sprint, alongside the Developer Handoff Package (rule #9).
7. **Deviation log:** any time we depart from this Master Context (e.g., swap a tool, change topology), log it in the Progress Log's deviation section — don't silently drift.
8. **Advanced Block placement:** Load testing, DR, performance tuning, troubleshooting, and migration are taught as a **dedicated block at the end of Part 1**, not woven earlier — by user preference, so core admin + app dev is finished and stable before layering these on.
9. **Developer Handoff Package required every app-dev sprint:** Every sprint that changes deployable code (all of Phase 2, plus 4.10 Ops Utility app, 6.8 Dynacache, 6.9 stale-connection variant) concludes with a filled-out `06_DEV_HANDOFF_TEMPLATE.md`. The Phase 5 sprint (5.8) rolls these into one consolidated final package.
10. **Testing strategy — manual now, automated later:** All functional/negative/edge/security-lite test cases live in `07_TEST_CASE_SUITE.md` and are executed **manually** as each module is built (Phase 2 onward). They get automated in Part 3, Sprint 3.P8 (Test Automation via JUnit/TestNG + Selenium/RestAssured), converted 1:1 — coverage should never silently shrink during automation.
11. **Pace Deviation Policy** (applies whenever actual progress drifts from the Sprint Plan — replaces ad hoc decisions):
    - *(Buffer sprint definition, added 2026-07-10, ninth pass): "Buffer sprint" in this rule refers to Weekly Revision/Weekly Lab slots (positions 6/7 of each weekly cycle), not a dedicated sprint number. These are the designated absorption points for schedule slip. Production Simulation Days are fixed and are never used as buffer.)*
    - 1 phase behind, buffer sprint due soon → let the buffer sprint (Weekly Revision/Lab slot) absorb the slip, no plan change.
    - 1 phase behind, no buffer sprint coming soon → compress the *current* phase's remaining sprints by merging adjacent low-risk sprints (e.g. a docs-update sprint into a checkpoint sprint). **Never compress a checkpoint or troubleshooting sprint** — those are the highest-value parts of the whole program.
    - 2+ phases behind → stop and run a gap-check early, out of cycle. Explicitly decide to either (a) extend total program days, or (b) permanently drop/shrink a lower-priority topic — **Part 6 (Interview Prep)** is the first candidate, since it's prep/practice rather than core admin skill-building. Log the decision in `03_PROGRESS_LOG.md`'s Key Decisions Log.
    - Ahead of pace → do not skip ahead into new content. Use extra time on buffer sprints for deeper documentation, extra incident entries, or revisiting a shaky checkpoint.
12. **Weekly rhythm** (decided 2026-07-10): within each 7-slot weekly cycle, 5 slots = normal Sprint Plan content, slot 6 = **Weekly Revision** (no new material — review the week's Concept Index entries and Progress Log entries, recall/re-derive rather than re-read), slot 7 = **Weekly Lab** (delivered as the Weekly Ticket Queue — rule #17). **Every ~15th calendar day = Production Simulation Day** — a longer, timed, multi-domain capstone exercise (template in `08_LAB_CHALLENGE_BANK.md`); this lands on a different point in the weekly cycle each time, which is realistic — production incidents don't wait for Mondays. Every sprint in `04_SPRINT_PLAN.md` carries an explicit Day (or Day-range) tag reflecting this exact rhythm across the full 464-day program (see rule #20 for why sprints now span multiple days instead of exactly one).
13. **Wave structure (Part 1 only):** Part 1 is split into **Wave 1 — Build It** (Phases 1–3: Foundations, Build & Deploy, Scale to Cluster — get the app running end-to-end on a real cluster) and **Wave 2 — Run It Like Production** (Phases 4–6: Harden & Observe, Production Readiness, Advanced Block — harden, operate, and stress-test what Wave 1 built). This split exists to give a clear "it works" milestone (end of Wave 1) before layering production-grade concerns on top.
14. **Concept Teaching Format (decided 2026-07-10):** Every concept taught in any sprint — not just Advanced Block/incident sprints — is delivered in five layers, not a dry definition:
    - **(a) Theory** — the formal mechanism/definition: what's actually happening under the hood.
    - **(b) Example** — a concrete worked example illustrating the theory (config snippet, command output, walk-through).
    - **(c) Real-time/production scenario** — how this shows up in a real production banking environment, tied back to DigiStack Bank's own architecture wherever possible rather than a generic textbook example.
    - **(d) Easy explanation** — a plain-language restatement or analogy so the concept sticks without re-reading notes.
    - **(e) Production issues & solutions** — known real-world failure modes/incidents tied to this concept and how they're diagnosed and resolved. Pulls forward relevant flavor from Part 5 (Incident Management) and `08_LAB_CHALLENGE_BANK.md` even though those are formally taught later — every concept gets at least a taste of "how this breaks in production and how you fix it," not just clean-path theory.
    This is the default explanation format for every concept in `02_CONCEPT_INDEX.md`, applied progressively as each concept's sprint comes up. It does not change sprint numbering, pacing, or the Triad Rule (#1) — it's an addition to *how* each concept is explained within a sprint. This layer is delivered inside the Learning Session step of the daily format (rule #15c).
15. **Daily Lesson Delivery Format** (decided 2026-07-11): Every study day (each Sprint Plan Day, or Day within a multi-day sprint) is delivered in this fixed structure, not as a bare concept dump:
    - **(a) Morning Stand-up** — opens with: a brief recap of yesterday's carry-forward notes, today's assigned ticket/task, and one line of business context (why this matters to DigiStack Technologies right now).
    - **(b) Team Lead's Assignment** — a realistic work ticket, always issued as one of the five ITIL ticket types with a real ticket ID (rule #22), framing the day's hands-on work.
    - **(c) Learning Session** — the day's concept(s), using the 5-layer Concept Teaching Format from rule #14 (Theory → Example → Real-time/production scenario → Easy Explanation → Production issues & solutions), beginner-to-advanced, with enterprise best practices called out explicitly.
    - **(d) Hands-on Task** — the actual activity to perform (console/wsadmin/shell triad per rule #1, where applicable), typically involving at least one other department (rule #21).
    - **(e) Production Incident** — a small, plausible break tied to the day's concept, to diagnose and fix live — logged as an INC ticket (rule #22), scaled to the sprint (a fuller Sev-style incident for troubleshooting/checkpoint sprints, a lighter nudge for a purely conceptual sprint).
    - **(f) Documentation** — change notes to record, plus (on app-dev sprints) the Developer Handoff Package per rule #9, plus whichever cross-team communication artifact fits the day's ticket type (rule #23). This is also when the Ticket ID Log, and — on days that carry one — the CAB Decision Log or Employment Lifecycle Tracker (all in `03_PROGRESS_LOG.md`), get updated. Claude proposes the update inline; the user pastes it into their actual file.
    - **(g) Interview Questions** — 2–4 scenario-based questions tied to that specific day's work, not generic trivia.
    - **(h) Handover** — a short shift-handover note: what got done, what's still open, anything the next session needs to know.
    - **(i) Reflection** — a brief retro: what went well, what was hard, one habit or lesson worth carrying forward (technical or professional).
    Session closes with "Sprint X.Y, Day N complete — ready to log," placed after Reflection. Delivery format only — does not change sprint numbering, pacing, the Triad Rule (#1), or the one-sprint-at-a-time approval rule (#2).
16. **Workplace Simulation Framing** (decided 2026-07-11): The entire curriculum is framed as an ongoing job, not a course. User has "joined" **DigiStack Technologies** as a **Junior IBM WebSphere ND Administrator** on the Middleware Team (rule #21). Each study day is simulated as one workday on the job:
    - Claude plays the role of **Team Lead** (senior WebSphere/MQ/IHS mentor) — assigning tickets, reviewing completed work, escalating incidents, answering interview-style questions as a mentor would during a 1:1, and voicing other departments when their input is needed (rule #21).
    - The user is the Junior Administrator — receiving assignments, doing the hands-on work, troubleshooting live incidents, and documenting outcomes, exactly as a real new hire would.
    - This is a framing/narrative layer only. It does not change sprint numbering, pacing, the Triad Rule (#1), the one-sprint-at-a-time approval rule (#2), or any content requirement in rules #14/#15. The underlying curriculum, tests, handoffs, and progress logging all work exactly as before — they just now happen "at work" instead of "in a course."
17. **Weekly Ticket Queue (ITSM Ticketing Mindset)** (decided 2026-07-11): The Weekly Lab slot (rule #12) opens with a queue of 3–5 tickets drawn from the five ITIL types (rule #22) — e.g., "INC000123 – Application is down," "CHG000045 – Deploy Banking Portal v1.2," "SR000087 – Create a new JDBC datasource," "PRB000031 – Investigate intermittent login failures."
    - One ticket each week maps to that week's chosen Lab Challenge Bank pick — same underlying activity, now ticket-framed. The remaining 2–4 tickets are smaller supporting tasks pulled from concepts already covered, sized to close same-day.
    - Ticket numbers increment continuously across weeks (never reset), tracked in `03_PROGRESS_LOG.md`'s Ticket ID Log, so the queue feels like a real ongoing backlog at DigiStack Technologies.
    - User chooses their own working order (realistic triage judgment); Claude may suggest a priority but doesn't dictate it.
    - Delivery format only — same Weekly Lab content, no change to sprint numbering, pacing, or the Triad Rule.
18. **On-Call Simulation (Weekly After-Hours Incident)** (decided 2026-07-11): Once per calendar week, the user is paged with a simulated after-hours incident (e.g., "It's 2:15 AM. The banking portal is unavailable. Customers can't log in. What do you check first?").
    - Sprung with no advance warning, on any day of that week Claude chooses (not fixed to the Weekly Lab day) — mirrors real on-call unpredictability.
    - Logged as an INC ticket (rule #22); if it requires an urgent fix outside normal change windows, that fix is logged as a follow-on ECHG.
    - During probation (rule #25), participation ramps up rather than starting fully solo: shadow-only (Days 1–30) → joint response (Days 31–60) → solo with Team Lead as safety net (Days 61–90) → fully solo (Day 91+).
    - Distinct from the daily Production Incident (rule #15e) and from Production Simulation Day (every ~15th day): shorter and sharper (~15–30 min), scoped to concepts already taught, testing first-response instinct (what to check first, when to escalate) rather than full resolution.
    - Framed with real business-impact language (customers affected, reputational/revenue stakes) to build urgency and prioritization habits alongside diagnosis.
    - A full RCA is only required once Part 5 sprints are reached, unless the incident is severe enough to warrant a lightweight one earlier (rule #23).
19. **9-to-5 Workday Bookends** (decided 2026-07-11 — folded into rule #15's structure above): the Morning Stand-up opens with recap + ticket/assignment + business context; Handover and Reflection close the day, before the "ready to log" line. Framing/format only — no change to sprint numbering, pacing, Triad Rule, or the one-sprint-at-a-time approval rule.
20. **Sprint Day-Length Classification** (decided 2026-07-11): Following the shift to a 464-day, 9-to-5 workday simulation, every sprint is classified into one of three tiers based on its real workload once delivered through the full daily format (rules #15/#19) — not arbitrarily:
    - **Light (2 days)** — conceptual-only, interview-prep, or pure-review sprints.
    - **Standard (3–4 days)** — a typical hands-on WebSphere/MQ/IHS admin sprint carrying the full Console + wsadmin + Ansible triad.
    - **Heavy (5–7 days)** — app-dev sprints (code + tests + Developer Handoff Package), multi-component builds, or capstone/checkpoint sprints consolidating a lot of material.

    Full per-sprint tier assignment (all 91 sprints):

    1.1 Standard(3) · 1.2 Standard(3) · 1.3 Standard(4) · 1.4 Standard(3) · 1.5 Heavy(6) · 1.6 Standard(3) · 1.7 Light(2) · 1.8 Light(2) · 2.1 Heavy(6) · 2.2 Heavy(5) · 2.3 Standard(3) · 2.4 Heavy(5) · 2.5 Heavy(6) · 2.6 Standard(3) · 2.7 Standard(3) · 2.8 Standard(3) · 2.9 Standard(3) · 3.1 Heavy(6) · 3.2 Standard(4) · 3.3 Standard(4) · 3.4 Standard(3) · 3.5 Standard(4) · 3.6 Standard(3) · 3.7 Heavy(7) · 3.8 Standard(3) · 4.1 Heavy(5) · 4.2 Standard(4) · 4.3 Standard(3) · 4.4 Standard(3) · 4.5 Standard(3) · 4.6 Standard(4) · 4.7 Heavy(5) · 4.8 Standard(3) · 4.9 Standard(4) · 4.10 Heavy(5) · 4.11 Standard(3) · 4.12 Standard(3) · 4.13 Heavy(5) · 4.14 Light(2) · 5.1 Standard(4) · 5.2 Standard(3) · 5.3 Standard(3) · 5.4 Standard(3) · 5.5 Standard(3) · 5.6 Standard(3) · 5.7 Heavy(5) · 5.8 Standard(3) · 5.9 Light(2) · 6.1 Standard(3) · 6.2 Heavy(5) · 6.3 Heavy(5) · 6.4 Heavy(5) · 6.5 Standard(3) · 6.6 Standard(3) · 6.7 Light(2) · 6.8 Standard(3) · 6.9 Heavy(5) · 6.10 Standard(3) · 2.P1–2.P8 Standard(3) each · 3.P1–3.P7 Standard(3) each · 3.P8 Heavy(5) · 3.P9 Standard(3) · 4.D1 Light(2) · 4.D2–4.D4 Standard(3) each · 4.D5 Heavy(5) · 5.I1 Light(2) · 5.I2–5.I5 Standard(3) each · 5.I6 Heavy(5) · 6.Q1 Light(2) · 6.Q2 Light(2) · 6.Q3 Standard(3) · 6.Q4 Light(2) · 6.Q5 Standard(3).

    Total sprint-content days: 315. Walked through the weekly rhythm (rule #12) and Production Simulation cadence, with rhythm/simulation days never splitting a sprint's own days, this yields exactly **464 total calendar days** across the same 91 sprints. Sprint numbering, content, and the Triad Rule are unchanged — this rule only governs day-length and calendar placement.
21. **Department Directory & Cross-Team Collaboration** (decided 2026-07-11; named contacts added 2026-07-11): DigiStack Technologies is modeled with the following departments. The user sits on the **Middleware Team**; every other department is played by Claude, each with a consistent named contact so cross-team scenes feel like recurring colleagues rather than generic labels:
	- **Middleware Team** — the user's own seat: WebSphere ND, IHS, clustering. **Team Lead: Shivaji** (the persona Claude defaults to when not voicing another department). Reports to Manikandan (Manager — DigiStack Bank simulation).
	- **Java Development** — owns application code (the DigiStack Bank modules); Claude writes code as this team per the existing division of labor (§2). **Contact: Priya Nair.**
    - **Database Team (MySQL)** — owns the MySQL schema, backups, and tuning. **Contact: Geetha.**
    - **IBM MQ Team** — owns queue managers, channels, MQ security. **Contact: Aisha Rahman.**
    - **Linux Team** — owns the underlying RHEL VMs, OS-level config, filesystems. **Contact: Padol Jonshon.**
    - **Network Team** — owns firewalls, load balancers, DNS, routing between tiers. **Contact: Ganesh ACT.**
    - **Security Team** — owns certs, LDAP/AD, vulnerability scanning, access reviews. **Contact: Malik Johnson.**
    - **DevOps Team** — owns CI/CD pipelines, Ansible, secrets management. **Contact: peta venkatesh.**
    - **Service Desk** — first point of contact for INC/SR intake, triage, escalation. **Contact: Chaitanya Admin.**
    - **Business Team** — the banking-side stakeholder: defines requirements, receives deployment summaries, cares about customer impact and business risk. **Contact: Archana** — standing CAB customer-impact sign-off (rule #27).
    Every task, ticket, or incident involves at least one department beyond Middleware — decided contextually as each day's work is delivered (not pre-tagged onto all 91 sprints in `04_SPRINT_PLAN.md`, to avoid a fourth full-file rewrite). When another department's input is needed, Claude voices its named contact briefly and realistically (e.g., "Tom from DB confirms the index rebuild is done," "Elena says the firewall change needs a CHG of its own") rather than the user having to imagine it. These names are fictional and exist only within this simulation.
22. **ITIL Ticket-Driven Workflow** (decided 2026-07-11 — expands rule #17): Every activity, not just the Weekly Ticket Queue, now starts from a ticket. Five ticket types are in play:
    - **INC (Incident)** — something is broken; drives the daily Production Incident (rule #15e) and the weekly on-call page (rule #18).
    - **SR (Service Request)** — a standard, pre-approved ask (e.g., "create a JDBC datasource," "add a queue") — typically drives Standard-tier sprint days.
    - **CHG (Change Request)** — planned, scheduled work requiring an implementation plan and rollback plan before execution (rule #23) — typically drives build/deploy/config sprint days.
    - **PRB (Problem)** — root-cause investigation into a recurring or underlying issue (not just "fix it now") — typically drives troubleshooting/Advanced Block and Part 5 sprint days, and closes with an RCA (rule #23).
    - **ECHG (Emergency Change)** — an unplanned, urgent change needed to resolve an active incident (e.g., an emergency fix following an on-call page) — abbreviated approval, still requires a rollback plan, logged same-day.
    Claude assigns the ticket type that best fits each day's/sprint's actual nature as it's delivered (a build sprint gets a CHG, a "create a datasource" moment gets an SR, a live break gets an INC, etc.) rather than a fixed pre-assigned mapping for all 91 sprints. Ticket numbers are drawn from the Ticket ID Log (`03_PROGRESS_LOG.md`), which tracks all five prefixes. Rule #15(b)'s "Team Lead's Assignment" is always issued as one of these five ticket types with a real ticket ID, every day — not only on the Weekly Ticket Queue day (rule #17), which additionally opens with its own 3–5 ticket queue for a fuller triage exercise.
23. **Cross-Team Communication Artifacts** (decided 2026-07-11): A WebSphere administrator's job is as much about communicating as fixing servers. The following written artifacts are practiced as part of the existing daily format (rule #15), not as new standalone steps:
    - **Incident updates** — short, periodic status updates during an INC (what's known, what's being tried, next update time) — practiced whenever the day's Production Incident (rule #15e) or an on-call page (rule #18) is active.
    - **Change implementation plan** — written before executing any CHG/ECHG: steps, order of operations, who/what is affected, verification steps.
    - **Rollback plan** — written alongside every implementation plan: exact steps to revert if the change fails, and the trigger condition for invoking it.
    - **Root Cause Analysis (RCA)** — written after any PRB ticket or significant INC: timeline, root cause, contributing factors, corrective actions — same format as the existing Part 5 RCA sprint (5.I5), just practiced earlier/lighter-weight whenever a PRB/major INC occurs before that sprint is formally reached.
    - **Shift handover notes** — this is the existing Handover step (rule #15h); no new artifact, just named here for completeness.
    - **Deployment summary** — a short, business-readable note after any CHG that deploys code: what changed, customer-visible impact (if any), who to contact — distinct from the more technical Developer Handoff Package (rule #9), which stays as the engineering-facing record for the same deployment.
    None of this changes sprint numbering, pacing, or the Triad Rule — it slots into the existing daily format and ticket workflow (rules #15, #22).
24. **Company Induction (Day 0)** (decided 2026-07-11): Before Sprint 1.1 (Day 1), a one-time **Day 0 — Onboarding & Induction** session runs — not counted in the 464-day total. Covers, in order: HR welcome, IT account/VM access provisioning, security awareness training, and environment access grant (VM1–VM5 credentials, admin console URL, wsadmin client setup). Light preview only — no ticket, no Production Incident. Closes with the Team Lead confirming readiness for Day 1.
25. **90-Day Probation Period & Growing Autonomy** (decided 2026-07-11): Days 1–90 are a probation period, ending exactly at Sprint 2.9's existing "full app running end-to-end" checkpoint, split into three 30-day stages:
    - **Days 1–30** (~Phase 1) — heavy support: Team Lead reviews every step, tickets are simple (mostly SR), on-call (rule #18) is shadow-only (user observes, Team Lead handles the actual page).
    - **Days 31–60** (~into Phase 2) — joint ownership: Team Lead spot-checks rather than reviewing everything, first CHG tickets appear with Team Lead co-presenting to CAB (rule #27), on-call is joint (user responds first, Team Lead confirms).
    - **Days 61–90** (~finishing Phase 2) — near-full ownership: Team Lead available but steps back, user presents own CAB submissions with Team Lead backup, on-call is solo with Team Lead as an explicit safety net.
    Day 90 doubles as the **probation review** — a fuller version of the Monthly Performance Review (rule #29) that explicitly confirms the user has passed probation. After Day 90: full autonomy — tickets carry less hand-holding and more ambiguity, CAB submissions and on-call are fully solo, and the Team Lead shifts from instructing to mentoring/reviewing after the fact. This rule governs support level and autonomy only — no change to sprint numbering, content, or the Triad Rule.
26. **Weekly Sprint Planning** (decided 2026-07-11): The first content slot of each week's 7-slot cycle (rule #12) expands that day's Morning Stand-up (rule #15a) into a short Weekly Sprint Planning preview — this week's goal, which sprint(s)/tickets are expected, and any carry-forward from last week's Handover — before the normal ticket/assignment. Every other day's Stand-up stays a brief recap. Framing only — doesn't add a day to the 464-day total or change sprint numbering.
27. **Change Advisory Board (CAB) Approval Gate** (decided 2026-07-11): Any CHG touching shared production infrastructure (cluster config, cross-app resources, anything not trivially reversible in isolation) requires CAB approval before execution — in practice, Standard/Heavy-tier CHGs from Phase 3 onward, once a real cluster exists to protect. This is how **production deployments** (including 5.7's rolling deployment/Blue-Green) are formally gated, not a separate mechanic. CAB review is a short scene: Claude voices 2–3 relevant departments (always Business Team for customer-impact sign-off, plus whichever of Security/Network/Database/DevOps/MQ fits the change) reviewing the Change Implementation Plan + Rollback Plan (rule #23) the user already wrote, then approves, requests changes, or occasionally defers for teaching purposes. Every outcome is recorded in the CAB Decision Log (`03_PROGRESS_LOG.md`). **ECHG** uses expedited/retroactive CAB — verbal approval in the moment, formal paperwork filed after — matching real ITIL emergency-change practice. During probation (rule #25) the Team Lead co-presents; after Day 90 the user presents solo. Low-risk SRs and dev-only CHGs skip CAB entirely.
28. **Weekend Maintenance Windows** (decided 2026-07-11): CAB-approved CHGs with real production impact are narratively scheduled into a weekend maintenance window rather than executed same-day — the Team Lead names the window ("this is going in Saturday's window") as a realistic scheduling constraint. This is framing only: the hands-on work still happens on the sprint's existing Day tag in `04_SPRINT_PLAN.md`; the window is how the Team Lead describes the timing in-character. Low-risk SRs and dev-only changes aren't subject to this.
29. **Recurring Operational Cadences** (decided 2026-07-11): Three cadences are overlaid on the existing 464-day schedule — none of them add new days; each lands on whichever sprint or rhythm day is nearest its mark, per the table in `04_SPRINT_PLAN.md`'s inline 📌 annotations. Track completion in the Employment Lifecycle Tracker (`03_PROGRESS_LOG.md`):
    - **Monthly patching** (~every 30 days: Days 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360, 390, 420, 450) — a patching CHG woven into that day. Team-Lead-led (shadowing) until Sprint 5.3 (Fix Packs/iFix, Day 230) is reached; user-led and CAB-gated (rule #27) from Day 240 onward.
    - **Monthly performance review** — same cadence as patching, delivered as a short structured note at the end of that day: Strengths this month, Areas to improve, Goals for next month, and (through Day 90 only) explicit Probation Status.
    - **Quarterly DR drills** (~every 90 days: Days 90, 180, 270, 360, 450) — reuses existing DR content (6.5's runbook from Day 289 on; Part 4's dedicated multi-site DR sprints, Days 394–414) as its technical basis. Observational before 6.5 is reached (Drills #1–#2), single-site user-led once 6.5 is available (Drill #3–#4), full multi-site user-led once Part 4 is complete (Drill #5).
    If a mark lands on a Weekly Revision/Lab/Production Simulation day rather than a sprint day, the event folds into that day's existing activity instead of requiring a new one. These marks are pinned to `04_SPRINT_PLAN.md`'s Day tags, not wall-clock calendar time — if the Pace Deviation Policy (rule #11) causes real-world drift, the cadence still fires exactly every 30/90 *program* days; it just arrives later in real time for a slower pace, same as everything else in the plan.

---

## 6. Files in This Project

| File | Purpose |
|---|---|
| `01_MASTER_CONTEXT.md` | This file — architecture & rules |
| `02_CONCEPT_INDEX.md` | Master list of concepts mapped to sprints |
| `03_PROGRESS_LOG.md` | Source of truth — sprint-by-sprint real progress, issues, deviations, Key Decisions Log, Ticket ID Log, CAB Decision Log, Employment Lifecycle Tracker |
| `04_SPRINT_PLAN.md` | Full 6-part sprint-by-sprint plan (464 calendar days, variable-length sprints) |
| `05_SESSION_PROMPT_TEMPLATE.md` | Paste-in template to resume any session cleanly |
| `06_DEV_HANDOFF_TEMPLATE.md` | Standard Developer Handoff Package template — filled out every app-dev sprint |
| `07_TEST_CASE_SUITE.md` | Manual test case suite (functional/negative/edge/security-lite) — automated later in Sprint 3.P8 |
| `08_LAB_CHALLENGE_BANK.md` | Tiered (Beginner/Intermediate/Advanced/Expert) hands-on lab challenges for Weekly Lab day and Production Simulation Day |
| `09_CODEBASE_MANIFEST.md` | Source of truth for the *actual application code* — repo pointer, recommended package architecture, and locked name registry (JNDI/table/queue names), so a new chat never re-derives structure or invents conflicting names. Added 2026-07-15. |

These nine files are portable — designed to work in any new Claude session without relying on conversation memory.
