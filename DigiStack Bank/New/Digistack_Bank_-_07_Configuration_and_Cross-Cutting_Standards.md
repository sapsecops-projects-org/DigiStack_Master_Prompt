# DigiStack Bank — Configuration & Cross-Cutting Standards

**Applies to:** Every version, every part — but especially Part-3 onward, once the single-EAR world becomes a 9-deployable, multi-service world. This file sits alongside docs 01–06 as a standing standard (per MASTER INDEX). Upload it alongside the MASTER INDEX and from Part-3 onward.

---

## 1. EAR / Deployable Naming Standard

Part-1/2 used one deployable: `digistack-bank-v<N>.ear`. From Version 23 onward there are multiple independent deployables, and naming has been ad hoc. Standardizing now, before v23 is built:

| Application | EAR/App Name |
|---|---|
| Internet Banking Portal | `digistack-portal-v<N>.ear` |
| CBS | `digistack-cbs-v<N>.ear` |
| Payment Hub | `digistack-paymenthub-v<N>.ear` |
| Notification Service | `digistack-notification-v<N>.ear` |
| Reporting Service | `digistack-reporting-v<N>.ear` |
| Branch Portal | `digistack-branch-v<N>.ear` |
| Card Portal | `digistack-cardportal-v<N>.ear` |
| Mobile Banking (Tomcat, .war) | `digistack-mobile-v<N>.war` |
| ATM Simulator (Tomcat, .war) | `digistack-atm-v<N>.war` |

**Rule:** `<N>` is always the roadmap Version number in which that deployable last changed — not a per-app independent counter. E.g. if Payment Hub is untouched between v25 and v29, its EAR filename stays `digistack-paymenthub-v25.ear` until a version actually modifies it. This keeps the filename traceable to "what version last touched this," consistent with how Git Standards (doc 02) ties tags to version numbers.

Retroactively applies to Part-3 (v23–v30) since none of those EARs have been built yet — no renumbering conflict, per Engineering Standards §7.

> **Duplication note (added 2026-07-19):** this exact table is intentionally duplicated in doc 02 (Git Standards) §"EAR / Deployable Naming Standard." If you ever edit this table, mirror the edit into doc 02 in the same sitting.

---

## 2. Database Migration Scope After Version 23

Add to Part-3, immediately after Version 23's Migration & Relocation Notes:

> **Beginning Version 24, all schema changes occur only inside `digistack_cbs`.** The legacy Portal/shared database (used by Parts 1–2) is frozen at the moment of v23's migration and is never targeted by any migration script numbered V24 or higher. It is retained read-only only as long as needed for migration verification/rollback (per v23's rollback note), then formally retired and decommissioned — its decommission step should be captured in `SetupDoc-v23.md`, not silently assumed.

This closes the gap in doc 05 (DB Deployment Standards), which defines the migration convention but never states which database is authoritative after the CBS split.

---

## 3. Deployment Dependency / Startup-Order Matrix

Required before any Part-3 UAT/Prod promotion (doc 04). Startup order (and reverse for shutdown):

```
1. Infrastructure   — VMs, networking, LB, IHS, Tomcat host up
2. Database         — PostgreSQL (digistack_cbs + legacy, until retired)
3. MQ                — IBM MQ Queue Manager
4. CBS               — must be up before any service that calls it
5. Payment Hub       — depends on CBS
6. Notification Service — depends on CBS (event consumer) + MQ
7. Reporting Service — depends on CBS (data consumer)
8. Internet Banking Portal — depends on CBS
9. Branch Portal     — depends on CBS
10. Card Portal      — depends on CBS's Card Service
11. Mobile Banking (Tomcat) — depends on CBS REST + IHS virtual host routing
12. ATM Simulator (Tomcat)  — depends on CBS REST/SOAP + IHS virtual host routing
```

**Rule:** No deployable starts before everything above it in the list is confirmed healthy (via the `/health` endpoints introduced in Part-4 v31, once that exists — until then, manual verification). This table belongs in doc 04 (Environment Promotion Standards) as a new subsection, and each `SetupDoc-v<N>.md` from v23 onward should reference it rather than restate it.

> **Duplication note (added 2026-07-19):** this exact table is intentionally duplicated in doc 04 §"Deployment Dependency / Startup-Order Matrix." If you ever edit this table, mirror the edit into doc 04 in the same sitting.

---

## 4. Configuration Standard (per Environment)

New standing rule: each deployable gets one properties file per environment, never hardcoded values.

```
/config
  application-dev.properties
  application-uat.properties
  application-prod.properties
```

**Region as an added dimension (Part-6, v39 onward):** once Singapore and Dubai exist alongside India, "environment" (Dev/UAT/Prod) and "region" (in/sg/ae) are two independent axes, not one combined counter — a given deployable can be `prod` in three regions simultaneously. Extend the naming to `application-<env>-<region>.properties` from v39 forward:

```
/config
  application-dev.properties          (unchanged — Dev stays single-region, per Environment Promotion Standards)
  application-uat-in.properties
  application-uat-sg.properties
  application-uat-ae.properties
  application-prod-in.properties
  application-prod-sg.properties
  application-prod-ae.properties
```

Each regional prod/UAT file differs only in region-specific values (regional DataSource JNDI target, regional MQ Queue Manager name, regional SSL alias) — everything else should be identical across regions, enforced by the golden cell template introduced in Part-6 v43.

**Each file defines, at minimum:**
- JNDI DataSource name(s) (e.g. `jdbc/CBSDataSource`)
- JNDI Mail Session name
- MQ Queue Manager name + connection factory JNDI name
- SIBus JMS connection factory JNDI name
- External service base URLs (CBS REST base URL, for Mobile/ATM/Card Portal to consume)
- SSL keystore/truststore aliases (not the actual cert — see §7 below)
- Log level (DEBUG/INFO/WARN, matching doc 04's existing table)
- Secrets: **never in these files** — placeholder references only (JAAS Auth Alias name, not the credential itself), per Git Standards' `.gitignore` rule already excluding `application.properties.local` and `*.env`

This extends the tiny config-diff table already in doc 04 into a full per-app standard, and should be committed to Git per-app (not per-environment-secret).

---

## 5. Service Dependency Diagram (static architecture view)

```
                    Mobile (Tomcat)   ATM (Tomcat)
                          │               │
                          └───────┬───────┘
                                  ▼
Internet Banking Portal ──►    CBS    ◄── Card Portal
                                  │            (Card Service only)
Branch Portal ───────────────────┤
                                  │
                    ┌─────────────┼──────────────┐
                    ▼             ▼              ▼
              Payment Hub    IBM MQ        Reporting Service
                    │             │
                    └──────►  Notification Service
                                  │
                                  ▼
                           digistack_cbs (sole writer: CBS)
```

This is a static complement to Part-3's per-version request-flow diagrams — one picture for "who calls whom," independent of any single transaction's path.

---

## 6. Enterprise Port Matrix

| Service | Port | Notes |
|---|---|---|
| IHS HTTP | 80 | Redirects to HTTPS (v11) |
| IHS HTTPS | 443 | |
| WAS Admin Console | 9060 | |
| WAS Admin Console (secure) | 9043 | |
| Application (WAS default) | 9080 | Per cluster member, offset per member |
| Application (WAS secure) | 9443 | |
| Tomcat HTTP | 8080 | Mobile/ATM, distinct instances/ports on `digistack-tomcat-01` |
| IBM MQ Listener | 1414 | |
| PostgreSQL | 5432 | Both legacy DB and `digistack_cbs` (same VM/instance unless split per doc 01) |
| Prometheus | 9090 | |
| Grafana | 3000 | |
| Jaeger UI | 16686 | |
| OpenSearch | 9200 | |
| OpenSearch Dashboards | 5601 | |
| PostgreSQL (DR standby) | 5432 | On `digistack-db-dr-01`; streaming replication port config documented in `SetupDoc-v37.md` |
| Jenkins | 8080 (HTTP) / 8443 (HTTPS) | On `digistack-gsvc-cicd-01` (Part-6 v39 VM); pipeline configured Part-8 v50 |
| Nexus | 8081 | On `digistack-gsvc-cicd-01` (Part-6 v39 VM); pipeline configured Part-8 v50 |

**Rule:** every new VM/service introduced in a future version must add its row here at the same time it's added to doc 01's VM inventory — the two tables should never drift apart. (`digistack-was-dr-01`, `digistack-db-dr-01`, `digistack-ihs-dr-01` — introduced Part-5 v37 — reuse the same port numbers as their Primary-site counterparts, since they're a mirrored topology, not new services. **Singapore/Dubai regional VMs — introduced Part-6 v39 — likewise reuse the same port numbers as their India counterparts, for the same reason: a replicated topology, not new services. Added per the 2026-07-19 cross-file audit.**)

---

## 7. Certificate Inventory

To be populated as each version actually generates/configures a cert (starting Part-1 v11). Standing template:

| Cert/Keystore | Used By | Type | Introduced | Renewal Cadence |
|---|---|---|---|---|
| IHS server cert | Browser ↔ IHS | Self-signed | v11 | Manual, document expiry date when generated |
| WAS plugin cert | IHS ↔ Plugin | Self-signed | v12 | Manual |
| AppServer cert | Plugin ↔ AppServer | Self-signed | v12 | Manual |
| DB mTLS cert | AppServer ↔ PostgreSQL | Self-signed | v12 (at least one hop) | Manual |
| MQ channel cert | CBS ↔ MQ (CHLAUTH/SSL) | Self-signed | v19 | Manual |
| Card/Mobile/ATM subdomain certs | IHS (per virtual host) | Self-signed | v26–v28 | Manual |
| Monitoring stack TLS (if enabled) | Prometheus/Grafana/Jaeger | Self-signed | v31–v33 | Manual |
| DR-site IHS/AppServer certs | Browser/Plugin ↔ DR site (Bangalore) | Self-signed, mirrors Primary | v37 | Manual — must be kept in sync with Primary-site cert renewal, per v37's Configuration Synchronization activity |
| DB replication cert (if SSL-enforced replication used) | Primary PostgreSQL ↔ DR standby | Self-signed | v37/v38 | Manual |
| Regional IHS/AppServer certs (Singapore, Dubai) | Browser/Plugin ↔ each new region | Self-signed, mirrors India-region pattern | v39 | Manual, per-region |
| Cross-region mTLS cert (inter-CBS) | Region CBS ↔ Region CBS (REST calls) | Signed by the Global Shared Services PKI (`digistack-gsvc-pki-01`), not self-signed per-hop | v41 | Manual — renewal must be coordinated across all three regions simultaneously, since a stale cert on any one side fails the mTLS handshake |
| Cross-region MQ TLS cert | Regional CBS ↔ MQ Hub (`digistack-gsvc-mqhub-01`) | Signed by Global Shared Services PKI | v41 | Manual, coordinated |
| LTPA key set (shared, not a cert but tracked here for the same reason) | All three regional WAS cells | Exported/imported key set, not self-signed per-cell | v42 | Manual — must be re-synchronized across all cells on rotation, per v42's LTPA Key Synchronization requirement; a cell holding a stale key set silently breaks SSO rather than failing loudly |
| AWS ACM-managed cert | Browser ↔ AWS-hosted ALB/IHS tier | AWS Certificate Manager (ACM)-issued, not self-signed | v67 | Automatic renewal (ACM-managed) — cross-referenced against on-prem self-signed certs above; does not replace them, only fronts the AWS-hosted tier introduced in Part-9 |

Actual expiry dates and keystore file locations get filled in per-version in the relevant `SetupDoc-v<N>.md`; this table is just the index of *what exists*, so a future version doesn't accidentally forget a hop needs its own cert.

---

## 8. Monitoring Ownership (RACI-style, introduced with Part-4)

| Layer | Tool | Owning Team (simulated) |
|---|---|---|
| Linux/OS | Node Exporter | Linux/Infra Team |
| WebSphere JVM | JMX Exporter, PMI, TPV | Middleware Team |
| Application (traces/health) | OpenTelemetry SDK, `/health` endpoints | Application Team |
| Database | PostgreSQL Exporter | DBA Team |
| Logs | Filebeat/Logstash/OpenSearch | Middleware + Ops Team (joint) |
| Alerts/Dashboards | Alertmanager, Grafana | Ops/SRE Team |
| Business KPIs (v34) | Business Dashboard | Application Team + Ops (joint) |

Since this is a solo-learner project, "team" here is a role you consciously switch into per task (per doc 04's "simulate the artifact even solo" pattern) — the value is practicing the separation of concerns, not literal staffing.

---

## 9. Load Testing Tooling & Monitoring Data Retention (added per 2026-07-19 architect review, Findings #11, #16)

**Load testing tool — standing choice:** **Apache JMeter.** "Load test" / "stress test" / "N concurrent users" appear repeatedly across Part-4 (v33, v35) and Part-9 (v61) without a named tool anywhere, which was inconsistent with this project's otherwise strict habit of naming exact tools for every capability. JMeter is the standing choice from Part-4 v33 onward — free, well-understood, and commonly paired with WebSphere in real shops. Add it to any future VM/tooling table alongside Ansible, Prometheus, etc.

**Monitoring data retention — standing policy, effective Part-4 v31/v32 onward:**

| Store | Retention | Notes |
|---|---|---|
| Prometheus | 30 days, local disk | Extend only if `digistack-monitoring-01`'s disk sizing (doc 01) is increased accordingly |
| OpenSearch (logs) | 90 days, weekly index rollover | Beyond 90 days: archive to S3 (Part-9 v65) rather than deleting outright, once that tier exists |
| Jaeger (traces) | 7 days | Traces are high-volume/low-long-term-value; short retention is standard practice |
| Grafana dashboards / Prometheus alert rules | Indefinite (config, not data) | Backed up per Part-5 v38's expanded backup inventory |

Without an explicit retention policy, unbounded metric/log/trace growth on lab-scale VM disk sizes (doc 01's 40–80 GB baseline) will eventually fill disk, especially once synthetic monitoring (Part-4 v34, every 5 minutes) and centralized logging across all 9 applications run continuously. `SetupDoc-v31.md` and `SetupDoc-v32.md` should implement these values explicitly, not leave retention at each tool's out-of-the-box default.

---

*This file is a standing standard, not tied to a specific part. Reference it alongside docs 01–06 from Part-3 onward, where the single-EAR world ends and multi-deployable configuration/ownership questions actually start mattering.*

---

**Change log for this revision (2026-07-19 cross-file audit):**
- §6: added a note that Part-6's Singapore/Dubai regional VMs reuse the same ports as their India counterparts, matching the existing DR-site note.
- §1 and §3: added duplication-drift warning notes cross-referencing doc 02 and doc 04 respectively.
