# DigiStack Bank — Roadmap Part-6

**Multi-Region Enterprise Banking & Middleware Architecture**

**Goal:** Build a globally distributed DigiStack Bank spanning multiple countries and data centers, learning the architecture and operational practices used by multinational banks — global traffic management, cross-region integration, federated identity, and the standing shared-services layer every region depends on.

**Prerequisite:** Part-5 Completion Checkpoint satisfied — HA (v36), DR (v37), and Business Continuity (v38) all operational at a single DR-paired site (Hyderabad ↔ Bangalore).

**Deployment model:** No new banking features are added in this Part. Every version extends the existing 9-application topology (Part-3) and its observability (Part-4) and HA/DR discipline (Part-5) from a single-site/single-DR-site model into a true multi-region model. The banking application itself is the same one built through Part-5 — this Part is entirely architecture, routing, integration, identity, and operations.

**Process for every version:** Requirements → Development/Configuration (beginner-level explanation) → Deployment & Admin across regional WAS cells → Testing → Documentation → **Pause for approval** before the next version.

**Per-version deliverables (per Master Index standing standards):** VM Setup section, Git-committed config/scripts, `TestCases-v<N>.md`, `SetupDoc-v<N>.md`, SQL migration script(s) only if a region-tracking table is added.

---

## ⚠️ Version Numbering Correction (resolved before this file is marked ready)

The draft material this Part was written from numbered its versions 38–42. **That collides with Part-5, which already owns and has frozen Versions 36–38** (per Engineering Standards §7 — Version Numbering Freeze: v38 is already "Business Continuity & Application Resilience"). Per the freeze rule, Part-6 is shifted forward so it starts immediately after Part-5 ends.

Because no version in the Part-6 draft had been implemented, and the only change is a uniform +1 shift with no internal reordering, this is a straightforward **offset**, not a historical renumbering of frozen content — a full mapping table (as required for Part-3/4/5's own renumbering passes, which *did* reorder or split versions) isn't necessary here. The offset is simply:

| Draft # | New # | Title |
|---|---|---|
| 38 | **39** | Multi-Region Banking Architecture |
| 39 | **40** | Global Traffic Management |
| 40 | **41** | Cross-Region Integration |
| 41 | **42** | Global Security & Identity Management |
| 42 | **43** | Enterprise Middleware Architect Capstone |

**Part-6 title, confirmed:** *Multi-Region Enterprise Banking & Middleware Architecture* is Part-6 (Option A from the MASTER INDEX's Open Decisions). This matches Part-5's existing "Carried forward into Part-6" note, which already assumes Part-6 is the multi-region Part — no edit needed there. **WebSphere Migration is deferred to a later Part** (e.g., Part-7), to be scoped when reached.

---

## Standing Architectural Layer — Global Shared Services

> Introduced here as a **persistent layer referenced in every diagram in this Part**, not as its own version. Three regions each running independent LDAP, CI/CD, and monitoring stacks would be duplicated infrastructure, not real multi-region architecture — real banks centralize exactly these services and let every region consume them.

```
                      Global Shared Services
────────────────────────────────────────────────────
 Enterprise LDAP          Enterprise PKI / CA
 Git                      Jenkins
 Nexus (Artifact Repo)    Enterprise Monitoring (Prometheus/Grafana)
 Enterprise Logging (ELK) ServiceNow (concepts)
 SMTP / SMS Gateway       NTP
 DNS                      IBM MQ Hub (cross-region messaging backbone)
────────────────────────────────────────────────────
                 consumed by every region ↓
```

**Rule:** every region-specific diagram from Version 39 onward sits *underneath* this layer, not beside it. A regional CBS talks to its own regional database, but authenticates against the **same** federated identity layer (v42), ships logs/metrics to the **same** monitoring stack (Part-4, extended here to be multi-region-aware), and is built/deployed through the **same** Git/Jenkins/Nexus pipeline — regional independence is at the data and traffic-serving layer, not at the tooling layer.

This layer is referenced by filename cross-reference in each version below rather than repeated per-version — consistent with how doc 07 (Configuration & Cross-Cutting Standards) is referenced rather than duplicated elsewhere in the roadmap.

### ⚠️ Data Residency / Multi-Region Data Model — Explicit Decision (added per Senior Architect Review, Finding #9)

> Version 39 stands up each region with its own **independent** PostgreSQL Primary/Standby cluster, implying regional data silos. Version 41 then adds cross-region customer lookup and account verification, which only makes sense if a customer's data can legitimately be found from another region — implying the regions are not fully independent after all. This ambiguity is resolved here, before either version is built, since it materially changes what v41's deliverable actually does:
>
> **Resolution: data-residency model.** Each region's CIF (Customer Information File, Part-3 v24) is authoritative for its own region's customers — this is not one global customer table sharded by region, and there is no replicated global customer index anywhere in this design. **"Cross-region customer lookup" (v41) means a live query into a foreign region's CBS, over the v41 mTLS-secured REST channel, at the moment it's needed** — not a query against a local, eventually-consistent copy of another region's data. This mirrors how real multi-country banks commonly operate under data-residency regulation: a customer's data legitimately lives in one region, and other regions reach it live, on demand, rather than replicating it wholesale. If a future version needs different semantics (e.g., a genuinely global customer able to transact identically from any region), that is a new, explicitly-scoped data-model change — not something to assume silently follows from v41's lookup feature as written.

---

## Version 39 — Multi-Region Banking Architecture

### Objective
Expand DigiStack Bank from a single-country (Hyderabad + Bangalore DR) deployment into a true multi-region platform, with independent, fully-functioning regional deployments.

### Banking Features Added
**None.** This version replicates the existing 9-application topology (Part-3) into two additional regions — it is an infrastructure/architecture exercise, not a new feature set.

### Regions
- 🇮🇳 India (existing Hyderabad site becomes the India region; Bangalore remains its DR pair per Part-5)
- 🇸🇬 Singapore (new region)
- 🇦🇪 Dubai (new region)

### Regional Components (per region)
- Enterprise Load Balancer
- IBM HTTP Server
- WebSphere ND Cell (Portal, CBS, Payment Hub, Notification Service, Reporting Service, Branch Portal, Card Portal — same 7 EARs as Part-3, plus Mobile/ATM Tomcat apps)
- DigiStack CBS
- **Regional PostgreSQL Cluster** — Primary + Standby (streaming replication), not a single database instance. This preserves continuity with the Primary/Standby pattern already established for DR in Part-5 v37, rather than introducing a second, inconsistent replication model for regional data.

### Architecture
```
                             Global Users
                                  │
                          Global DNS / GSLB
                                  │
      ┌───────────────────────────┼───────────────────────────┐
      ▼                           ▼                           ▼
 India Region               Singapore Region             Dubai Region
      │                           │                           │
Enterprise LB                Enterprise LB               Enterprise LB
      │                           │                           │
IBM HTTP Server Cluster   IBM HTTP Server Cluster   IBM HTTP Server Cluster
      │                           │                           │
WebSphere ND Cell          WebSphere ND Cell          WebSphere ND Cell
      │                           │                           │
DigiStack CBS               DigiStack CBS               DigiStack CBS
      │                           │                           │
Regional PostgreSQL         Regional PostgreSQL         Regional PostgreSQL
   Cluster                     Cluster                     Cluster
 (Primary/Standby)          (Primary/Standby)          (Primary/Standby)

──────────────────────────────────────────────────────────────────────────
                      Global Shared Services (see standing layer above)
──────────────────────────────────────────────────────────────────────────
```

### WebSphere Topics Covered
- Multi-Cell Architecture, Cell Isolation, Regional Deployments, Environment Management

### Enterprise Learning
- Global Architecture, Multi-Region Deployment, Regional Operations

**Sprint Deliverable:** Three independent regional deployments (India, Singapore, Dubai) are each fully operational — own LB, IHS, WAS cell, CBS, and Primary/Standby PostgreSQL cluster — each capable of serving banking traffic in complete isolation from the other two, with no cross-region dependency yet (that's v41).

---

## Version 40 — Global Traffic Management

### Objective
Route users to the nearest healthy region and fail over cleanly when a region becomes unhealthy.

### Banking Features Added
**None.**

### Enterprise Components
- Global DNS
- Global Server Load Balancing (GSLB)
- Health Checks (see below — reused, not reinvented)
- Regional Failover
- User Routing

### Health Check Design — Reuses Existing Mechanisms
> Rather than introducing a new, parallel health-check scheme, GSLB routing decisions are driven by the exact health signals already built earlier in the roadmap:

| Layer | Mechanism | Source |
|---|---|---|
| Application Health | `/health` liveness/readiness endpoint | Part-4, Version 31 |
| WebSphere Health | Cluster member status | Part-1 v5 clustering, Part-5 v36 HA |
| Database Health | PostgreSQL connectivity + replication lag | Part-5 v37/v38 streaming replication |

GSLB polls these same endpoints per region rather than a bespoke probe — a region is only considered healthy if all three layers report healthy, consistent with the existing observability stack rather than a duplicate one.

### Example Routing
```
User from India     → India DC
User from Singapore  → Singapore DC
User from UAE        → Dubai DC
India DC unavailable → routes to Singapore DC (nearest healthy region)
```

### Architecture
```
Users
   │
Global DNS
   │
Global Server Load Balancer (GSLB)
   │
   ├── Health Probe: /health (v31) ──► Application Health
   ├── Health Probe: Cluster Status ──► WebSphere Health
   └── Health Probe: Replication Lag ──► Database Health
   │
───────────────
│      │      │
▼      ▼      ▼
India Singapore Dubai
```

### WebSphere Topics Covered
- Health Policies (extended from Part-4 v31 and Part-5 v36), Cluster Health Reporting

### Enterprise Learning
- Geo Routing, Regional Failover, Traffic Engineering

**Sprint Deliverable:** GSLB correctly routes a simulated user in each region to their own regional DC under normal conditions; a deliberate India-region health-check failure (across all three layers) causes GSLB to fail traffic over to Singapore within the defined detection window, verified through the same Grafana/Prometheus dashboards used in Part-4/Part-5 — not a separate monitoring view.

---

## Version 41 — Cross-Region Integration

### Objective
Allow secure communication between regional banking systems for the specific cases where a customer or operation legitimately spans regions.

### Banking Features Added
**None** (integration only — no new banking transaction types).

### Features
- Cross-region customer lookup
- Cross-region account verification
- Cross-region reporting
- Regional service APIs
- Central notification service (consumes events from all three regions via the Global Shared Services' MQ Hub)

### Security Model — Explicit, Not Generic
> Cross-region traffic is never sent in the clear or over unauthenticated channels. Building directly on Part-1 v12's end-to-end mTLS work (rather than introducing a new trust model for inter-region calls):

- **Mutual TLS (mTLS)** between regions for all service-to-service calls
- **REST APIs over HTTPS** exclusively — no plain HTTP cross-region path, ever
- **IBM MQ channels secured with TLS** for the cross-region messaging backbone (Global Shared Services' MQ Hub)
- **Certificate-based trust** between regional Certificate Authorities, tying into doc 07 §7's Certificate Inventory (extended here with cross-region entries)

### Architecture
```
India CBS
    │
REST (HTTPS + mTLS) / IBM MQ (TLS)
    │
Singapore CBS
    │
REST (HTTPS + mTLS) / IBM MQ (TLS)
    │
Dubai CBS
```

### WebSphere Topics Covered
- Cross-Cell Communication, IBM MQ Across Regions, Secure REST APIs (mTLS), Service Federation

### Enterprise Learning
- Enterprise Integration, Cross-Region Services, Distributed Systems

**Sprint Deliverable:** A cross-region customer lookup (e.g., an India customer verified against Singapore's CIF) succeeds only over an mTLS-authenticated REST call; a cross-region MQ message (e.g., a central notification triggered by a Dubai transaction) is confirmed encrypted in transit; a deliberately mismatched/expired cross-region certificate is proven to fail the connection, not silently degrade to an insecure fallback.

---

## Version 42 — Global Security & Identity Management

### Objective
Provide centralized authentication and consistent security across all regions, so a single identity works everywhere rather than each region maintaining its own user store.

### Banking Features Added
**None.**

### Features
- Central LDAP (concepts, part of Global Shared Services)
- Single Sign-On (SSO)
- **LTPA Token Sharing** across regional cells
- **LTPA Key Synchronization** — called out explicitly as its own subsection below, not folded silently into "SSL Trust"
- **Trust Association Interceptor (TAI)** — concept-level
- Certificate Management (cross-references v41's cross-region certificate trust)
- Regional Role Mapping
- Audit Consolidation

### LTPA Key Synchronization — Why It Gets Its Own Subsection
Single Sign-On across India/Singapore/Dubai cells depends entirely on every cell trusting the same LTPA keys. If keys are generated independently per cell (the default), a token issued by India is rejected by Singapore, and SSO silently fails — often the least obvious failure mode to debug in a federated WebSphere environment, and a recurring real-world interview topic. This version's deliverable explicitly proves keys are exported from one cell and imported into the other two, not merely that each cell has *a* working LTPA configuration in isolation.

### ⚠️ Registry Migration Note (added per Senior Architect Review, Finding #7)

> Part-1 v10 introduced "File Registry (or LDAP)" for Customer/Administrator roles, without committing to which was actually built. This version introduces Central LDAP as part of Global Shared Services. If v10 was built as a **file-based registry**, this version is a clean cutover — there are no pre-existing user IDs/group mappings that need to survive the move, and that should be stated plainly in `SetupDoc-v42.md` rather than left ambiguous. If v10 was instead built directly against LDAP already, then this version's job is **federating** that existing LDAP into the new central/multi-region identity layer, and `SetupDoc-v42.md` must document how existing users/groups/role mappings carry over — UID/DN mapping mismatches between a standalone registry and a federated repository are a common real-world WebSphere security-realm migration failure mode, and this project should name that risk explicitly rather than silently assume a smooth cutover, consistent with how Part-7 treats the WAS *platform* migration.

### Trust Association Interceptor (TAI) — Concept
Covered at concept level only (no dedicated external SSO product installed, consistent with how Part-4 treats Dynatrace/AppDynamics/Instana as concepts-only): TAI is how WebSphere delegates authentication decisions to an external reverse-proxy or SSO product sitting in front of the application server, rather than performing authentication itself. Understanding where TAI fits relative to LTPA/SSO is the expected takeaway, not a working TAI deployment.

### Architecture
```
Users
   │
Identity Provider (Central LDAP + LTPA, part of Global Shared Services)
   │
───────────────
│      │      │
India Singapore Dubai
(each cell trusts the same synchronized LTPA keys)
```

### WebSphere Topics Covered
- Federated Repositories, LDAP, LTPA Across Cells (incl. Key Synchronization), SSL Trust Between Regions, Trust Association Interceptor (concept), Administrative Security

### Enterprise Learning
- Identity Federation, Global Authentication, Enterprise Security

**Sprint Deliverable:** A user authenticates once against the central identity provider and moves between India/Singapore/Dubai-hosted services without re-authenticating, proven by exporting/importing synchronized LTPA keys across all three cells (not just configuring each independently); a deliberately unsynchronized fourth cell is shown to reject the shared token, demonstrating why synchronization — not mere LTPA presence — is the actual requirement.

---

## Version 43 — Enterprise Middleware Architect Capstone

### Objective
Operate DigiStack Bank as if acting as the lead middleware architect for a global enterprise — build, operate, simulate failures across, and validate the full multi-region platform. This version also absorbs global configuration-management discipline, folded in here rather than as a separate fractional version.

### Banking Features Added
**None.**

### Global Configuration Management (folded in from the original "41A" recommendation)
> Rather than a separate version, configuration consistency across three regional cells is treated as part of what "operating" a global platform means — the natural home for it is this capstone, where build/operate/simulate/validate all come together.

- wsadmin automation across all three cells
- Configuration consistency — property files, environment variables
- Cell templates (a "golden" cell configuration each region's cell is built from)
- Standard JVM settings, shared SSL configuration, shared security policies (regional role mapping from v42 layered on top)
- Plugin standardization, DataSource standardization across regions
- **Configuration drift detection** — proving a manually-modified regional cell is caught and reconciled against the golden template, not just documented as a risk

### Activities

**Build**
- Multi-cell WebSphere topology
- Multi-region deployment
- Automated deployments (Jenkins/Git/Nexus, per Global Shared Services)
- Standardized configurations (golden cell template, above)

**Operate**
- Monitoring (multi-region-aware Grafana/Prometheus, extending Part-4)
- Logging (multi-region ELK, extending Part-4 v32)
- Incident response (extending Part-4 v35's runbook discipline to a regional/global scope)
- Change management
- Capacity planning (per-region, extending Part-4 v35)

**Simulate**
- Regional outage (an entire region goes dark — GSLB from v40 must route around it)
- Node failure (reuses Part-1 v5/Part-5 v36 patterns, at regional scale)
- Database outage (reuses Part-5 v38's DB continuity patterns, per region)
- Certificate expiry (cross-region, from v41's trust model)
- IBM HTTP Server failure
- Cluster member failure
- Network partition (between regions — a new failure type not covered by Part-5's single-DR-pair taxonomy)
- DR failover (a full region acts as DR for another, extending Part-5 v37's two-site model to three regions)

**Validate**
- Zero-downtime deployment (extends Part-5 v38's rolling restart to a multi-region rollout)
- Rollback
- DR testing
- Backup validation
- Monitoring verification (per the standing Monitoring Verification requirement established in Part-5 v36–v38)

### Final Enterprise Architecture
```
                               Global Users
                                     │
                           Global DNS / GSLB
                                     │
        ┌────────────────────────────┼────────────────────────────┐
        ▼                            ▼                            ▼
   India Region                Singapore Region             Dubai Region
        │                            │                            │
   Enterprise LB                Enterprise LB               Enterprise LB
        │                            │                            │
 IBM HTTP Server Cluster     IBM HTTP Server Cluster    IBM HTTP Server Cluster
        │                            │                            │
 WebSphere ND Cell          WebSphere ND Cell          WebSphere ND Cell
        │                            │                            │
 ┌───────────────┬───────────────┐   (same pattern in each region)
 ▼               ▼               ▼
Internet Banking   CBS     ATM/Card/Branch/Payment Hub/Notification/Reporting
        │
 Regional PostgreSQL Cluster (Primary/Standby)

──────────────────────────────────────────────────────────────────────────
                      Global Shared Services
──────────────────────────────────────────────────────────────────────────
 Enterprise LDAP | PKI | Git | Jenkins | Nexus | IBM MQ Hub
 Prometheus | Grafana | ELK | ServiceNow (concepts) | SMTP/SMS | NTP | DNS
──────────────────────────────────────────────────────────────────────────
```

### WebSphere Topics Covered
- Everything from Versions 39–42, exercised together under simulated failure conditions
- Configuration Drift, Configuration Compliance, Golden Configuration, Infrastructure Standardization

### Enterprise Learning
- Global Enterprise Architecture (end-to-end), Multi-Region Operations, Infrastructure Standardization, Global Incident Response, Capacity Planning at Scale

**Sprint Deliverable:** A simulated full regional outage (India) is detected and routed around by GSLB within the defined window, with zero-downtime failover to Singapore/Dubai for in-flight sessions where technically possible; a deliberately drifted regional cell configuration is detected against the golden template and reconciled; a full DR failover using one region as DR for another is executed and measured, extending the RPO/RTO discipline from Part-5 v37 to a three-region scale; all outcomes are confirmed through the existing multi-region-aware observability stack, per the standing Monitoring Verification requirement.

---

## ✅ Part-6 Completion Checkpoint

- [ ] Three independent regional deployments (India, Singapore, Dubai) operational, each with its own Enterprise LB, IHS, WAS cell, CBS, and Primary/Standby PostgreSQL cluster (v39)
- [ ] GSLB routes users to their nearest region and fails over correctly, driven by the reused `/health` (v31), cluster-health (v36), and replication-lag (v37/v38) signals — not a new health mechanism (v40)
- [ ] Cross-region customer lookup, account verification, and reporting all function exclusively over mTLS REST and TLS-secured MQ, with a deliberate certificate mismatch proven to fail closed, not open (v41)
- [ ] SSO functions across all three regional cells via synchronized (not merely present) LTPA keys; a deliberately unsynchronized cell is shown to reject the shared token (v42)
- [ ] Global Shared Services layer (LDAP, PKI, Git, Jenkins, Nexus, monitoring, logging, ServiceNow concepts, SMTP/SMS, NTP, DNS, MQ Hub) is referenced consistently across every region's diagram, not duplicated per-region
- [ ] Golden cell configuration template established; configuration drift on a regional cell detected and reconciled (v43)
- [ ] All "Simulate" scenarios in v43 (regional outage, node failure, DB outage, cert expiry, IHS failure, cluster member failure, network partition, DR failover) run at least once with recorded outcomes
- [ ] Zero-downtime multi-region deployment and rollback both proven (v43)
- [ ] All five versions' `TestCases-v39.md`–`v43.md` signed off per Test Case Standards
- [ ] VM inventory (doc 01) updated with regional VM sets for Singapore and Dubai, plus any new Global Shared Services VMs
- [ ] Part-6 promoted Dev → UAT → Prod per Environment Promotion Standards, `part6-release` tag applied

**Carried forward into Part-7:** The multi-region topology, Global Shared Services layer, and golden-configuration discipline built here become the foundation for whatever Part-7 covers next (e.g., WebSphere Migration, deferred from this Part per the title-conflict resolution above).

---

## Application State After Part-6

**Application code:** unchanged from Part-5 (`digistack-bank` family of EARs + Mobile/ATM Tomcat apps), now deployed identically across three regions instead of one.

**New Infrastructure**
- Singapore and Dubai regional deployments, each mirroring the India (former single-site) topology (v39)
- Global DNS/GSLB routing layer (v40)
- Cross-region mTLS/TLS integration paths and central notification consumption (v41)
- Federated identity: central LDAP, synchronized LTPA, TAI concept (v42)
- Golden cell configuration template + drift detection; multi-region CI/CD (v43)
- Global Shared Services layer formalized as a standing architectural reference (LDAP, PKI, Git, Jenkins, Nexus, monitoring, logging, ServiceNow, SMTP/SMS, NTP, DNS, MQ Hub)

This is the starting point for whichever Part comes next.

---

*This document is Part-6 of the DigiStack Bank Roadmap (Versions 39–43: Multi-Region Enterprise Banking & Middleware Architecture). See Part-1 for Versions 1–14, Part-2 for Versions 15–22, Part-3 for Versions 23–30, Part-4 for Versions 31–35, Part-5 for Versions 36–38, and the MASTER INDEX for full navigation.*

---

**Change log for this revision (Senior Architect Review follow-up):**
- Added an explicit "Data Residency / Multi-Region Data Model" decision to the Standing Architectural Layer section, resolving the silo-vs-global ambiguity between v39 and v41, per Finding #9.
- Added a "Registry Migration Note" to Version 42, addressing the undefined file/LDAP → federated LDAP migration path, per Finding #7.
