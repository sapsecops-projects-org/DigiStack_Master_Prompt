# DigiStack Bank — Roadmap Part-1 (WebSphere-Topic-First Edition)

**Enterprise Banking Application Development (Simple Banking)**

**Purpose:** This Part exists to practice IBM WebSphere Application Server ND administration and fill a 10-year career gap. **The WebSphere Topic is the deliverable of each version — the banking feature is only the minimum vehicle needed to exercise that topic.** Do not add banking realism, extra fields, extra screens, or "nice to have" modules that don't serve a topic. If a topic can be demonstrated with one screen and one field, that's the whole version.

**Deployment model:** ONE deployable application — a single EAR, `digistack-bank-vN.ear` — built and redeployed to WebSphere at every version. No separate Portal/CBS split in Part-1 (that happens in Part-3 v23). Keep the codebase small: a handful of servlets/JSPs, one or two DAOs, one table or two, growing only when a topic requires it.

**Continuity rule:** each version reuses the same tiny app and either (a) adds the *smallest possible* new screen/field a topic needs, or (b) touches zero new banking functionality and is purely an infrastructure/admin exercise on what already exists. No version is padded with features that exist "because a real bank would have them."

**Process for every version:** Requirements (topic-driven, not feature-driven) → Development (minimal, beginner-level explained) → Deployment & Admin in WAS → Testing → Documentation → **Pause for approval** before the next version.

---

## Version 1 — Project Setup & Enterprise Architecture

### WebSphere Topic (primary)
First EAR deployment to a standalone WAS AppServer — Enterprise Architecture, EAR/WAR structure, deployment layout, context root, virtual host.

### Minimum App Needed to Exercise It
- One static Home page ("DigiStack Bank")
- One PostgreSQL connectivity test (a single table, e.g. `app_config`, read on page load to prove DB wiring)
- Basic logging framework (so every later version has logs to look at)

That's it — no About/Contact/Login UI yet. They add nothing to the deployment topic.

### WebSphere Topics Covered
- Enterprise Architecture, EAR Structure, WAR Structure
- Deployment Layout, Context Root, Virtual Host
- First EAR Deployment via Admin Console

**Sprint Deliverable:** `digistack-bank-v1.ear` deployed to WAS, reachable via its context root/virtual host, Home page renders and confirms a live PostgreSQL read. Confirmed via Admin Console application status + browser hit, not just "it built."

---

## Version 2 — Login & Session

### WebSphere Topic (primary)
JVM/Application startup behavior, HTTP session creation, session-scoped logs.

### Minimum App Needed
- One `users` table (username, password_hash)
- Login screen + Logout — nothing else (no Forgot Password, no Dashboard, no Profile — those aren't needed to demonstrate session creation)
- On successful login, show "Last login: <timestamp>" as the only post-login content, purely to prove a session-scoped value survives across requests

### WebSphere Topics Covered
- JVM Startup, Application Startup, Session Creation, Logs
- EAR Redeploy (`digistack-bank-v2.ear` over v1 — same context root/virtual host)

**Sprint Deliverable:** Login/logout works against PostgreSQL; a session attribute (last login) is set at login and correctly read on the next request; v2 EAR redeployed cleanly over v1.

---

## Version 3 — Basic Transaction (Deposit & Withdraw)

### WebSphere Topic (primary)
Enterprise application layering (Controller → Service → DAO → DB) and ClassLoader basics — this is the one version where the "banking feature" itself is the point, because layered packaging is the topic.

### Minimum App Needed
- One `accounts` table (account_id, balance)
- One screen: view Balance, then Deposit or Withdraw, submit — balance updates and redisplays
- Balance is included because you need a way to *verify* Deposit and Withdraw actually worked, not as a separate module — it's the same screen, just showing the current figure before/after the transaction.
- That's the entire feature set for this version. No Customer module, no Beneficiary, no Transfer, no History — all deferred until a later topic actually needs them.

### WebSphere Topics Covered
- Enterprise Application Architecture, ClassLoader Basics, Application Packaging
- EAR Redeploy (`digistack-bank-v3.ear`)

**Sprint Deliverable:** Balance, Deposit, and Withdraw work end-to-end through Controller → Service → DAO → DB, deployed as v3, with the layering explained class-by-class (this is the version where "why layers matter" is taught, since v4 onward assumes it).

---

## Version 4 — EAR Update, Rollback & Application Lifecycle

### WebSphere Topic (primary)
Update Application (redeploy over a running app), Application Lifecycle (start/stop/restart), Rollback.

### Minimum App Needed
- **Zero new banking functionality.** Make one trivial, visible UI change (e.g., a version label "v4" on the Home page) purely so you can *see* the redeploy took effect.

### WebSphere Topics Covered
- Update Application, Application Lifecycle, Deployment Targets
- Rollback (deliberately roll back to v3, confirm it serves the old label, redeploy v4)

**Sprint Deliverable:** `digistack-bank-v4.ear` deployed; a real rollback to v3 is performed and verified (old label visible), then v4 redeployed — proving the update/rollback workflow every later version reuses. No feature work this version — it's 100% an admin-practice sprint.

---

## Version 5 — WAS Clustering

### ⚠️ Prerequisite Note (resolved gap — read before starting)
A WebSphere cluster cannot exist without a Deployment Manager (DMgr) and at least one federated node — clustering is a cell-level construct, not something a standalone AppServer profile (as built in v1) can do on its own. Version 6 is where DMgr, node federation, and wsadmin are formally **taught in depth** (with real admin fluency as the goal), but the underlying plumbing — creating a DMgr profile and federating the node(s) into its cell — must exist *before* a cluster can be created here in v5. **Resolution:** this version includes the minimum operational steps to stand up a DMgr profile and federate the existing node (treated as bare setup, not yet explained topic-by-topic), so the cluster itself can be built and tested; v6 then goes back over that same DMgr/federation foundation properly — node synchronization internals, wsadmin scripting, application/server lifecycle management — as its own dedicated topic. `SetupDoc-v5.md` must show the DMgr-creation and federation commands used, even though the deep explanation of *why* each step works is deferred to `SetupDoc-v6.md`.

### WebSphere Topic (primary)
Cluster creation, horizontal scaling, session replication, failover.

### Minimum App Needed
- **Zero new banking functionality.** Reuse v3's Deposit/Withdraw and v2's session/login exactly as-is — they're the test subjects, not the point.

### WebSphere Topics Covered
- DMgr Profile Creation & Node Federation (operational setup only — deep-dive is v6)
- Cluster Creation, Horizontal/Vertical Scaling, Plugin Routing (prep only — IHS itself is v8), Failover, Session Replication, Cluster Members

**Sprint Deliverable:** 2-member cluster runs `digistack-bank-v5.ear` (same app as v4, unchanged); logging in, then killing one cluster member mid-session, proves the session and a Deposit/Withdraw both survive via replication/failover.

---

## Version 6 — Application Administration

*(Renamed from "WAS Administration" — DMgr/Node/wsadmin below are genuine WebSphere Administration topics, but Freeze/Unfreeze itself is an application-level admin action, not a server-tier one. The version name now reflects what the feature actually is.)*

### WebSphere Topic (primary)
DMgr, node federation/synchronization, wsadmin scripting, application/server lifecycle management. **This is the deep-dive on the DMgr/federation plumbing that v5 already had to stand up operationally to build its cluster** (see v5's Prerequisite Note) — v5 proved it works, this version explains why and builds real fluency with it.

### Minimum App Needed
- One admin action: Freeze / Unfreeze an account (toggle a `status` flag on the `accounts` table from v3, block Deposit/Withdraw when frozen)
- That single toggle is enough to exercise "admin managing the app" — no full Admin Dashboard, no Customer/Account Approval workflows, no Employee Management, no Audit Logs UI (logs already exist from v1's logging framework — just point at them, don't build a viewer).

### WebSphere Topics Covered
- DMGR, Node Federation, Node Synchronization, JVM Management, Application Management, Server Lifecycle, wsadmin

**Sprint Deliverable:** DMgr manages federated nodes; Freeze/Unfreeze toggled via the app and verified to block/allow Deposit/Withdraw; at least one of the freeze/unfreeze actions performed via a wsadmin script instead of the app UI, to prove wsadmin fluency.

---

## Version 7 — WAS JDBC

### WebSphere Topic (primary)
JDBC Providers, DataSources, JNDI, connection pooling, transactions.

### Minimum App Needed
- **Zero new banking functionality.** Take the existing DB connection (used since v1) and migrate it from however it's currently wired to a proper WAS-managed JDBC DataSource looked up via JNDI, with a connection pool and a JAAS auth alias for credentials.

### WebSphere Topics Covered
- JDBC Providers, Datasources, JNDI, Connection Pool, Validation, Transactions

### ⚠️ Connection Pool Sizing — Worked Example (added per Senior Architect Review, Finding #10)

> Pool sizing is a genuine real-world failure mode that's easy to overlook until it happens under load: connection exhaustion at the **database** level, not the app server level. The arithmetic is simple but rarely written down anywhere, so it's captured here once for reuse whenever clustering (v5) or additional cluster members are added later in the roadmap:
>
> **Rule:** `(cluster members × max connection pool size per member) + admin/replication headroom ≤ PostgreSQL max_connections`
>
> **Example:** 3 cluster members × a 50-connection pool each = 150 connections required at peak, against PostgreSQL's out-of-the-box default `max_connections = 100`. That configuration would exhaust the database's connection limit under load long before any single app server's pool is actually full — a classic "the app server looks fine, the database is what's actually starved" incident. Either the per-member pool size must shrink, the cluster size must be accounted for when sizing `max_connections`, or both — sized deliberately, not left at defaults on either side. Document the actual numbers chosen for this project's pool size and `max_connections` in `SetupDoc-v7.md`, and revisit the math explicitly any time cluster membership changes (e.g., Part-1 v5, Part-6 v39's regional clusters).

**Sprint Deliverable:** All existing features (login, deposit/withdraw, freeze) now read/write exclusively through a JNDI-looked-up, WAS-managed connection pool — no hardcoded JDBC URL or credentials remain anywhere in the code.

---

## Version 8 — IBM HTTP Server (IHS)

### WebSphere Topic (primary)
IHS install, web server definition, plugin-cfg.xml generation/propagation, reverse proxy, virtual hosts.

### Minimum App Needed
- One static asset (a single logo image or CSS file) to prove it's served by IHS, not the AppServer — nothing else changes in the app.
- Custom error pages for 404 and 500, configured at the IHS layer — real organizations always customize these instead of leaking a default server error page, so it's a genuinely useful IHS admin skill even though it touches zero application code.

### WebSphere Topics Covered
- IBM HTTP Server, Web Server Definition, Plugin Generation, Plugin Propagation, Reverse Proxy, Virtual Hosts
- Custom Error Document configuration (404, 500) at the IHS level

**Sprint Deliverable:** IHS installed as the front door to the WAS cluster; plugin-cfg.xml generated and propagated; the one static asset confirmed served by IHS (via response headers/logs); a deliberately broken URL returns the custom 404 page and a deliberately forced server error returns the custom 500 page — both served by IHS, not WAS's default error output.

---

## Version 9 — Session Management

### WebSphere Topic (primary)
Sticky sessions, session persistence/failover across the cluster, memory-to-memory replication tuning.

### Minimum App Needed
- **Zero new banking functionality.** Add one config-level behavior: Session Timeout (e.g., auto-logout after N minutes idle) — the smallest possible feature that lets you *observe* session replication/timeout behavior across cluster members.

### WebSphere Topics Covered
- HTTP Sessions, Sticky Sessions, Session Persistence, Session Failover, Memory-to-Memory Replication

**Sprint Deliverable:** Session timeout enforced correctly; a session survives a cluster member restart (memory-to-memory replication proven); sticky-session routing confirmed via IHS/plugin logs.

---

## Version 10 — Users & Groups

### WebSphere Topic (primary)
Administrative security, file registry (or LDAP), users, groups, roles, authorization.

### Minimum App Needed
- **Zero new banking functionality.** Take v6's Freeze/Unfreeze admin action and gate it behind a real "Administrator" role instead of being open to any logged-in user; regular users get a "Customer" role that can only use Deposit/Withdraw.

### WebSphere Topics Covered
- Administrative Security, File Registry, LDAP, Users, Groups, Roles, Authorization

**Sprint Deliverable:** File-based (or LDAP) user registry configured; Customer and Administrator roles/groups defined; Freeze/Unfreeze is now unreachable by a Customer-role user, proving role enforcement (not just UI hiding).

---

## Version 11 — SSL (HTTPS at the Web Tier)

### WebSphere Topic (primary)
SSL basics, certificates, keystore/truststore, HTTPS, certificate chains.

### Minimum App Needed
- **Zero new banking functionality.** All existing pages (login, deposit/withdraw, freeze) simply move to HTTPS.

### WebSphere Topics Covered
- SSL Basics, Certificates, KeyStore, TrustStore, HTTPS, Certificate Chains

**Sprint Deliverable:** Self-signed certificate generated and imported; HTTPS enforced on IHS for all existing pages; HTTP requests redirect to HTTPS.

---

## Version 12 — WAS SSL Configuration (End-to-End)

### WebSphere Topic (primary)
SSL repertoires, NodeDefaultSSLSettings/CellDefaultSSLSettings, mutual TLS, certificate renewal.

### Minimum App Needed
- **Zero new banking functionality.** Extend v11's SSL from just browser↔IHS to the full hop chain: IHS↔plugin↔AppServer↔DB, with mTLS on at least one internal hop.

### WebSphere Topics Covered
- SSL Repertoires, NodeDefaultSSLSettings, CellDefaultSSLSettings, Mutual SSL (mTLS), Plugin SSL, Certificate Renewal, SSL Troubleshooting

**Sprint Deliverable:** SSL enabled end-to-end (browser→IHS→plugin→AppServer→DB); mTLS configured on at least one internal hop; certificate expiry/renewal process documented and tested once.

---

## Version 13 — Notifications (JavaMail / JNDI Mail Session)

### WebSphere Topic (primary)
JavaMail, SMTP configuration, JNDI Mail Session, external resource configuration.

### Minimum App Needed
- One trigger point: a successful **Withdraw** (from v3) sends one real email via a WAS Mail Session. That's the entire feature — no SMS, no push, no OTP, no multi-channel alert matrix.

> **Note on Fund Transfer vs. Withdraw:** a Fund Transfer email is the more realistic banking notification, but Part-1's v3 only builds Balance/Deposit/Withdraw — Fund Transfer doesn't exist yet (it's deferred, per the strategic recommendation below, to Part-2's business-module buildout). Rather than pull Transfer into Part-1 just to justify this email, the trigger stays on **Withdraw** — the higher-risk/higher-value operation of the two available, so the "why does this deserve an email" reasoning still holds. Once Fund Transfer is built in Part-2, that's the natural point to add a second, more realistic transfer-notification email — flag if you'd rather build minimal Transfer into Part-1 instead.

### WebSphere Topics Covered
- JavaMail, SMTP Configuration, Resource Environment Entries, JNDI Mail Session, External Resource Configuration, Logging/Troubleshooting Mail Delivery

**Sprint Deliverable:** WAS Mail Session configured via JNDI; a Withdraw triggers a real email delivered through the configured SMTP server; delivery failure is visible in logs when deliberately misconfigured once, to prove troubleshooting.

---

## Version 14 — Reports & JVM Heap Tuning

### WebSphere Topic (primary)
JVM heap management, large-object generation, thread pool tuning, GC/PMI monitoring, OutOfMemory prevention.

### Minimum App Needed
- One **Transaction Report**: dump all rows from the transaction log (built in v3's Deposit/Withdraw activity) as a large PDF/CSV — big enough (multi-thousand synthetic rows) to actually stress the heap. Named "Transaction Report" rather than "Accounts Report" because transaction-level rows are what naturally scale into the thousands and stress the heap — an accounts-only report wouldn't. No Daily/Customer/Audit/Login report variants — one report is enough to exercise the topic.

### WebSphere Topics Covered
- JVM Heap Management, Heap Sizing, Large Report Generation, Thread Pool Tuning, Performance Monitoring, GC, Memory Analysis

**Sprint Deliverable:** The report generates without OutOfMemoryError on a large synthetic dataset; JVM heap tuned and the improvement verified via PMI/GC logs before/after tuning.

---

## ✅ Part-1 Completion Checkpoint

Before starting Part-2, confirm:

- [ ] `digistack-bank-v14.ear` running as a single EAR on WAS ND (no Portal/CBS split — that's Part-3 v23)
- [ ] PostgreSQL connected via managed JNDI DataSource, no hardcoded credentials
- [ ] 2-member cluster operational, session replication/failover tested
- [ ] IHS installed, fronting the cluster via plugin-cfg.xml
- [ ] SSL/HTTPS end-to-end (browser → IHS → plugin → AppServer → DB), mTLS on at least one hop
- [ ] Administrative security enabled — Customer/Administrator roles enforced, not just hidden in UI
- [ ] DMgr + federated nodes operational, comfortable with wsadmin
- [ ] Email notification working via WAS Mail Session/JNDI
- [ ] Large report generates under tuned JVM heap without OOM
- [ ] App itself stayed intentionally tiny: Home, Login/Logout, Deposit/Withdraw, Freeze/Unfreeze, one report, one email trigger — every other WebSphere topic was practiced on infrastructure around this same small app, not on new banking modules

**Carried forward into Part-2:** the same small app + cluster + IHS + SSL + security domain + DataSource + mail session becomes the foundation Part-2 builds JMS, Web Services, deeper security, monitoring, IBM MQ, and load balancing on top of — still one EAR.

---

## Application State After Part-1

**Application:** `digistack-bank-v14.ear`

**Modules**
- Home
- Login / Logout
- Balance
- Deposit
- Withdraw
- Freeze / Unfreeze
- One Report (Transaction Report)
- One Email (Withdraw notification)

**Infrastructure**
- DMGR
- Node
- Cluster
- DataSource
- JNDI
- IHS (incl. custom 404/500 error pages)
- SSL (end-to-end, mTLS on one hop)
- Security (roles/registry)
- JVM (heap-tuned)
- Mail (JNDI Mail Session)
- Reports

This is the exact starting point Part-2 picks up from.

---

## Strategic Note — Where the Missing Banking Modules Belong (Resolved)

Part-1 deliberately never builds Customer, Beneficiary, Fund Transfer, or Transaction History as real modules (Balance/Deposit/Withdraw were enough to teach the WebSphere fundamentals). This originally created a slight inconsistency with Part-3, which assumed Fund Transfer and a Customer/Account model already existed by the time it introduces the Core Banking System pivot (v23) — but those concepts were never built anywhere before Part-3.

**This has since been resolved in Part-2's own rewrite.** Part-2 (Enterprise Middleware Integration) is now the version that grows these missing business modules — Customer, Account, Fund Transfer, Beneficiary — naturally, at Version 15, *while* teaching JMS/SIBus (the same "topic first, feature as the minimum vehicle" discipline used here in Part-1). Transaction History is added slightly later, formalized as a queryable statement at Version 16 alongside the REST/SOAP topic. As a result:

- **Part-1** stays 100% focused on WebSphere fundamentals with the tiny Balance/Deposit/Withdraw app.
- **Part-2** grows the application's business breadth *while* introducing enterprise middleware — Fund Transfer is the JMS/async use case (v15), Customer/Account/Fund Transfer become REST endpoints and Account Statement becomes a SOAP endpoint (v16).
- **Part-3** focuses purely on the CBS system-of-record pivot (v23) and adding new channels (Mobile, ATM, Card Portal, Branch Portal) rather than backfilling missing banking functionality.

No further action needed here — this note is kept only as a historical record of the gap and its resolution.

---

*This document is Part-1 of the DigiStack Bank Roadmap (Versions 1–14). Subsequent parts continue in separate roadmap documents.*

---

**Change log for this revision (Senior Architect Review follow-up):**
- Added a worked connection pool sizing example (cluster members × pool size vs. PostgreSQL `max_connections`) to Version 7, per Finding #10.
