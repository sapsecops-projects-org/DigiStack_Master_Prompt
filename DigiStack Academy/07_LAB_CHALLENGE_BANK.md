# 06 — Lab Challenge Bank

Tiered hands-on challenges: **Beginner → Intermediate → Advanced → Expert**. Used on Weekly LAB days (`02_CURRICULUM_PLAN.md`) and pulled into Capstones/Final Assessment. Advanced/Expert entries are written as real scenarios with a constraint and a success condition — no walkthrough given, same as a real job.

Format per entry: **Scenario** (what you're handed) · **Constraint** (time limit / no-GUI / etc.) · **Success Criteria** (how you know it's actually fixed).

---

## Topic: Foundations — Linux/Networking/SSL (Part 1, Wave 1, pre-WebSphere)
*Covers the earliest Advanced Lab days (Cycle 1–2), before any WebSphere install exists yet.*

**Beginner** — Navigate the filesystem, check running processes, read a systemd unit status.
**Intermediate** — Configure a firewall rule to open a specific port; generate a self-signed cert and load it into a keystore.

**Advanced — Diagnose a Broken Base Image**
- *Scenario:* You're handed a Linux VM that "won't let the app connect" — no other detail.
- *Constraint:* Must check firewall rules, DNS resolution, and port binding in sequence, not guess-and-check randomly. 20-minute limit.
- *Success Criteria:* Correct layer identified (firewall / DNS / binding) and connectivity restored, with the diagnostic order explained.

**Advanced — Cert Chain Break**
- *Scenario:* A test connection fails with an SSL handshake error; you're given only the client-side error message.
- *Constraint:* Must inspect the keystore/truststore chain to find the actual break (expired cert / wrong CA / hostname mismatch) — no guessing which one without checking.
- *Success Criteria:* Correct cause identified and connection succeeds; you can name the specific field in the cert that was wrong.

---

## Topic: Core Cell/Cluster Operations (Part 1, Wave 1)

**Beginner** — Install WAS ND via GUI following the official checklist; verify the Dmgr starts cleanly.
**Intermediate** — Federate two nodes to a cell manually; confirm both Node Agents show green in the console.

**Advanced — Deploy Without the GUI**
- *Scenario:* You're given an EAR file and a JNDI/datasource spec. The Admin Console is "down for maintenance" (i.e., off-limits).
- *Constraint:* wsadmin/Jython only. 30-minute time limit.
- *Success Criteria:* App is deployed, started, and reachable via the IHS front-end within the time limit.

**Advanced — Recover a Failed Node**
- *Scenario:* One node in your 2-node cluster is unreachable — Node Agent won't restart, sync fails, cell config looks stale on that node.
- *Constraint:* The other node must stay serving traffic the entire time (no full cluster outage allowed).
- *Success Criteria:* Failed node rejoins the cell with correct config, cluster returns to full capacity, zero dropped requests on the surviving node during recovery.

**Expert — Cold-Start the Whole Cell**
- *Scenario:* The 5-VM lab has been wiped. You have only your own scripts and `06_LAB_RECIPES.md`.
- *Constraint:* No GUI at any point. Target: full cell (Dmgr + 2-node cluster + IHS + plugin) live within 90 minutes.
- *Success Criteria:* Config validation checklist passes; a smoke-test transaction completes end-to-end through IHS → cluster → datasource.

---

## Topic: Data & Messaging (Part 1, Wave 2)

**Beginner** — Create a JDBC datasource via the console and run the "test connection" button successfully.
**Intermediate** — Given a target load profile (concurrent users, avg query time), size a connection pool and justify the numbers.

**Advanced — Fix a Broken Datasource**
- *Scenario:* An app is throwing connection errors on every request. You're not told why.
- *Constraint:* No documentation lookup — diagnose from server logs and console state only. 20-minute limit.
- *Success Criteria:* Root cause identified (wrong JNDI name / exhausted pool / stale credentials / driver mismatch) and app is serving requests again.

**Advanced — Recover an MQ Queue**
- *Scenario:* Messages are piling up in a queue; consumers report nothing is being processed. A channel may be down.
- *Constraint:* Production-like — you cannot simply restart the queue manager without checking for in-flight transactions first.
- *Success Criteria:* Message flow restored, verified with a test message round-trip, and you can explain what would have been lost if you'd just restarted blindly.

**Expert — Cascading Data + Messaging Failure**
- *Scenario:* The datasource AND the MQ channel degrade within the same incident window (simulating a shared network/storage issue).
- *Constraint:* 45-minute SLA. You must triage which to fix first based on stated business impact (e.g., payment queue vs. reporting datasource).
- *Success Criteria:* Both restored within the SLA; triage order documented and defensible.

---

## Topic: Performance Tuning (Part 2)

**Beginner** — Change heap min/max via the console; restart and confirm the new values took effect in `SystemOut.log`.
**Intermediate** — Given a verbose GC log, correctly identify whether it shows a young-gen or full-GC-dominated pattern.

**Advanced — Tune the JVM Under Load**
- *Scenario:* A verbose GC log from a peak-load window shows frequent full GCs and multi-second pause times.
- *Constraint:* You get the log and the app's business SLA, nothing else. 30-minute diagnosis + fix window.
- *Success Criteria:* A specific, justified change (heap sizing, GC policy, or both) applied; a follow-up load test shows pause times back within SLA.

**Expert — SLA-Blind Tuning**
- *Scenario:* You're handed a live loaded system and only a business SLA number (e.g., "95th percentile under 800ms at 500 TPS"). Nobody tells you what's currently wrong.
- *Constraint:* No hints. Tune heap, thread pools, and connection pools end-to-end.
- *Success Criteria:* SLA proven met with a load test report you generate yourself.

---

## Topic: Real-Time Troubleshooting (Part 3)

**Beginner** — Pull a thread dump and count total threads by state (running/waiting/blocked).
**Intermediate** — Given a thread dump with one obviously stuck thread, identify it and explain why it's stuck.

**Advanced — Investigate a Slow Transaction**
- *Scenario:* The only input is "checkout is slow" — no stack trace, no error.
- *Constraint:* Must trace through app server → datasource → downstream MQ/DB to isolate the actual bottleneck. 30-minute limit.
- *Success Criteria:* Correct layer identified with evidence (not a guess), and a fix or mitigation proposed.

**Advanced — Recover from an OOM**
- *Scenario:* The JVM has crashed with `OutOfMemoryError`. A javacore/heap dump exists from the crash.
- *Constraint:* Must determine leak vs. undersizing *before* applying any fix — a wrong diagnosis that "fixes" the symptom but not the cause fails the challenge.
- *Success Criteria:* Correct root cause identified from the dump, fix applied, and a prevention step documented in `08_TROUBLESHOOTING_PLAYBOOK.md`.

**Expert — Multi-Day Incident Chain**
- *Scenario:* A slow leak that doesn't crash until day 3 of the simulation — early warning signs appear on day 1 that are easy to miss.
- *Constraint:* Spans real calendar days, not one sitting. You must flag the early warning signs *before* being told about the eventual crash.
- *Success Criteria:* Leak caught and mitigated before the simulated crash, or — if missed — a full incident response executed once it does crash, with an honest RCA on why the early signal was missed.

---

## Topic: Disaster Recovery (Part 4)

**Beginner** — Walk through a documented backup procedure and verify the backup file is valid.
**Intermediate** — Restore a WAS profile from a backup into a clean environment.

**Advanced — Recover a Failed Node (DR variant)**
- *Scenario:* A node has gone completely unreachable (simulated VM failure, not a graceful shutdown).
- *Constraint:* Cluster must return to full capacity using only the surviving members and your own runbook — no live coaching. Timed.
- *Success Criteria:* Full capacity restored within your own stated RTO; runbook gaps documented afterward.

**Advanced — Run a DR Drill**
- *Scenario:* Execute a full failover from primary to DR site against a checklist, then fail back.
- *Constraint:* Must produce a drill report (what worked, what didn't, actual vs. target RTO/RPO).
- *Success Criteria:* Successful cutover and failback; report is honest about gaps, not just a pass/fail stamp.

**Expert — Unannounced DR Drill**
- *Scenario:* No warning — just a "site is down" message, presented as if it might be real.
- *Constraint:* Full cutover executed under the belief it could be genuine, then debriefed.
- *Success Criteria:* Correct cutover decision made under uncertainty, plus an honest reflection on decision-making under pressure vs. a scheduled drill.

---

## Topic: Observability (Part 6)

**Beginner** — Enable PMI on a server and view basic metrics in the console.
**Intermediate** — Pull thread pool and connection pool utilization metrics and interpret them against known thresholds.

**Advanced — Build a Monitoring Dashboard**
- *Scenario:* Using raw PMI/log data, build a dashboard that would have caught the Part 3 OOM incident *before* it caused an outage.
- *Constraint:* Must define and justify the specific alert threshold — "alert on high memory" isn't specific enough.
- *Success Criteria:* Dashboard demonstrably would have fired an alert with enough lead time to intervene, replayed against the earlier incident's data.

**Expert — Design a Full Observability Strategy**
- *Scenario:* Given a week of historical incident data, design dashboards + alerts + escalation paths.
- *Constraint:* Must defend the design against "why not just alert on everything" pushback.
- *Success Criteria:* Strategy avoids both alert fatigue and blind spots, with reasoning for each threshold chosen.

---

## Topic: Incident Management (Part 7)

**Advanced — Live War-Room**
- *Scenario:* A Sev1 with multiple systems reporting different symptoms simultaneously (classic confusing multi-symptom outage).
- *Constraint:* Must triage, send status updates on a fixed timer (e.g., every 15 simulated minutes), resolve, then write the RCA.
- *Success Criteria:* Correct root system identified despite noisy symptoms; RCA meets the quality bar in `05_ARCHITECT_TRACK.md`.

**Expert — Incident Commander Under a Bad Fix**
- *Scenario:* Your first fix attempt makes things worse (a realistic complication).
- *Constraint:* Must recognize the fix backfired, roll back, and re-escalate correctly — while still hitting the resolution SLA.
- *Success Criteria:* Incident resolved within SLA despite the setback; decision to roll back is made promptly, not after excessive sunk-cost persistence.

---

## Topic: DevSecOps (Part 8)

**Advanced — Timed Production Deployment**
- *Scenario:* Deploy a new app version to the cluster via the Part 8 CI/CD pipeline, zero downtime required, with a security scan gate that must pass.
- *Constraint:* Strict time limit (e.g., 20 minutes) for the full pipeline run.
- *Success Criteria:* Deployment completes within the time limit, zero dropped requests during rollout, scan gate genuinely enforced (not bypassed).

**Expert — Pipeline Failure at 90% Rollout**
- *Scenario:* A deployment gate fails when the rollout is already 90% complete.
- *Constraint:* Time pressure — must decide roll-forward vs. roll-back and execute.
- *Success Criteria:* Decision made with clear reasoning (not a coin flip), executed cleanly, and post-incident note captures why the gate should or shouldn't have caught this earlier.

---

## How This Gets Used
- **Weekly LAB (Advanced Scenario) days** in `02_CURRICULUM_PLAN.md` pull from whichever topic section matches that fortnight's content.
- **Capstones 9 & 10** and the **Final Real-World Assessment** draw on Expert-tier entries here plus fresh scenarios.
- **Quarterly DR Drills** (per `01_MASTER_CONTEXT.md`'s Career Simulation layer) pull from the Disaster Recovery topic above, even on cycles before Part 4 has been formally taught.
- Every completed Advanced/Expert challenge should get logged as an entry in `08_TROUBLESHOOTING_PLAYBOOK.md` if it surfaced a real technique worth keeping.
