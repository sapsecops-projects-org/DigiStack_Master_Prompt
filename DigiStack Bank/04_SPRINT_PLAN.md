# SPRINT PLAN — DigiStack Bank

Rules: one sprint at a time, explicit approval before advancing. Every WebSphere/IHS/MQ task = Console + wsadmin/Jython + Shell/Ansible triad. This plan is a rhythm guide, not a deadline — never compress sprints to save time.

**Recalculated 2026-07-11 for the 9-to-5 workday simulation (Master Context standing rules #15–#19):** sprints are no longer 1 calendar day each. Each sprint now spans the number of workdays its content actually needs once delivered through the full daily format (stand-up → ticket/assignment → 5-layer learning session → hands-on task → production incident → documentation → interview questions → handover → reflection). Day-length per sprint is classified Light (2 days), Standard (3–4 days), or Heavy (5–7 days) — see Master Context standing rule #20 (Sprint Day-Length Classification) for the full methodology and per-sprint tier table. The weekly 5:1:1 rhythm (5 content days → 1 Weekly Revision day → 1 Weekly Lab day) and the Production Simulation Day every ~15 calendar days are both preserved exactly as before — they now simply sit between variable-length sprints instead of between fixed 1-day sprints, and a rhythm/simulation day is never allowed to split a sprint's own days. Total program length: **464 calendar days** (up from the prior 136-day figure), across the same 91 sprints — sprint numbering, content, and the Triad Rule are all unchanged.

**Added 2026-07-11 (employment lifecycle pass):** a one-time **Day 0 — Onboarding & Induction** now precedes Sprint 1.1 (not counted in the 464-day total — see Master Context rule #24). Days 1–90 are a **90-day probation period** with increasing autonomy (rule #25), ending exactly at Sprint 2.9's existing "full app running end-to-end" checkpoint. Recurring **monthly patching + performance review** (~every 30 days) and **quarterly DR drills** (~every 90 days) are overlaid on the existing schedule per rule #29 — see the marker table there; no new days were added for these, they land on whichever existing sprint/rhythm day is nearest each mark.

---

## Day 0 — Onboarding & Induction (not counted in the 464-day total)

One-time session before Sprint 1.1 begins, per Master Context rule #24: HR welcome, IT account/VM access provisioning, security awareness training, environment access grant (VM1–VM5 credentials, admin console URL, wsadmin client setup), and introductions to the named department contacts you'll be working with (rule #21) — Derek Osei (your Team Lead), plus Priya, Tom, Aisha, Jake, Elena, Malik, Sofia, Ben, and Grace. Light preview only — no ticket, no production incident. Closes with the Team Lead confirming you're ready for Day 1.

---

# PART 1 — WebSphere Admin Course + Parallel App Development

Part 1 is organized into two **Waves**:
- **Wave 1 — Build It** (Phases 1–3): get the core banking app running, end to end, on a real cluster. Days 1–140.
- **Wave 2 — Run It Like Production** (Phases 4–6): harden, observe, operate, and stress-test what Wave 1 built. Days 143–314.

A full Day-Wise Calendar for the entire program (all 6 Parts) follows the Part 1 sprint listing below.

---

## WAVE 1 — Build It (Phases 1–3, Days 1–140)

### Phase 1: Foundations (Sprints 1.1–1.8 | Days 1–35)
- **1.1** (Days 1–3) — WAS architecture overview; DMGR install & profile creation (VM1); also cover silent install / response files (IBM Installation Manager) as the scripted alternative to GUI install
- **1.2** (Days 4–6) — Node federation (concept only until VM2 arrives); wsadmin/Jython basics — explicitly cover the four core objects (AdminConfig, AdminControl, AdminApp, AdminTask) so scripting is understood as a model, not copy-paste; admin console deep tour
- *(Day 7 — Weekly Revision · Day 8 — Weekly Lab)*
- **1.3** (Days 9–12) — NFR & capacity baseline (expected load, sizing assumptions for the banking app); JVM basics
- *(Day 13 — Weekly Revision · Day 14 — Weekly Lab)*
- **1.4** (Days 15–17) — Security domains, global security setup, admin user roles
- **1.5** (Days 18–23) — MySQL install & full database design pass for banking domain (VM4) — ER modeling, normalization, keys/constraints, schema-to-requirements traceability — including a notifications inbox table (for later dual-notification feature) and ~20–30 synthetic seed customer/account records; **Application Architecture & MVC-style Design** session (Controller/Model/View mapped to Servlet/DAO/JSP, consistent with the no-frameworks convention in Master Context §2); **Frontend UI/UX Design** session (wireframing per module, Bootstrap 5 conventions for one consistent header/nav/color scheme across all 5 modules); app requirement walkthrough: Create Account + Login modules (design only, no code yet). *(Added 2026-07-15: Architecture/MVC and Frontend UI Design sessions folded into this sprint's existing Days 18–23 window at user request — no Day-range or tier change; see Progress Log Standing Deviation Log.)*
- *(Day 24 — Weekly Revision · Day 25 — Weekly Lab)*
- *(Day 26 — PRODUCTION SIMULATION DAY)*
- **1.6** (Days 27–29) — Lab Bring-Up: get VM1 (DMGR) + VM4 (MySQL) fully operational end-to-end — must complete before 1.7
- *(Day 30 — Weekly Revision · Day 31 — Weekly Lab)* — 📌 **Month 1: Patching + Performance Review** (rule #29), Team-Lead-led (shadowing) since Sprint 5.3 hasn't been reached yet
- **1.7** (Days 32–33) — Firewall/tier-access rule table (browser→IHS→WAS→DB ports); document in topology
- **1.8** (Days 34–35) — Checkpoint & review of Phase 1

### Phase 2: Build & Deploy (Sprints 2.1–2.9 | Days 38–91)
*Every sprint below concludes with: manual test case execution from `07_TEST_CASE_SUITE.md` + a filled `06_DEV_HANDOFF_TEMPLATE.md` entry.*
- *(Day 36 — Weekly Revision · Day 37 — Weekly Lab)*
- **2.1** (Days 38–43) — JDBC provider & data source setup (externalized via WebSphere variables, not hardcoded); build Create Account module (Servlet/JSP/DAO); Git repo initialized here; execute CA-01–CA-07 test cases
- *(Day 44 — Weekly Revision · Day 45 — Weekly Lab)*
- *(Day 46 — PRODUCTION SIMULATION DAY)*
- **2.2** (Days 47–51) — Virtual hosts; build Customer Login module; execute LG-01–LG-06 test cases
- *(Day 52 — Weekly Revision · Day 53 — Weekly Lab)*
- **2.3** (Days 54–56) — Connection pooling tuning; build Check Balance module; execute CB-01–CB-04 test cases
- *(Day 57 — Weekly Revision · Day 58 — Weekly Lab)*
- **2.4** (Days 59–63) — Session management (in-memory); build Manage Beneficiary module; add visible Session ID + "Served by: Cluster Member X" footer (pays off once clustering starts in Phase 3); execute MB-01–MB-06 test cases — 📌 **Day 60: Month 2 Patching + Performance Review** (rule #29), still Team-Lead-led
- *(Day 64 — Weekly Revision · Day 65 — Weekly Lab)*
- *(Day 66 — PRODUCTION SIMULATION DAY)*
- **2.5** (Days 67–72) — Class loader policy; begin Transfer Money module (core logic, no messaging yet); introduce XA transactions / two-phase commit concepts (relevant once this module writes to DB + later publishes to MQ) and last participant support; execute TM-01–TM-04 test cases (messaging-dependent cases TM-05+ wait for 3.7)
- *(Day 73 — Weekly Revision · Day 74 — Weekly Lab)*
- **2.6** (Days 75–77) — App packaging (WAR/EAR via Maven, with build version/timestamp stamped into the footer); first full deploy via Admin Console
- **2.7** (Days 78–80) — Same deploy, this time via wsadmin/Jython scripting
- *(Day 81 — Weekly Revision · Day 82 — Weekly Lab)*
- *(Day 83 — PRODUCTION SIMULATION DAY)*
- **2.8** (Days 84–86) — Same deploy, this time via shell/Ansible automation — triad now complete for deployment
- *(Day 87 — Weekly Revision · Day 88 — Weekly Lab)*
- **2.9** (Days 89–91) — Checkpoint: full app (minus dual notification) running end-to-end on single server — 📌 **Day 90: End of 90-Day Probation** (rule #25) + **Month 3 Performance Review** (doubles as the probation review) + **Quarterly DR Drill #1** (rule #29, observational — Part 4's dedicated DR sprints haven't been reached yet). A fitting coincidence: passing probation lands on the same day the app first runs end-to-end.

### Phase 3: Scale to Cluster (Sprints 3.1–3.8 | Days 92–140)
- **3.1** (Days 92–97) — Clustering concepts, including Core Groups, the HAManager, and the DCS (Discovery/Failure Detection) transport — the actual mechanism behind "how does WAS know a node failed," which underpins the failover drill later; stand up VM2 (Node1) + VM3 (IHS); create cluster + Cluster Member1
- *(Day 98 — Weekly Revision · Day 99 — Weekly Lab)*
- *(Day 100 — PRODUCTION SIMULATION DAY)*
- **3.2** (Days 101–104) — Workload management (WLM) configuration
- *(Day 105 — Weekly Revision · Day 106 — Weekly Lab)*
- **3.3** (Days 107–110) — Session replication (memory-to-memory or DB-based) across cluster members
- *(Day 111 — Weekly Revision · Day 112 — Weekly Lab)*
- **3.4** (Days 113–115) — IHS install, httpd.conf, WebSphere plugin integration
- *(Day 116 — Weekly Revision · Day 117 — Weekly Lab)*
- *(Day 118 — PRODUCTION SIMULATION DAY)*
- **3.5** (Days 119–122) — Load balancing verification; vertical/horizontal scaling exercise — 📌 **Day 120: Month 4 Patching + Performance Review** (rule #29) — first review post-probation (full autonomy framing per rule #25), though patching itself is still Team-Lead-led until Sprint 5.3 is reached
- **3.6** (Days 123–125) — IBM MQ install (VM5); queue manager, local/remote queues, listener ports
- *(Day 126 — Weekly Revision · Day 127 — Weekly Lab)*
- **3.7** (Days 128–134) — Wire Transfer Money → MQ → MDB → dual notification (sender + receiver), written to a visible per-customer notification inbox (not just a log line), using a structured XML/JSON message payload (transaction ID, timestamp, amount); full triad on MDB config; cover XA transaction coordination across DB + MQ, and what happens/how to recover when XA recovery fails; execute TM-05, TM-06, TM-08 test cases; fill Developer Handoff Package
- *(Day 135 — Weekly Revision · Day 136 — Weekly Lab)*
- *(Day 137 — PRODUCTION SIMULATION DAY)*
- **3.8** (Days 138–140) — Build a `/health` servlet (checks DB connectivity, reports cluster member identity); wire IHS to poll it — reused later for Monitoring Policy (5.6) and Part 2 observability

**— End of Wave 1. The app is now running, clustered, and notifying both parties on a transfer. —**

---

## WAVE 2 — Run It Like Production (Phases 4–6, Days 143–314)

### Phase 4: Harden & Observe (Sprints 4.1–4.14 | Days 143–218)
- *(Day 141 — Weekly Revision · Day 142 — Weekly Lab)*
- **4.1** (Days 143–147) — SSL/TLS end-to-end (IHS termination or pass-through), keystores, LTPA token config; also cover certificate lifecycle management — expiry tracking, renewal process, and automating renewal (a top real-world incident source)
- *(Day 148 — Weekly Revision · Day 149 — Weekly Lab)*
- **4.2** (Days 150–153) — RBAC / admin roles hardening; SPOF audit part 1 (identify: single DMGR, single MySQL, single IHS, single MQ) — 📌 **Day 150: Month 5 Patching + Performance Review** (rule #29)
- *(Day 154 — Weekly Revision · Day 155 — Weekly Lab)*
- *(Day 156 — PRODUCTION SIMULATION DAY)*
- **4.3** (Days 157–159) — Logging deep dive (SystemOut/Err, HPEL log viewer), using the app's real INFO/WARNING/SEVERE logging per module for hands-on filtering; also cover First Failure Data Capture (FFDC) — where it lives, how to read it, why it fires before you even notice a problem; SPOF audit part 2 (document production-grade alternatives)
- **4.4** (Days 160–162) — PMI setup, including wiring 1–2 custom PMI counters into the app (e.g., "transfers processed", "failed logins") — this is the bridge into Part 2 observability
- *(Day 163 — Weekly Revision · Day 164 — Weekly Lab)*
- **4.5** (Days 165–167) — MQ security (channel auth records, SSL on channels)
- *(Day 168 — Weekly Revision · Day 169 — Weekly Lab)*
- **4.6** (Days 170–173) — LDAP / Active Directory federation — federated repositories setup (most real WAS shops use this instead of local file-based registries; frequent interview topic)
- **4.7** (Days 174–178) — TAI / custom JAAS login module — the enterprise SSO pattern (Trust Association Interceptor) most banking shops actually use on top of LDAP; login servlet gets a code path that trusts a pre-authenticated header, simulating the TAI handoff
- *(Day 179 — Weekly Revision · Day 180 — Weekly Lab)* — 📌 **Day 180: Month 6 Patching + Performance Review** + **Quarterly DR Drill #2** (rule #29) — patching still Team-Lead-led (Sprint 5.3 is a few weeks out yet); DR drill still observational until Part 4
- *(Day 181 — PRODUCTION SIMULATION DAY)*
- **4.8** (Days 182–184) — Backup DMGR, Job Manager, and Admin Agent (flexible management) — the actual fix for the DMGR SPOF flagged in 4.2's audit
- *(Day 185 — Weekly Revision · Day 186 — Weekly Lab)*
- **4.9** (Days 187–190) — Dynamic clusters & Intelligent Management (conceptual/light-hands-on) — shows depth beyond static clustering
- *(Day 191 — Weekly Revision · Day 192 — Weekly Lab)*
- **4.10** (Days 193–197) — Multi-application cluster coexistence: build and co-deploy a second, tiny "Ops Utility" status-page app on the same cluster — real class loader isolation and resource contention between two apps, and richer material for the Dynamic Clusters/App Placement Controller behavior in 4.9; execute XC-05; fill Developer Handoff Package
- *(Day 198 — Weekly Revision · Day 199 — Weekly Lab)*
- *(Day 200 — PRODUCTION SIMULATION DAY)*
- **4.11** (Days 201–203) — Configuration scope precedence (cell → node → server → cluster member) — set the same custom property at multiple scopes with different values and observe which wins; app footer shows an "Environment Scope" indicator reading that property so the result is directly visible
- **4.12** (Days 204–206) — Fix the IHS SPOF flagged in 4.2/4.3 for real: stand up a second IHS instance behind an external load balancer (HAProxy or nginx); prove failover by pulling one IHS down mid-session
- *(Day 207 — Weekly Revision · Day 208 — Weekly Lab)*
- **4.13** (Days 209–213) — Fix the MQ SPOF flagged in 4.2/4.3 for real: multi-instance queue manager (active/standby on shared storage) — closes the loop the SPOF audit opened, alongside the IHS and DMGR fixes already done — 📌 **Day 210: Month 7 Patching + Performance Review** (rule #29), still Team-Lead-led (Sprint 5.3 lands at Day 230)
- *(Day 214 — Weekly Revision · Day 215 — Weekly Lab)*
- *(Day 216 — PRODUCTION SIMULATION DAY)*
- **4.14** (Days 217–218) — Checkpoint & review of Phase 4

### Phase 5: Production Readiness (Sprints 5.1–5.9 | Days 219–261)
- **5.1** (Days 219–222) — Backup/restore: WAS config archive + MySQL mysqldump backup/restore drill
- *(Day 223 — Weekly Revision · Day 224 — Weekly Lab)*
- **5.2** (Days 225–227) — Change management basics (staging vs prod mindset, rollback planning); property-based configuration management — extract config to property files via wsadmin (e.g., the JDBC datasource), edit, and reapply in bulk, the way real automation teams manage repeatable environments
- *(Day 228 — Weekly Revision · Day 229 — Weekly Lab)*
- **5.3** (Days 230–232) — Fix packs / interim fixes / iFix apply process (console + command line)
- **5.4** (Days 233–235) — Manual HA/failover drill (kill a cluster member, observe WLM behavior) — now grounded in the Core Groups/HAManager theory from 3.1
- *(Day 236 — Weekly Revision · Day 237 — Weekly Lab)*
- *(Day 238 — PRODUCTION SIMULATION DAY)*
- **5.5** (Days 239–241) — Start/stop dependencies and safe shutdown order (DMGR vs nodes vs DB vs MQ) — avoiding split-brain scenarios during cluster restarts, a common real-world restart incident — 📌 **Day 240: Month 8 Patching + Performance Review** (rule #29) — first **user-led, CAB-gated** patching cycle now that Sprint 5.3 is behind you
- *(Day 242 — Weekly Revision · Day 243 — Weekly Lab)*
- **5.6** (Days 244–246) — Monitoring Policy (ping interval, restart threshold) — trigger the existing toggleable "slow endpoint" to simulate a real hang, then watch Node Agent detect it and auto-restart the cluster member
- **5.7** (Days 247–251) — Rolling deployment / simulated Blue-Green: deploy v2 to one cluster member while v1 keeps serving on the other, shift traffic via IHS/WLM, and watch the existing build-version-stamp footer flip from v1 to v2 per request as the rollout progresses
- *(Day 252 — Weekly Revision · Day 253 — Weekly Lab)*
- *(Day 254 — PRODUCTION SIMULATION DAY)*
- **5.8** (Days 255–257) — Developer handoff package: README, deployment guide, config reference, DB schema + seed scripts, one-page operational runbook
- *(Day 258 — Weekly Revision · Day 259 — Weekly Lab)*
- **5.9** (Days 260–261) — WebSphere licensing: PVU counting and ILMT sub-capacity licensing — an architect-level compliance responsibility that most admin training skips; understanding why sub-capacity licensing matters and how it's tracked

### Phase 6: Advanced Block — Load Test / Perf / Troubleshoot / DR / Migration (Sprints 6.1–6.10 | Days 262–314)
- **6.1** (Days 262–264) — JMeter load test design against banking flows (login, balance, transfer), including the toggleable "slow endpoint" for controlled stress scenarios
- *(Day 265 — Weekly Revision · Day 266 — Weekly Lab)*
- **6.2** (Days 267–271) — Thread pool & connection pool tuning based on load test results; connection leak detection settings (a common "app slowly dying" production symptom, ties to incident scenario 5.I4); IBM JVM GC policies (gencon vs optthruput) and how to choose between them — 📌 **Day 270: Month 9 Patching + Performance Review** + **Quarterly DR Drill #3** (rule #29), both user-led now; DR drill still observational (Part 4 hasn't arrived yet)
- *(Day 272 — Weekly Revision · Day 273 — Weekly Lab)*
- *(Day 274 — PRODUCTION SIMULATION DAY)*
- **6.3** (Days 275–279) — Thread dump / javacore analysis; hang & deadlock troubleshooting exercise using the toggleable "slow endpoint" and "error-prone endpoint" to generate real stack traces on demand; also cover the MustGather / collector tool workflow used when opening a real IBM PMR support case
- *(Day 280 — Weekly Revision · Day 281 — Weekly Lab)*
- **6.4** (Days 282–286) — Heap dump analysis basics; memory leak triage; hands-on with IBM Support Assistant and GC and Memory Visualizer (GCMV) for reading verbose GC logs
- *(Day 287 — Weekly Revision · Day 288 — Weekly Lab)*
- **6.5** (Days 289–291) — DR runbook v1 (backup/restore + failover drill, single-site) — feeds into Part 4's deeper DR
- **6.6** (Days 292–294) — Migration scenario: fix pack upgrade path (step-by-step, real steps)
- *(Day 295 — Weekly Revision · Day 296 — Weekly Lab)*
- *(Day 297 — PRODUCTION SIMULATION DAY)*
- **6.7** (Days 298–299) — Migration scenario (conceptual): traditional WAS → Liberty profile — capstone discussion + comparison
- **6.8** (Days 300–302) — Dynacache (WebSphere's built-in caching) — apply to Check Balance or beneficiary list as a real performance-tuning lever beyond JVM/pool tuning — 📌 **Day 300: Month 10 Patching + Performance Review** (rule #29)
- *(Day 303 — Weekly Revision · Day 304 — Weekly Lab)*
- **6.9** (Days 305–309) — Stale connection handling: Purge Policy (EntirePool vs FailingConnectionOnly) and connection validation queries — the app's "error-prone endpoint" gets a stale-connection variant to simulate MySQL silently dropping idle connections, one of the most common "random errors under low traffic" production mysteries; execute TM-09; fill Developer Handoff Package
- *(Day 310 — Weekly Revision · Day 311 — Weekly Lab)*
- **6.10** (Days 312–314) — Close the capacity-planning loop: reconcile the real load-test/tuning results from this block against the original NFR/capacity baseline assumptions set back in Sprint 1.3 — capstone review of the whole Advanced Block

**— End of Wave 2. End of Part 1. —**

---

# PART 2 — Banking Observability (Open Source Tools)
*(Sprints 2.P1–2.P8 | Days 318–350)*

- *(Day 315 — Weekly Revision · Day 316 — Weekly Lab)*
- *(Day 317 — PRODUCTION SIMULATION DAY)*
- **2.P1** (Days 318–320) — PMI → JMX bridge; what metrics matter for a banking app (transaction latency, thread pool usage, JDBC pool usage, MQ depth)
- **2.P2** (Days 321–323) — Prometheus + WebSphere exporter (JMX exporter) setup
- *(Day 324 — Weekly Revision · Day 325 — Weekly Lab)*
- **2.P3** (Days 326–328) — Grafana dashboards: banking KPIs (transfer success rate, login latency, queue depth)
- **2.P4** (Days 329–331) — Centralized logging part 1: Filebeat/Fluentd shipping WAS logs — 📌 **Day 330: Month 11 Patching + Performance Review** (rule #29)
- *(Day 332 — Weekly Revision · Day 333 — Weekly Lab)*
- *(Day 334 — PRODUCTION SIMULATION DAY)*
- **2.P5** (Days 335–337) — Centralized logging part 2: Elasticsearch + Kibana (or OpenSearch) dashboards
- *(Day 338 — Weekly Revision · Day 339 — Weekly Lab)*
- **2.P6** (Days 340–342) — Distributed tracing basics (Zipkin or Jaeger) across the Transfer Money → MQ → MDB flow
- **2.P7** (Days 343–345) — Alertmanager: alert rules for queue depth spikes, pool exhaustion, error rate
- *(Day 346 — Weekly Revision · Day 347 — Weekly Lab)*
- **2.P8** (Days 348–350) — Synthetic transaction monitoring (scripted login+transfer heartbeat) + capstone observability review

---

# PART 3 — DevSecOps for WebSphere-Centric Banking
*(Sprints 3.P1–3.P9 | Days 351–393)*

- **3.P1** (Days 351–353) — CI/CD concepts for WebSphere; Jenkins (or GitLab CI) install
- *(Day 354 — Weekly Revision · Day 355 — Weekly Lab)*
- *(Day 356 — PRODUCTION SIMULATION DAY)*
- **3.P2** (Days 357–359) — Pipeline: build WAR/EAR via Maven, artifact versioning
- *(Day 360 — Weekly Revision · Day 361 — Weekly Lab)* — 📌 **Day 360: Month 12 Patching + Performance Review (one-year mark)** + **Quarterly DR Drill #4** (rule #29) — DR drill can now be user-led at the single-site level using 6.5's runbook; the fuller multi-site version waits for Part 4
- **3.P3** (Days 362–364) — Ansible for WebSphere provisioning (profile creation, app deploy) — ties back to the automation leg of the triad
- **3.P4** (Days 365–367) — SAST with SonarQube on the app codebase
- *(Day 368 — Weekly Revision · Day 369 — Weekly Lab)*
- **3.P5** (Days 370–372) — Dependency & container image scanning (Trivy)
- **3.P6** (Days 373–375) — Secrets management (Vault, or WAS built-in credential store) for DB/MQ credentials
- *(Day 376 — Weekly Revision · Day 377 — Weekly Lab)*
- *(Day 378 — PRODUCTION SIMULATION DAY)*
- **3.P7** (Days 379–381) — Full automated deployment pipeline using wsadmin scripted deploy as the pipeline's deploy stage
- *(Day 382 — Weekly Revision · Day 383 — Weekly Lab)*
- **3.P8** (Days 384–388) — Test Automation: convert the manual `07_TEST_CASE_SUITE.md` into an automated regression pack (JUnit/TestNG + Selenium/RestAssured), wired into the pipeline as a gate before deploy — 1:1 conversion, no silent coverage loss; flag concurrency/MQ-resilience/failover cases (TM-05, TM-07, XC-01) honestly if they remain manual/scripted-manual
- *(Day 389 — Weekly Revision · Day 390 — Weekly Lab)* — 📌 **Day 390: Month 13 Patching + Performance Review** (rule #29)
- **3.P9** (Days 391–393) — Security gates in the pipeline (fail build on critical vuln); capstone pipeline run end-to-end

---

# PART 4 — Disaster Recovery (Dedicated, Deeper)
*(Sprints 4.D1–4.D5 | Days 394–414)*

- **4.D1** (Days 394–395) — Define RTO/RPO for DigiStack Bank's critical flows (login, transfer)
- *(Day 396 — Weekly Revision · Day 397 — Weekly Lab)*
- *(Day 398 — PRODUCTION SIMULATION DAY)*
- **4.D2** (Days 399–401) — Multi-site DR topology design (active-passive concept for DMGR/cluster/MySQL/MQ)
- **4.D3** (Days 402–404) — Automated backup/restore pipeline (scripted, scheduled)
- *(Day 405 — Weekly Revision · Day 406 — Weekly Lab)*
- **4.D4** (Days 407–409) — DR tabletop exercise (paper scenario walk-through, no system changes)
- **4.D5** (Days 410–414) — Full failover simulation (execute the DR runbook live in the lab)

---

# PART 5 — Real-Time Incident Management
*(Sprints 5.I1–5.I6 | Days 418–443)*

- *(Day 415 — Weekly Revision · Day 416 — Weekly Lab)*
- *(Day 417 — PRODUCTION SIMULATION DAY)*
- **5.I1** (Days 418–419) — Incident severity classification (Sev1–Sev4) for a banking context
- *(Day 420 — Weekly Revision · Day 421 — Weekly Lab)* — 📌 **Day 420: Month 14 Patching + Performance Review** (rule #29)
- **5.I2** (Days 422–424) — Real scenario 1: cluster member down mid-transfer — detect, triage, resolve
- **5.I3** (Days 425–427) — Real scenario 2: MQ backlog / poison message on the notification queue
- *(Day 428 — Weekly Revision · Day 429 — Weekly Lab)*
- **5.I4** (Days 430–432) — Real scenario 3: DB connection pool exhaustion during peak load
- *(Day 433 — Weekly Revision · Day 434 — Weekly Lab)*
- *(Day 435 — PRODUCTION SIMULATION DAY)*
- **5.I5** (Days 436–438) — RCA & blameless postmortem writing for one of the above
- **5.I6** (Days 439–443) — On-call runbook authoring; capstone: simulated war-room with all three scenarios in sequence

---

# PART 6 — WebSphere Interview Preparation
*(Sprints 6.Q1–6.Q5 | Days 446–462)*

- *(Day 444 — Weekly Revision · Day 445 — Weekly Lab)*
- **6.Q1** (Days 446–447) — Core WAS admin Q&A drills (topology, clustering, security, tuning)
- *(Day 448 — Weekly Revision · Day 449 — Weekly Lab)*
- **6.Q2** (Days 450–451) — MQ + IHS scenario questions — 📌 **Day 450: Month 15 Patching + Performance Review** + **Quarterly DR Drill #5** (rule #29) — Part 4's dedicated DR sprints are complete by now, so this drill runs the full multi-site failover, entirely user-led
- **6.Q3** (Days 452–454) — Troubleshooting/whiteboard scenarios (thread dump reading, hang diagnosis live)
- *(Day 455 — Weekly Revision · Day 456 — Weekly Lab)*
- *(Day 457 — PRODUCTION SIMULATION DAY)*
- **6.Q4** (Days 458–459) — Behavioral + "tell me about a production incident" storytelling using your own DigiStack Bank scenarios
- **6.Q5** (Days 460–462) — Full mock interview (mixed technical + behavioral) + final portfolio review
- *(Day 463 — Weekly Revision · Day 464 — Weekly Lab)*

**— Program complete: 464 calendar days across 91 sprints, at the same 5-study/1-revision/1-lab weekly rhythm with a Production Simulation Day every ~15 calendar days, now delivered through the full 9-to-5 workday simulation (Master Context rules #15–#19) with sprints sized to their real content instead of fixed at 1 day each. This is a rhythm guide, not a deadline — see Pace Deviation Policy in Master Context. —**

---

**Total: 91 sprints across 6 parts, spanning 464 calendar days** (recalculated 2026-07-11 to reflect multi-day sprints under the 9-to-5 workday simulation — see Master Context standing rule #20 for the day-length classification methodology and Progress Log's deviation entry for the full before/after detail). Sprint numbers are stable reference points — do not renumber; if a sprint is split or merged, log it as a deviation in the Progress Log.

*(Prior changelog entries — silent install/response files, XA transactions, LDAP/AD federation, Backup DMGR/Job Manager/Admin Agent, Dynamic Clusters, cert lifecycle management, GC policies/GCMV tooling, wsadmin object model, Core Groups/HAManager/DCS, FFDC, start/stop sequencing, connection leak detection, MustGather, Dynacache, health check endpoint, config scope precedence, external LB fix, property-based config mgmt, Monitoring Policy, rolling deployment, TAI/JAAS SSO, multi-app coexistence, MQ SPOF fix, licensing/PVU/ILMT, stale connection handling, capacity-planning closure, Developer Handoff Package requirement, manual test case tagging, Test Automation sprint, Pace Deviation Policy, DigiStack Bank rename, Wave structure, per-sprint Day tags — all retained from before; see `03_PROGRESS_LOG.md` for full history.)*

*(Updated 2026-07-11: Recalculated every sprint's day-tag from a fixed 1-day-per-sprint model (136 total days) to a variable multi-day model (464 total days) to match the new 9-to-5 workday simulation. Each of the 91 sprints was classified Light/Standard/Heavy by real workload (see Master Context rule #20), then walked through the existing 5:1:1 weekly rhythm and ~15-day Production Simulation cadence — both preserved exactly, now simply spanning variable-length sprints instead of fixed ones, with rhythm/simulation days never splitting a sprint's own days. Phase/Part/Wave boundaries, sprint numbering, and all sprint content are unchanged. See Progress Log deviation entry for the full before/after and methodology.)*
