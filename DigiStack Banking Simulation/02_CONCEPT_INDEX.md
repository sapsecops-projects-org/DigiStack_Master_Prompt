# CONCEPT INDEX — DigiStack Bank

> **Purpose:** A running checklist of every banking domain concept and every WebSphere ND admin concept this project touches. Claude updates the status column as sprints complete. Use this file to quickly see what's been covered and what's still ahead, without re-reading every sprint's full documentation.

**Status key:** ⬜ Not started · 🟨 In progress · ✅ Covered

---

## Banking Domain Concepts

| Concept | Status | Covered in Sprint | Notes |
|---|---|---|---|
| Real account numbering scheme (branch + sequence) | ⬜ | | |
| KYC fields & customer risk category | ⬜ | | |
| Account lifecycle states (ACTIVE/DORMANT/FROZEN/CLOSED) | ⬜ | | |
| Double-entry GL posting (debit/credit legs) | ⬜ | | |
| Value dating vs transaction dating | ⬜ | | |
| Idempotency keys on transfers | ⬜ | | |
| Failed transaction reversal flow | ⬜ | | |
| Maker-checker (four-eyes) approval | ⬜ | | |
| Segregation of duties (teller vs manager) | ⬜ | | |
| EOD batch processing | ⬜ | | |
| Interest accrual (daily-balance method) | ⬜ | | |
| GL vs sub-ledger reconciliation | ⬜ | | |
| Dormancy classification | ⬜ | | |
| EMI amortization (reducing balance) | ⬜ | | |
| NPA classification (loans) | ⬜ | | |
| Fixed Deposit maturity instructions | ⬜ | | |
| Premature closure penalty calculation | ⬜ | | |
| Transaction limits per channel | ⬜ | | |
| AML rule engine (threshold + structuring) | ⬜ | | |
| Immutable audit trail | ⬜ | | |
| API Gateway simulation (rate limit, correlation ID) | ⬜ | | |
| MQ-routed monetary transactions | ⬜ | | |
| Independent GL datastore for reconciliation | ⬜ | | |

## Application Engineering Concepts

| Concept | Status | Covered in Sprint | Notes |
|---|---|---|---|
| BigDecimal / NUMERIC(19,4) precision | ⬜ | | |
| Rounding rules (HALF_EVEN) | ⬜ | | |
| DB transaction isolation levels | ⬜ | | |
| Concurrency-safe balance updates (row locking/versioning) | ⬜ | | |
| Contract-first API design (OpenAPI/Swagger) | ⬜ | | |
| API versioning (/api/v1/) | ⬜ | | |
| Standard error response structure | ⬜ | | |
| Password hashing (bcrypt/argon2) | ⬜ | | |
| Input validation at trust boundary | ⬜ | | |
| Unit tests for calculation edge cases | ⬜ | | |
| Integration tests (Portal→CBS→DB/MQ) | ⬜ | | |

## WebSphere ND Admin Concepts (Part 2 primary focus, introduced from Part 1)

| Concept | Status | Covered in Sprint | Notes |
|---|---|---|---|
| WAS ND installation | ⬜ | | |
| Profile creation (Dmgr, custom) | ⬜ | | |
| Node & federation | ⬜ | | |
| Cell/cluster topology | ⬜ | | |
| Application deployment (Console) | ⬜ | | |
| Application deployment (wsadmin/Jython) | ⬜ | | |
| Application deployment (Ansible) | ⬜ | | |
| JDBC datasource configuration | ⬜ | | |
| Connection pool tuning | ⬜ | | |
| JMS / IBM MQ setup & administration | ⬜ | | |
| SSL & certificate management | ⬜ | | |
| Admin security (console users/roles) | ⬜ | | |
| Application security (J2EE roles, RBAC) | ⬜ | | |
| LDAP / federated repositories | ⬜ | | |
| JVM tuning & GC strategy | ⬜ | | |
| Thread pool tuning | ⬜ | | |
| Web server plugin (IHS) configuration | ⬜ | | |
| Session management / replication | ⬜ | | |
| Workload management / load balancing | ⬜ | | |
| Backup & restore | ⬜ | | |
| Log analysis (SystemOut/SystemErr, HPEL) | ⬜ | | |
| Thread dump / heap dump analysis | ⬜ | | |
| IBM Support Assistant usage | ⬜ | | |
| Fix pack / patching strategy | ⬜ | | |
| WebSphere Liberty basics & comparison | ⬜ | | |
| wsadmin/Jython scripting (advanced) | ⬜ | | |
| Ansible/DevSecOps automation | ⬜ | | |
| Capacity planning (load-test → sizing) | ⬜ | | |
| Failover / HAManager validation | ⬜ | | |
| Disaster recovery (RTO/RPO, drills, failback) | ⬜ | | |
| Migration planning (ND→ND, traditional→Liberty) | ⬜ | | |

---
*Update this file at the end of every sprint: change ⬜/🟨 to ✅, fill in the sprint number, and add any notes worth remembering (gotchas, decisions, things to revisit).*
