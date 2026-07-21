# Glossary — WebSphere ND Mastery

Terms are added as we hit them. Banking-context notes included where relevant.

| Term | Definition |
|------|------------|
| **Cell** | The full administrative domain — all nodes managed together (e.g., "all core banking servers in a region") |
| **Node** | A single physical/virtual server within a cell (a "branch") |
| **Node Agent** | Lightweight process on each node that takes instructions from the Deployment Manager and manages app servers on that node |
| **Deployment Manager (Dmgr)** | Central management process for the whole cell — the "head office" pushing config/policy to every node |
| **Application Server** | The actual JVM process hosting deployed applications (the "teller" serving requests) |
| **Cluster** | A group of identical application servers (often across nodes) providing redundancy and load distribution |
| **Profile** | A set of config files defining a runtime environment (Dmgr profile, custom profile, standalone profile) |
| **Federation** | Process of joining a standalone node to a Dmgr-managed cell |
| **EAR / WAR** | Enterprise/Web Archive — the packaged application deployed to WebSphere |
| **JVM** | Java Virtual Machine — the runtime each Application Server process runs inside |
| **OOM (OutOfMemoryError)** | JVM error when heap space is exhausted; can be sizing issue or memory leak |
| **GC (Garbage Collection)** | JVM process reclaiming unused memory; verbose GC logs are key troubleshooting data |
| **Heap Dump** | Snapshot of JVM memory at a point in time, used to find memory leaks |
| **Thread Dump** | Snapshot of all JVM threads at a point in time, used to diagnose hung/deadlocked threads |
| **ADR (Architecture Decision Record)** | A written record of *why* a design choice was made, not just what was configured — core architect artifact |
| **PVU (Processor Value Unit)** | Unit IBM uses to license WebSphere based on processor type/core count; drives hardware sizing conversations |
| **RPO / RTO** | Recovery Point Objective (how much data loss is acceptable) / Recovery Time Objective (how fast must service resume) — negotiated, not assumed |
| **Active-Active / Active-Passive** | DR topology styles — both sites serving traffic vs. one standing by; trade-off between cost/complexity and readiness |
| **CAB (Change Advisory Board)** | Governance body that reviews/approves changes before they hit production in regulated environments |
| **Bulkhead Pattern** | Isolating components so one failure doesn't cascade — applied to clusters/nodes for blast-radius control |
| **Dynacache** | WebSphere's built-in object caching mechanism; contrast with external caches like Redis for enterprise-scale needs |
| **DMZ** | Demilitarized Zone — network segment exposed to less-trusted traffic (e.g., internet-facing); web tier (IHS) lives here, app servers never do |
| **WLM (Workload Management)** | WebSphere's mechanism for distributing requests across cluster members |
| **J2C (Java EE Connector Architecture)** | Framework for connecting to backend systems (databases, MQ); J2C auth aliases store the credentials used |
| **HPEL (High Performance Extensible Logging)** | WebSphere's structured log format, alternative to plain SystemOut/SystemErr text logs — faster to query/correlate |
| **PMI (Performance Monitoring Infrastructure)** | WebSphere's built-in metrics collection framework — the data source most APM tools read from |
| **APM (Application Performance Monitoring)** | Tooling category (Dynatrace, AppDynamics, etc.) for tracing transactions and correlating performance across tiers |
| **SLA / SLO** | Service Level Agreement (the promise, often contractual) / Service Level Objective (the internal target used to hit the SLA) |
| **ITIL** | IT Infrastructure Library — the standard framework for incident/problem/change management processes used in most enterprises |
| **RCA (Root Cause Analysis)** | The formal writeup after an incident explaining what actually caused it and what prevents recurrence — not just what fixed the symptom |
| **Sev1 / Sev2 / Sev3** | Incident severity tiers — Sev1 typically means major business impact, all-hands response |
| **TMDA** | IBM's Thread and Monitor Dump Analyzer — specialized tool for reading WebSphere thread dumps |
| **Eclipse MAT (Memory Analyzer Tool)** | Tool for analyzing heap dumps to find memory leaks — pairs with IBM Support Assistant |
| **ILMT (IBM License Metric Tool)** | Tracks sub-capacity licensing usage so PVU billing reflects actual virtualized core usage, not full physical capacity |
| **PMR (Problem Management Record)** | IBM Support's formal case/ticket for engaging their support team on an issue |
| **MustGather** | A defined set of logs/configs/diagnostics IBM Support requires upfront for a given issue type, to avoid back-and-forth |
| **HAManager (High Availability Manager)** | WebSphere component that coordinates failover and singleton services (like the JMS message engine) across a cluster |
| **INC (Incident)** | ITSM ticket type for live, broken/impacted-service work — logged and tracked to resolution |
| **SR (Service Request)** | ITSM ticket type for standard asks (access, provisioning, routine builds) |
| **CHG (Change)** | ITSM ticket type for a planned, approved config/deployment change; classified Standard, Normal/Major, or Emergency |
| **PRB (Problem)** | ITSM ticket type for root-cause investigation into a recurring issue — distinct from a one-off Incident fix |
| **ECHG (Emergency Change)** | Change executed without normal CAB lead time because production is actively degraded; reviewed retroactively |
| **Change Implementation Plan** | Written steps + validation checkpoints + backout triggers, required before executing a Normal/Major change |
| **Rollback Plan** | The paired fallback procedure written alongside every Change Implementation Plan, before execution — not after something breaks |
| **Shift Handover Note** | End-of-shift written summary of open items and overnight watch-points for whoever picks up next |
| **Deployment Summary** | Post-deployment record of what shipped, how it was verified, and the outcome |

*(More terms will be added as each part introduces them.)*
