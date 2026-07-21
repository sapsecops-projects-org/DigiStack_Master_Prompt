# DigiStack Bank — Database & SQL Deployment Standards

**Database:** PostgreSQL (standardized project-wide). **Applies to:** every version that touches schema or data.

---

## Directory Structure (in `digistack-infra` repo, or a `/db` folder per app repo)

```
/db
  /migrations
    V1__init_schema.sql
    V2__add_users_table.sql
    V3__add_accounts_table.sql
    V13__add_notifications_table.sql
    V15__add_jms_audit_table.sql
    ...
  /seed
    seed_dev.sql          (fake test data — Dev only, never run in UAT/Prod)
    seed_reference.sql    (reference data safe for all envs — e.g., transaction type codes)
  /rollback
    V3__add_accounts_table_rollback.sql
    ...
  /procedures
    (stored procedures / functions, if used)
```

## Migration Naming Convention (Flyway-style, industry standard)

```
V<version>__<description>.sql
```
- `V` prefix, version number matches (or maps to) the roadmap Version number where practical
- Double underscore separates version from description
- Description in `snake_case`, lowercase

**Examples:**
```
V1__init_schema.sql
V2__create_users_and_sessions.sql
V3__create_accounts_deposits_withdrawals.sql
V7__add_customer_profile_fields.sql
V13__create_notifications_table.sql
V15__create_jms_dlq_audit_table.sql
```

> Even if you're not using the Flyway tool itself, follow this naming convention manually — it's the de facto enterprise standard and keeps migrations ordered and traceable.

## Every Migration Script Must Include

```sql
-- =====================================================
-- Migration: V<N>__<description>.sql
-- Version:   Roadmap Version <N> — <Title>
-- Author:    <you>
-- Date:      <date>
-- Purpose:   <one line>
-- =====================================================

BEGIN;

-- Forward-only DDL/DML here

COMMIT;
```

- Wrap in a transaction (`BEGIN`/`COMMIT`) wherever PostgreSQL allows (DDL is transactional in Postgres — take advantage of it).
- Every table gets: `created_at TIMESTAMP DEFAULT now()`, `updated_at TIMESTAMP DEFAULT now()` at minimum, for audit-mindedness (this is a bank).
- Every migration is **forward-only** in the main script; the corresponding rollback lives in `/rollback` as a separate file, never combined.

## Naming Standards (Enterprise SQL Conventions)

- Tables: `snake_case`, plural — `customers`, `accounts`, `fund_transfers`, `notifications`
- Primary keys: `id` (surrogate, `BIGSERIAL` or `UUID` — pick one and stay consistent; `UUID` recommended for a banking system to avoid sequence-guessing)

> **Note:** `Digistack Bank Roadmap - Engineering Standards.md` §5 has an older example migration script (`beneficiary` table, `beneficiary_id SERIAL PRIMARY KEY`) that predates this plural/UUID standardization and doesn't follow it — that file's own Document Status note says this file governs on conflict. Every migration script actually written for this project should follow the naming standard on this page, not that older example.
- Foreign keys: `<referenced_table_singular>_id` — e.g., `customer_id`, `account_id`
- Indexes: `idx_<table>_<column(s)>` — e.g., `idx_accounts_customer_id`
- Constraints: `chk_<table>_<rule>`, `fk_<table>_<ref_table>`, `uq_<table>_<column>`

## Database Backup Practice (required from Version 1 onward)

> **Added per the 2026-07-20 architecture review (Finding 2).** Doc 01's VM snapshot discipline backs up the whole VM state, which is not a substitute for a DB-native, restorable backup — a VM snapshot taken mid-write can capture the database in an inconsistent state, and it doesn't give you point-in-time recovery. Real DB backup discipline starts here, in doc 05, from Version 1 — it is not deferred to Part-5 v38.

**Minimum required practice, every environment, from Version 1:**

1. **Weekly `pg_dump`** of every database in use at that point in the roadmap (the single shared DB through v22; `digistack_cbs` — and the legacy DB until its v23-era decommission — from v23 onward).
2. **Restore test every 15 days** — restore the most recent dump into a scratch database and confirm it loads cleanly and the app can read from it. An untested backup is not a backup.
3. **Retention:** keep the last 4 weekly dumps and the last 2 restore-test confirmations (rolling window, roughly a month of coverage at this cadence) — document the exact retention window and where dumps are stored in the relevant `SetupDoc-v<N>.md`.
4. **Naming convention:** `digistack_<db_name>_<env>_<YYYYMMDD>.dump` (e.g., `digistack_cbs_dev_20260722.dump`), stored outside the DB VM itself (a second disk, a dedicated backup share, or — from Part-9 v58 onward — the S3-based off-site target already established there).

**What this is not:** this is the *baseline* practice, not the final word on DB continuity. Part-5 v37/v38 still owns the advanced topics this baseline deliberately defers — streaming replication, PITR, automated failover, the full expanded backup inventory across every component (WAS config, IHS, plugin, certs, EARs, Git, dashboards). The weekly-dump/15-day-restore-test baseline above exists so that Versions 1–36 aren't running with zero DB-native backup story while waiting for those advanced topics to arrive.

## Environment-Specific DB Deployment (ties into Environment Promotion Standards)

| Environment | Who runs migrations | Seed data allowed? |
|---|---|---|
| Dev | You, manually, via psql or migration tool | Yes — `seed_dev.sql` freely |
| UAT | Run **only** the same migration scripts already approved in Dev — no ad hoc changes | Reference data only, no fake seed data |
| Prod | Run the exact same migration scripts, in the exact same order, as a documented Change | Reference data only |

**Rule:** the SQL that runs in Prod must be byte-identical to what was tested in UAT. No "quick fix" SQL typed directly into a Prod psql session, ever — that's how real banking outages happen.

## Authoritative Database After the CBS Split (Version 23+)

> **Beginning Version 24, all schema changes occur only inside `digistack_cbs`.** The legacy Portal/shared database used by Parts 1–2 is frozen at the moment of Version 23's migration (see Part-3, `V23__migrate_existing_data_to_cbs.sql`) and is never targeted by any migration script numbered `V24` or higher. It's retained read-only only as long as needed for migration verification/rollback, then formally decommissioned — the decommission step must be captured in `SetupDoc-v23.md`, not silently assumed.

## Version Control for DB Objects

- All migration scripts committed to Git (per Git Standards), same feature branch as the code that needs them.
- A running `schema_version` table in the DB itself (or Flyway's own tracking table if you adopt the real tool) records which migrations have been applied where — this becomes your source of truth for "what schema state is UAT actually in."

```sql
CREATE TABLE IF NOT EXISTS schema_version (
    version         VARCHAR(20) PRIMARY KEY,
    description     TEXT,
    applied_at      TIMESTAMP DEFAULT now(),
    applied_by      VARCHAR(100)
);
```

## Connection & Credentials Standard (ties into Part-1 v7 JDBC work)

- No credentials ever hardcoded in SQL scripts or application code.
- WAS-managed JAAS Auth Alias holds DB credentials (already part of Part-1's JDBC roadmap).
- Per-environment DB users with least privilege: an app runtime user (DML only, no DDL) is distinct from a migration/admin user (DDL rights) — a real bank would never let the app's runtime connection pool have `DROP TABLE` rights.

---

*This file is a standing standard. Each version that requires schema changes will produce its own numbered migration script(s) following this convention.*

---

**Change log for this revision (2026-07-20 architecture review):**
- Added "Database Backup Practice (required from Version 1 onward)" section — closing the gap where no DB-native backup discipline existed until Part-5 v38.

**Change log for this revision (cadence update):**
- Backup cadence changed from daily `pg_dump` to **weekly `pg_dump`**, and restore-test cadence changed from weekly to **every 15 days**, per explicit direction. Retention window adjusted accordingly (last 4 weekly dumps, last 2 restore-test confirmations — roughly a month of coverage at this cadence).
