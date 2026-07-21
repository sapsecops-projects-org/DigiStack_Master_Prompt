# LAB CHALLENGE BANK — DigiStack Bank

A bank of hands-on challenges, independent of the Sprint Plan's linear teaching order — used for **recurring practice**, not first-time learning. You learn a concept in its sprint; you drill it here afterward until it's reflexive.

> **Note (added 2026-07-11):** "Day 6" / "Day 7" below refer to *relative position within a weekly cycle* (slot 6 = Weekly Revision, slot 7 = Weekly Lab), not an absolute program day — sprints now span multiple days each, so the absolute calendar Day for any given week's Revision/Lab/Production Simulation slot is whatever `04_SPRINT_PLAN.md` shows for that point in the schedule. The Weekly Lab slot is now delivered as a **Weekly Ticket Queue** (Master Context rule #17): the challenge you pick from this bank becomes one ticket (INC/CHG/SR/PRB) in a 3–5 ticket queue for that session, rather than a single named exercise.

---

## How This Fits the Weekly Rhythm

- **Content slots 1–5:** Sprint Plan content, one sprint at a time, as normal (a sprint may span several of these slots if it's a multi-day sprint — see Master Context rule #20).
- **Slot 6 — Weekly Revision:** Review the Concept Index entries and Progress Log entries from the past week. No new material — verbal/written recall, re-read your own handoff docs and test results, identify anything shaky.
- **Slot 7 — Weekly Lab (delivered as a Ticket Queue, rule #17):** Pick ONE challenge from this bank related to what you studied that week — this becomes your "main" ticket. 2–4 smaller supporting tickets round out the queue.
  - Early in a topic (just learned it) → **Lab Type 1 (Basic Setup & Config)**, Beginner or Intermediate tier.
  - Once a topic is solid (you've lived with it a few weeks) → **Lab Type 2 (Advanced Scenario/Incident)**, Advanced or Expert tier.
- **Every ~15th calendar day — Production Simulation Day:** A bigger, timed, multi-domain capstone exercise (template at the bottom of this file). This is deliberately not tied to a fixed weekday — production incidents don't wait for Mondays either.
- **Once a week, unscheduled — On-Call Incident (rule #18):** A short, sharp after-hours page, separate from the above — see Master Context rule #18. Not drawn from this bank; generated fresh each time to stay unpredictable.

**Rule:** Don't jump to Expert tier before Advanced is comfortable. The tiers are a ladder, not a menu — skipping rungs just means you fail the drill and it stops being useful practice.

---

# LAB TYPE 1 — Basic Setup & Config

Repeatable setup/config drills. Tiers mostly progress by **method** (console → wsadmin → automation → blind/timed), matching the triad rule.

| Domain | Beginner | Intermediate | Advanced | Expert |
|---|---|---|---|---|
| DMGR/Node setup | Create a profile via console | Create the same profile via `manageprofiles` silently | Federate a node and verify sync via wsadmin only | Rebuild a wiped node's profile and re-federate it in under 20 min, no console |
| Clustering | Add a cluster member via console | Same, via wsadmin script | Create a full 2-member cluster + WLM policy via Ansible, zero manual console steps | Stand up a cluster from a bare RHEL VM to serving traffic in under 45 min |
| IHS + Plugin | Install IHS, generate plugin manually | Automate plugin regeneration on app deploy | Reconfigure IHS + plugin after a cluster topology change with zero downtime | Do it with one IHS instance deliberately killed mid-task — route around it live |
| MQ setup | Create a queue manager + local queue via console | Same via `runmqsc` scripts | Configure MDB activation spec + listener port entirely via wsadmin | Stand up queue manager + queues + MDB wiring from scratch, timed, no console |
| MySQL setup | Create schema + user via SQL client | Script schema creation + seed data via shell | Configure JDBC provider/datasource entirely via wsadmin, verify via test connection | Recreate DB + datasource + pool tuning from a documented outage in under 20 min |
| Security/LDAP | Enable global security via console | Configure LDAP federation via wsadmin | Add TAI/JAAS module + verify SSO handoff without console | Rotate an expiring cert + verify SSL end-to-end under time pressure |
| PMI/Monitoring | Enable PMI via console, view a counter | Wire a custom PMI counter into the app | Script PMI extraction into a file for Prometheus scraping | Add a brand-new custom metric end-to-end (app → PMI → Prometheus → Grafana) in one sitting |

---

# LAB TYPE 2 — Advanced Lab: Real-Time Scenarios & Incidents

These simulate things going wrong, not things being built. No step-by-step console walkthrough — you're given a symptom and a goal.

### 1. Deploy Without the GUI
- **Beginner:** Deploy the current EAR via wsadmin `AdminApp.install()`, verify via console after.
- **Intermediate:** Deploy via a wsadmin Jython script that also updates the datasource JNDI binding if changed.
- **Advanced:** Deploy a new version to a running 2-member cluster via script only, with zero application downtime.
- **Expert:** Full production deployment (build stamp change, rollback plan ready) completed via automation only, **target time: 15 minutes**, console never opened.

### 2. Recover a Failed Node
- **Beginner:** A node agent is stopped — restart it via console, confirm sync with DMGR.
- **Intermediate:** Diagnose why a node shows "unsynchronized" and resync via wsadmin.
- **Advanced:** A cluster member is unresponsive but not crashed (simulate via the toggleable slow endpoint) — diagnose whether it's a hang vs. a real failure before acting, using Core Groups/HAManager knowledge from 3.1.
- **Expert:** Node's config repository is corrupted — recover using the Backup DMGR/Job Manager path from 4.8, **target time: 30 minutes**, document the incident like a real Sev2.

### 3. Fix a Broken Datasource
- **Beginner:** Datasource JNDI name was typo'd — find and fix it via console.
- **Intermediate:** Same fix, but via wsadmin, and verify with a test connection script.
- **Advanced:** App reports intermittent connection failures under load — diagnose whether it's pool exhaustion, a leak, or stale connections (ties to 6.2/6.9) before touching config.
- **Expert:** Datasource works in isolation but fails only under concurrent load matching a specific pattern — reproduce with JMeter, diagnose, fix, and prove it with a second load test, **target time: 45 minutes**.

### 4. Recover an MQ Queue
- **Beginner:** A queue is stopped — start it via `runmqsc`, confirm message flow resumes.
- **Intermediate:** A message landed on the Dead Letter Queue — inspect it, determine cause, redeliver or discard appropriately.
- **Advanced:** Simulate a poison message causing the MDB to repeatedly fail and requeue — diagnose the backoff/retry behavior and stop the loop without losing legitimate messages.
- **Expert:** Queue manager itself is down mid-transaction (ties to 4.13 MQ HA and TM-07 test case) — fail over to the standby instance and verify no notification was silently lost, **target time: 30 minutes**.

### 5. Tune the JVM
- **Beginner:** View current heap/GC settings via console, document them.
- **Intermediate:** Adjust initial/max heap based on a given load profile, restart, verify via PMI.
- **Advanced:** Given JMeter load test results (6.1), choose gencon vs. optthruput and justify the choice with GC log evidence (6.2).
- **Expert:** Given only a verbose GC log from a "mystery" run (you didn't run the test yourself), diagnose the GC behavior using GCMV/IBM Support Assistant and propose a fix — **no access to live system, log-only diagnosis**.

### 6. Investigate a Slow Transaction
- **Beginner:** Use the toggleable slow endpoint, observe the delay in a thread dump.
- **Intermediate:** Take two thread dumps 10 seconds apart, identify the thread that didn't move.
- **Advanced:** A real (simulated) slow transaction with an unclear cause — could be DB lock, thread pool exhaustion, or a downstream MQ wait — diagnose using thread dumps + logs + PMI, not by being told the cause.
- **Expert:** The slowdown is intermittent and cluster-wide, not on one member — correlate across multiple members' logs/dumps to find a shared root cause (e.g., DB-side lock contention), **target time: 40 minutes**.

### 7. Recover From an OOM
- **Beginner:** Trigger a controlled OOM (undersized heap + load), observe the crash in logs.
- **Intermediate:** Capture a heap dump at the moment of OOM (or via `-Xdump` trigger), restart the server cleanly.
- **Advanced:** Analyze the heap dump with IBM Support Assistant to identify the largest object retainers.
- **Expert:** Identify the actual leak source (a specific code path holding references), propose and verify a fix, then re-run the load test to confirm the leak is gone — **full incident writeup required, Sev1 style**.

### 8. Run a DR Drill
*(This is the technical basis for the Quarterly DR Drills in Master Context rule #29 — Days 90/180/270/360/450. Use whichever tier matches how far the curriculum has gotten: Beginner/Intermediate before 6.5 is taught, Advanced once 6.5 lands, Expert once Part 4 is complete.)*
- **Beginner:** Execute the documented backup steps from 5.1, verify backup integrity.
- **Intermediate:** Execute a restore from that backup into a clean environment.
- **Advanced:** Run the full DR runbook from 6.5 end-to-end, including the failover step, and time each phase.
- **Expert:** Run the Part 4 multi-site failover (4.D5) with one undocumented gap deliberately introduced (e.g., a config file the runbook forgot to mention) — you must adapt live and then update the runbook afterward, **target RTO: whatever you defined in 4.D1**.

### 9. Build a Monitoring Dashboard
- **Beginner:** Reproduce an existing Grafana panel from a screenshot/spec.
- **Intermediate:** Add a new panel for an existing custom PMI counter.
- **Advanced:** Design and build a dashboard for a metric that doesn't exist yet — add the custom PMI counter, wire Prometheus scraping, then build the panel, start to finish.
- **Expert:** Build a dashboard **and** an Alertmanager rule that would have caught a specific past incident (pick one from your own Progress Log) before it became customer-visible — justify the threshold you chose.

### 10. Complete a Production Deployment Within a Target Time
- **Beginner:** Time yourself doing a console-based deploy of a known-good build. Just establish your baseline time.
- **Intermediate:** Do the same deploy via wsadmin scripting — beat your console time.
- **Advanced:** Full rolling deployment (5.7 pattern) across a 2-member cluster with zero downtime, **target: 20 minutes**.
- **Expert:** Same, but the build has a last-minute rollback trigger halfway through (simulate a bad build) — detect it via the version-stamp footer and roll back cleanly, **target: 30 minutes total including the rollback**.

### 11. (Bonus) Certificate Expiry Incident
*(Certificate renewal is a natural fit to fold into a Monthly Patching cycle, Master Context rule #29, if a cert happens to be nearing expiry that month — otherwise it stands alone as a regular Weekly Lab pick.)*
- **Beginner:** Identify a cert nearing expiry using the tools/process from 4.1.
- **Intermediate:** Renew it via console, verify SSL still works end-to-end.
- **Advanced:** Renew it via wsadmin/automation with zero downtime to IHS.
- **Expert:** Cert has *already expired* (simulate it) — customers are getting SSL errors right now — recover under pressure, **target time: 15 minutes**, then write the postmortem on why the expiry wasn't caught earlier.

### 12. (Bonus) Multi-Domain War Room
- **Beginner:** Walk through one of the Part 5 incident scenarios (5.I2/5.I3/5.I4) using the provided script.
- **Intermediate:** Same scenario, but you weren't told which one in advance — diagnose from symptoms alone.
- **Advanced:** Two of the Part 5 scenarios happen back-to-back (e.g., cluster member down, then MQ backlog) — triage which to address first.
- **Expert:** All three Part 5 scenarios compound into one incident (this is what 5.I6's capstone war-room is for) — full Sev1 handling, RCA, and postmortem, **target time: 60 minutes for triage + resolution**, postmortem due same day.

---

# PRODUCTION SIMULATION DAY (Every ~15th Calendar Day) — Template

A single extended session (2–4 hours) combining multiple domains under realistic time pressure. Rotate through this template; don't repeat the same simulation twice in a row.

**Structure:**
1. **Setup phase (untimed):** A believable "start of shift" state — pick 1–2 pre-existing minor issues from Type 1 labs to leave unresolved going in (like a real handoff would).
2. **Incident injection (timed):** Pick ONE Expert-tier Type 2 challenge as the main incident. Don't tell yourself in advance which one — have it randomly selected (dice roll across the 12 domains, or ask Claude to pick).
3. **Resolution (timed, target set by the challenge):** Resolve it using the full triad where applicable. If resolution requires a real production change, run it through the CAB gate (rule #27) even under time pressure — emergency changes still get the expedited/retroactive ECHG treatment, not a skip.
4. **Documentation (untimed but required):** Fill a Developer Handoff Package if code changed, log the incident in the Progress Log like a real Sev-rated event, and note anything that took longer than expected.
5. **Retro (5–10 min):** What would a real on-call engineer have needed that you didn't have ready? Add it as a deviation/decision if it changes anything in the other files.

Pull in at least one other department (rule #21) as the incident unfolds — Ben from Service Desk raising the initial ticket, Elena from Network confirming it isn't a firewall issue, Grace from Business asking for a customer-impact estimate — this is what makes it feel like one job instead of a solo lab.

This day is where Parts 1–5 stop being separate subjects and start being one job.
