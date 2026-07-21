# DBA request — WebSphere ND 9 data sources & JMS store (bankCell01)

Reference CR: ______________ (link to the Phase 0 change request)

## 1. Purpose

WebSphere ND 9's own cell/profile configuration does not require a database. This request covers the two things that *do* need one once applications deploy onto the cell:

- HTTP session persistence (survives a cluster member restart, unlike memory-to-memory replication alone)
- JMS message store for the Service Integration Bus (guaranteed-delivery queues — relevant if RTGS/NEFT settlement messaging is in scope)

## 2. Connection pool sizing (derived from cluster topology — Phase 0)

| Cluster | Members | Max pool size per JVM | Total connections |
|---|---|---|---|
| Retail banking cluster | 8 | 30 | 240 |
| RTGS/NEFT gateway | 3 | 20 | 60 |
| **Subtotal** | | | **300** |
| **Requested DB-side capacity (+20% headroom)** | | | **~360** |

DBA action: size `PROCESSES`/`SESSIONS` (Oracle) or `MAXAPPLS` (DB2) to comfortably exceed this total, not just the connection count of a single application.

## 3. Schema & tablespace requirements

| Item | Detail (fill in) |
|---|---|
| RDBMS type/version | e.g. Oracle 19c / DB2 11.5 |
| Schema name(s) | |
| Session persistence tablespace sizing | Est. size = concurrent sessions × avg session size (see Phase 0 sizing worksheet) |
| JMS message store tablespace sizing | Est. size = peak message volume × retention period (audit/replay requirement) |
| Retention period for JMS store | e.g. settlement messages retained ___ days |
| JDBC driver version | Must match the WAS ND 9 supported driver matrix — confirm exact jar version with DBA before requesting |

## 4. Credential management (do not skip — this is an audit item)

- [ ] Credentials will **not** rely solely on WebSphere's default `{xor}` encoding — minimum requirement is AES-based custom encryption (`PropFilePasswordEncryptionUtility`)
- [ ] Preferred: integration with enterprise vault (CyberArk / HashiCorp Vault) via a J2C custom credential provider, so rotation doesn't require a WebSphere config change
- [ ] Rotation policy agreed with Security: ______________

## 5. Sign-off

| Role | Name | Date |
|---|---|---|
| DBA lead | | |
| Middleware admin | | |
| Security reviewer | | |
