# DigiStack Bank — Roadmap Part-9

**Enterprise Hybrid Cloud & AWS Migration**

**Goal:** Transform DigiStack Bank from a traditional on-premises banking platform into a fully AWS-native banking platform, through a realistic, phased, enterprise-grade migration — hybrid connectivity → lift-and-shift → platform modernization → full cloud migration.

**Prerequisite:** Part-8 Completion Checkpoint satisfied — the commit-to-production-ready pipeline (v49–v53) is live and region-aware across India/Singapore/Dubai; every version from this Part forward is expected to move *through* that pipeline rather than being manually deployed, per Part-8's closing note.

**Deployment model / Standing Principle — Modernize the Platform, Not the Bank:** This Part modernizes the deployment platform only. **The DigiStack Bank applications developed in Parts 1–8 remain functionally unchanged.** Every version here is infrastructure- and platform-focused — moving *where* and *how* the 9 existing applications run, never *what* they do. No new banking functionality is introduced anywhere in this Part. Any test failure that would require an actual application/business-logic change is logged as a migration blocker, not silently worked around by adding scope (same discipline as Part-7's "Migrate, Don't Rebuild" principle).

**Process for every version:** Requirements → Development/Configuration (cloud service setup, beginner-level explanation) → Deployment & Admin (AWS Console, **AWS CLI**, and IaC + existing WAS admin) → Testing (connectivity/failover/regression as applicable) → Documentation → **Pause for approval** before the next version.

**Tooling note — AWS CLI:** Alongside the Console and Ansible/wsadmin (Part-8 v51), the **AWS CLI** is used throughout this Part for scripted, repeatable AWS operations (resource creation, tagging, one-off diagnostics) — the same role it plays for real WebSphere administrators who script AWS tasks directly rather than always going through a console or a full playbook run. `SetupDoc-v<N>.md` for each version should show the exact CLI command alongside any Console-click equivalent, per this project's standing "no run-and-paste-back" / "exact commands shown inline" preference.

**Tooling note — Terraform (concept):** Part-8 v51 established Ansible as this project's Infrastructure-as-Code tool for middleware/OS-level configuration. For AWS-native resource provisioning (VPCs, RDS, S3, IAM), **Terraform is introduced at concept level only** — its declarative, state-tracked approach to provisioning cloud infrastructure is genuinely the more common enterprise tool for this specific job, and a resume-holder should be able to discuss it (consistent with this project's existing "commercial/heavier tooling = concept, not deployed" pattern used for Instana/Dynatrace/ServiceNow/Vault). **Ansible remains the primary, actually-used automation tool in this roadmap** for both middleware configuration and, where practical, AWS resource provisioning — Terraform is not stood up as a second parallel IaC tool, just understood as the alternative a real team would likely reach for.

**Per-version deliverables (per Master Index standing standards):** VM/Cloud Resource Setup section (doc 01, extended per the Cloud Resource Inventory note below), Git-committed IaC/config (doc 02), `TestCases-v<N>.md` (doc 03), `SetupDoc-v<N>.md` (doc 06), SQL migration script(s) only where a schema or DB-engine change is introduced (v64), config changes per doc 07.

**Git note (added 2026-07-19 cross-file audit — F11):** Per doc 02's `release/part-<N>` rule (required for any Part whose promotion spans multiple regional passes or a long cutover window), a `release/part-9` branch is cut from `develop` once Version 54 begins, and all three regions' UAT/Prod passes build from it — consistent with how Parts 6, 7, and 8 each handled their own multi-pass promotion windows. See doc 04's new "Phased Cloud Migration Promotion" section for the exact gating rules this Part follows (phase capstones v58/v63/v68 are Dev-only gates; the actual UAT/Prod promotion happens once, at the end, across all three regions).

---

## ⚠️ Version Numbering Correction (resolved before this file is marked ready)

The source material this Part was drafted from numbered its versions **53–72**. **That collides with Part-8, which already owns and has frozen Versions 49–53** (per Engineering Standards §7 — Version Numbering Freeze: v53 is already "End-to-End Automation & Operational Readiness Capstone"). Per the freeze rule, Part-9 is renumbered to start immediately after Part-8 ends.

Because no version in the Part-9 draft had been implemented, and the only change is a uniform **+1 shift** with no internal reordering, splitting, or renaming, this is a straightforward offset — same precedent as Part-6's own +1 offset from its 38–42 draft — not a full historical renumbering table of the kind Part-3/4/5 required.

**Renumbering table (required by Engineering Standards §7 whenever a renumbering happens):**

| Old # (draft) | Title | New # | Phase |
|---|---|---|---|
| 53 | AWS Foundation | **54** | Phase-1 |
| 54 | Enterprise Hybrid Connectivity | **55** | Phase-1 |
| 55 | AWS Landing Zone | **56** | Phase-1 |
| 56 | Hybrid Monitoring | **57** | Phase-1 |
| 57 | Phase-1 Capstone | **58** | Phase-1 |
| 58 | WebSphere on AWS EC2 | **59** | Phase-2 |
| 59 | Hybrid Production | **60** | Phase-2 |
| 60 | High Availability on AWS | **61** | Phase-2 |
| 61 | AWS Operations | **62** | Phase-2 |
| 62 | Lift & Shift Capstone | **63** | Phase-2 |
| 63 | Database Modernization | **64** | Phase-3 |
| 64 | Storage Modernization | **65** | Phase-3 |
| 65 | Messaging Modernization | **66** | Phase-3 |
| 66 | Security Modernization | **67** | Phase-3 |
| 67 | Platform Modernization Capstone | **68** | Phase-3 |
| 68 | Production Cutover | **69** | Phase-4 |
| 69 | Disaster Recovery on AWS | **70** | Phase-4 |
| 70 | Cloud Operations | **71** | Phase-4 |
| 71 | AWS Security & Compliance | **72** | Phase-4 |
| 72 | AWS Enterprise Migration Capstone | **73** | Phase-4 |

No version has been implemented yet — clean pre-implementation +1 shift, no internal reordering, same precedent as every prior Part's own renumbering pass (Part-6, Part-7 §, Part-8).

**Second correction — database continuity gap.** The draft's Phase-2 (Version 58/new 59, "WebSphere on AWS EC2") specified **MySQL** as the database engine to run on EC2, and Phase-3's Database Modernization step (old 63/new 64) accordingly read "MySQL → Amazon RDS." This directly conflicts with the project-wide standard, resolved once already in the MASTER INDEX Open Decisions: **PostgreSQL is the standardized database for DigiStack Bank across every environment and every Part** (originally corrected at Part-2 v22, and never revisited since). **Corrected throughout this file:** every EC2/on-prem database reference reads **PostgreSQL**, and the Phase-3 migration reads **PostgreSQL → Amazon RDS for PostgreSQL**, not a MySQL/Postgres swap disguised as a "modernization." No new database engine is introduced anywhere in this Part outside of the RDS-for-PostgreSQL managed-service move itself.

**Third correction — gap-fill from Phase Review.** A reviewer pass over the original draft flagged several topic omissions per phase (enterprise networking/identity concepts in Phase-1, expanded Systems Manager tooling in Phase-2, expanded security/cost topics in Phase-3/4, and an AWS Backup line in the final architecture). Rather than adding new versions, these are folded into the nearest version that already covers that topic area — consistent with how Part-4 absorbed its "doc 14" gap analysis and Part-7/8 absorbed their own consolidation notes. Each fold-in is called out explicitly in the relevant version below.

---

## Cloud Resource Inventory — Extending Doc 01 for AWS (standing note, Version 54 onward)

> Doc 01 (VM Setup Standards) governs on-premises VM inventory. AWS introduces resources that are not VMs in the traditional sense (VPCs, managed databases, object storage, managed queues) alongside ones that are (EC2 instances hosting WebSphere/IHS/MQ). Rather than force AWS resources into doc 01's VM table, this Part introduces a parallel **Cloud Resource Inventory**, referenced the same way doc 07 is referenced from Part-3 onward — cross-referenced per version, not restated. **Doc 01 itself now cross-references this section too (added 2026-07-19 cross-file audit), so the relationship is stated in both directions.**

**Naming convention (mirrors doc 01's `digistack-<role>-<region>-01` pattern, cloud-qualified):**
```
digistack-aws-<role>-<region>-01     e.g. digistack-aws-was-in-01, digistack-aws-rds-in-01
```
Region codes reuse Part-6 doc 01's two-letter codes (`in`, `sg`, `ae`) where the AWS resource maps onto an existing DigiStack region, plus the AWS region identifier it actually lives in (e.g., `ap-south-1` for India) noted alongside — the DigiStack region code and the AWS region code are two different things and both are recorded in `SetupDoc-v<N>.md`, not conflated.

**Every version in this Part that introduces a new AWS resource must add a row here (`SetupDoc-v<N>.md`) and a corresponding row in doc 07 §6's Port Matrix if it exposes a new network endpoint** — same drift-prevention rule doc 07 §6 already states for on-prem VMs.

---

## Standing Architectural Note — WebSphere Continuity

Every phase in this Part changes *where* WebSphere runs and *what* it's backed by — never the fact that it's WebSphere. The end-state request flow, at every phase, still reads:

```
Users → Route 53 → Application Load Balancer → IBM HTTP Server → WebSphere ND Cluster → DigiStack CBS
```

Phase-3/4 change what sits *beneath* CBS (RDS instead of self-managed PostgreSQL, S3 instead of local disk, SQS/SNS instead of IBM MQ for some flows) — they do not change the WebSphere administration focus that has been the point of this entire roadmap since Part-1. `SetupDoc-v<N>.md` for every version in this Part should explicitly reconfirm this diagram is unchanged at the WAS-cluster layer, so a fresh reader never mistakes "the DB moved to RDS" for "WebSphere was replaced."

---

## Standing Architectural Note — Observability Continuity (extends Part-4)

Per the Phase Review's Hybrid Monitoring recommendation: the Part-4 observability stack (Prometheus, Grafana, OpenSearch/ELK, Jaeger, Alertmanager) is **extended to cover AWS workloads, not replaced by CloudWatch/CloudTrail.** CloudWatch and CloudTrail are ingested *into* the same operational view (Grafana panels, Alertmanager routing) established in Part-4/Part-6, exactly as Part-6's multi-region rollout extended — rather than duplicated — the same stack region by region. This is called out explicitly at Version 57 (Hybrid Monitoring) below and remains true through every later version in this Part.

---

# Phase-1 — AWS Foundation & Hybrid Connectivity

**Goal:** Learn AWS fundamentals and securely connect the existing on-premises DigiStack Bank environment (all 9 applications, still on-prem throughout this phase) to AWS.

## Version 54 — AWS Foundation

### Objective
Establish the foundational AWS account, network, and compute primitives that every later version in this Part builds on.

### Banking Features Added
**None.**

### Topics Covered
- AWS Global Infrastructure (Regions, Availability Zones, Edge Locations)
- IAM (Users, Groups, Roles, Policies), AWS Organizations (concepts)
- AWS Accounts (multi-account strategy, concept-level pending v56's Landing Zone)
- VPC, CIDR Planning, Public Subnets, Private Subnets, Route Tables, Internet Gateway, NAT Gateway
- Security Groups, Network ACLs
- EC2, EBS, Elastic IP
- **VPC Endpoints** (Gateway and Interface) — *fold-in from Phase Review*: lets later AWS-hosted services (S3 in v65, Secrets Manager/KMS in v67) be reached from private subnets without traversing the public internet
- **AWS Transit Gateway** (concept-level) — *fold-in from Phase Review*: the enterprise pattern for connecting multiple VPCs/on-prem networks at scale, positioned here as the concept a resume-holder should recognize even though this project's scale doesn't require standing one up

### Cloud Resource Inventory Note
New resources: one VPC per DigiStack region eventually (India first), public/private subnet pairs, one NAT Gateway, one Internet Gateway. No EC2 workloads carrying application traffic yet — this version is pure networking foundation.

### WebSphere Topics Covered
None directly — this version has no WebSphere footprint; it's pure AWS networking/IAM foundation feeding every later version.

### Enterprise Learning
Cloud Networking Fundamentals, IAM Fundamentals, Account/Network Planning

**Sprint Deliverable:** A VPC with public/private subnets, route tables, an Internet Gateway, and a NAT Gateway is provisioned for the India region; a single EC2 instance in the private subnet is reachable only via a bastion pattern (formalized in v56); IAM roles/policies enforce least-privilege access to the account; at least one VPC Endpoint (S3 Gateway Endpoint) is proven reachable from the private subnet without an internet route.

---

## Version 55 — Enterprise Hybrid Connectivity

### Objective
Connect the on-premises DigiStack Bank data center (India, per Part-6) with the AWS VPC built in v54.

### Banking Features Added
**None.**

### Topics Covered
- Site-to-Site VPN (concepts), AWS Direct Connect (concepts)
- Hybrid DNS, Route 53 Private Hosted Zones, Hybrid Routing
- Security Design (encryption in transit over the hybrid link, route-scoping so AWS can't reach more of the on-prem network than necessary)

### Architecture
```
On-Prem Data Center (India, per Part-6 v39)
        │
  VPN / Direct Connect
        │
   AWS VPC (v54)
```

### Cloud Resource Inventory Note
New resources: Virtual Private Gateway / Customer Gateway (VPN concept), Route 53 Private Hosted Zone for `*.digistack.com` resolvable from both sides of the hybrid link.

### WebSphere Topics Covered
None directly.

### Enterprise Learning
Hybrid Cloud Architecture, Secure Connectivity Design, DNS Federation Across Environments

**Sprint Deliverable:** A simulated Site-to-Site VPN (or Direct Connect concept walkthrough, whichever the lab environment supports) connects the India on-prem network to the AWS VPC; a hostname in the Route 53 Private Hosted Zone resolves correctly from an on-prem host, proving hybrid DNS works both directions; a security review confirms the hybrid link exposes only the specific subnets/ports it needs to, not the full on-prem network.

---

## Version 56 — AWS Landing Zone

### Objective
Formalize the multi-account, governed AWS foundation a real enterprise would run production banking workloads on, rather than a single flat account.

### Banking Features Added
**None.**

### Topics Covered
- Account Strategy (multi-account: e.g., separate accounts for Dev/UAT/Prod and Shared Services, mirroring doc 04's environment topology and Part-6's Global Shared Services principle)
- IAM Roles (cross-account assume-role pattern), AWS Organizations (Service Control Policies, concept-level)
- Network Architecture (hub-and-spoke, reusing v54's Transit Gateway concept as the hub)
- Shared Services (logging, monitoring, bastion — centralized, consumed by every account, same principle as Part-6's Global Shared Services layer)
- Bastion Host (the answer to v54's "reachable only via a bastion pattern" note)
- Logging (centralized CloudTrail), Monitoring (foundation for v57)
- **AWS IAM Identity Center** (concept-level) — *fold-in from Phase Review*: centralized workforce identity/SSO across AWS accounts
- **Hybrid Active Directory** (concept-level) — *fold-in from Phase Review*: extending the on-prem/Part-6 identity model (central LDAP, v42) into AWS via AD Connector/managed AD concepts, so a single identity still works across on-prem and AWS, consistent with Part-6 v42's "one identity everywhere" principle

### Cloud Resource Inventory Note
New resources: AWS Organization with Dev/UAT/Prod/Shared-Services member accounts (or a documented single-account simulation if multi-account isn't feasible at lab scale — call out explicitly in `SetupDoc-v56.md`), one bastion host in the Shared Services account/VPC.

### WebSphere Topics Covered
None directly.

### Enterprise Learning
Landing Zone Design, Multi-Account Governance, Centralized Identity & Shared Services

**Sprint Deliverable:** A documented (and where feasible, provisioned) multi-account structure exists with a Shared Services account hosting the bastion and centralized logging; a cross-account IAM role is assumed successfully from a Dev-equivalent account into Shared Services; the bastion is the only path to any private-subnet EC2 instance, proven by confirming direct access is blocked.

---

## Version 57 — Hybrid Monitoring

### Objective
Extend the existing Part-4/Part-6 observability stack to cover AWS workloads and the hybrid link itself — not replace it. See the standing Observability Continuity note above.

### Banking Features Added
**None.**

### Tools
CloudWatch, CloudTrail, SNS, AWS Systems Manager (introduced here, expanded in v62)

### Integration
Prometheus, Grafana, OpenSearch/ELK (Part-4 v31/v32) — CloudWatch metrics and CloudTrail events are shipped into the **same** Grafana dashboards and OpenSearch indices already used for on-prem monitoring, via CloudWatch exporter / Firehose-to-OpenSearch (or equivalent), not a second, parallel monitoring UI.

### Monitors
- On-Prem (unchanged, per Part-4/Part-6)
- AWS (VPC flow logs, EC2/NAT Gateway health, the hybrid VPN/Direct Connect link's own health)

### WebSphere Topics Covered
None directly — this version instruments the surrounding cloud infrastructure, not WebSphere itself (WebSphere isn't on AWS yet — that's Phase-2).

### Enterprise Learning
Hybrid Observability, Unified Monitoring Strategy, Cloud-Native Logging/Alerting Concepts

**Sprint Deliverable:** A single Grafana dashboard shows both an on-prem WAS cluster health panel (Part-4 v31) and an AWS VPC/hybrid-link health panel side by side; a CloudTrail event (e.g., an unauthorized API call attempt) is visible in the same OpenSearch Dashboards view used for on-prem logs; an SNS-triggered alert for a hybrid link degradation reaches the same Alertmanager/email path already proven in Part-4 v34.

---

## Version 58 — Phase-1 Capstone: Hybrid Operations

### Objective
Operate DigiStack Bank in a hybrid state: the application remains fully on-prem (per Part-8's final state), while AWS provides monitoring, backup, connectivity, and management — proving the hybrid foundation actually works end-to-end before any workload physically moves.

### Banking Features Added
**None.** Application topology is unchanged from Part-8 — this version validates the surrounding hybrid platform, not the app.

### What AWS Provides at This Point
- Monitoring (v57)
- Backup (AWS Backup / S3-based off-site backup target for the existing on-prem backup inventory from Part-5 v38 — an *additional* off-site copy, not a replacement for the existing on-prem backup process)
- Connectivity (v55)
- Management (bastion, centralized logging/IAM, v56)

### WebSphere Topics Covered
None directly — validates the hybrid platform around the unchanged on-prem WAS estate.

### Enterprise Learning
Hybrid Operations Validation, Phase-Gate Discipline (proving each phase's foundation before building the next on top of it)

### Promotion Note (added 2026-07-19 cross-file audit)
This capstone — like v63 and v68 below — is a **Dev-only internal gate**, not a UAT/Prod promotion event. Per doc 04's "Phased Cloud Migration Promotion" section, Part-9's actual environment promotion happens once, after Version 73, across all three regions. This capstone's job is to prove Phase-1 is solid enough to build Phase-2 on top of, in Dev.

**Sprint Deliverable:** A full hybrid operations day is simulated: an on-prem alert (Part-4/5 style) is visible and actionable from the AWS-integrated Grafana view; an on-prem backup (per Part-5 v38's inventory) is confirmed replicated to an S3-based off-site target via AWS Backup; access to any AWS or on-prem management surface is proven to route only through the bastion/centralized identity established in v56 — no direct/back-door path exists. **Phase-1 Completion Gate:** none of Phase-2's lift-and-shift work begins until this Sprint Deliverable is signed off, per doc 03/04's standing sign-off discipline.

---

# Phase-2 — Lift & Shift (Infrastructure Migration)

**Goal:** Move infrastructure to AWS with minimal application changes — same PostgreSQL database, same IBM MQ, same WebSphere ND, just running on EC2 instead of on-prem VMs.

## Version 59 — WebSphere on AWS EC2

### Objective
Deploy the existing WebSphere/IHS/MQ/PostgreSQL stack onto EC2, unchanged in configuration from its on-prem equivalent — a true lift-and-shift, not a redesign.

### Banking Features Added
**None.**

### Deployed on EC2
- IBM HTTP Server
- WebSphere ND
- IBM MQ
- **PostgreSQL** *(corrected from the draft's "MySQL" — see Second Correction above; this project has never used any database other than PostgreSQL, and this version does not introduce an exception)*

### Cloud Resource Inventory Note
New resources: EC2 instances named per this Part's convention — `digistack-aws-was-in-01`, `digistack-aws-ihs-in-01`, `digistack-aws-mq-in-01`, `digistack-aws-db-in-01` — sized per doc 01's existing baseline specs (this version doesn't change sizing standards, just the hosting substrate). AMIs built from the same Ansible playbooks Part-8 v51 already wrote — this version *targets* an EC2 inventory group with those same playbooks, it does not write new provisioning logic.

### WebSphere Topics Covered
EC2-hosted WAS ND installation and configuration — identical topics to Part-1 v1–v12, now on EC2 instead of on-prem VMware.

### ⚠️ Licensing Note
**Verify IBM WebSphere licensing and support requirements before any production deployment on AWS.** IBM's licensing terms (e.g., PVU-based or BYOL entitlement rules, and whether the existing license covers deployment on third-party cloud infrastructure) are a genuine, common blocker in real enterprise cloud migrations — moving WAS ND onto EC2 is not just a technical lift-and-shift, it's also a licensing/procurement conversation. This project treats it as a documented planning consideration in `SetupDoc-v59.md` (a real migration would confirm this with IBM/a licensing specialist before v59 is anything more than a Dev-environment exercise), not as a blocking gate on the lab itself.

### Enterprise Learning
Lift-and-Shift Migration Strategy, Cloud Compute Fundamentals for Enterprise Middleware, Enterprise Software Licensing Considerations in Cloud Migration

**Sprint Deliverable:** One full WebSphere ND cell (DMgr + cluster members), IHS, IBM MQ, and PostgreSQL are running on EC2 in the AWS VPC, provisioned via Part-8 v51's existing Ansible playbooks pointed at a new `inventory/aws-in` group; a redeployed EAR (any of the 9 applications) runs identically to its on-prem counterpart, confirmed via the same `TestCases-v<N>.md` regression subset used in Part-7 v45.

---

## Version 60 — Hybrid Production

### Objective
Run a subset of the 9 applications on AWS while others remain on-prem, proving the two environments can serve live, integrated production traffic together — the realistic middle state of any real migration, not an all-or-nothing switch.

### Banking Features Added
**None.**

### Split (initial split — subject to change per actual migration order documented in `SetupDoc-v60.md`)
```
Internet Banking Portal
        │
        ▼
       AWS
        │
        ▼
       CBS
        │
        ▼
     On-Prem
```
Internet Banking Portal runs on AWS (v59's EC2 estate); CBS and the remaining satellite services (Payment Hub, Notification, Reporting, Branch, Card Portal, Mobile/ATM Tomcat) remain on-prem, per Part-3/6/7's existing topology, communicating across the hybrid link established in v55.

### WebSphere Topics Covered
Cross-environment service-to-service communication (WAS-on-EC2 ↔ WAS-on-prem), hybrid classloading/deployment consistency checks (confirming the same EAR behaves identically regardless of which side of the hybrid link it runs on)

### Enterprise Learning
Hybrid Production Operations, Phased Cutover Planning, Cross-Environment Integration Testing

### Cutover Tracking Note (added 2026-07-19 cross-file audit)
This version marks the first point where real, live production-style traffic starts flowing to AWS for a given region. From here on, log each region's split/decommission progress in the Progress Log's "AWS Migration Cutover Status" table — don't wait until v69's final cutover to start tracking.

**Sprint Deliverable:** A live Fund Transfer request originates at the AWS-hosted Internet Banking Portal, crosses the hybrid link, and completes against the still-on-prem CBS — with the same latency/success profile as the fully on-prem baseline (Part-4 v33); the hybrid monitoring view (v57) shows both legs of the request end-to-end.

---

## Version 61 — High Availability on AWS

### Objective
Bring AWS-hosted WebSphere to the same HA bar already proven on-prem in Part-5 v36 — using AWS-native HA primitives rather than reinventing Part-5's discipline from scratch.

### Banking Features Added
**None.**

### Topics
- Multi-AZ deployment (WAS cluster members spread across at least two Availability Zones)
- Application Load Balancer (fronting IHS, or replacing the on-prem Enterprise LB's role for the AWS-hosted tier), including:
  - **Sticky Sessions** (ALB-level session affinity, e.g. duration-based cookies) — the AWS-native counterpart to Part-5 v36's Sticky Session / Session Affinity discussion; the ALB keeps a user's requests on one target, but as with the on-prem LB, it's WebSphere's own session replication (Part-1 v5/v9) that actually protects the session *data* if that target disappears
  - **Health Checks** — ALB target-group health checks reuse the same `/health` endpoints introduced in Part-4 v31, exactly as Part-6 v40's GSLB routing did — no new, parallel health-check scheme is invented for AWS
- Route 53 (health-check-driven DNS, extending Part-6 v40's GSLB concept to an AWS-native mechanism)
- EC2 Auto Recovery
- EBS Snapshots, AMIs (as the AWS-native equivalent of Part-1 doc 01's VM snapshot discipline)

### WebSphere Topics Covered
Cluster failover behavior re-verified across AZ boundaries (extends Part-5 v36's Server/Application failure-type drills to a Multi-AZ topology)

### Enterprise Learning
Cloud High Availability Design, Multi-AZ Architecture, AWS-Native Recovery Automation

> **Scale disclaimer (added per 2026-07-19 architect review, Finding #12):** as with Part-4 v33, any load figures produced during this version's failover drill reflect lab-scale EC2 instance sizes, not production capacity — the drill validates the *failover mechanism*, not a real-world traffic ceiling.

**Sprint Deliverable:** A deliberate AZ-level failure (stopping all cluster members in one AZ) is absorbed by the remaining AZ's members with session continuity intact (reusing Part-1 v9/Part-5 v36 session replication) and ALB health checks routing around the failed AZ within a defined window — verified through the same Grafana/Prometheus views used for every prior HA drill in this project, not a separate AWS-only dashboard.

---

## Version 62 — AWS Operations

### Objective
Establish day-to-day operational tooling for the AWS-hosted estate, extending Part-4/Part-5's operational discipline (runbooks, backup, patching) to AWS-native tooling.

### Banking Features Added
**None.**

### Topics
- CloudWatch, CloudTrail, SNS (reused from v57, now driving actual EC2/WAS operational alerts, not just hybrid-link health)
- AWS Systems Manager, expanded per the Phase Review fold-in:
  - **Run Command** — ad hoc command execution across the EC2 fleet without SSH sprawl
  - **Session Manager** — the AWS-native answer to v56's bastion pattern, reducing (not necessarily replacing) reliance on a standing bastion host
  - **Patch Manager** — extends Part-5 v38's OS Patching process item to AWS-managed patch scheduling
  - **Automation Documents** and **State Manager** — codifying the runbook-style operational actions (Part-4 v35, Part-5 v38) as reusable SSM documents
- AWS Backup (extends v58's off-site backup concept into the full operational backup schedule for the AWS-hosted estate)

### WebSphere Topics Covered
None directly — operational tooling around the AWS-hosted WAS estate, not WAS configuration itself.

### Enterprise Learning
Cloud Operations, Patch Management at Scale, Runbook-as-Code (SSM Automation/State Manager)

**Sprint Deliverable:** A Patch Manager-scheduled patch cycle runs against the EC2 fleet with zero manual SSH sessions; a Part-4/5-style incident (e.g., a hung WAS process on EC2) is worked using an SSM Automation Document as the runbook, not a manually-typed command sequence; Session Manager is proven as a working bastion-free access path, logged and auditable via CloudTrail.

---

## Version 63 — Phase-2 Capstone: Lift & Shift Complete

### Objective
Confirm the entire DigiStack infrastructure now runs on AWS EC2, with no application redesign anywhere — the lift-and-shift promise kept in full.

### Banking Features Added
**None.**

### Scope Confirmation
All 9 applications (7 WAS EARs + 2 Tomcat WARs), IBM MQ, and PostgreSQL now run entirely on EC2 across at least the India region (Singapore/Dubai migration sequencing documented in `SetupDoc-v63.md`, following the same one-region-at-a-time discipline established in doc 04's Multi-Region Promotion rules). On-prem is fully decommissioned for the migrated region(s), following the same "decommission only after the observation window closes cleanly" discipline Part-7 v48 established for the WebSphere platform migration.

### WebSphere Topics Covered
Full-estate migration validation — every topic from Parts 1–8 re-confirmed functioning identically on EC2 as it did on-prem.

### Enterprise Learning
End-to-End Lift-and-Shift Validation, Migration Governance (reuses Part-7 v48's Migration Success Criteria pattern)

### Promotion Note (added 2026-07-19 cross-file audit)
Like v58, this capstone is a **Dev-only internal gate** — it does not itself constitute UAT/Prod promotion (per doc 04's "Phased Cloud Migration Promotion" section). However, the on-prem decommissioning described in this version's Sprint Deliverable **is** a real, trackable infrastructure event: log it per-region in the Progress Log's "AWS Migration Cutover Status" table as it happens, independent of when the Part-level promotion eventually occurs.

**Sprint Deliverable:** A full regression pack (all prior `TestCases-v<N>.md` files) passes against the fully AWS-hosted estate; a before/after performance comparison (reusing Part-4 v33's baseline methodology, extended in Part-7 v45) shows no unexplained regression; the on-prem estate for the migrated region is formally decommissioned only after a defined observation window closes with no rollback triggered — mirroring Part-7 v48's Migration Success Criteria exactly, applied here to the infrastructure-hosting decision rather than a WAS version upgrade.

---

# Phase-3 — Platform Modernization

**Goal:** Replace self-managed infrastructure services with AWS managed services — the same applications, now backed by managed database, storage, and messaging instead of self-administered EC2-hosted equivalents.

## Version 64 — Database Modernization

### Objective
Move the self-managed PostgreSQL instance(s) on EC2 (v59) to Amazon RDS for PostgreSQL.

### Banking Features Added
**None.**

### Migration
```
PostgreSQL (self-managed, EC2)
        │
        ▼
Amazon RDS for PostgreSQL
```
*(Corrected from the draft's "MySQL → Amazon RDS" — see Second Correction above. No database engine change occurs anywhere in this project; this version is purely a self-managed-to-managed-service move within the same engine, consistent with the project's PostgreSQL standard.)*

### Topics
Multi-AZ (RDS-native, distinct from v61's EC2 Multi-AZ pattern), Read Replicas, Automated Backups, Failover (RDS-managed, compared explicitly against the self-managed streaming replication pattern from Part-5 v38/Part-6 v39 in `SetupDoc-v64.md`)

### SQL / Migration Note
Per doc 05, a schema-compatibility verification (not a schema *change*) is required before cutover — confirm every DataSource/JNDI configuration (Part-1 v7) points at the new RDS endpoint, and that connection pool behavior (Part-5 v38's JDBC Failover discipline) still holds against RDS's own failover mechanics.

### WebSphere Topics Covered
JDBC DataSource reconfiguration (JNDI target change only — no code change), connection pool re-validation against RDS endpoints

### Enterprise Learning
Database-as-a-Service Migration, RDS Operational Model, Read Replica Design

**Sprint Deliverable:** All CBS/CBS-adjacent DataSources are repointed to Amazon RDS for PostgreSQL with zero application code change; a Multi-AZ RDS failover is triggered deliberately and JDBC connection pool recovery is confirmed (reusing Part-5 v38's JDBC Failover test); at least one read replica is proven serving Reporting Service's read-only queries (Part-3 v23's ownership rule preserved — Reporting Service still never writes).

---

## Version 65 — Storage Modernization

### Objective
Move application file storage (report output, log archives, static assets) from EC2-local/EBS storage to Amazon S3.

### Banking Features Added
**None.**

### Migration
```
Application Files (EBS-local)
        │
        ▼
     Amazon S3
```

### Topics
S3, Versioning, Lifecycle policies (tiering old Transaction Reports per Part-1 v14 into cheaper storage classes over time), Glacier (long-term archival), Cross-Region Replication (extends the RPO/RTO discipline from Part-5 v37 to object storage)

### WebSphere Topics Covered
Application-level storage path reconfiguration (Reporting Service's output target, Part-1 v14/Part-4 v32's log-shipping target) — no code logic change, only where files land.

### Enterprise Learning
Object Storage Architecture, Lifecycle Cost Management, Cross-Region Data Durability

**Sprint Deliverable:** Transaction Reports (Part-1 v14) and archived logs (Part-4 v32) write to S3 instead of local EBS; a lifecycle policy demonstrably transitions a report older than a defined threshold into a cheaper storage class; Cross-Region Replication is proven by confirming an object written in the India region's bucket appears in a DR-region replica bucket within an expected window.

---

## Version 66 — Messaging Modernization

### Objective
Evaluate and selectively migrate messaging from IBM MQ to Amazon SQS/SNS — as a deliberate architectural decision, not a wholesale replacement.

### Banking Features Added
**None.**

### Migration
```
IBM MQ
    │
    ▼
Amazon SQS
    │
    ▼
   SNS
```

### Explicit Decision Framework (this is the point of the version, not a footnote)
- **When IBM MQ should remain:** transactional, XA-integrated flows requiring guaranteed delivery semantics tightly coupled to WebSphere's own transaction manager (e.g., the Fund Transfer JMS/MDB flow from Part-2 v15, the external payment leg from Part-2 v19) — these stay on IBM MQ/SIBus, since re-platforming them onto SQS would require re-architecting transaction boundaries the roadmap has deliberately never touched.
- **When SQS/SNS is appropriate:** fire-and-forget or fan-out notification patterns that don't require XA integration — Notification Service's event consumption (Part-3 v23) is the natural first candidate, since it already only *consumes* events rather than participating in a distributed transaction.
- **Enterprise migration strategy:** a hybrid messaging topology (some flows on IBM MQ, some on SQS/SNS) is the realistic end state for this project, mirroring how real banks rarely do a 100% messaging-platform swap in one pass.

### WebSphere Topics Covered
JMS-to-SQS bridging concepts (where applicable), MDB behavior compared against SQS-consumer Lambda/polling patterns (concept-level for the latter, since this project stays WebSphere-centric)

### Enterprise Learning
Messaging Modernization Strategy, Migration Decision-Making (what moves vs. what deliberately doesn't), Fan-Out Notification Patterns

**Sprint Deliverable:** Notification Service's event consumption is migrated from IBM MQ to SQS/SNS, proven functionally equivalent (same notification delivered, same latency profile within an acceptable range); the Fund Transfer JMS/MDB flow (Part-2 v15) and the external MQ payment leg (Part-2 v19) are explicitly confirmed to **remain on IBM MQ**, with the rationale above documented in `SetupDoc-v66.md` rather than assumed.

---

## Version 67 — Security Modernization

### Objective
Replace self-managed security tooling (self-signed certs, hardcoded-adjacent secrets handling) with AWS-managed security services, extending — not replacing — the security discipline built since Part-1 v10/v11/v12.

### Banking Features Added
**None.**

### Topics
- IAM (deepened from v54/v56), **Least Privilege**, **IAM Roles for EC2** (instance profiles — no long-lived credentials on any EC2 host) — *fold-in from Phase Review*
- Secrets Manager (replaces the JAAS Auth Alias credential-storage pattern's *backing store* — the JAAS Auth Alias abstraction in WAS itself is unchanged, per doc 05's "never in these files" rule, now backed by Secrets Manager instead of a local credential store)
- KMS (encryption key management — backs both Secrets Manager and RDS/S3 encryption at rest)
- ACM (AWS Certificate Manager) — manages the certs fronting the AWS-hosted ALB/IHS tier, cross-referenced against doc 07 §7's Certificate Inventory (a new "AWS ACM-managed" row is added there)
- AWS WAF, AWS Shield (concepts), GuardDuty (concepts)
- **Security Groups vs. NACLs** — explicit comparison, since both were introduced separately (v54) without being contrasted — *fold-in from Phase Review*
- **Encryption at Rest / Encryption in Transit** — formalized as an explicit checklist item (RDS, S3, EBS at rest via KMS; ALB/IHS in transit via ACM-issued certs) — *fold-in from Phase Review*

### WebSphere Topics Covered
LTPA/SSL configuration re-verified against ACM-issued certs at the AWS-hosted tier (extends Part-6 v42/Part-7 v46's LTPA/cert migration discipline to the AWS estate)

### Enterprise Learning
Cloud Security Architecture, Managed Secrets & Key Management, Defense-in-Depth on AWS

**Sprint Deliverable:** No EC2 instance in the AWS-hosted estate holds a long-lived IAM credential — all access is via instance profile roles; DB credentials are read from Secrets Manager at runtime, never present in any config file (extends doc 05's "never in these files" rule); ACM-issued certs front the AWS ALB, and doc 07 §7's Certificate Inventory is updated with the new row; a deliberately misconfigured Security Group (open to `0.0.0.0/0` on a sensitive port) is caught by a GuardDuty finding (concept walkthrough if GuardDuty isn't actually enabled in the lab account) and remediated.

---

## Version 68 — Phase-3 Capstone: Platform Modernization Complete

### Objective
Confirm DigiStack Bank now runs on a fully modernized AWS platform — managed database, managed storage, hybrid messaging, and cloud-native security — with the WebSphere/CBS application layer itself still unchanged.

### Banking Features Added
**None.**

### Confirmed Platform State
EC2 (WebSphere/IHS/MQ-for-retained-flows), RDS (PostgreSQL), S3, SQS, SNS, IAM, KMS — all operating together, per the Standing WebSphere Continuity note above.

### WebSphere Topics Covered
Full-stack re-verification: every WebSphere topic from Parts 1–8 re-confirmed functioning against the now-modernized backing services (RDS instead of self-managed PostgreSQL, S3-backed report/log storage, hybrid IBM MQ/SQS messaging).

### Enterprise Learning
Managed-Services Migration Governance, Platform Modernization Validation

### Promotion Note (added 2026-07-19 cross-file audit)
Like v58 and v63, this capstone is a **Dev-only internal gate** confirming Phase-3 is solid before Phase-4's final cutover begins — it is not a UAT/Prod promotion event in its own right.

**Sprint Deliverable:** A full regression pack passes against the modernized platform; RDS failover, S3 lifecycle/replication, the IBM MQ/SQS hybrid messaging split, and the Secrets Manager/KMS/ACM security chain are each re-verified in the same sprint (not assumed carried over individually from their own versions); a Migration Success Criteria checklist (reusing Part-7 v48's shape) confirms no open Critical/High defects before Phase-4 begins.

---

# Phase-4 — Full AWS Migration

**Goal:** Complete the migration of DigiStack Bank to AWS — final cutover, cloud-native DR, ongoing cloud operations, and a formal security/compliance pass.

## Version 69 — Production Cutover

### Objective
Execute the final production cutover — the remaining on-prem traffic (if any regions/services haven't already moved per v60/v63) is fully routed to AWS.

### Banking Features Added
**None.**

### Topics
- DNS Cutover (Route 53, extending v61's health-check-driven routing to a full traffic switch)
- Data Synchronization (final delta sync between any remaining on-prem data store and RDS/S3 before the last cutover step)
- Final Migration, Rollback Plan, Validation

### Cutover Mechanics
Reuses Part-7 v47's incremental canary traffic-shifting discipline (5% → 25% → 50% → 100%) and connection-draining/session-continuity proof points — applied here to the on-prem→AWS cutover rather than an old-platform→new-platform WebSphere version cutover. The mechanics are identical; only the two environments being cut over between have changed.

### WebSphere Topics Covered
Session continuity across the on-prem/AWS boundary during cutover (extends Part-1 v9/Part-5 v36/Part-7 v47's session-replication proof points one final time)

### Enterprise Learning
Cloud Migration Cutover Discipline, Zero-Downtime Cloud Transition

**Sprint Deliverable:** A full production cutover completes via incremental canary traffic shifting with zero customer-visible downtime; a mid-cutover session is proven to survive the on-prem→AWS boundary; a deliberate rollback is exercised at the 25% stage, proving on-prem can still take 100% of traffic back cleanly; final data synchronization is confirmed with zero data loss (RPO 0, per Part-5 v37's Fund Transfer RPO/RTO table, now measured against the AWS cutover instead of the DR site). **Update the Progress Log's "AWS Migration Cutover Status" table with each region's final cutover % as this version progresses.**

---

## Version 70 — Disaster Recovery on AWS

### Objective
Re-establish DR — previously a second on-prem data center (Part-5 v37: Hyderabad ↔ Bangalore) — as a cloud-native, multi-region AWS pattern.

### Banking Features Added
**None.**

### Topics
Multi-Region DR, Cross-Region Replication (RDS cross-region read replica / snapshot copy, S3 Cross-Region Replication from v65), Backup Strategy (AWS Backup, extending v62), Recovery Testing

### RPO/RTO Re-Validation
Reuses Part-5 v37's exact Fund Transfer/Login/Notification/Reporting RPO/RTO table — the targets don't change because the DR mechanism moved from a second physical DC to a second AWS region; this version's Sprint Deliverable is measured against that same table.

### WebSphere Topics Covered
DR failover mechanics re-verified once more, now between AWS regions instead of between an on-prem primary and DR site.

### Enterprise Learning
Cloud-Native Disaster Recovery, Multi-Region Architecture, Recovery Testing Discipline

**Sprint Deliverable:** A full planned failover from the primary AWS region to a secondary AWS region is executed and measured against Part-5 v37's RPO/RTO table (Fund Transfer recovers within 15 minutes, zero data loss); an unplanned-failure simulation is also run; failback to the primary region is performed once it's confirmed healthy — all verified via the same Grafana/Prometheus/Jaeger stack used for every prior DR drill in this project.

---

## Version 71 — Cloud Operations

### Objective
Establish ongoing operational discipline for the fully-AWS estate — cost, configuration compliance, and auditing — as distinct from the incident/patch-focused operations already covered in v62.

### Banking Features Added
**None.**

### Topics
- **Cost Optimization**, expanded per the Phase Review fold-in: **Cost Explorer**, **Budgets**, **Savings Plans** (concept), **Reserved Instances** (concept), **Tagging Strategy** (a consistent resource-tagging convention — `Project=DigiStack`, `Environment=`, `Region=` — applied retroactively to every resource introduced since v54, documented in `SetupDoc-v71.md`)
- **Trusted Advisor** (concepts)
- AWS Config (configuration compliance — the AWS-native equivalent of Part-6 v43's golden cell template/configuration drift detection, applied to AWS resource configuration rather than WAS cell configuration)
- CloudWatch Dashboards, CloudTrail Auditing
- Operational Excellence (as an AWS Well-Architected pillar, referenced by name so it's a recognizable interview topic)
- **Configuration sprawl audit** (added per 2026-07-19 architect review, Finding #14) — distinct from drift *detection* (v43/AWS Config, above): a periodic review of the golden cell template and its AWS/on-prem counterparts for orphaned JVM custom properties, unused DataSources from retired experiments, and stale JAAS auth aliases accumulated across 71 versions and 3 regions. Drift detection asks "have we diverged from the template"; this asks "does the template itself still need everything in it." Retire anything unused, documented in `SetupDoc-v71.md`.

### WebSphere Topics Covered
None directly — this version is cloud-resource operations, not WebSphere configuration.

### Enterprise Learning
Cloud Cost Governance, Configuration Compliance at Scale, Operational Excellence as a Framework

**Sprint Deliverable:** A consistent tagging strategy is applied across every AWS resource provisioned since v54, and a Cost Explorer report broken down by tag is generated; AWS Config flags a deliberately drifted resource (e.g., a Security Group rule manually widened outside of IaC) against its expected baseline, mirroring Part-6 v43's drift-detection deliverable; a Budgets alert fires on a deliberately exceeded threshold.

---

## Version 72 — AWS Security & Compliance

### Objective
Perform a formal security and compliance validation pass across the entire AWS estate before the final capstone — closing the loop on v67's Security Modernization with an audit-style review rather than a build-time checklist.

### Banking Features Added
**None.**

### Topics
- Security Hub (concepts)
- IAM Best Practices (re-audit of v54/v56/v67's roles and policies against least-privilege)
- Encryption (re-confirmation of v67's at-rest/in-transit coverage, no gaps)
- Compliance (mapping DigiStack Bank's controls to a representative framework — e.g., PCI-DSS-style control categories relevant to a bank — at a conceptual/documentation level, not a real certification)
- Logging, Audit (CloudTrail completeness check — every management-plane action across every account from v56 onward is confirmed logged and retained)
- **Log PII masking re-verification** (added per 2026-07-19 architect review, Finding #8) — confirms the masking requirement established at Part-4 v31 (account numbers, Aadhaar/PAN, card numbers masked at point of emission) still holds true for logs now replicated into S3 (v65) across regions; this is the point in the roadmap where that requirement gets formally audited rather than assumed to still be working

### WebSphere Topics Covered
Security configuration migration re-audited one final time (extends Part-7 v46's Security Testing item to the AWS estate)

### Enterprise Learning
Security Auditing, Compliance Mapping, Continuous Security Validation

**Sprint Deliverable:** A documented security/compliance review confirms no IAM policy grants broader access than needed (least-privilege re-verified), every encryption-at-rest/in-transit checkpoint from v67 still holds, and CloudTrail logging is confirmed complete and retained per a defined retention policy across every account in the Landing Zone (v56); any finding is logged as a remediation item and at least one is fixed and re-verified as part of this version's own sign-off.

---

## Version 73 — AWS Enterprise Migration Capstone

### Objective
Confirm the complete transformation of DigiStack Bank to a fully AWS-native banking platform, exercising Phases 1–4 together as one governed program — the same "build, operate, simulate, validate" discipline Part-6 v43 established for multi-region, and Part-7 v48 established for platform migration, now applied to the cloud migration as a whole.

### Banking Features Added
**None.**

### Final Architecture
```
                          Users
                            │
                         Route 53
                            │
              Application Load Balancer
                            │
                  IBM HTTP Server
                            │
              WebSphere ND Cluster (EC2)
                            │
                     DigiStack CBS
                            │
              Amazon RDS for PostgreSQL
                            │
                        Amazon S3
                            │
                 Amazon SQS / SNS  (hybrid with retained IBM MQ flows, per v66)
                            │
                       CloudWatch
                            │
                       CloudTrail
                            │
                AWS Systems Manager
                            │
                       AWS Backup
```
*(The final architecture adds an explicit **AWS Backup** stage at the base — flagged in the Phase Review as missing from the original draft's final diagram — reflecting that a production banking environment's architecture diagram should show its backup posture as a first-class element, not an implied afterthought.)*

### AWS Well-Architected Framework Alignment
The final architecture above is reviewed against all five Well-Architected pillars, tying together work already done in earlier versions rather than introducing new scope:
- **Operational Excellence** — v62/v71 (Systems Manager automation, AWS Config, runbooks-as-code)
- **Security** — v67/v72 (IAM least-privilege, Secrets Manager/KMS/ACM, formal audit pass)
- **Reliability** — v61/v70 (Multi-AZ HA, multi-region DR, RPO/RTO validated)
- **Performance Efficiency** — v63/v68's before/after performance baselining, RDS read replicas (v64)
- **Cost Optimization** — v71 (tagging, budgets, Cost Explorer, Savings Plans/Reserved Instances concepts)

This mapping is documented once, here, in `SetupDoc-v73.md` — each pillar is satisfied by a version already built, not retrofitted at the capstone.

### Migration Success Criteria (mirrors Part-7 v48's shape, applied to the cloud migration)
Not complete until every item below is true simultaneously:
- No open Critical/High defects across the AWS estate
- All 9 applications available and passing health checks (Part-4 v31's `/health` endpoints, now polled against the AWS-hosted estate)
- Performance within the baseline established across v63/v68 (no unexplained regression)
- Security validated per v72's audit, with all findings remediated or explicitly accepted-risk documented
- DR tested per v70, RPO/RTO targets met
- Cost governance (v71) operating — tagging complete, budgets configured
- Backup completed and restorable (AWS Backup, full inventory)
- On-prem infrastructure for every migrated region formally decommissioned (per v63/v69's observation-window discipline) — not merely idle

### Promotion Note (added 2026-07-19 cross-file audit)
Per doc 04's "Phased Cloud Migration Promotion" section, **this is the version after which Part-9's actual Dev→UAT→Prod promotion happens** — once, across all three regions sequentially, using the standard Prod Promotion Checklist. `part9-release` is applied on `main` only once every region's row in the Progress Log's "AWS Migration Cutover Status" table reads "Cut over — old on-prem decommissioned" **and** every region has independently completed that checklist — mirroring the same "no two-of-three mostly-promoted state" rule already established for Parts 6 and 7.

### WebSphere Topics Covered
Everything from Versions 54–72, exercised together as one governed program; Cloud Migration Governance, Full-Lifecycle Cloud Transformation

### Enterprise Learning
Enterprise Cloud Migration Program Management, End-to-End AWS Architecture, Full Lifecycle Change Governance (cloud-specific)

**Sprint Deliverable:** All Migration Success Criteria above are demonstrated true simultaneously, with real evidence (not placeholders) for each; the final architecture diagram is confirmed to match what's actually running, end to end, from a live request through to CloudTrail/Backup; a single retrospective document captures what changed at each phase and confirms the Standing Architectural Note's promise held throughout — **DigiStack Bank's applications never changed; only the platform beneath them did.**

---

## ✅ Part-9 Completion Checkpoint

Before starting Part-10 (Containerization) or whichever Part follows, confirm:

- [ ] AWS Foundation (VPC, IAM, EC2 basics), hybrid connectivity, Landing Zone, and hybrid monitoring all operational and validated as one working hybrid platform (v54–v57)
- [ ] Phase-1 gate passed: hybrid operations (monitoring, backup, connectivity, management) proven functional with the application still fully on-prem (v58) — Dev-only gate, per doc 04's Phased Cloud Migration Promotion rules
- [ ] Full WebSphere/IHS/MQ/PostgreSQL stack running on EC2, matching on-prem behavior via full regression (v59)
- [ ] Hybrid production topology proven (at least one app on AWS, rest on-prem, integrated live) (v60)
- [ ] Multi-AZ HA proven on AWS, equivalent to Part-5 v36's on-prem HA bar (v61)
- [ ] AWS-native operations (CloudWatch/CloudTrail/SNS/Systems Manager incl. Run Command/Session Manager/Patch Manager/Automation Documents/State Manager) operational (v62)
- [ ] Phase-2 gate passed: full estate running on EC2, full regression pass, on-prem decommissioned per region with a clean observation window (v63) — Dev-only gate; decommissioning itself tracked in the Progress Log's AWS Migration Cutover Status table
- [ ] PostgreSQL migrated to Amazon RDS for PostgreSQL (not MySQL — corrected), Multi-AZ/read-replica/failover all proven (v64)
- [ ] Application file storage migrated to S3 with lifecycle/versioning/cross-region replication proven (v65)
- [ ] Messaging modernization decision (IBM MQ retained vs. SQS/SNS migrated) explicitly documented and implemented per the decision framework, not assumed (v66)
- [ ] Security modernization complete: IAM least-privilege/instance profiles, Secrets Manager, KMS, ACM, WAF/Shield/GuardDuty concepts, encryption at rest/in transit all confirmed (v67)
- [ ] Phase-3 gate passed: full regression against the modernized platform, Migration Success Criteria checklist clean (v68) — Dev-only gate
- [ ] Full production cutover executed via incremental canary shifting, zero-downtime, rollback proven mid-cutover (v69)
- [ ] Multi-region AWS DR proven against Part-5 v37's RPO/RTO table (v70)
- [ ] Cost governance (tagging, budgets, Cost Explorer) and configuration compliance (AWS Config drift detection) operational (v71)
- [ ] Formal security/compliance audit pass completed with findings remediated (v72)
- [ ] Final Migration Success Criteria (v73) demonstrated true simultaneously, with the final architecture diagram matching actual running state
- [ ] All twenty versions' `TestCases-v54.md`–`v73.md` signed off per Test Case Standards
- [ ] Cloud Resource Inventory (new, this Part) and doc 07 §6/§7 (Port Matrix, Certificate Inventory) updated with every AWS resource/endpoint/cert introduced
- [ ] Progress Log's "AWS Migration Cutover Status" table shows every region as "Cut over — old on-prem decommissioned"
- [ ] Part-9 promoted Dev → UAT → Prod per Environment Promotion Standards **once, at the end** (per doc 04's Phased Cloud Migration Promotion section), `part9-release` tag applied, via the Part-8 v53 automated pipeline (the first Part actually promoted through that pipeline rather than manually, per Part-8's closing note)

**Carried forward into whichever Part follows:** DigiStack Bank now runs entirely on AWS-native infrastructure (EC2, RDS for PostgreSQL, S3, SQS/SNS-hybrid-with-retained-MQ). Any future Part (e.g., Part-10 Containerization) assumes this as the current baseline — the pre-migration on-prem/VM-based estate is retained only as historical record, per the same explicit transition rule Part-7 established for its own platform migration.

---

## Application State After Part-9

**Application code:** unchanged from Part-8 (`digistack-bank` family of 7 EARs + Mobile/ATM Tomcat WARs) — **zero new banking functionality was added in this Part.**

**Platform Changes**
- Full AWS Foundation: VPC, IAM, multi-account Landing Zone, hybrid connectivity to on-prem (v54–v56)
- Observability extended (not replaced) to cover AWS + hybrid link (v57)
- WebSphere/IHS/MQ/PostgreSQL fully lifted onto EC2, Multi-AZ HA, AWS-native operations tooling (v59–v62)
- PostgreSQL modernized to Amazon RDS for PostgreSQL; storage modernized to S3; messaging modernized to a deliberate IBM MQ/SQS-SNS hybrid; security modernized to IAM/Secrets Manager/KMS/ACM (v64–v67)
- Full production cutover to AWS complete; DR re-established as multi-region AWS; cost governance and formal security/compliance audit operational (v69–v72)
- On-prem infrastructure formally decommissioned per region, following the same observation-window discipline established in Part-7

This is the starting point for whichever Part comes next (e.g., a future containerization Part, building on the now fully-AWS-native estate).

**Explicit transition rule:** every Part from this point forward assumes the **AWS-native platform** (EC2, RDS for PostgreSQL, S3, hybrid SQS/SNS+MQ, IAM/Secrets Manager/KMS/ACM) as the current state. The pre-migration on-prem estate is retained only as historical record — it is not referenced as "current," "existing," or a fallback in any future Part's roadmap text, request-flow diagrams, or resource inventory, except where a future chat explicitly needs migration history for context.

---

*This document is Part-9 of the DigiStack Bank Roadmap (Versions 54–73: Enterprise Hybrid Cloud & AWS Migration). See Part-1 for Versions 1–14, Part-2 for Versions 15–22, Part-3 for Versions 23–30, Part-4 for Versions 31–35, Part-5 for Versions 36–38, Part-6 for Versions 39–43, Part-7 for Versions 44–48, Part-8 for Versions 49–53, and the MASTER INDEX for full navigation.*

---

**Change log for this revision (2026-07-19 cross-file audit):**
- Added an explicit "Git note" near the top stating `release/part-9` is cut per doc 02's rule (Finding F11) — previously implied but never stated, unlike Parts 6–8.
- Added "Promotion Note" callouts to v58, v63, v68, and v73 clarifying which are Dev-only internal gates vs. the actual once-at-the-end Part-level promotion (per the new doc 04 "Phased Cloud Migration Promotion" section, Finding F3).
- Added cutover-tracking reminders to v60, v63, and v69 pointing at the Progress Log's new "AWS Migration Cutover Status" table (Finding F4).
- Noted doc 01 now cross-references this Part's Cloud Resource Inventory in both directions (Finding F5).
- Updated the Completion Checkpoint to reflect all of the above.
