# DigiStack Bank — VM Setup Standards

**Applies to:** Every version, every part. This is the standing checklist Claude will follow whenever a version requires VM provisioning or reconfiguration.

---

## Principle

Every version's documentation must include a **"VM Setup"** section that lets you build/launch the VM state needed for that version from scratch, even if you've never touched it before — no assumed tribal knowledge.

## Standard VM Inventory (grows as parts progress)

| VM Name | Purpose | Introduced In | OS |
|---|---|---|---|
| `digistack-was-01` | Primary WebSphere ND node (DMgr + AppServer/cluster members) | Part-1, v1 | Linux (RHEL/CentOS/Ubuntu — your choice, stay consistent) |
| `digistack-db-01` | PostgreSQL database server | Part-1, v1 | Linux |
| `digistack-ihs-01` | IBM HTTP Server | Part-1, v8 | Linux |
| `digistack-lb-01` | NGINX/HAProxy (F5/Citrix ADC simulation) | Part-2, v21 | Linux |
| `digistack-mq-01` | IBM MQ Queue Manager | Part-2, v19 | Linux |
| `digistack-tomcat-01` | Apache Tomcat — hosts the two Tomcat-based channel simulators: Mobile (`mobile.digistack.com`), ATM (`atm.digistack.com`) — separate Tomcat instances/ports on one VM, or split later if resource contention appears. **Card Portal (`card.digistack.com`) is deployed on WebSphere, not here** — see `digistack-was-01` | Part-3, v26 | Linux |
| `digistack-db-01` *(extended)* | Also hosts the new dedicated `digistack_cbs` database (separate DB/schema, separate DataSource `jdbc/CBSDataSource`, separate connection pool and JAAS auth alias from the original Part-1 pool) — or a new `digistack-cbs-db-01` VM if capacity requires splitting; call out which in `SetupDoc-v23.md` | Part-3, v23 | Linux |
| `digistack-monitoring-01` | Observability stack: Prometheus, Grafana, Alertmanager, Node/JMX/PostgreSQL exporters | Part-4, v31 | Linux |
| `digistack-elk-01` | Centralized logging: Filebeat targets ship to Logstash → OpenSearch → OpenSearch Dashboards on this VM (or split into `digistack-logstash-01`/`digistack-opensearch-01` if resource contention appears — call out which in `SetupDoc-v32.md`) | Part-4, v32 | Linux |
| `digistack-tracing-01` | Jaeger (distributed tracing backend/UI) — can be co-located on `digistack-monitoring-01` if capacity allows; call out which in `SetupDoc-v33.md` | Part-4, v33 | Linux |
| `digistack-was-dr-01` | Secondary/DR-site WebSphere ND node (Bangalore DC) — mirrors `digistack-was-01`'s role at the DR site | Part-5, v37 | Linux |
| `digistack-db-dr-01` | Secondary/DR-site PostgreSQL — streaming replication standby target for `digistack_cbs` | Part-5, v37 | Linux |
| `digistack-ihs-dr-01` | Secondary/DR-site IBM HTTP Server | Part-5, v37 | Linux |

### Regional VM Naming Convention (Part-6, v39 onward)

Once Part-6 stands up Singapore and Dubai as full regions, the single-region naming above (`digistack-<role>-01`) becomes ambiguous — every role now needs a **region code**. Standard: `digistack-<role>-<region>-01`, where `<region>` is a two-letter code:

| Region | Code |
|---|---|
| India (existing Hyderabad site, becomes the India region) | `in` |
| Singapore | `sg` |
| Dubai | `ae` |

**Existing Part-1–5 VMs are retroactively read as the India region's VMs** (e.g., `digistack-was-01` ≡ `digistack-was-in-01`) — no physical rename required, but `SetupDoc-v39.md` must call out this equivalence explicitly so a fresh reader isn't left wondering why India has no `-in-` suffix while Singapore/Dubai do.

**New regional VMs introduced at Part-6, v39** (one full set per new region — Singapore and Dubai each get their own):

| VM Name Pattern | Purpose | Introduced In | OS |
|---|---|---|---|
| `digistack-was-sg-01` / `digistack-was-ae-01` | Regional WebSphere ND node (DMgr + AppServer/cluster members) | Part-6, v39 | Linux |
| `digistack-db-sg-01` / `digistack-db-ae-01` | Regional PostgreSQL cluster — Primary | Part-6, v39 | Linux |
| `digistack-db-sg-standby-01` / `digistack-db-ae-standby-01` | Regional PostgreSQL cluster — Standby (streaming replication, mirrors the Part-5 v37 Primary/Standby pattern) | Part-6, v39 | Linux |
| `digistack-ihs-sg-01` / `digistack-ihs-ae-01` | Regional IBM HTTP Server | Part-6, v39 | Linux |
| `digistack-lb-sg-01` / `digistack-lb-ae-01` | Regional Enterprise Load Balancer | Part-6, v39 | Linux |
| `digistack-tomcat-sg-01` / `digistack-tomcat-ae-01` | Regional Tomcat (Mobile/ATM simulators) | Part-6, v39 | Linux |

**Global Shared Services VMs** (not region-specific — one set serving all regions, per the standing Global Shared Services layer defined in the Part-6 file):

| VM Name | Purpose | Introduced In | OS |
|---|---|---|---|
| `digistack-gsvc-ldap-01` | Central/federated LDAP | Part-6, v39 (stood up ahead of v42's identity work) | Linux |
| `digistack-gsvc-pki-01` | Enterprise Certificate Authority / PKI | Part-6, v39 | Linux |
| `digistack-gsvc-git-01` | Git hosting (or reference to externally hosted Git, if used) | Part-6, v39 | Linux |
| `digistack-gsvc-cicd-01` | Jenkins + Nexus (build/artifact pipeline) | Part-6, v39 | Linux |
| `digistack-gsvc-dns-01` | Global DNS / GSLB control point | Part-6, v40 | Linux |
| `digistack-gsvc-mqhub-01` | Cross-region IBM MQ Hub | Part-6, v41 | Linux |

**Rule:** Global Shared Services VMs are provisioned once and consumed by all three regions — they are never duplicated per-region. This is the VM-inventory-level enforcement of the Global Shared Services principle in the Part-6 roadmap file (regional independence at the data/traffic layer, shared tooling at the platform layer).

*(More regional VM sets added if a future Part expands beyond India/Singapore/Dubai.)*

> Update this table as new VMs are introduced. A single VM can host multiple roles early on (e.g., v1–v10 can run WAS + PostgreSQL on one VM) — the table should say so explicitly when that's the case, and note the version where a role gets split onto its own VM.

## Cross-Reference — AWS Resources (Part-9, v54 onward)

> **Added per the 2026-07-19 cross-file audit.** From Part-9 (Version 54) onward, this document's VM inventory stops being the complete picture. AWS introduces resources that aren't VMs in the traditional on-prem sense — managed databases (RDS), object storage (S3), managed queues (SQS/SNS) — alongside ones that still are (EC2 instances hosting WebSphere/IHS/MQ). Rather than force those into this table, Part-9 defines a **parallel Cloud Resource Inventory** (see `Digistack Bank Roadmap - Part-9.md`, "Cloud Resource Inventory — Extending Doc 01 for AWS"), using its own naming convention (`digistack-aws-<role>-<region>-01`).
>
> **Rule:** on-prem and EC2-hosted compute continues to use this doc's naming convention and gets added to the table above; AWS-managed services (RDS, S3, SQS/SNS, IAM, KMS, etc.) are tracked in Part-9's Cloud Resource Inventory instead. If a future SetupDoc is unsure which table a given resource belongs in, the test is: "is this something you provision and patch yourself (this doc), or something AWS operates for you (Part-9's inventory)?"

## What Every Version's VM Setup Section Must Contain

1. **Prerequisite VM state** — which VM(s) this version touches, and what state they must already be in (from prior versions).
2. **Resource sizing** — minimum vCPU / RAM / disk for this version's workload (WebSphere is memory-hungry; sizing changes as clustering/MQ/etc. are added).
3. **New software/packages to install** — exact package names and versions.
4. **Network/port requirements** — which ports open on which VM (e.g., 9060 Admin Console, 9443 HTTPS, 1414 MQ listener).
5. **Step-by-step commands** — exact shell commands, shown inline with expected output, per your standing "no run-and-paste-back" preference.
6. **Snapshot checkpoint** — a recommendation to take a VM snapshot after the version is verified working, so you can roll back if a later version breaks something. Snapshot naming convention: `digistack-<vmname>-v<N>-verified`.

## Baseline Minimum Specs (Part-1, single-VM start)

| Resource | Minimum | Recommended |
|---|---|---|
| vCPU | 2 | 4 |
| RAM | 4 GB | 8 GB (WAS ND alone typically wants 2–4 GB heap headroom) |
| Disk | 40 GB | 80 GB (grows once MQ, clustering, logs accumulate) |
| Network | NAT + Host-only adapter (for browser access to Admin Console) | Same |

These will be revised upward at the version where clustering (Part-1 v5), MQ (Part-2 v19), or a second VM (Part-2 v21) is introduced.

## Snapshot Discipline

- Snapshot **before** starting a new version (rollback point if the version's changes break something).
- Snapshot **after** the version is tested and approved (a known-good state to return to, per version, forever).
- Naming: `pre-v<N>` and `post-v<N>-approved`.

---

*This file is a standing standard, not tied to a specific part. Reference it whenever building any version's setup documentation.*

---

**Change log for this revision (2026-07-19 cross-file audit):**
- Added the "Cross-Reference — AWS Resources (Part-9, v54 onward)" section, so this doc points outward to Part-9's Cloud Resource Inventory instead of leaving that relationship implicit.
