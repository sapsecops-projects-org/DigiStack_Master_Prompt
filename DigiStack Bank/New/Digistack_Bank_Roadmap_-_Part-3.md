# DigiStack Bank — Roadmap Part-3

**Enterprise Banking Systems (CBS, Payments, Channel Simulators, Loans)**

**Goal:** Transform DigiStack Bank into a real enterprise banking platform where the Core Banking System (CBS) is the heart of all banking operations, with realistic external channel simulators (Mobile, ATM, Card Portal) integrating against it.

**Two-app architecture (evolves in this Part):**
- **DigiStack Banking Portal** — presentation layer ONLY. From Version 23 onward, it no longer touches the database directly — it calls CBS services exclusively.
- **DigiStack CBS (Core Banking System)** — becomes the **single system of record**. All customer/account/transaction data is owned and updated only through CBS.
- **NEW in this Part — Channel Simulators:** Mobile Banking and ATM are built as small, separate applications deployed on **Apache Tomcat** (not WebSphere), each under its own subdomain, each calling CBS via REST/SOAP exactly like any external client would. **Card Portal, by contrast, is deployed on WebSphere** — see the "Why Card Portal Belongs on WAS" note below. See the Channel Simulator Standard for the two Tomcat apps.
- **NEW in this Part — Satellite Services:** Payment Hub, Notification Service, and Reporting Service each become their own independent WebSphere applications (own EARs), rather than modules bolted onto CBS or Portal. See the Governing Rule and Ownership Matrix below.

**Process for every version:** Requirements → Development (beginner-level explanation) → Deployment & Admin in WAS/Tomcat → Testing → Documentation → **Pause for approval** before the next version.

**Prerequisite:** Part-2 Completion Checkpoint satisfied (full middleware stack — LB, IHS, WAS Cluster, SIBus JMS, IBM MQ, Web Services, Security Hardening, Monitoring — all operational).

**Per-version deliverables (per Master Index standing standards):** VM Setup section, Git-committed code, `TestCases-v<N>.md`, `SetupDoc-v<N>.md`, SQL migration script(s) where schema changes.

---

## 🔒 The One Governing Rule (introduced at Version 23, applies for the rest of the roadmap)

> **Only CBS writes to `digistack_cbs`. Every other application either invokes CBS services (synchronously, via REST/SOAP/EJB) or consumes CBS-published events (asynchronously, via JMS/MQ). No exceptions.**

Applied per service, from Version 23 onward:

| Service | Allowed | Never |
|---|---|---|
| **Payment Hub** | Routes payments, coordinates settlement | Never updates balances directly — settlement is confirmed back to CBS, which performs the actual write |
| **Notification Service** | Consumes events, sends SMS/Email | Never updates account balances |
| **Reporting Service** | Reads data, generates reports | Never updates business tables |
| **Branch Portal** | Invokes CBS services on the teller's behalf | Never touches `digistack_cbs` directly |
| **Mobile / ATM (Tomcat)** | REST/SOAP calls into CBS | Never touches `digistack_cbs` directly |
| **Card Portal (WAS)** | REST/SOAP calls into CBS's Card Service | Never touches `digistack_cbs` directly |

This rule is a standing footnote for every request-flow diagram in this Part and every Part after it — it's the thing that keeps the topology honest as more services are added.

---

## 🃏 Why Card Portal Belongs on WAS, Not Tomcat

Unlike Mobile Banking and ATM — genuinely external, lower-risk customer channels — the **Card Portal is treated as a bank-owned enterprise application** in this roadmap. It handles sensitive card lifecycle operations: Card Issue, Card Activation, Card Blocking, PIN Generation, PIN Reset, Card Replacement, Card Status, and Hotlisting. These are commonly hosted on enterprise middleware (WebSphere) rather than a lighter-weight servlet container, reflecting how real banks segregate card-management systems from consumer-facing channel apps. Accordingly, **Card Portal is deployed as its own WebSphere EAR** (`digistack-cardportal-vN.ear`) on the same ND cluster as Internet Banking Portal, CBS, Payment Hub, Notification Service, Reporting Service, and Branch Portal — not on Tomcat.

This raises the WAS EAR count to **seven** by end of Part-3, giving practice across: multiple EAR deployments, context roots, virtual hosts, classloader isolation, shared libraries, security roles, independent deployment/rollback per application, application startup order, cluster deployment, session management, and cross-application troubleshooting — all genuinely valuable, résumé-relevant WebSphere administration territory.

## 📱 Channel Simulator Standard (applies to Versions 26 and 27)

Per your direction, Mobile Banking and ATM are each built as a **small standalone app with a neat UI, deployed on Tomcat, under its own subdomain**, rather than as modules bolted onto the WAS-hosted CBS/Portal. Card Portal (Version 28) follows a different deployment model — see above — but reuses the same presentation-only guardrails.

| Application | Domain | Deployment | Version |
|---|---|---|---|
| Mobile Banking | `mobile.digistack.com` | Apache Tomcat | Version 26 |
| ATM Simulator | `atm.digistack.com` | Apache Tomcat | Version 27 |
| Card Portal | `card.digistack.com` | **WebSphere (own EAR)** | Version 28 |

**Why the Tomcat split is genuinely good WebSphere admin practice, not a detour:** Real banking estates are rarely single-vendor — WebSphere ND commonly coexists with lighter Tomcat instances for newer/lower-risk channels. The valuable admin skill here isn't Tomcat itself — it's configuring **IHS / the Enterprise Load Balancer to route distinct subdomains to a completely different backend server type**, alongside the existing WAS cluster. That's real heterogeneous-topology routing work. Card Portal's placement on WAS instead is the deliberate counterpoint: not every channel goes to the lighter tier, and knowing *which* ones don't (and why) is itself part of real architecture judgment.

**Shared guardrails for Mobile and ATM simulators:**
- **Presentation-only**, same rule as the main Portal — zero direct database access, all business logic and data access happens through CBS REST/SOAP calls (relocated to CBS in Version 23, originally built in Version 16, hardened in Version 17).
- **"Neat UI" means clean, minimal HTML5/CSS3/Bootstrap 5 — no heavy JS framework** (same standing tech constraint: no React/Angular/Vue). A neat UI is entirely achievable with well-structured Bootstrap 5 + a little vanilla JS.
- Tomcat installation/config is kept intentionally shallow — the learning focus stays on IHS/LB routing, virtual hosts, and cross-server topology, not deep Tomcat administration.
- Each simulator authenticates against CBS (reusing Version 17's MFA/OTP/session rules, now hosted by CBS per the Version 23 relocation) — none of them maintain their own separate user store.
- Each is its own Git repo or a clearly separated folder (`digistack-mobile`, `digistack-atm-sim`), per Git Standards. (Card Portal follows the same one-repo-per-application principle but as a WAS EAR project — see Version 28.)

**Shared request flow pattern (Mobile and ATM):**
```
Customer / Teller / ATM User
     │
     ▼
<subdomain>.digistack.com
     │
     ▼
Enterprise Load Balancer
     │
     ▼
IBM HTTP Server
     │
Virtual Host Routing Rule
(<subdomain> → Tomcat, NOT the WAS plugin)
     │
     ▼
Apache Tomcat
     │
     ▼
Simulator App (JSP/Servlet, Bootstrap 5 UI)
     │
REST/SOAP calls only
     ▼
DigiStack CBS (sole writer of digistack_cbs)
     │
     ▼
digistack_cbs Database
```

**Shared WebSphere/Enterprise topics across Mobile and ATM (Tomcat):**
- Heterogeneous backend routing (WAS + non-WAS Tomcat instances behind one IHS/LB tier)
- Virtual host configuration per subdomain, alongside existing WAS virtual hosts and Card Portal's own WAS-routed virtual host
- Reverse proxy rules distinguishing plugin-routed traffic (→ WAS, including Card Portal) vs. standard proxy-routed traffic (→ Tomcat)
- SSL/certificate handling for three additional subdomains on the same IHS instance (mobile, atm routed to Tomcat; card routed to the WAS plugin)
- Cross-server topology documentation and troubleshooting

---

## Enterprise Architecture (Introduced at Start of Part-3)

```
                    DigiStack Enterprise Banking

                           Customer Channels
     ┌──────────────┬──────────────┬─────────────┬─────────────┐
     │              │              │             │
     ▼              ▼              ▼             ▼
Internet Banking  Mobile Banking  ATM/POS    Card Portal / Branch Banking
(WAS/IHS)          (Tomcat)       (Tomcat)    (WAS/IHS)
     │              │              │             │
     └──────────────┴──────────────┴─────────────┘
                           │
                           ▼
                 DigiStack Core Banking System
                           (CBS)
                    (sole writer of digistack_cbs)
                           │
     ┌─────────────┬──────────────┬──────────────┐
     ▼             ▼              ▼              ▼
 Customer      Accounts      Transactions    Products
                           │
                           ▼
                     digistack_cbs Database
```

---

## Version 23 — Core Banking System (CBS)

### Objective
Develop DigiStack CBS, the central banking platform responsible for executing every banking transaction. After this version, Internet Banking will no longer access the database directly. Instead, it invokes CBS services, and CBS becomes the only system that updates customer accounts.

**This version is the architectural pivot point of the entire project.** Everything built across Parts 1–2 lived inside a single EAR with reasonable proximity to the database. From this version forward, ownership of data, endpoints, and infrastructure is explicitly transferred to CBS — see the Migration & Relocation Notes below. Nothing is silently dropped; every Part-1/Part-2 capability is accounted for.

### Banking Features Added
**Customer**
- Customer Information
- Customer Verification

**Accounts**
- Open Account
- Close Account

**Transactions**
- Deposit
- Withdrawal
- Balance Inquiry
- Fund Transfer
- Mini Statement

**Products**
- Savings Account
- Current Account

### Request Flow
```
Customer
     │
     ▼
Internet Banking
     │
   REST/SOAP
     ▼
DigiStack CBS
     │
Business Validation
     │
Transaction Manager
     │
CBS Database
     │
   Response
     │
Internet Banking
     │
Customer
```

### Database Architecture (New in This Version)
CBS gets its **own dedicated PostgreSQL database**: `digistack_cbs`, separate from the shared database used by the Portal in Parts 1–2. A new JDBC Provider and DataSource (`jdbc/CBSDataSource`) is configured in WAS specifically for this — separate connection pool sizing, separate JAAS auth alias from Part-1's pool. This mirrors real banking architecture, where the core banking database is isolated from channel-layer databases for security, blast-radius, and performance-tuning reasons.

### Migration & Relocation Notes

**1. Data Migration**
```
Portal (Shared Database, Part-1/Part-2)
        │
        ▼
Migration (V23__migrate_existing_data_to_cbs.sql)
        │
        ▼
digistack_cbs
        │
        ▼
Switch DataSource (jdbc/CBSDataSource)
        │
        ▼
CBS Live
```
A one-time migration script, following the standard `V<N>__<description>.sql` convention (per DB Deployment Standards), copies existing Customer, Account, Beneficiary, Fund Transfer, and Transaction History data from the shared Part-1/Part-2 database into `digistack_cbs`. Once verified, the Portal's DataSource is decommissioned entirely — the Portal retains no database connectivity of its own from this point forward.

**2. Service Relocation**
> The REST and SOAP services introduced in Version 16 relocate from the Banking Portal application to the CBS application. Existing clients continue using the same contracts — no breaking changes to endpoint paths, WSDL, or request/response shapes.

**3. Messaging Relocation**
> The SIBus, MDBs, JMS queues, and IBM MQ integrations introduced in Versions 15 and 19 are now hosted by CBS, since they represent business processing rather than presentation logic. The Portal no longer has any direct SIBus/MQ configuration.

**4. Notification & Reporting Relocation**
> The Withdraw-triggered email (v13) and Transaction Report (v14) — later joined by v16's SOAP Account Statement — are extracted from the single EAR into two new independent applications, **Notification Service** and **Reporting Service**, each consuming CBS-published events/data rather than querying the database directly. See "Satellite Services" note below; these are built out fully starting this version and referenced again through v25.

**Ownership Matrix (before/after this version):**

| Component | Before v23 | After v23 |
|---|---|---|
| Database Writes | Portal | CBS only |
| REST/SOAP Endpoints | Portal | CBS |
| SIBus / MDB | Portal | CBS |
| IBM MQ Business Processing | Portal | CBS |
| Authentication | Portal (own session/MFA) | Internet Banking authenticates users (login/MFA) and propagates a trusted identity (LTPA/JWT) to CBS; CBS performs authorization for business services |
| Notifications | Portal module (v13) | Notification Service (own EAR) |
| Reporting | Portal module (v14, v16 SOAP) | Reporting Service (own EAR) |
| Payment Processing (from v25) | — | Payment Hub (own EAR), routes only — never writes balances |

**EAR Naming (cross-reference — see doc 07 §1 for full table)**

> From this version onward there are multiple independent deployables, not one EAR. Use the standing naming convention: `digistack-cbs-v<N>.ear`, `digistack-portal-v<N>.ear`, etc., where `<N>` is the version that last touched that deployable — not a per-app independent counter. Full table lives in `Digistack Bank - 07 Configuration and Cross-Cutting Standards.md`, §1.

**Database Migration Scope (cross-reference — see doc 05, updated)**

> **Beginning Version 24, all schema changes occur only inside `digistack_cbs`.** The legacy Portal/shared database (used by Parts 1–2) is frozen at the moment of this migration and is never targeted by any migration script numbered V24 or higher — retained read-only only as long as needed for verification/rollback, then formally decommissioned (capture the decommission step in `SetupDoc-v23.md`, not silently assumed).

**Satellite Services Introduced Here**

> **Notification Service and Reporting Service** become **independent WebSphere applications** in this version — not modules inside CBS. CBS publishes transaction events (directly or via IBM MQ); Notification Service consumes these events to deliver SMS/Email alerts; Reporting Service consumes transaction data to generate operational and customer reports. **Neither service performs core banking transactions or updates account balances — CBS remains the sole system of record**, per the Governing Rule above. This split is chosen deliberately for independent deployment, scaling, and maintenance — and for the additional WAS administration practice of managing two more distinct EARs with their own lifecycles.

```
CBS
   │
   ▼
  IBM MQ (event publish)
   │
   ├──────────────► Notification Service (own EAR)
   │
   └──────────────► Reporting Service (own EAR)
```

**Documentation Requirement for This Version**

Because v23 changes data, endpoint, and infrastructure ownership all at once, `SetupDoc-v23.md` must include a dedicated **"Migration & Ownership Transfer"** section (in addition to the standard SetupDoc template) covering:
- Exact migration script execution steps and row-count verification (old DB vs. `digistack_cbs`) before the old DataSource is retired
- The Ownership Matrix above, expanded with exact JNDI names / config references
- Confirmation steps proving the Portal can no longer reach the database directly (e.g., DataSource unbound/removed from Portal's JNDI, verified via a deliberate failed lookup test)
- Confirmation steps proving Notification Service and Reporting Service cannot write to `digistack_cbs` (e.g., their DB users, if any, are granted read-only or no direct grants at all — they only consume events/CBS-exposed data)
- A rollback note specific to this version: since this isn't just an EAR redeploy but a data + ownership migration, the rollback procedure must explicitly state whether rolling back means restoring the old shared-DB Portal *and* retaining the migrated CBS data, or a full revert — this is more complex than every prior version's rollback and deserves its own explicit call-out rather than the generic template line.

`TestCases-v23.md` must include a negative test proving the Portal's old DataSource lookup now fails, and negative tests proving Notification/Reporting Service cannot write to `digistack_cbs`.

VM/database provisioning detail (which VM hosts `digistack_cbs`, exact DataSource configuration steps, updates to the standing VM inventory table in doc 01) belongs in `SetupDoc-v23.md` — the roadmap states **what** changes; the SetupDoc states **how**.

### WebSphere Topics Covered
- Enterprise Service Layer
- Shared Business Services
- XA Transactions
- Clustered Business Services
- Service Integration
- JDBC Optimization
- Connection Pool Tuning
- Enterprise Deployment
- Application Ownership Migration (data, endpoints, messaging, and satellite service extraction — new to this version)

### Enterprise Learning
- Core Banking Architecture
- Banking Domain Model
- Shared Service Design
- Enterprise Transaction Processing
- Production Banking Flow
- Real-world migration/ownership-transfer discipline (no breaking contracts, verified cutover, explicit rollback complexity)

**Sprint Deliverable:** Internet Banking Portal calls CBS exclusively via REST/SOAP for every transaction (deposit, withdrawal, balance inquiry, fund transfer) — direct Portal→DB access is removed entirely; CBS enforces business validation and XA transaction integrity for all writes; existing Part-1/Part-2 data is migrated into `digistack_cbs` and verified; Notification Service and Reporting Service are stood up as independent applications consuming CBS events/data.

**Architectural note — this is the pivot point of the whole project:** From this version forward, **CBS is the only system permitted to write to the CBS Database.** This is the single most important rule for the rest of Part-3 onward — including the two Tomcat simulators, Card Portal, Payment Hub, Notification Service, Reporting Service, and Branch Portal.

---

## Version 24 — Customer Information File (CIF) & Account Lifecycle

### Objective
Introduce Customer Information File (CIF), the master customer repository used by every banking channel. One customer → multiple accounts.

### Banking Features Added
- Create CIF
- Modify CIF
- Customer Search
- Aadhaar Verification
- PAN Verification
- Primary Holder
- Nominee

### Request Flow
```
Customer
     │
     ▼
Internet Banking
     │
     ▼
CBS
     │
     ▼
CIF Service
     │
     ▼
Account Service
     │
     ▼
CBS Database
```

### WebSphere Topics Covered
- Multi-module EAR
- Shared Libraries
- Service-to-Service Communication
- JDBC Transactions
- Data Integrity

### Enterprise Learning
- CIF Architecture
- Customer Master Data
- Enterprise Banking Relationships
- Account Lifecycle Management

**Sprint Deliverable:** A single CIF record supports multiple linked accounts; Aadhaar/PAN verification (simulated) gates CIF creation; CIF Service and Account Service communicate as separate modules within CBS's multi-module EAR, not as one monolithic class.

**Note:** "Enterprise Validation" appeared as a heading with no listed content in the source material — folded into Enterprise Learning above (Aadhaar/PAN verification is the validation being exercised in this version).

---

## Version 25 — Payment Systems (NEFT, IMPS)

### Objective
Develop DigiStack Payment Hub responsible for routing all electronic payments.

### Deployment Model
> **Payment Hub is deployed as its own EAR** (`digistack-paymenthub-vN.ear`), separate from CBS, communicating with CBS via internal REST/SOAP or EJB calls. This gives an additional distinct deployable unit for WAS admin practice — its own application lifecycle, classloader, and startup-dependency ordering (Payment Hub must come up after CBS is available) — rather than folding payment logic into CBS's multi-module EAR.
>
> Per the Governing Rule: **Payment Hub routes payments and coordinates settlement, but never updates balances directly.** Settlement is confirmed back to CBS, which alone performs the write to `digistack_cbs`.

`SetupDoc-v25.md` should include Payment Hub's own build/deploy steps, distinct from CBS's, and note the startup-order dependency (CBS must be up first) in its Pre-Deployment Checklist.

### Banking Features Added
**Payment Systems**
- NEFT Transfer
- IMPS Transfer

**Beneficiary**
- Add Beneficiary
- Modify Beneficiary
- Delete Beneficiary

**Processing**
- Payment Validation
- Beneficiary Validation
- Payment Routing
- Settlement
- Failed Payment Handling

### Request Flow
```
Customer
     │
     ▼
Internet Banking
     │
     ▼
Payment Hub (own EAR)
     │
  ┌──┴──┐
  ▼     ▼
NEFT   IMPS
  │     │
  └──┬──┘
     ▼
    CBS  (writes settlement to digistack_cbs)
     │
     ▼
Settlement Confirmation → Payment Hub
```

### WebSphere Topics Covered
- JMS
- IBM MQ
- Distributed Transactions
- Asynchronous Processing
- Retry Mechanisms
- Queue Monitoring
- Transaction Recovery
- Multi-EAR startup dependency management (new to this version)

### Enterprise Learning
- Payment Gateway
- Payment Switch
- Settlement
- Reconciliation
- Financial Messaging

**Sprint Deliverable:** IMPS transfer completes in real time (synchronous validation, async settlement via JMS/MQ); NEFT transfer is processed in a batch window; a deliberately failed payment is retried per the configured retry policy and, if still unresolved, lands in a reviewable failed-payment queue; Payment Hub never writes directly to `digistack_cbs` — all confirmed settlements are written by CBS.

**Consistency note:** NEFT/IMPS were originally scoped for Part-3 in the Master Index under this exact heading — this version fulfills that scope precisely, building on the JMS (Part-2 v15) and IBM MQ (Part-2 v19) foundations rather than duplicating them.

---

## Version 26 — Mobile Banking Simulator (Tomcat — `mobile.digistack.com`)

### Objective
Build Mobile Banking as a small, standalone, neat-UI app on Apache Tomcat, calling CBS exclusively via REST. See the Channel Simulator Standard above for shared rules and request flow.

### Banking Features Added
- Mobile Login (delegates auth to CBS, same MFA/OTP rules as Version 17)
- Balance Inquiry
- Mini Statement
- Fund Transfer (IMPS only — mirrors real mobile banking's real-time bias)
- Quick Pay to Saved Beneficiary

### Request Flow
Follows the shared Channel Simulator request flow (see standard above), specifically:
```
Customer (Mobile Browser)
     │
     ▼
mobile.digistack.com
     │
     ▼
IHS Virtual Host Rule → Tomcat
     │
     ▼
Mobile App (JSP/Servlet, Bootstrap 5)
     │
REST calls only
     ▼
DigiStack CBS → digistack_cbs Database
```

### WebSphere / Enterprise Topics Covered
(In addition to the shared Channel Simulator topics above)
- API-first channel design (mobile as "just another CBS API consumer")
- Channel-specific rate limiting / throttling at the IHS layer (optional stretch goal)

### Enterprise Learning
- Multi-vendor application server estates in real banking IT
- Channel isolation and blast-radius reasoning (why a bank might deliberately keep mobile off the same cluster as core Internet Banking)

**Sprint Deliverable:** `mobile.digistack.com` resolves through the IHS/LB tier and routes to Tomcat (not the WAS plugin); a customer can log in (CBS auth, MFA intact), check balance, view mini statement, and complete an IMPS Quick Pay — all via REST calls to CBS, zero direct database access from the Tomcat app, clean Bootstrap 5 UI.

---

## Version 27 — ATM Simulator (Tomcat — `atm.digistack.com`)

### Objective
Build the ATM channel as a small, standalone, neat-UI app on Apache Tomcat, simulating physical ATM interactions while calling CBS exclusively via REST/SOAP.

### Reference UI Flow
```
==========================
 DIGISTACK ATM SIMULATOR
==========================
1. Balance Inquiry
2. Cash Withdrawal
3. Mini Statement
4. Change PIN
5. Exit
```

### Banking Features Added
- Card/PIN Entry (simulated card swipe → card number + PIN form)
- Balance Inquiry
- Cash Withdrawal
- Mini Statement
- PIN Change

### Request Flow
```
ATM User (Browser simulating ATM screen)
     │
     ▼
atm.digistack.com
     │
     ▼
IHS Virtual Host Rule → Tomcat
     │
     ▼
ATM Simulator App (JSP/Servlet, Bootstrap 5 "ATM screen" UI)
     │
REST/SOAP calls only
     ▼
DigiStack CBS
     │
Check PIN → Check Balance → Debit → Update Ledger
     │
     ▼
digistack_cbs Database
     │
     ▼
Return Success / Dispense Confirmation (simulated)
```

### WebSphere / Enterprise Topics Covered
(In addition to the shared Channel Simulator topics above)
- Connection Pools sized for high-frequency, low-latency ATM-style calls
- Thread Pool tuning for synchronous request patterns
- High Availability considerations specific to always-on ATM traffic

### Enterprise Learning
- ATM Switch concepts
- Card Authorization flow
- External Banking Integration patterns

**Sprint Deliverable:** ATM Simulator UI (styled to resemble a real ATM screen) performs Balance Inquiry, Cash Withdrawal, Mini Statement, and PIN Change against CBS, entirely through REST/SOAP; PIN validation and a blocked/incorrect-PIN negative case are both provable.

**Scope note (per your "ATM & POS Integration {Minimal}" instruction):** Stays intentionally minimal — a functional web-based simulator proving the request flow and relevant WebSphere admin topics, not a full ISO 8583 switch implementation. POS is treated as sharing this same simulator's transaction path, distinguished by transaction type (purchase vs. withdrawal) rather than as a separate app — kept out of scope as its own build to avoid over-expanding this already-growing Part.

---

## Version 28 — Card Portal (WebSphere — `card.digistack.com`)

### Objective
Build the Card Management channel as a small, standalone, neat-UI application, deployed as **its own WebSphere EAR** (not Tomcat — see "Why Card Portal Belongs on WAS" above), giving customers (or bank staff, depending on how you want to frame it) a portal for card lifecycle operations — calling CBS exclusively via REST/SOAP.

### Deployment Model
> **Card Portal is deployed as its own EAR** (`digistack-cardportal-vN.ear`) on the existing WAS ND cluster, fronted by IHS via a virtual host rule for `card.digistack.com` that routes to the **WAS plugin** (not Tomcat, unlike Mobile and ATM). It remains presentation-only: zero direct database access, all card operations invoked through CBS's Card Service. Per the Governing Rule, Card Portal never writes to `digistack_cbs` directly.

### Banking Features Added
- Issue Card
- Activate Card
- Block Card
- Generate PIN
- Reset PIN
- Card Status Lookup
- Hotlisting

### Request Flow
```
Customer / Staff
     │
     ▼
card.digistack.com
     │
     ▼
IHS Virtual Host Rule → WAS Plugin
     │
     ▼
Card Portal (own EAR, JSP/Servlet, Bootstrap 5)
     │
REST/SOAP calls only
     ▼
DigiStack CBS (Card Service)
     │
     ▼
digistack_cbs Database
```

### WebSphere / Enterprise Topics Covered
- Deploying and administering a seventh independent WAS EAR alongside Portal, CBS, Payment Hub, Notification Service, Reporting Service, and Branch Portal
- Virtual host routing distinguishing Card Portal's plugin-routed traffic from Mobile/ATM's Tomcat-routed traffic, on the same IHS instance
- Service-to-service call from Card Portal into CBS's Card Service specifically (as opposed to CBS's core Account/Transaction services) — a good example of routing to the *correct* internal service, not just "CBS" as a monolith
- IBM MQ / JMS touchpoint: card issuance triggers an async "Card Issued" notification, published by CBS and consumed by Notification Service (per the v23 satellite service split)

### Enterprise Learning
- Card Authorization
- Card Lifecycle Management
- External Banking Integration

**Sprint Deliverable:** A card can be issued, activated, blocked, and have its PIN reset through the Card Portal UI; a blocked card correctly fails authorization when tested against the ATM Simulator (Version 27) — proving Card Portal (WAS), ATM Simulator (Tomcat), and CBS are properly integrated across the heterogeneous topology, not siloed.

**Scope note:** Card expiry/renewal is a deliberate, documented omission — consistent with the "minimal" instruction for this area, not an oversight.

---

## Version 29 — Enterprise Banking Operations

### Objective
Implement day-to-day banking operations performed by branch staff and operations teams.

### Deployment Model
> **Branch Portal is a separate WebSphere application** deployed on the existing ND cluster and communicates only with CBS services — it does not access `digistack_cbs` directly, following the same presentation-only rule as the Internet Banking Portal, Card Portal, and the two Tomcat simulators.

### Banking Features Added
- Teller Login
- Cash Deposit
- Cash Withdrawal
- Beginning of Day (BOD)
- End of Day (EOD)
- EOD Reconciliation Report (NEFT/IMPS settlement tie-out against CBS ledger)

### Request Flow
```
Branch Teller
     │
     ▼
Branch Portal (own EAR)
     │
     ▼
Operations Service (within CBS)
     │
     ▼
CBS
     │
     ▼
Batch Service
     │
     ▼
Reporting Service (v23) — EOD Reconciliation Report
```

### WebSphere Topics Covered
- Batch Scheduling
- JVM Monitoring
- Thread Pools
- JMS Batch Queue
- Log Analysis
- Performance Tuning
- Production Troubleshooting

### Enterprise Learning
- Branch Banking
- Batch Processing
- EOD/BOD Operations
- Production Support
- Banking Operations

**Sprint Deliverable:** A Teller can log in to the Branch Portal and process cash deposits/withdrawals against CBS; a scheduled BOD job opens the banking day (e.g., interest accrual prep, NEFT batch window opens) and an EOD job closes it — including a **reconciliation report**, generated by Reporting Service, that ties out the day's NEFT/IMPS settlements (Version 25) against CBS's own ledger, surfacing any mismatch — both BOD/EOD run as WAS-scheduled batch jobs, not manually triggered code.

**Note:** This is where "Reconciliation," originally only mentioned under Version 25's Enterprise Learning with no actual feature, gets a concrete implementation — EOD is when real banks reconcile, so it belongs here rather than as a separate version.

---

## Version 30 — Loan Management

### Objective
Introduce lending as a core CBS product line — the module referenced in Part-2's Capstone feature list but never actually built until now. Closes the realism gap in an otherwise deposit/payments-only simulation.

### Banking Features Added
**Loan Origination**
- Loan Application
- Eligibility Check (simulated credit/income rules)
- Loan Approval / Rejection
- Loan Disbursement (credits the linked CBS account)

**Loan Servicing**
- EMI Schedule Generation
- EMI Auto-Debit (scheduled)
- Loan Statement
- Foreclosure / Prepayment
- Overdue / NPA Flagging (simulated)

**Products**
- Personal Loan
- Home Loan (simplified)

### Request Flow
```
Customer
     │
     ▼
Internet Banking
     │
     ▼
Loan Service (within CBS)
     │
Eligibility Check
     │
     ▼
CBS (Account Service)
     │
Disbursement
     │
     ▼
CBS Database
     │
     ▼
EMI Scheduler (EJB Timer / Batch)
     │
     ▼
Auto-Debit on Due Date
```

### WebSphere Topics Covered
- EJB Timer Service (EMI due-date scheduling)
- Batch Interest Accrual
- Long-Running Transaction Patterns
- Scheduled Task Administration in WAS
- Transaction Isolation for Concurrent EMI Processing

### Enterprise Learning
- Lending Domain Model
- EMI Amortization Logic
- Credit Risk Simulation (simplified)
- Batch-Driven Financial Processing
- NPA/Overdue Handling Basics

**Sprint Deliverable:** A customer can apply for a Personal Loan, pass a simulated eligibility check, get approved, and have the loan amount disbursed straight into their CBS savings account; an EMI schedule is generated and at least one EMI auto-debits on its due date via EJB Timer Service, correctly reducing the outstanding principal.

**Why this version exists:** Flagged during Part-3 review — Loan Management was referenced in the Part-2 Capstone (v22) feature list as something the platform "combines," but no version anywhere actually built it. Given lending is core to any real bank and adds genuinely new WebSphere topics (EJB Timer Service, batch accrual) not exercised elsewhere in the roadmap, it's added here to complete Part-3.

---

## Enterprise Architecture After Part-3

```
                               Customers
                                   │
      ┌──────────────┬──────────────┬──────────────┬──────────────┐
      ▼              ▼              ▼              ▼
Internet Banking  Mobile Banking   ATM Sim      Card Portal
(www.digistack.com)(mobile.digistack.com)(atm.digistack.com)(card.digistack.com)

                          Branch Employees
                                   │
                                   ▼
                            Branch Portal
                                   │
      │              │              │              │              │
      │              ▼              ▼              │              │
      │         IBM HTTP Server / Enterprise LB                    │
      │      (single tier, virtual-host routed)                   │
      │              │              │              │              │
      │        ┌─────┴──────────────┴─────┐        │              │
      │        ▼                          ▼        │              │
      │   WAS Plugin                   Tomcat       │              │
      │   (→ cluster)              (Mobile, ATM)     │              │
      └──────────────┴──────────┬───────────────────┴──────────────┘
                                 │ (all non-CBS apps call CBS via REST/SOAP/EJB only)
                                 ▼
                     WebSphere ND Cluster (7 EARs)
                     │
                     ├── Internet Banking Portal
                     ├── CBS  ◄────────────────────────┐
                     ├── Payment Hub                   │
                     ├── Notification Service           │ (sole writer of
                     ├── Reporting Service               │  digistack_cbs)
                     ├── Branch Portal                   │
                     └── Card Portal                     │
                                                          │
      IBM MQ:  CBS → MQ → Notification Service ──────────┘
                    → Payment Hub (external NEFT/IMPS leg)

                                   │
                                   ▼
                     DigiStack Core Banking System
                                (CBS)
      ┌────────────┬────────────┬────────────┬────────────┬────────────┐
      ▼            ▼            ▼            ▼            ▼
      CIF      Accounts    Transactions   Products       Loans
                                   │
                                   ▼
                            digistack_cbs Database
                    (dedicated CBS database — CBS is the
                       ONLY application that writes here)
```

**Total deployable applications by end of Part-3:** Internet Banking Portal, CBS, Payment Hub, Notification Service, Reporting Service, Branch Portal, Card Portal (**7 WAS EARs**) + Mobile Banking, ATM Simulator (**2 Tomcat apps**) = **9 distinct deployable applications**, all governed by the single rule that only CBS writes to `digistack_cbs`.

---

## ✅ Part-3 Completion Checkpoint

Before starting Part-4 (Enterprise Observability), confirm the following are in place:

- [ ] **Governing Rule enforced:** only CBS writes to `digistack_cbs`; Payment Hub, Notification Service, Reporting Service, Branch Portal, Card Portal, and both Tomcat apps (Mobile, ATM) verified (via negative test) to have no direct write access
- [ ] CBS is the sole system of record — Internet Banking Portal has zero direct DB access
- [ ] CBS running on its own dedicated `digistack_cbs` database via a separate DataSource/connection pool
- [ ] Version 23 data migration completed and verified (row-count reconciliation between old shared DB and `digistack_cbs`), old Portal DataSource decommissioned
- [ ] REST/SOAP endpoints (v16) confirmed relocated to CBS with unchanged contracts; SIBus/MDB/MQ (v15, v19) confirmed relocated to CBS
- [ ] Notification Service and Reporting Service live as independent EARs, consuming CBS events/data only, with no direct database write access
- [ ] CIF supports multiple accounts per customer, with Aadhaar/PAN verification gating creation
- [ ] Payment Hub deployed as its own EAR; NEFT (batch) and IMPS (real-time) both functional, with retry/DLQ handling proven; Payment Hub confirmed never writing balances directly
- [ ] `mobile.digistack.com` live on Tomcat, routed via IHS virtual host, calling CBS via REST only
- [ ] `atm.digistack.com` live on Tomcat, ATM Simulator functional including a blocked/incorrect-PIN negative test
- [ ] `card.digistack.com` live on **WebSphere** (own EAR, routed via IHS to the WAS plugin, not Tomcat), Card Portal functional; a card blocked here correctly fails at the ATM Simulator
- [ ] Branch Portal deployed as its own EAR; Teller operations functional; BOD/EOD batch jobs run on a WAS schedule, including EOD reconciliation report generated by Reporting Service
- [ ] Loan origination through disbursement functional; at least one EMI auto-debit proven via EJB Timer Service
- [ ] All eight versions' `TestCases-v23.md`–`v30.md` signed off per Test Case Standards, including the new ownership/write-access negative tests introduced at v23
- [ ] `SetupDoc-v23.md`'s "Migration & Ownership Transfer" section completed, reviewed, and matches what was actually executed
- [ ] Part-3 promoted Dev → UAT → Prod per Environment Promotion Standards, `part3-release` tag applied (all 9 applications — 7 WAS EARs + 2 Tomcat apps — promoted together, per environment)

**Carried forward into Part-4:** CBS as system of record, Payment Hub, Notification Service, Reporting Service, the two Tomcat-based channel simulators (Mobile/ATM), the WAS-hosted Card Portal, Branch Portal, and Loan Servicing all become subjects of observability instrumentation (APM, distributed tracing, chaos testing) in Part-4. The heterogeneous WAS+Tomcat topology, combined with 9 independently deployed applications all communicating through CBS, is especially valuable here — distributed tracing across this many services, on two different application server products, is closer to real enterprise observability work than a single-vendor, single-app stack would be.

---

## 🔍 Module Sufficiency Review — Resolved

**Verdict on your standing question (is this enough to practice WAS admin, with Part-4 observability in mind?)** — Yes, and the satellite-service split (Payment Hub, Notification, Reporting each as their own EAR), the Mobile/ATM restructure into separate Tomcat apps, and **Card Portal's placement on WAS rather than Tomcat** makes it *more* valuable, not less: Versions 23–30 now give **nine distinct services/apps** — **seven independent WebSphere EARs** (Internet Banking Portal, CBS, Payment Hub, Notification Service, Reporting Service, Branch Portal, Card Portal) plus **two Tomcat apps** (Mobile Banking, ATM Simulator) — a genuinely heterogeneous topology (WAS + Tomcat behind one IHS/LB tier), multiple queues (JMS + MQ), a dedicated CBS database with a single-writer rule, and batch/scheduled jobs. That heterogeneous routing and cross-server tracing work is realistic, résumé-relevant WAS admin territory that a pure single-vendor stack wouldn't have taught.

**Decisions reflected in this version of the document:**

1. ✅ **Loan Management** — Version 30 (renumbered from 28). Closes the Part-2 Capstone reference gap.
2. ✅ **Mobile Banking and ATM** — rebuilt as **separate small Tomcat apps** under their own subdomains (Versions 26, 27), per your explicit direction.
3. ✅ **Card Portal moved to WebSphere** — Version 28 deploys Card Portal as its own WAS EAR (not Tomcat), reflecting that card lifecycle operations (issue, activate, block, PIN reset, hotlisting) are sensitive bank-owned enterprise functions, not an external customer channel like Mobile/ATM. This brings the WAS EAR count to seven and adds a deliberate architectural counterpoint to the Tomcat-split reasoning used for Mobile/ATM.
4. ✅ **CBS database separation** — CBS has its own dedicated `digistack_cbs` database and DataSource (Version 23), with an explicit one-time migration script and ownership matrix documenting the cutover from the shared Part-1/Part-2 database.
5. ✅ **Service and messaging relocation** — v16's REST/SOAP and v15/v19's SIBus/MDB/MQ explicitly relocate from Portal to CBS at v23, with existing contracts preserved.
6. ✅ **Satellite services** — Notification Service and Reporting Service become independent EARs at v23 (not folded into CBS), and Payment Hub becomes an independent EAR at v25 — all three governed by the single "only CBS writes" rule.
7. ✅ **Branch Portal** — explicitly scoped as its own separate WebSphere application at v29, presentation-only, no direct DB access.
8. ✅ **Reconciliation** — concrete feature inside Version 29's EOD, generated by Reporting Service.
9. **Card expiry/renewal** and **POS as a separate app** — both confirmed as deliberate, documented omissions to keep this Part from over-expanding further.

**Renumbering summary (for your records):**
| Old # | Old Title | New # | New Title |
|---|---|---|---|
| 23 | Core Banking System (CBS) | 23 | *(unchanged, now includes migration/relocation/satellite-service notes)* |
| 24 | CIF & Account Lifecycle | 24 | *(unchanged)* |
| 25 | Payment Systems (NEFT, IMPS) | 25 | *(unchanged, now explicit standalone Payment Hub EAR)* |
| 26 | ATM, POS & Card Channel Simulation (combined, on WAS) | — | **Replaced** — split into new v27 and v28 |
| 27 | Enterprise Banking Operations | 29 | Enterprise Banking Operations |
| 28 | Loan Management | 30 | Loan Management |
| 29 | Mobile Banking Channel (Tomcat) | 26 | Mobile Banking Simulator (Tomcat) |
| — | *(new)* | 27 | ATM Simulator (Tomcat) |
| — | *(new)* | 28 | Card Portal (WebSphere) |

**Nothing further outstanding in Part-3.**

---

*This document is Part-3 of the DigiStack Bank Roadmap (Versions 23–30: Enterprise Banking Systems — CBS, Payments, Mobile/ATM Channel Simulators on Tomcat, Card Portal on WebSphere, Loans). See Part-1 for Versions 1–14, Part-2 for Versions 15–22, and the MASTER INDEX for full navigation.*
