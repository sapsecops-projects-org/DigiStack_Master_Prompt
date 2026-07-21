# CODEBASE MANIFEST — DigiStack Bank

**Purpose:** This file is the source of truth for the *actual application codebase* — separate from `03_PROGRESS_LOG.md`, which is the source of truth for *curriculum progress*. Paste this alongside the other 8 files (and the repo URL below, once created) at the start of any new chat session, starting Phase 2 (Sprint 2.1). It exists so a brand-new Claude session never re-derives architecture decisions, never re-invents a name that's already locked, and never contradicts code that already exists.

**Relationship to other files:** `06_DEV_HANDOFF_TEMPLATE.md` captures per-sprint deployment detail (one entry per app-dev sprint). This file is the cumulative, always-current summary across all sprints — what the codebase looks like *right now*, as of the most recent commit.

---

## 1. Repository

- **Canonical repo:** `<PASTE ACTUAL GIT URL HERE ONCE CREATED — e.g. https://github.com/<you>/digistack-bank>`
- **Recommendation:** create this now, even though it stays empty until Sprint 2.1 (rule #6 — Git usage begins Phase 2). An empty repo with just this manifest and a README costs nothing and means the pointer is already correct when Phase 2 starts.
- **Branch convention:** `main` = last known-good state (matches what's actually deployed in the lab). Optional feature branches per sprint (`sprint-2.1-jdbc-createaccount`) merged into `main` at that sprint's close — mirrors real change-control practice and gives you a clean CAB-reviewable diff once Phase 3's CAB gate (rule #27) is live.
- **At the start of any new chat, once code exists:** paste the repo URL (if not already filled in above) and say which sprint/day you're resuming. Claude will `git clone` it via the sandboxed shell (github.com is reachable) to pull the current state before writing anything new. If cloning isn't possible for some reason, paste the specific file(s) in question instead — but the manifest below should still prevent naming drift even without the clone.

---

## 2. Current Build Status

*(Update this section at the close of every app-dev sprint — same moment you fill out `06_DEV_HANDOFF_TEMPLATE.md`.)*

- **Last sprint with code changes:** none yet — Phase 2 opens at Sprint 2.1 (Day 38).
- **Current EAR name / version:** N/A yet (first assigned Sprint 2.6 — packaging).
- **Modules built:** none yet.
- **Modules pending:** Create Account, Customer Login, Check Balance, Manage Beneficiary, Transfer Money + Dual Notification (all Phase 2), Ops Utility companion app (4.10).

---

## 3. Recommended Package Architecture

This is the locked skeleton — designed once, now, specifically so every later sprint's code has an obvious, correct place to go rather than forcing a refactor later. Plain Servlet/JSP/DAO, no frameworks, per Master Context §2.

```
com.digistackbank
├── controller/                 — Servlets (the "Controller" in our MVC-style layering)
│   ├── CreateAccountServlet    (Sprint 2.1)
│   ├── LoginServlet            (Sprint 2.2 — gains TAI/pre-auth header path at 4.7)
│   ├── BalanceServlet          (Sprint 2.3 — becomes Dynacache-eligible at 6.8)
│   ├── BeneficiaryServlet      (Sprint 2.4)
│   ├── TransferServlet         (Sprint 2.5 begins core logic; 3.7 adds MQ hand-off)
│   ├── HealthServlet           (Sprint 3.8)
│   ├── SlowEndpointServlet     (toggleable — Advanced Block, Monitoring Policy 5.6)
│   └── ErrorProneServlet       (toggleable — 4.3 logging; stale-connection variant at 6.9)
│
├── dao/                        — Data access, JDBC via JNDI only — never a hardcoded URL
│   ├── AccountDAO, CustomerDAO, BeneficiaryDAO, NotificationDAO
│   └── util/ConnectionManager  — single JNDI lookup point (see Name Registry below)
│
├── model/                      — POJOs: Account, Customer, Beneficiary, Transaction, Notification
│
├── mq/                         — Sprint 3.6/3.7
│   ├── TransferMessageProducer
│   └── NotificationMDB         — structured XML/JSON payload (txn ID, timestamp, amount)
│
├── monitoring/                 — Sprint 4.4 / Part 2 bridge
│   └── CustomPMICounters       (transfersProcessed, failedLogins)
│
├── cache/                      — Sprint 6.8
│   └── BalanceCacheHelper      (Dynacache)
│
└── util/
    ├── BuildVersionStamp       — footer version/timestamp (2.6, paid off again at 5.7)
    ├── SessionClusterInfo      — Session ID + "Served by: Cluster Member X" (2.4, 3.3, 5.4)
    ├── EnvironmentScopeReader  — Sprint 4.9 scope-precedence footer
    └── AppLogger               — java.util.logging wrapper (4.3), real INFO/WARNING/SEVERE levels
```

**Second WAR — `ops-utility`** (Sprint 4.10): minimal, separate status-page app, co-deployed on the same cluster specifically to demonstrate class loader isolation. Deliberately not merged into the main package tree above.

**Why this shape:** every module in Phase 2 is a `controller` + `dao` pair with a shared `model` — nothing later has to restructure that. Every instrumentation hook Master Context already committed to (session/cluster footer, build stamp, health check, PMI counters, environment scope, dynacache, toggleable endpoints) has exactly one home in `util/`, `monitoring/`, or `cache/` — so when, say, Sprint 4.9 needs the Environment Scope footer, it's extending an existing class, not inventing new structure under time pressure.

---

## 4. Name Registry — Locked Names (do not re-derive; update only when a sprint actually confirms a value)

| Resource | Name | Locked at |
|---|---|---|
| JNDI datasource | `jdbc/DigiStackDB` | Sprint 1.2, Day 5 (confirmed with Priya Nair) |
| MySQL schema name | *TBD* | Sprint 1.5 |
| Notification inbox table | *TBD* | Sprint 1.5 |
| MQ Queue Manager | *TBD* | Sprint 3.6 |
| MQ notification queue | *TBD* | Sprint 3.6/3.7 |
| Health endpoint path | `/health` | Sprint 3.8 (per Master Context §2) |
| Ops Utility context root | *TBD* | Sprint 4.10 |
| EAR name | *TBD* | Sprint 2.6 |

*(Fill in each "TBD" the day its sprint actually locks the value — not before. This table is the single place any future chat checks before creating a resource, so two sessions never invent two different names for the same thing.)*

---

## 5. Instrumentation Hook ↔ Concept Cross-Reference

| Hook | Lives in | Exercises |
|---|---|---|
| Slow endpoint (toggleable) | `controller/SlowEndpointServlet` | Thread pool exhaustion (6.2), Monitoring Policy auto-restart (5.6), hang diagnosis (6.3) |
| Error-prone endpoint (toggleable) | `controller/ErrorProneServlet` | Logging/HPEL/FFDC (4.3), stale-connection variant (6.9) |
| Session ID + cluster footer | `util/SessionClusterInfo` | Session mgmt (2.4), replication (3.3), failover drill (5.4) |
| Build version stamp | `util/BuildVersionStamp` | Packaging (2.6), rolling deployment (5.7) |
| Health servlet | `controller/HealthServlet` | Health check pattern (3.8), Monitoring Policy (5.6), Part 2 observability |
| Custom PMI counters | `monitoring/CustomPMICounters` | PMI (4.4), PMI→JMX bridge (Part 2) |
| Environment Scope footer | `util/EnvironmentScopeReader` | Config scope precedence (4.9) |
| Dynacache | `cache/BalanceCacheHelper` | Dynacache (6.8) |
| XA coordination | `dao/` + `mq/`, Transfer flow | XA/2PC (2.5, 3.7) |

---

## 6. How to Use This File in a New Chat

1. Attach this file alongside the other 8 project files (or all 9 together).
2. If the Repository URL above is still a placeholder, paste the real one.
3. State which sprint/day you're resuming.
4. Claude clones the repo to check current code state before writing anything new, and cross-checks any new resource name against Section 4 before creating it.
5. At the close of any app-dev sprint, Claude updates Sections 2 and 4 here — same moment the Developer Handoff Package (rule #9) gets filled out.

---

*Added 2026-07-15. Maintained alongside `03_PROGRESS_LOG.md` — that file answers "what happened and when," this one answers "what does the code look like and where does it live." See Progress Log's Standing Deviation Log for the full rationale.*
