# DigiStack Health Enterprise — Concept Index

Quick-lookup reference: every concept taught, in teaching order, with the sprint it belongs to. Use this to jump straight to a topic without scanning the full roadmap, or to check "have I learned X yet?"

**Note on tickets/ITIL/departments:** the SR/CHG/ECHG/INC/PRB ticket system, the 9-department roster, and CAB approval (Master Context Sections 1a and 10d) are used informally from Day 1 as the delivery wrapper for every sprint — that's not "learned" content, it's the format everything else arrives in. The *formal* ITIL theory (why CAB exists, incident vs. problem vs. change management as a discipline, SLAs) is still taught properly at Sprints 4.5–4.6, same as always; don't treat informal day-one ticket practice as a substitute for that sprint when it comes up.

---

## Phase 1 — Foundations

| Concept | Sprint |
|---|---|
| Business analysis / SDLC / Agile | 1.1 |
| MVC architecture & layering | 1.2 |
| Capacity & NFR baseline (lightweight) | 1.3 |
| Database design (PostgreSQL schema, FHIR-aligned) | 1.4 |
| UI wireframing (Bootstrap 5/JSP) | 1.5 |
| Lab environment bring-up | 1.6 |
| Linux users, groups & permissions | 1.7 |
| Linux networking, DNS & NTP | 1.8 |
| Linux firewall & SELinux | 1.9 |
| Linux storage & services | 1.10 |
| **What an app server does; profiles basics; minimal WAS ND install** | 1.11 |
| **JDBC providers, datasources & connection pooling (fundamentals)** | 1.12 |

## Phase 2 — Build, Deploy & Scale

| Concept | Sprint |
|---|---|
| **Application deployment & the Admin Console/wsadmin/Automation triad** | 2.1 |
| **Session management (JSESSIONID)** | 2.2 |
| **Profiles/Cells/Nodes at cell scale; the Deployment Manager's role** | 2.3 |
| **Node federation & node agents** | 2.4 |
| **Clusters & cluster members** | 2.5 |
| **IBM HTTP Server & virtual hosts** | 2.6 |
| **Plugin generation & propagation (plugin-cfg.xml)** | 2.7 |
| **Load balancing & SSL on IHS** | 2.8 |
| **Session replication, sticky sessions & failover** | 2.9 |
| **JDBC connection pool & statement cache tuning at cluster scale** | 2.10 |
| **Transactions — commit & rollback** | 2.11 |
| Exception handling for business-rule failures | 2.12 |
| Virtual hosts revisited for multi-module routing | 2.13 |
| JDBC query tuning for larger result sets | 2.14 |
| Session invalidation & timeout, deep dive | 2.15 |
| **MQ foundations — queue manager, queues, channels, JMS, connection factory** | 2.16 |
| **MDB & activation specification; MQSC; Dead Letter Queue; real-time status polling** | 2.17 |
| JVM configuration for multiple cluster members | 2.18 |
| **WebSphere security & SSL (cell-wide)** | 2.19 |
| Shared libraries & class loading | 2.20 |
| **wsadmin & Jython, deep dive** | 2.21 |
| Centralized logging & exception handling (cross-cutting) | 2.22 |
| Testing & code review approach | 2.23 |
| Maven build, WAR/EAR packaging, developer handoff package | 2.24 |

## Phase 3 — Harden & Observe

| Concept | Sprint |
|---|---|
| **Security hardening (HTTPS, LTPA, JAAS, CSRF/XSS/SQLi, secrets mgmt)** | 3.1 |
| JVM/heap/thread pool monitoring & PMI | 3.2 |
| MQ & JDBC pool monitoring, health checks | 3.3 |
| Metrics, logs, tracing, correlation IDs, diagnostics dashboard | 3.4 |
| Troubleshooting: app/deployment failures | 3.5 |
| Troubleshooting: JVM/memory failures | 3.6 |
| Troubleshooting: data/messaging failures | 3.7 |
| Troubleshooting: network/security/plugin failures | 3.8 |
| JMeter load/stress/spike/soak/volume testing | 3.9 |
| JVM & WebSphere tuning (Xms/Xmx, GC) | 3.10 |
| IHS, MQ & PostgreSQL tuning | 3.11 |

## Phase 4 — Resilience, Ops & Compliance

| Concept | Sprint |
|---|---|
| HA simulation (rolling restart, injected failures) | 4.1 |
| **DR planning; RTO/RPO; explicit SPOF audit of lab topology** | 4.2 |
| **DR drills (DMGR/Node/DB/MQ/Plugin/full-site failure)** | 4.3 |
| Backup & recovery (backupConfig/restoreConfig, pg_dump) | 4.4 |
| ITIL: incident, problem, change, release management | 4.5 |
| ITIL: configuration, knowledge, availability, capacity, SLA | 4.6 |
| **Compliance: HIPAA/HITECH, data classification tiers, audit logging** | 4.7 |
| Capacity planning (validates Sprint 1.3 NFR baseline) | 4.8 |
| Automation wrap-up; formal Git branch strategy | 4.9 |

## Phase 5 — Production Support

| Concept | Sprint |
|---|---|
| Incident management fundamentals | 5.1 |
| Problem management & root cause analysis | 5.2 |
| Change & release management, live production | 5.3 |
| Advanced troubleshooting: CPU/threads/memory (live) | 5.4 |
| Advanced troubleshooting: node/cluster/MQ/DB/IHS (live) | 5.5 |
| SSL/certificate/plugin issues in production | 5.6 |
| Session replication issues in production | 5.7 |
| DR execution (full live drill) | 5.8 |
| Backup/restore execution in production | 5.9 |
| Production automation, on-call readiness | 5.10 |

## Phase 6 — Modernization (lowest priority, conceptual-only)

| Concept | Sprint |
|---|---|
| Liberty fundamentals & WAS ND vs. Liberty | 6.1 |
| OpenShift & IBM Cloud Pak containerization concepts | 6.2 |
| Modernization roadmap & coexistence patterns | 6.3 |
| Capstone: portfolio & job-search package | 6.4 |

---

**Bold entries** are the milestone/integration concepts — the ones most likely to come up in an interview or a real production incident. If short on time, these are the ones to review first.
