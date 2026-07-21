# CONCEPT INDEX — DigiStack Bank

Master list of concepts, grouped by domain, with the sprint(s) where each is taught. Use this to quickly check "have I covered X yet" or to jump to a topic. Sprint numbers reference `04_SPRINT_PLAN.md`.

---

## A. WebSphere ND Core Admin

| Concept | Sprint(s) |
|---|---|
| WAS architecture (cells, nodes, servers, profiles) | 1.1 |
| DMGR install & profile creation | 1.1 |
| Node federation | 1.2 |
| Admin console navigation | 1.1–1.2 |
| wsadmin (Jython) fundamentals | 1.2 |
| Security domains / global security | 1.4 |
| JVM custom properties & tuning basics | 1.3, Advanced Block |
| Virtual hosts | 2.2 |
| JDBC providers & data sources | 2.1, 2.3 |
| JNDI resources | 2.1 |
| Session management (in-memory) | 2.4 |
| Class loaders / WAR class loading policy | 2.5 |
| Application install/update/uninstall (console, wsadmin, scripting) | 2.6–2.9 |
| Clustering & workload management (WLM) | 3.1–3.2 |
| Session replication (memory-to-memory / DB) | 3.3 |
| IHS plugin config & regeneration | 3.4 |
| Vertical/horizontal scaling | 3.5 |
| SSL/TLS, keystores, LTPA tokens | 4.1 |
| RBAC / admin roles | 4.2 |
| Logging (SystemOut/Err, HPEL) | 4.3 |
| PMI (Performance Monitoring Infrastructure) | 4.4 |
| Backup/restore (config archive) | 5.1 |
| Change management basics | 5.2 |
| Fix packs / interim fixes / iFix | 5.3 |
| HA drills (manual failover) | 5.4 |
| Silent install / response files (Installation Manager) | 1.1 |
| XA transactions / two-phase commit / last participant support | 2.5, 3.7 |
| Certificate lifecycle management (expiry, renewal, automation) | 4.1 |
| LDAP / Active Directory federation | 4.6 |
| Backup DMGR, Job Manager, Admin Agent (flexible management) | 4.7 |
| Dynamic clusters / Intelligent Management | 4.8 |
| IBM JVM GC policies (gencon vs optthruput) | 6.2 |
| IBM Support Assistant / GC and Memory Visualizer (GCMV) | 6.4 |
| Externalized app config via WebSphere variables/env entries | 2.1 |
| Custom PMI counters (app-level metrics) | 4.4 |
| Session ID / cluster-member visibility for failover drills | 2.4, 5.4 |
| java.util.logging integration with WAS (SystemOut/HPEL) | 4.3 |
| First Failure Data Capture (FFDC) | 4.3 |
| Core Groups, HAManager, DCS transport | 3.1 |
| Start/stop dependency order & safe shutdown (avoiding split-brain) | 5.5 |
| Connection leak detection | 6.2 |
| wsadmin object model (AdminConfig/AdminControl/AdminApp/AdminTask) | 1.2 |
| MustGather / collector tool for IBM PMR support cases | 6.3 |
| Dynacache (WebSphere built-in caching) | 6.8 |
| Configuration scope precedence (cell/node/server/cluster member) | 4.9 |
| Health check endpoint pattern (app + IHS + monitoring) | 3.8 |
| External load balancer for multi-IHS HA (fixing the IHS SPOF) | 4.10 |
| Property-based config management (wsadmin extract/edit/reapply) | 5.2 |
| Monitoring Policy & automatic restart on hang | 5.6 |
| Rolling deployment / simulated Blue-Green | 5.7 |
| MQ SPOF fix — multi-instance queue manager (active/standby) | 4.13 |
| WebSphere licensing — PVU counting & ILMT sub-capacity | 5.9 |
| Multi-application cluster coexistence & class loader isolation | 4.10 |
| Stale connection handling — Purge Policy & connection validation | 6.9 |
| TAI / custom JAAS login module (enterprise SSO pattern) | 4.7 |
| Closing the capacity-planning loop (vs. Sprint 1.3 baseline) | 6.10 |

## B. IBM MQ

| Concept | Sprint(s) |
|---|---|
| MQ architecture (queue managers, queues, channels) | 3.6 |
| Local/remote queues, listener ports | 3.6 |
| MDB configuration in WAS (activation specs / listener ports) | 3.7 |
| Dual notification pattern (fan-out to 2 consumers) | 3.7 |
| MQ security (channel auth, SSL) | 4.5 |
| MQ troubleshooting (dead letter queue, poison messages) | Advanced Block |

## C. IBM HTTP Server (IHS)

| Concept | Sprint(s) |
|---|---|
| IHS install & httpd.conf basics | 3.4 |
| WebSphere plugin integration | 3.4 |
| Load balancing behavior | 3.5 |
| SSL termination at IHS | 4.1 |

## D. MySQL DBA Basics

| Concept | Sprint(s) |
|---|---|
| Schema design for banking domain | 1.5 |
| Connection pooling tuning (WAS side) | 2.3 |
| Backup/restore (mysqldump) | 5.1 |
| Basic replication concepts | Advanced Block / DR |

## E. Load Testing / Perf / Troubleshooting / Migration (Advanced Block, Part 1 end)

| Concept | Sprint(s) |
|---|---|
| JMeter load test design for banking flows | 6.1 |
| Thread pool tuning, connection pool tuning | 6.2 |
| Thread dumps, javacores, GC analysis | 6.3 |
| Hang/deadlock troubleshooting | 6.3 |
| Heap dump analysis basics | 6.4 |
| DR runbook (backup/restore + failover drill) | 6.5 |
| Migration scenario (fix pack upgrade path) | 6.6 |
| Migration scenario (conceptual: traditional WAS → Liberty) | 6.7 |

## F. Observability (Part 2 — open source tools)

| Concept | Sprint(s) |
|---|---|
| PMI → JMX bridge | 2.P (Part 2, sprint 1) |
| Prometheus + WAS exporter | 2.P2 |
| Grafana dashboards for banking KPIs | 2.P3 |
| Centralized logging (ELK/EFK) | 2.P4–P5 |
| Distributed tracing basics (Zipkin/Jaeger) | 2.P6 |
| Alerting rules (Alertmanager) | 2.P7 |
| Synthetic transaction monitoring | 2.P8 |

## G. DevSecOps (Part 3)

| Concept | Sprint(s) |
|---|---|
| CI/CD pipeline (Jenkins or GitLab CI) for WAR/EAR builds | 3.P1–P2 |
| Ansible for WebSphere provisioning/config | 3.P3 |
| SAST (SonarQube) | 3.P4 |
| Dependency/container scanning (Trivy) | 3.P5 |
| Secrets management (Vault or WAS built-in) | 3.P6 |
| Automated deployment pipeline (wsadmin scripted deploy) | 3.P7 |
| Security gates in pipeline | 3.P8 |

## H. Disaster Recovery (Part 4 — dedicated, deeper)

| Concept | Sprint(s) |
|---|---|
| RTO/RPO definition for banking app | 4.D1 |
| Multi-site DR topology design | 4.D2 |
| Automated backup/restore pipeline | 4.D3 |
| DR tabletop exercise | 4.D4 |
| Full failover simulation | 4.D5 |

## I. Incident Management (Part 5)

| Concept | Sprint(s) |
|---|---|
| Incident severity classification | 5.I1 |
| War-room simulation (real scenario 1: cluster member down) | 5.I2 |
| Real scenario 2: MQ backlog / poison message | 5.I3 |
| Real scenario 3: DB connection pool exhaustion | 5.I4 |
| RCA & postmortem writing | 5.I5 |
| On-call runbook authoring | 5.I6 |

## J. Interview Prep (Part 6)

| Concept | Sprint(s) |
|---|---|
| Core WAS admin Q&A drills | 6.Q1 |
| MQ + IHS scenario questions | 6.Q2 |
| Troubleshooting/whiteboard scenarios | 6.Q3 |
| Behavioral + production incident storytelling | 6.Q4 |
| Mock interview (mixed) | 6.Q5 |
## K. Process & Documentation

| Concept | Sprint(s) |
|---|---|
| Developer Handoff Package (per app-dev sprint) | Every Phase 2 sprint + 4.10, 6.8, 6.9 |
| Manual test case execution (functional/negative/edge/security-lite) | Phase 2, 3.7, 4.10, 6.9 |
| Test automation conversion (regression pack in CI) | 3.P8 |
| Pace Deviation Policy (phase-drift handling) | Standing rule, applied as needed |
| ITIL ticket types — INC/SR/CHG/PRB/ECHG and when each applies | Every day from Day 1 onward (Master Context rule #22) |
| Change Advisory Board (CAB) approval process | From Phase 3 onward, any production-impacting CHG/ECHG (rule #27) |
| Change implementation plan & rollback plan writing | Every CHG/ECHG (rule #23), reinforced ahead of CAB review (rule #27) |
| Incident update writing (status cadence during an active INC) | Daily Production Incidents + on-call pages (rule #23) |
| Root Cause Analysis (RCA) writing — lightweight, ahead of formal 5.I5 | Any PRB or major INC before Part 5 is reached (rule #23) |
| Deployment summary writing (business-readable, post-CHG) | Any CHG that deploys code (rule #23) |
| Shift handover note writing | Every day (rule #15h) |
| Weekly sprint planning | First content day of every week (rule #26) |

## L. Employment Lifecycle & Cross-Team Practice

| Concept | Sprint(s) / Day(s) |
|---|---|
| Company induction — HR, IT accounts, security training, environment access | Day 0 (rule #24) |
| 90-day probation & staged autonomy (shadow → joint → near-full ownership) | Days 1–90 (rule #25) |
| Department directory & cross-team collaboration model (10 departments) | Ongoing from Day 1 (rule #21) |
| Weekend maintenance window scheduling for production changes | Any CAB-approved production CHG (rule #28) |
| Monthly patching cycle | Days 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360, 390, 420, 450 (rule #29) |
| Monthly performance review | Same days as monthly patching (rule #29) |
| Quarterly DR drill (observational → single-site → full multi-site) | Days 90, 180, 270, 360, 450 (rule #29) |
| On-call participation ramp (shadow → joint → solo-with-backup → solo) | Tied to probation stage (rule #18/#25) |

## M. Application Design Foundations (Pre-Dev)

*(Added 2026-07-15, folded into Sprint 1.5's existing Days 18–23 window — see Master Context §2 addendum and Sprint Plan's Sprint 1.5 entry. Taught at solution-architect/admin depth: enough to intelligently deploy, configure, and troubleshoot the app's structure — not hands-on coding, consistent with the project's non-negotiable "not a Java-dev exercise" identity, §1.)*

| Concept | Sprint(s) |
|---|---|
| Application architecture & MVC-style layered design (Controller/Model/View mapped to Servlet/DAO/JSP; no frameworks per §2) | 1.5 |
| Database design principles for banking domain (ER modeling, normalization, primary/foreign keys, constraints, schema-to-requirements traceability) | 1.5 |
| Frontend UI/UX design conventions (wireframing per module, Bootstrap 5 consistent header/nav/color scheme across all 5 modules) | 1.5 |

