# DigiStack Health Enterprise — Advanced Lab Challenge Bank

Companion to `04_SPRINT_PLAN_180_DAYS.md`. This is the challenge menu for the **Advanced LAB tickets** on every Weekly LAB day (Day 7 / Day 14), for the **once-a-week after-hours on-call page**, and for Day 15 Production Simulations.

**How to use this file:**
- Each topic lists the sprint(s) it's tied to and the earliest sprint it becomes usable. Don't draw a challenge from a topic that hasn't been taught yet — check `02_CONCEPT_INDEX.md` first.
- Four tiers per topic: **Beginner → Intermediate → Advanced → Expert.** Tiers build on each other; don't skip to Expert on a topic you haven't done Beginner/Intermediate on at least once.
- "Advanced" and "Expert" tiers are meant to be run **cold** — no walkthrough open, no hints, ideally with a synthetic incident injected by rerunning a script or manually breaking config, not by reading what's broken beforehand.
- Each challenge drawn from here is delivered as its own ticket (SR/CHG/INC/PRB/ECHG per Master Context Section 10d) — Beginner/Intermediate as SR, Advanced/Expert as INC, PRB, or CHG depending on whether it's a live break-fix, a root-cause dig, or a change; ECHG for anything urgent enough it can't wait for a normal change window.
- Master Context Section 1a's "every ticket names a department" rule applies here too, even though it isn't spelled out on every line below — as a default, name whichever department owns that layer: JDBC/Datasource challenges → Database Team; IHS/Plugin/SSL challenges → Network Team (+ Security Team for certs); MQ challenges → IBM MQ Team; Linux/OS challenges → Linux Team; anything cell/cluster/DMGR-level stays with Middleware.
- **Snapshot before you break anything.** Any Advanced/Expert challenge that injects failure into cluster, cell, or DMGR state (e.g. "DMGR is unrecoverable," "kill a cluster member," any full-site failure drill) should be preceded by a hypervisor snapshot of the affected VM(s) — VM1/VM2 at minimum, plus VM4/VM5 if the drill touches PostgreSQL or MQ state. The point of these labs is a timed, controlled recovery — not an actually-corrupted environment that costs hours of unplanned rebuild because the injected failure went further than intended. Restore the snapshot afterward (or keep it as the "known good" baseline for the next attempt).
- Add a timer to any Advanced/Expert challenge once you've done it slowly at least once correctly — speed is a later goal, correctness is the first one.
- Log every Advanced/Expert attempt in `03_PROGRESS_LOG.md` (pass/fail, time taken, root cause if it was an incident, and the ticket ID if you're tracking those) — this becomes your interview-story material later.

---

## Phase 1 / Early Phase 2 — Foundations

### JDBC, Datasources & Connection Pooling *(usable from 1.12 / deepens at 2.10)*
- **Beginner:** Test datasource connectivity via the Admin Console "Test Connection" button; confirm success/failure messages.
- **Intermediate:** Resize a connection pool (min/max) and observe the effect on concurrent-user capacity using a small synthetic load.
- **Advanced:** *Fix a broken datasource* — a config value (wrong password, host, or port) has been quietly changed. App throws JDBC connection errors. Diagnose and fix using only server logs — no hints.
- **Expert:** Under sustained load, the pool exhausts (`ConnectionWaitTimeoutException`). Determine whether it's pool sizing, a connection leak in DAO code, or a long-running query — and fix the actual cause, not just the pool size.

---

## Phase 2 — Build, Deploy & Scale

### Deployment & the Console / wsadmin / Automation Triad *(from 2.1)*
- **Beginner:** Deploy the Login WAR via Admin Console only; verify in browser.
- **Intermediate:** Deploy the same WAR via wsadmin (Jython) only — no Console clicks.
- **Advanced:** *Deploy without the GUI at all* — wsadmin + shell script only, fully scripted, zero manual steps, start to finish.
- **Expert:** Given a WAR that's uploaded but the app won't start, diagnose and fix within 15 minutes using logs only.

### Session Management & Replication *(from 2.2, deepens at 2.9 / 2.15)*
- **Beginner:** Log in, inspect the JSESSIONID cookie, trace it across two page navigations.
- **Intermediate:** Configure memory-to-memory session replication between cluster members.
- **Advanced:** Kill the cluster member holding an active session mid-transaction; verify the session survives on the peer with zero data loss.
- **Expert:** Diagnose an intermittent "random logout" bug where session affinity breaks unpredictably under load — find the root cause (sticky session config vs. plugin config vs. replication lag) and fix it.

### Cell, DMGR & Node Federation *(from 2.3 / 2.4)*
- **Beginner:** Start/stop the DMGR; confirm Console reachability.
- **Intermediate:** Federate a node; verify node agent health two ways (Console + wsadmin).
- **Advanced:** *Recover a node* that's fallen out of sync with the DMGR — force a manual resync without losing custom configuration.
- **Expert *(usable from 4.4 — forward-reference, do not attempt before Backup & Recovery is taught)*:** DMGR is unrecoverable (simulated). Restore full cell operation from a `backupConfig` archive and re-verify federation, both cluster members, and every deployed app — within 30 minutes. This challenge is listed here thematically (it's the natural "hardest" DMGR/federation scenario) but depends on `backupConfig`/`restoreConfig`, which per `02_CONCEPT_INDEX.md` isn't taught until Sprint 4.4. Skip it during Cycle 2/3 and return to it once Sprint 4.4 is complete.

### Clusters & Cluster Members *(from 2.5)*
- **Beginner:** Create the 2-member cluster; deploy Login onto it.
- **Intermediate:** Take one cluster member offline gracefully (rolling); confirm zero dropped requests.
- **Advanced:** *Recover a failed node* — simulate a hard crash of Cluster Member-1's host; bring the cluster back to full health without touching Member-2.
- **Expert:** Both cluster members degrade at once (simulated resource exhaustion) under active synthetic load. Decide which to restart first, in what order, with what verification — while keeping the app minimally available throughout.

### IHS, Virtual Hosts & Plugin *(from 2.6 / 2.7 / 2.8)*
- **Beginner:** Serve a static test page through IHS.
- **Intermediate:** Regenerate and repropagate `plugin-cfg.xml` after adding a module; verify routing changed.
- **Advanced:** Plugin is routing traffic to only one cluster member despite both being healthy — diagnose stale config vs. weighting vs. affinity, and fix.
- **Expert:** IHS's SSL certificate has expired mid-load-test. Rotate the cert live with minimal downtime, verify HTTPS end-to-end, and write it up like a real incident.

### Transactions *(from 2.11)*
- **Beginner:** Book an appointment normally; confirm the record commits.
- **Intermediate:** Force an exception mid-booking; verify a clean rollback with no partial row.
- **Advanced:** Simulate two near-simultaneous bookings for the same slot; verify no double-booking under concurrency.
- **Expert:** *Investigate a slow transaction* — a booking request takes 8+ seconds. Use thread dumps and DB query logs to determine whether it's lock contention, a missing index, or pool starvation, then fix it.

### MQ Foundations & MDB / Messaging *(from 2.16 / 2.17)*
- **Beginner:** Put/get a test message manually via MQ Explorer or `runmqsc`.
- **Intermediate:** Submit a lab order through the app; confirm it lands on the queue and the MDB consumes it into the audit table.
- **Advanced:** *Recover an MQ queue* — the queue manager is down, or a queue has filled to max depth. Bring it back online and drain the backlog without losing or duplicating messages.
- **Expert:** Messages are silently landing on the Dead Letter Queue. Diagnose why (malformed message, MDB down, channel issue), fix the root cause, then safely redrive the DLQ contents back to the original queue.

### JVM Configuration for Multiple Cluster Members *(from 2.18, deepens at 3.10)*
- **Beginner:** Change Xms/Xmx on one cluster member via Console; restart and confirm.
- **Intermediate:** Enable verbose GC; capture a GC log during a load test.
- **Advanced:** *Tune the JVM* — given a GC log showing frequent full GCs, adjust heap sizing/GC policy to cut pause times, and prove the improvement with a before/after load test.
- **Expert:** *Recover from an OOM* — a cluster member has crashed with `OutOfMemoryError`. Analyze the heap dump, identify the leak or cause, apply a fix, and bring the member back into rotation.

### WebSphere Security & SSL, Cell-Wide *(from 2.19, deepens at 3.1)*
- **Beginner:** Enable administrative security on the DMGR; log in with credentials.
- **Intermediate:** Configure SSL between DMGR and node agents; verify with a cert trust check.
- **Advanced:** An internal SSL cert expires mid-operation, breaking DMGR-to-node communication. Diagnose and rotate it without a full cell restart.
- **Expert:** Simulate an admin lockout (can't log into the Console). Recover access using an approved emergency procedure without wiping cell security configuration.

### wsadmin & Jython Automation *(from 2.21)*
- **Beginner:** Run a single wsadmin command interactively (e.g., list deployed applications).
- **Intermediate:** Write one Jython script that automates a manual Console task end-to-end.
- **Advanced:** Build a small reusable Jython script library covering deployment + datasource config + cluster restart, callable with parameters.
- **Expert:** *Complete a production deployment within a target time* — using only your automation library, no manual Console clicks — deploy a new module version, verify health, and roll back cleanly if a smoke test fails, all within a set time budget (e.g., 15 minutes).

---

## Phase 3 — Harden & Observe

### Monitoring & Observability *(from 3.2–3.4)*
- **Beginner:** Pull current heap/thread-pool stats from PMI via Console.
- **Intermediate:** Correlate one request across app log + IHS log + DB log using a correlation ID.
- **Advanced:** *Build a monitoring dashboard* — assemble key JVM/JDBC/MQ metrics plus recent errors into one view a production support engineer could glance at.
- **Expert:** Given only dashboard data (no direct server access), identify which of 3 simulated incidents is occurring (memory pressure vs. DB slowness vs. MQ backlog) and propose the fix.

### Troubleshooting — All Four Batches *(App/Deploy, JVM/Memory, Data/Messaging, Network/Security/Plugin — from 3.5–3.8)*
- **Beginner:** Reproduce and resolve one seeded incident per category with the answer key open.
- **Intermediate:** Resolve 5 seeded incidents cold, any category, no answer key.
- **Advanced:** Resolve 10 seeded incidents cold, mixed categories, in a single timed session.
- **Expert:** Resolve an incident with two overlapping root causes stacked together (e.g., a plugin failure caused by a hung thread caused by a JDBC leak) — untangle the chain and fix each layer in the right order.

### Load / Stress / Spike / Soak Testing *(from 3.9)*
- **Beginner:** Run a basic JMeter test against Login with 10 concurrent users.
- **Intermediate:** Run a spike test simulating a shift-change login rush; identify the first bottleneck.
- **Advanced:** Run a multi-hour soak test and catch a slow resource leak before it causes an outage.
- **Expert:** Given a fixed hardware budget, tune the full stack (JVM + pools + IHS + MQ) to survive a defined peak-load target, proving it with before/after test results.

### IHS / MQ / PostgreSQL Tuning *(from 3.10–3.11)*
- **Beginner:** Adjust one IHS worker-thread setting; observe the effect.
- **Intermediate:** Tune PostgreSQL connection limits / `shared_buffers` for the app's load profile.
- **Advanced:** Tune MQ channel/queue buffer settings under sustained message throughput.
- **Expert:** Given a mixed bottleneck (IHS thread starvation + a slow PostgreSQL query + an MQ backlog, all under one load test), tune all three layers together and prove the combined fix.

---

## Phase 4 — Resilience, Ops & Compliance

### HA Simulation *(from 4.1)*
- **Beginner:** Perform a planned rolling restart of both cluster members with zero downtime.
- **Intermediate:** Run a scripted health-check sweep across all 5 VMs.
- **Advanced:** Inject a random failure (node/IHS/MQ/DB, picked blind) and recover using only monitoring signals — no advance warning of what broke.
- **Expert:** Chain two unannounced failures in the same window (e.g., a cluster member dies *and* the DB pool saturates) — recover both without a full outage.

### DR Planning & Drills *(from 4.2 / 4.3)*
- **Beginner:** Document RTO/RPO targets for each component.
- **Intermediate:** Run a single-component DR drill (e.g., restore PostgreSQL from backup); time it.
- **Advanced:** *Run a DR drill* covering DMGR + node + full app recovery from scratch, measuring actual recovery time against the documented RTO.
- **Expert:** Simulate a full-site failure (treat all 5 VMs as lost). Rebuild the environment from documented procedures and backups only, stopwatch running, and note every gap the runbook didn't cover.

### Backup & Recovery *(from 4.4)*
- **Beginner:** Run `backupConfig` and `pg_dump` manually; confirm the output files are valid and non-empty.
- **Intermediate:** Restore a WAS profile from a `backupConfig` archive into a fresh state.
- **Advanced:** Restore PostgreSQL from a `pg_dump`/`pg_basebackup` into a fresh instance; verify data integrity via checksum or row count.
- **Expert:** Recover from a corrupted/partial backup (simulate a truncated dump file). Determine what's actually recoverable, accept what data loss is unavoidable, and document it like a real incident report.

### ITIL — Incident / Problem / Change / Release Management *(from 4.5 / 4.6)*
- **Beginner:** Write a well-formed incident ticket for a seeded outage, naming at least one department beyond Middleware (Master Context Section 1a) as requester or approver.
- **Intermediate:** Run a full incident lifecycle (detect → ticket → resolve → close) for a seeded scenario, timed, writing at least one Incident Update mid-investigation (Section 10e).
- **Advanced:** Run a full Change Management cycle for a real config change — CAB request (Security/Business sign-off per Section 1a), Change Implementation Plan + Rollback Plan (Section 10e), execution, verification, Deployment Summary — on a production-simulated deployment.
- **Expert:** Handle a "failed change": a change was approved and executed but broke something in production. Raise it as an Emergency Change (`ECHG`) if it can't wait for the next CAB cycle, execute the rollback plan live, and write the full Root Cause Analysis (Section 10e) as the post-incident problem record.

### Capacity Planning *(from 4.8)*
- **Beginner:** Record current baseline resource usage (CPU/mem/connections) at idle.
- **Intermediate:** Extrapolate a 6-month user-growth capacity forecast from the Sprint 3.9 load-test data.
- **Advanced:** Given a target of 3x current concurrent users, produce a full resource plan (heap, threads, pool sizes, MQ, DB) and justify each number with data.
- **Expert:** Defend the capacity plan in a mock stakeholder review — answer hard follow-ups about assumptions, worst case, and cost tradeoffs.

---

## Phase 5 — Production Support (cross-cutting, all prior topics in play)

- **Beginner:** Shadow a seeded live incident end-to-end with guidance available.
- **Intermediate:** Resolve one unannounced live incident solo, timed, category unknown in advance.
- **Advanced:** Resolve 3 unannounced incidents back-to-back in one session, escalating severity, each one kicked off by a synthetic on-call page.
- **Expert:** *Complete a production deployment within a target time* while a live incident is unfolding elsewhere in the stack — prioritize, sequence the work, and get both done without making the incident worse.

---

## Notes on running these well

- **Injection, not disclosure.** The best version of any Advanced/Expert challenge is one where you (or a script) breaks something and walks away — not one where the problem is described up front. If you're both breaker and fixer, break it a day or two before you attempt the fix so it's not fresh in memory.
- **Timed challenges need a real target, not an arbitrary one.** Where a time budget is mentioned (e.g., "within 15 minutes"), set it once you've done the untimed version successfully at least once — first attempts should never be timed.
- **Expert tier is where interview stories come from.** When logging these in the Progress Log, capture root cause and resolution in enough detail to retell as a STAR-format answer later — Sprint 6.4's capstone interview pull straight from this material.
