# SPRINT PLAN — 180 DAYS (Part 1: App Development)

> **Purpose:** Maps Part 1's ~25 sprints onto a realistic 180-day (~6 month) part-time calendar, assuming roughly 5-8 hours/week alongside a full-time job. Use this to track pacing — if you're consistently behind or ahead of the day ranges, that's a signal to revisit scope, not a hard deadline to stress over. Part 2 (WebSphere Admin Mastery, ~24 sprints, ~6 months) begins after Part 1 completes and will get its own day-mapped plan at that time.

**Assumption:** ~7 days average per sprint, adjusted for sprint complexity. Actual pace should follow 03_PROGRESS_LOG.md, not this calendar — this is a planning guide, not a rigid deadline.

---

## Day-by-Day Phase Map

| Days | Phase | Sprints | Objective |
|---|---|---|---|
| 1–14 | Phase 0 — Environment & Foundation | 2 | RHEL/VMware topology, PostgreSQL install, WAS ND cell (Dmgr + 2 nodes), IHS install + plugin, IBM MQ install, project skeleton |
| 15–35 | Phase 1 — CBS Core: Customer & Account | 3 | Account numbering, KYC fields, lifecycle states, PostgreSQL schema, first datasource, first REST endpoints |
| 36–49 | Phase 2 — Portal Foundation | 2 | Login, dashboard, nav/sidebar, REST calls to CBS, simulated API Gateway, IHS plugin wiring |
| 50–70 | Phase 3 — Transactions & Fund Transfer | 3 | Double-entry GL posting, value dating, idempotency keys, reversal flow, MQ-routed monetary calls |
| 71–77 | Phase 3a — Maker-Checker Workflow | 1 | Approval workflow above threshold, segregation of duties |
| 78–91 | Phase 3.5 — EOD Batch & Reconciliation | 2 | Scheduled EOD batch, nightly GL vs sub-ledger reconciliation |
| 92–105 | Phase 4 — Clustering & HA | 2 | WAS ND cluster conversion, session replication, IHS load balancing |
| 106–126 | Phase 5 — Cards, Loans, Fixed Deposits | 3 | EMI amortization, penalty interest, FD maturity instructions |
| 127–140 | Phase 6 — Security | 2 | LDAP/WAS security domains, SSL end-to-end, J2C aliases, RBAC |
| 141–154 | Phase 7 — Ops & Monitoring | 2 | Logging, PMI, thread/heap dump drills, scheduled batch, backup/restore |
| 155–175 | Phase 8 — Reporting, GL, Audit | 3 | Immutable audit trail, AML rule engine, final polish, docs |
| 176–180 | Buffer | — | Catch-up, review, or early start on Part 2 planning |

**Total: 175 days of active sprint work + 5-day buffer = 180 days**

---

## How to Use This File

- **Check in at the end of every Phase** (not every sprint): calculate elapsed days since 03_PROGRESS_LOG.md's "Project Start Date" and compare that to the day range for the phase just completed, below. If you're roughly 2x behind, that's fine — it's a normal part-time reality — but decide explicitly at that checkpoint whether to trim scope later (e.g., merge Phase 6 and 7) rather than letting the gap compound silently over 12 months. Note the decision in 03_PROGRESS_LOG.md's Open Issues section.
- If a phase is taking meaningfully longer than its day range, that's fine — just note it in 03_PROGRESS_LOG.md's Open Issues section so it's visible.
- This file does **not** override the Pacing rule in 00_MASTER_CONTEXT.md: one sprint at a time, explicit approval before moving on, regardless of calendar position.
- When Part 1 is fully complete, create a matching `SPRINT_PLAN_180_DAYS_PART2.md` (or renamed appropriately) for Part 2's ~24 sprints over its own ~180-day part-time window.

---
*This is a pacing guide, not a contract. 03_PROGRESS_LOG.md is always the authoritative record of actual progress.*
