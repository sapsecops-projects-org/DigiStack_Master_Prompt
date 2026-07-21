# DigiStack Bank — Roadmap Part-5

**Enterprise High Availability (HA), Disaster Recovery (DR) & Business Continuity**

**Goal:** Learn how enterprise organizations ensure that banking applications remain available even during failures, maintenance, disasters, or data center outages. This Part focuses on Business Continuity, High Availability, Disaster Recovery, and Production Resilience — all critical skills for senior WebSphere administrators.

**Prerequisite:** Part-4 Completion Checkpoint satisfied — full observability stack (Prometheus/Grafana, OpenSearch/ELK, Jaeger, Alertmanager) operational across all 9 Part-3 applications.

**Deployment model:** No new banking features are added anywhere in this Part, with one narrow exception (idempotency/retry handling in v38, which is a resilience behavior bolted onto existing transactions, not a new banking module). Every version instruments, hardens, or drills recovery procedures on the 9 applications already built.

**Process for every version:** Requirements → Development (HA/DR configuration, beginner-level explanation) → Deployment & Admin in WAS/monitoring stack → Testing (drills) → Documentation → **Pause for approval** before the next version.

**Per-version deliverables (per Master Index standing standards):** VM Setup section, Git-committed config/scripts, `TestCases-v<N>.md`, `SetupDoc-v<N>.md`, SQL migration script(s) only if a DR/HA-tracking table is added.

---

## ⚠️ Version Numbering Correction (resolved before this file is marked ready)

The source material this Part was drafted from numbered its versions 33 and 34. **That collides with Part-4, which already owns and has frozen Versions 31–35** (per Engineering Standards §7 — Version Numbering Freeze: v33 is already "APM, Distributed Tracing & SRE Methodology" and v34 is already "Alerting, Dashboard Engineering & Synthetic Monitoring"). Per the freeze rule, Part-5 is renumbered to start immediately after Part-4 ends.

**Renumbering table (required by Engineering Standards §7 whenever a renumbering happens):**

| Old # (draft) | Old Title | New # | New Title |
|---|---|---|---|
| 33 | High Availability (HA) | 36 | High Availability (HA) |
| 34 | Disaster Recovery (DR) | 37 | Disaster Recovery (DR) |
| — (recommended addition) | — | 38 | Business Continuity & Application Resilience |

No version has been implemented yet, so this is a clean pre-implementation renumbering (same precedent as Part-3's and Part-4's own renumbering passes) — not a mid-flight break.

**Consolidation note.** A gap-analysis review of the source material raised 12 distinct gaps (application continuity, database continuity, MQ continuity, monitoring integration, planned maintenance, HA/DR split, backup strategy, DR runbook, RPO/RTO examples, architecture consistency, business continuity, production exercises). Rather than creating a version per gap — which would fragment what is really one story ("what happens to an in-flight banking transaction and the platform around it when something breaks") — each gap is folded into whichever of the three versions below it most naturally extends, with cross-cutting items (monitoring verification) treated as a standing requirement rather than a separate version. The mapping is documented inline in each version below.

---

## Version 36 — High Availability (HA)

### Objective
Build a highly available WebSphere environment where no single server failure causes an application outage.

### Banking Features Added
**None.** This version is 100% infrastructure resilience — every banking feature already built across Parts 1–4 is the test subject, not the point.

### Infrastructure Features
**WebSphere HA**
- Cluster Failover
- Session Failover
- Automatic Workload Distribution
- Cluster Member Recovery

**IBM HTTP Server**
- Plugin Failover
- Health Checks
- Automatic Routing
- Plugin Generation, Plugin Propagation, Plugin Refresh — the everyday admin cycle that keeps `plugin-cfg.xml` in sync whenever cluster membership changes

**Load Balancer**
- Health Monitoring
- Server Removal
- Automatic Traffic Routing
- Sticky Session / Session Affinity / Cookie-based routing — how the LB itself keeps a user on one member even though WebSphere's own session replication (Part-1 v5/v9) is what actually protects the session data

### Architecture
```
               Load Balancer
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
IBM HTTP Server-1         IBM HTTP Server-2
        │                         │
        └────────────┬────────────┘
                      ▼
             WebSphere Cluster
         ┌────────────┬────────────┐
         ▼            ▼            ▼
      JVM1          JVM2         JVM3
                      │
                      ▼
                 DigiStack CBS
                      │
                      ▼
                 PostgreSQL
```

### Failure Type Taxonomy (introduced here, reused in v37/v38)
> **Gap 6 fold-in.** Every HA/DR drill from this version forward is classified against one of these failure types, so "what kind of failure are we testing" is never ambiguous:
- Server Failure (a JVM/cluster member dies)
- Application Failure (the app hangs/errors, server is fine)
- Database Failure (PostgreSQL unreachable)
- Storage Failure (disk full/unavailable)
- Network Failure (connectivity between tiers lost)
- DNS Failure (name resolution breaks)
- Load Balancer Failure (LB itself goes down)
- Site Failure (the whole DC is gone — this is v37's territory, not v36's)

v36 exercises the first two (Server, Application); v37 exercises Site; v38's Gap 2/3 items exercise Database, Storage, and messaging-layer failure specifically.

### Failure Scenarios (drill-based test cases, not new features)
> **Gap 1 fold-in.** These are the concrete verification cases for this version's Sprint Deliverable — detailed test cases for HA, not new banking scope.

**Scenario A — Customer transferring money, JVM crashes mid-transaction**
```
Customer initiates Fund Transfer
        │
        ▼
   JVM1 crashes
        │
        ▼
Does the transfer complete, rollback, or hang?
Can the customer safely retry?
Can a duplicate transaction occur?
```
Expected: the in-flight transaction either completes via XA recovery or rolls back cleanly — it must never leave the account in a half-updated state, and a retry must not double-process. (Deep idempotency/retry mechanics are v38's job; this version just proves the cluster-level failover doesn't corrupt the transaction.)

**Scenario B — Customer logged in, cluster member crashes**
```
Customer is logged in
        │
        ▼
Cluster member crashes
        │
        ▼
Session replicated (reuses Part-1 v5/v9 session replication)
        │
        ▼
Customer continues without re-logging in
```

**Scenario C — IHS/plugin failover**
Kill one IHS instance mid-traffic; confirm the Load Balancer routes around it with no dropped requests.

### Post-Recovery Synchronization
Once a killed member/node comes back, failover alone doesn't guarantee it rejoins cleanly — this is where real production activity continues after the drill "passes":
- **Node Sync** — the recovered node pulls the latest configuration from the DMgr's master repository
- **Full Resynchronization** — used when a node's local config has drifted or is suspect, rather than trusting an incremental sync
- **Repository Synchronization** — confirming the DMgr's master repository and every node's local repository agree, cell-wide

Each drill in this version isn't considered closed until the recovered member/node has gone through a confirmed Node Sync, not just "came back up."

### Monitoring Verification (standing requirement — Gap 4)
> Not a separate feature. Every drill's pass/fail is confirmed through Part-4's stack, not eyeballed: Grafana shows the cluster health dip and recovery, Prometheus/Alertmanager fires (and clears) an alert for the killed JVM, and Jaeger shows the in-flight trace either completing or cleanly failing. If a drill "passes" but the observability stack didn't see it, the drill isn't actually verified.

### WebSphere Topics Covered
- Cluster Failover, Session Persistence, Plugin Routing, Workload Management
- **Core Groups** — Core Group Bridge (communication between Core Groups), Core Group Policies (which HAManager singleton services run where), DCS (Data Replication Service — the underlying transport Core Groups use for heartbeat and state replication) — standard WebSphere HA interview topics, exercised here rather than just named
- **Messaging Engine HA** (added per Senior Architect Review, Finding #5) — SIBus's Messaging Engine has been load-bearing infrastructure since Part-2 v15 (Fund Transfer async processing) but its own HA story was never covered separately from generic cluster failover. Messaging Engines are singleton services with their own Core Group Policy-driven failover binding — a genuinely different concern from ordinary cluster member failover. Covered here, as a natural extension of the Core Groups material above: **Messaging Engine failover policy** (which cluster member hosts the active ME, and how Core Group Policy governs failover to another member), and the **ME data store** — file store vs. DB store — with the consequence that a file-store ME failing over to another cluster member can lose access to in-flight/uncommitted messages, unlike a DB-backed store. Exercised directly against this version's existing "kill a cluster member mid-Fund-Transfer" drill (Scenario A) — confirm whether the ME failed over cleanly and whether any in-flight JMS message was affected, given the data store type actually configured.
- Node Synchronization — Node Sync, Full Resynchronization, Repository Synchronization (post-recovery, see above)

### Enterprise Learning
High Availability, Zero-Downtime Services, Failover Testing, Cluster Recovery

**Sprint Deliverable:** JVM1, JVM2, and the Node Agent are each killed in turn during active banking traffic; in every case, session state survives (Scenario B), no in-flight Fund Transfer is corrupted or duplicated (Scenario A), and Load Balancer/IHS failover is transparent to the user (Scenario C) — each outcome confirmed via Grafana/Prometheus/Jaeger, not manual inspection alone; each recovered member is confirmed to have completed Node Sync against the DMgr's master repository before the drill is marked closed.

---

## Version 37 — Disaster Recovery (DR)

### Objective
Implement a Disaster Recovery site for DigiStack Bank and prove failover/failback between two data centers.

### Banking Features Added
**None.** DR validates the same 9 applications from Part-3 running at a second site.

### DR Concepts
- **Primary Site:** Hyderabad DC
- **Secondary Site:** Bangalore DC

**Components per site:**
| Site | Components |
|---|---|
| Primary | IBM HTTP Server, WebSphere ND, CBS + the other 8 Part-3 applications, PostgreSQL |
| Secondary (DR) | IBM HTTP Server, WebSphere ND, CBS + the other 8 Part-3 applications, PostgreSQL (replica) |

### Architecture
> **Gap 10 fold-in.** The single-CBS-box diagram in the original draft predates Part-3's 9-service topology — updated here to stay consistent with Parts 2–4:

```
                         PRIMARY DC (Hyderabad)
Users
  │
  ▼
Load Balancer
  │
  ▼
IBM HTTP Server (IHS-1, IHS-2)
  │
  ▼
   Portal Cluster
  │
  ├──────────────► CBS Cluster ◄──────────────┐
  │                    │                       │
  │              Payment Hub              Notification Service
  │                    │                       │
  │              Reporting Service       (IBM MQ event bus)
  │                    │
  │              PostgreSQL (digistack_cbs) — Primary
  │
  ├── Branch Portal, Card Portal (WAS)
  └── Mobile, ATM (Tomcat)

======================== Replication ========================

                       SECONDARY / DR DC (Bangalore)
IBM HTTP Server
  │
  ▼
WebSphere ND (Portal Cluster, CBS Cluster, satellite EARs — standby/warm)
  │
  ▼
PostgreSQL (digistack_cbs) — Standby (streaming replication target)
```

### DR Activities
- Backup / Restore
- Database Replication (concepts — streaming replication, standby promotion)
- Configuration Synchronization (WAS cell config, IHS/plugin config, security config kept in sync between sites)
- DR Drill
- Planned Failover
- Unplanned Failover
- **Failback** to Primary once it's confirmed healthy again

**Enterprise Storage (concept-level — not implemented, just understood):**
- Shared Storage
- SAN / NAS
- Snapshot Backup

These aren't built in this project (no real SAN available), but knowing where they fit — e.g., a storage-level snapshot as a faster restore path than a full `pg_dump` restore — is expected enterprise DR knowledge, and belongs in `SetupDoc-v37.md` as a documented concept even though the lab itself uses simple VM/file-based backups.

**DNS Failover (concept-level, alongside the DNS Failure type from v36's taxonomy):**
- DNS Failover — updating DNS to point at the DR site during a real site failure
- Virtual IP (VIP) — a floating IP that can move between Primary/DR without a DNS change
- Global Server Load Balancer (GSLB) — concept only; the enterprise-grade way large banks route traffic across sites without relying on DNS TTL expiry

For this lab, the actual DR drill uses a manual traffic-routing step (updating the Load Balancer or a hosts-file-level override) rather than real DNS/GSLB infrastructure — call out explicitly in `SetupDoc-v37.md` which stand-in is used.

### RPO / RTO — Tied to Actual DigiStack Flows
> **Gap 9 fold-in.** Definitions alone are abstract; tying them to real flows makes the targets concrete and testable.

| Flow | RPO | RTO | Rationale |
|---|---|---|---|
| Fund Transfer (Part-2 v15/v19, Part-3 v25) | 0 minutes | 15 minutes | Money movement — zero tolerated data loss, fast recovery |
| Login / Session | 0 minutes | 15 minutes | Tied to the same cluster as Fund Transfer |
| Notification (Part-1 v13, Part-3 satellite) | 30 minutes | 60 minutes | Best-effort delivery is acceptable to delay |
| Reporting (Part-1 v14, Part-3 satellite) | 24 hours | 4 hours | Reports can be regenerated from replicated data after recovery |

These targets are what the DR drill below is actually measured against — a drill that recovers Fund Transfer in 20 minutes has failed its RTO even if everything else worked.

### Failure Type Coverage (from v36's taxonomy)
This version specifically exercises **Site Failure** — the case v36 deliberately left out.

### WebSphere Topics Covered
- BackupConfig, RestoreConfig, Cell Export, Profile Backup, DR Planning

### Enterprise Learning
Disaster Recovery, Recovery Point Objective (RPO), Recovery Time Objective (RTO), Business Continuity (introductory pass — formalized in v38)

### Monitoring Verification (standing requirement)
DR drill success is confirmed the same way as v36: Grafana shows the Secondary site's cluster coming to full health, Prometheus/Alertmanager reflects the Primary site's alerts and their clearing on failback, and Jaeger/ELK confirm a Fund Transfer trace completes correctly against the Secondary site during the drill window.

**Sprint Deliverable:** A full planned failover from Hyderabad to Bangalore is executed and measured against the RPO/RTO table above (Fund Transfer recovers within 15 minutes with zero data loss); an unplanned-failure simulation is also run; failback to Primary is performed once Primary is confirmed healthy; all outcomes verified via the Part-4 observability stack.

---

## Version 38 — Business Continuity & Application Resilience

### Objective
Close the remaining gaps between "the infrastructure fails over" (v36/v37) and "the business — and the specific in-flight transactions and messages — actually survives intact." This version is where transaction-level integrity, database/MQ continuity specifics, planned maintenance without downtime, a real backup inventory, a DR runbook, and broader business-continuity process live.

### Banking Features Added
**Effectively none**, with one narrow exception: **idempotency keys / duplicate-transaction prevention** are added as a resilience behavior on top of the existing Fund Transfer flow (Part-2 v15, Part-3 v25) — not a new banking module, just a safety property retrofitted onto an existing one.

### 1. Transaction Integrity (Gap 1, deepened from v36's Scenario A)
- **In-flight Transaction Recovery** — XA transaction recovery on JVM restart, so a Fund Transfer that was mid-commit when a JVM died is neither lost nor double-applied
- **JMS Message Reliability** — persistent messages on SIBus/MQ queues (Part-2 v15/v19) survive a broker restart
- **Idempotent Requests** — Fund Transfer (and other write operations) accept an idempotency key so a client's retry after a timeout doesn't create a second transaction
- **Retry Logic** — standardized client-side and server-side retry policy (max attempts, backoff) reused from Part-3 v25's Payment Hub retry work
- **Duplicate Transaction Prevention** — enforced via the idempotency key, verified with a deliberate double-submit test

**Failure scenario (Gap 1):**
```
Message sent to MQ
        │
        ▼
CBS unavailable
        │
        ▼
Message waits (persistent, not lost)
        │
        ▼
CBS comes online
        │
        ▼
Processing resumes — exactly once, not twice
```

### 2. Database Continuity (Gap 2)
- Primary Database / Standby Database
- Streaming Replication
- Failover concepts (manual promotion is fine for this project's scale)
- Read Replica (concept)
- Automatic Promotion (concept — noted as a production enhancement beyond this project's scope)
- Point-in-Time Recovery (PITR)
- Connection Pool Recovery
- JDBC Failover — confirming the WAS-managed DataSource (Part-1 v7) reconnects cleanly once PostgreSQL is back

**Failure scenario:**
```
Database temporarily unavailable
        │
        ▼
Application retries (connection pool)
        │
        ▼
Pool recovers
        │
        ▼
Transaction resumes, or safely rolls back — never silently corrupts
```

### 3. IBM MQ Continuity (Gap 3)
- MQ HA (concepts)
- Queue Manager Backup
- Persistent Messages
- Dead Letter Queue (reused from Part-2 v19)
- Message Replay
- Queue Recovery
- Channel Recovery

**Failure scenario:**
```
CBS offline
        │
        ▼
MQ stores messages (persistent queue)
        │
        ▼
CBS starts
        │
        ▼
Messages processed — none lost, none duplicated
```

### 4. Planned Maintenance / Zero-Downtime Operations (Gap 5)
- Rolling Restart
- Rolling Deployment
- Plugin Refresh / Plugin Regeneration
- Node Maintenance
- JVM Maintenance
- OS Patching (process, not deep OS admin)
- WebSphere Fix Pack application
- **No-downtime maintenance** — proven by performing one real rolling restart of the cluster while banking traffic continues, with zero customer-visible errors

### 5. Backup Strategy — Expanded Inventory (Gap 7)
> The Part-1–4 "Backup / Restore" line items were too thin for a real DR posture. Full inventory:

| Item | Notes |
|---|---|
| WAS profile backup | `backupConfig` |
| IHS backup | Config + custom error pages (Part-1 v8) |
| Plugin backup | `plugin-cfg.xml` |
| SSL certificate / keystore backup | Ties to doc 07 §7's Certificate Inventory |
| Database backup | `pg_dump` + PITR base backups |
| Application EAR/WAR backup | All 7 EARs + 2 WARs |
| Deployment scripts backup | wsadmin scripts, Ansible if used |
| Git repository backup | Mirrors of all project repos |
| Grafana dashboards backup | Exported JSON (Part-4 v34) |
| Prometheus configuration backup | Scrape configs, alert rules (Part-4 v31/v34) |

### 6. DR Runbook (Gap 8)
A formally documented runbook, in the same shape as Part-4 v35's incident runbooks:
```
Failure Detected
      │
      ▼
Incident Created
      │
      ▼
Management Approval (simulated)
      │
      ▼
Activate DR
      │
      ▼
Restore Infrastructure
      │
      ▼
Restore Database
      │
      ▼
Deploy Applications
      │
      ▼
Health Checks
      │
      ▼
Business Validation
      │
      ▼
Traffic Switch
      │
      ▼
Monitoring
      │
      ▼
Close Incident
```
This runbook is the one actually exercised in this version's Sprint Deliverable — v37 proved the technical failover works; this version proves the *process* around it is real.

### 7. Business Continuity (Gap 11 — broader than DR)
- Alternate Workplace (concept)
- Communication Plan (who gets notified, in what order)
- Incident Response (ties to Part-4 v35)
- Change Freeze (during active incident/DR windows)
- Emergency CAB (Change Advisory Board — concept)
- Business Owner Approval
- Customer Notification (ties to Notification Service, Part-3 v23)
- Audit Compliance
- Post-Incident Review

### 8. Production Exercises (Gap 12 — this version's test cases)
- Kill one JVM during active banking transactions and verify idempotency prevents duplication
- Shut down an entire node while users remain logged in
- Restart IBM HTTP Server during production traffic
- Simulate a PostgreSQL outage and observe JDBC failover/recovery
- Stop the IBM MQ Queue Manager and verify persistent messages process correctly on recovery
- Perform a rolling cluster maintenance window with zero downtime
- Execute one complete DR drill end-to-end using the runbook above, Primary → Secondary → back
- Validate dashboards, alerts, and distributed traces after each exercise
- Confirm traffic correctly switches back to Primary DC after recovery

**Recovery Record (required for every exercise above):**
Each production exercise produces one short record, in the same spirit as a real post-incident report:

| Field | Description |
|---|---|
| Failure Time | When the failure was injected |
| Detection Time | When monitoring/alerting first flagged it |
| Recovery Time | When the system returned to normal operation |
| Root Cause | What actually broke (even if deliberately induced) |
| Resolution | What action restored service |
| Lessons Learned | Anything that should change an alert threshold, runbook step, or timeout value |

These records are what feed the MTTD/MTTR figures referenced in Part-4 v35 and the RPO/RTO validation from v37 — without them, "we ran the drill" isn't distinguishable from "we proved the numbers."

### Monitoring Verification (standing requirement)
Every production exercise above is confirmed via Grafana (cluster/DB/MQ health), Prometheus/Alertmanager (alert fired and cleared), Jaeger (trace behavior during the failure), and OpenSearch/ELK (log evidence of retry/recovery behavior) — consistent with v36 and v37.

### WebSphere Topics Covered
- XA Transaction Recovery, JDBC Failover, Rolling Deployment, Plugin Regeneration, Fix Pack Management, backupConfig/restoreConfig (full inventory), Change Management
- **Transaction Log & XA Recovery — Heuristic Completion** (added per Senior Architect Review, Finding #4) — "In-flight Transaction Recovery" above names the *result* (a transaction isn't lost or duplicated); this names the actual mechanism behind it. WebSphere's **Transaction Log** (`tranlog`) records in-doubt XA transactions so that, on server restart after a crash mid-two-phase-commit, WebSphere can automatically resolve most in-doubt transactions by replaying the log against the resource managers involved. The harder, genuinely differentiating case is **heuristic completion**: situations where a resource manager (e.g., PostgreSQL) and the WebSphere Transaction Manager disagree on the outcome of a transaction — one believes it committed, the other believes it rolled back — and automatic recovery isn't possible; an administrator must manually inspect the transaction log and force a heuristic outcome (heuristic commit, heuristic rollback, or heuristic mixed/hazard, if different resource managers within the same transaction ended up in different states). This is exercised directly against v36's Scenario A (JVM crashes mid-Fund-Transfer): after that drill, locate the transaction log, confirm whether recovery was automatic or required manual heuristic resolution, and document which occurred.

### Enterprise Learning
Business Continuity Planning, Transaction Integrity, Idempotency Design, Database HA, Messaging HA, Zero-Downtime Operations, DR Runbook Execution, Post-Incident Review

**Sprint Deliverable:** All nine production exercises listed above are run at least once, each with its detection/recovery outcome recorded; a deliberate double-submit of a Fund Transfer proves idempotency prevents a duplicate; a full DR runbook execution (Primary → Secondary → failback) is performed as a documented, approved (simulated) change rather than an ad hoc technical test; the full backup inventory is confirmed restorable, not just present.

---

## ✅ Part-5 Completion Checkpoint

Before starting Part-6 (Multi-Region Enterprise Banking), confirm:

- [ ] Cluster-level failover proven for Server and Application failure types — session survives, in-flight transactions don't corrupt (v36)
- [ ] LB/IHS failover transparent to users under a killed-node drill (v36)
- [ ] Full DR site (Bangalore) stood up and kept in sync with Primary (Hyderabad) via replication and configuration sync (v37)
- [ ] Planned failover, unplanned failover, and failback all executed at least once, measured against the RPO/RTO table (v37)
- [ ] Idempotency/duplicate-prevention proven on Fund Transfer via a deliberate double-submit test (v38)
- [ ] Database continuity (streaming replication, PITR, JDBC failover) demonstrated (v38)
- [ ] MQ continuity (persistent messages, queue/channel recovery) demonstrated (v38)
- [ ] At least one zero-downtime rolling maintenance window performed against live traffic (v38)
- [ ] Full backup inventory (WAS, IHS, plugin, SSL/keystore, DB, EARs, scripts, Git, Grafana, Prometheus) confirmed restorable, not just backed up (v38)
- [ ] DR runbook executed end-to-end as a documented, approved change (v38)
- [ ] All production exercises in v38 run at least once with recorded outcomes
- [ ] Every drill/exercise across v36–v38 verified through the Part-4 observability stack (Grafana/Prometheus/Jaeger/ELK), not manual inspection alone
- [ ] All three versions' `TestCases-v36.md`–`v38.md` signed off per Test Case Standards
- [ ] Part-5 promoted Dev → UAT → Prod per Environment Promotion Standards, `part5-release` tag applied

**Carried forward into Part-6:** The HA/DR/continuity discipline built here (failure taxonomy, RPO/RTO targets, DR runbook, backup inventory) becomes the template Part-6 extends from single-DR-site to true multi-region operation.

---

## Application State After Part-5

**Application code:** unchanged from Part-3/Part-4 (`digistack-bank` family of EARs + Mobile/ATM Tomcat apps), with the narrow addition of idempotency-key handling on Fund Transfer (v38). **No new banking modules were added in this Part.**

**New Infrastructure**
- Secondary DR site (Bangalore DC) — full WAS ND, IHS, CBS + satellite EARs, PostgreSQL standby (v37)
- Database streaming replication, PITR capability (v38)
- Formal DR runbook, expanded backup inventory, business continuity process documentation (v38)

This is the exact starting point Part-6 (Multi-Region Enterprise Banking) picks up from.

---

*This document is Part-5 of the DigiStack Bank Roadmap (Versions 36–38: Enterprise HA, DR & Business Continuity). See Part-1 for Versions 1–14, Part-2 for Versions 15–22, Part-3 for Versions 23–30, Part-4 for Versions 31–35, and the MASTER INDEX for full navigation.*

---

**Change log for this revision (Senior Architect Review follow-up):**
- Added "Messaging Engine HA" (failover policy, file store vs. DB store) to Version 36's WebSphere Topics Covered, per Finding #5.
- Added "Transaction Log & XA Recovery — Heuristic Completion" to Version 38's WebSphere Topics Covered, per Finding #4.
