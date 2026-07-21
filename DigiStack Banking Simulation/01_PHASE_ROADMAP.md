# PHASE ROADMAP — DigiStack Bank (Full Detail)

> **Purpose:** The complete phase-by-phase breakdown for both Part 1 (App Development) and Part 2 (WebSphere Admin Mastery Course), with full deliverable descriptions per phase. 04_SPRINT_PLAN_180_DAYS.md gives the lightweight calendar view for Part 1 pacing; this file is the detailed reference for what each phase actually contains. Update 03_PROGRESS_LOG.md as sprints within these phases complete — this file itself should rarely change.

---

# PART 1 — APP DEVELOPMENT
*Estimated: ~5–6 months part-time (~25 sprints)*

| Phase | Objective | Key Deliverables | Sprints |
|---|---|---|---|
| 0 | Environment & Foundation | RHEL/VMware topology, PostgreSQL install, WAS ND cell (Dmgr + 2 nodes), IHS install + plugin, IBM MQ install, project skeleton (Maven, Git) | 2 |
| 1 | CBS Core — Customer & Account | CBS Customer + Account services, real account numbering scheme, KYC fields, account lifecycle states, PostgreSQL schema, first datasource, first REST endpoints, deploy to WAS ND | 3 |
| 2 | Portal Foundation | Portal shell: login, dashboard, nav/sidebar, calls CBS via REST for inquiry/read operations, simulated API Gateway layer (request validation, rate limiting, correlation-ID tracing), deploy alongside CBS, IHS plugin wiring. **HLD step must explicitly resolve the API Gateway implementation shape (servlet filter inside Portal WAR vs. small standalone WAS application) — see open decision in 05_DECISIONS_LOG.md — before proceeding to LLD, since the choice changes deployment topology and IHS plugin routing.** | 2 |
| 3 | Transactions & Fund Transfer | CBS transaction engine with double-entry GL posting to an independent GL datastore, value dating, idempotency keys, reversal flow for failed postings, monetary calls routed via IBM MQ (not direct REST) for durability, Portal transaction UI | 3 |
| 3a | Maker-Checker Workflow | Approval workflow for transactions above threshold; segregation-of-duties enforcement (teller vs branch manager roles) | 1 |
| 3.5 | EOD Batch & Reconciliation | Scheduled EOD batch (interest accrual, standing instructions, dormancy checks); nightly GL vs sub-ledger reconciliation job with injectable mismatch scenario. **HLD step must include a forward-looking design note on singleton execution — this batch runs on a single-instance topology now, but Phase 4 converts to a cluster, and every member firing the job redundantly must be designed against from the start (e.g., WAS scheduler service "run on one member only" pattern) rather than reworked later — see open decision in 05_DECISIONS_LOG.md.** | 2 |
| 4 | Clustering & HA | Convert to WAS ND cluster, session replication, IHS load balancing, workload management | 2 |
| 5 | Cards, Loans, Fixed Deposits | EMI amortization schedule (reducing balance), late-payment penalty interest, FD maturity instructions (auto-renew/payout/premature closure) | 3 |
| 6 | Security | LDAP/WAS security domains, SSL end-to-end, J2C aliases, RBAC | 2 |
| 7 | Ops & Monitoring | Logging, PMI, thread/heap dump drills, scheduled batch, backup/restore | 2 |
| 8 | Reporting, GL, Audit | Remaining modules, immutable audit trail (who/when/old/new value), basic AML rule engine (threshold + structuring detection), final polish, docs | 3 |

**Total: 25 sprints**

---

# PART 2 — WEBSPHERE ADMIN MASTERY COURSE
*Estimated: ~6 months part-time (~24 sprints)*

Starts after Part 1 (App Development) is complete. Uses DigiStack CBS and Banking Portal as the live hands-on lab for every topic. Goal: take WAS ND admin skills from zero to advanced, closing the 10-year experience gap, then layer in Ansible/shell/DevSecOps automation.

### Format for Every Topic
1. Concept explanation (what it is, why it matters, where it fits in a banking-grade WAS environment)
2. Hands-on on DigiStack Bank (Console + wsadmin/Jython + Ansible, in full)
3. Production issues & solutions
4. Real-time scenarios, use cases, case studies
5. Performance tuning angle
6. Troubleshooting angle
7. Interview questions (concept + scenario-based)

| Phase | Objective | Key Topics | Sprints |
|---|---|---|---|
| 9 | WAS ND Foundations | Installation, Profiles, Dmgr concepts recap, Node & Federation deep-dive | 2 |
| 10 | Clustering Mastery | Cluster topologies, workload management, session replication internals, vertical/horizontal scaling | 2 |
| 11 | Deployment & App Management | Application deployment lifecycle, versioning, rolling updates, EAR/WAR internals | 2 |
| 12 | Data & Messaging | JDBC/Datasources deep-dive, connection pool tuning, JMS & IBM MQ administration | 2 |
| 13 | Security Deep-Dive | SSL & certificate management, admin/app security, LDAP, federated repositories/multi-realm | 3 |
| 14 | Performance & Tuning | JVM tuning, GC strategies, thread pools, capacity planning, translating load-test data to sizing | 2 |
| 15 | Web Tier & Sessions | Web server plugin config deep-dive, session management edge cases | 1 |
| 16 | Operations | Backup & restore, log/dump analysis (SystemOut/SystemErr, HPEL, IBM Support Assistant, thread/heap dumps) | 2 |
| 17 | Patching & Modernization | Fix pack strategy, rolling patch updates, WebSphere Liberty basics & comparison | 2 |
| 18 | Automation Mastery | wsadmin/Jython advanced scripting, Ansible/Shell/DevSecOps end-to-end automation | 2 |
| 19 | Capstone — Resilience | Load-test DigiStack under concurrency, diagnose bottlenecks (thread/JDBC/JVM/MQ), inject failures, validate failover/HAManager/session replication | 2 |
| 20 | Capstone — DR & Migration | Multi-site DR scenarios (RTO/RPO, replication, drills, failback), version migration planning (ND→ND, traditional→Liberty) | 2 |

**Total: 24 sprints**

---

## Combined Total

**Part 1 (25 sprints) + Part 2 (24 sprints) = 49 sprints, ~12 months part-time.**

---
*This file is the detailed reference. For day-by-day pacing of Part 1, see 04_SPRINT_PLAN_180_DAYS.md. For live sprint-by-sprint status, see 03_PROGRESS_LOG.md. For the checklist of concepts covered, see 02_CONCEPT_INDEX.md.*
