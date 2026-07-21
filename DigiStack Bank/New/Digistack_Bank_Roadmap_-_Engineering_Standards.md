# DigiStack Bank — Engineering Standards

**Purpose of this document:** This is a **process standard**, not a version roadmap. It defines *how* every version across every Part will be built, tested, versioned, and promoted — matching real enterprise organization practices. Every version's sprint must produce the artifacts described here, in addition to the code itself.

This file should be uploaded alongside the MASTER INDEX and the relevant Part file in every new chat.

---

## ⚠️ Document Status & Relationship to docs 01–07 (resolved gap)

This file predates the more detailed, per-topic standards files (`Digistack Bank - 01 VM Setup Standards.md` through `07 Configuration and Cross-Cutting Standards.md`), which the MASTER INDEX lists separately as "Standing Process Standards" to be uploaded alongside this file every session. Sections 1–6 below cover the same ground as docs 01–06 respectively, and in a few places use **older conventions that were superseded** when those files were written — most notably:

- **Filenames:** Section 3/6 below use `TESTCASES-vN-<short-name>.md` / `SETUP-vN-<short-name>.md`. **The actual convention used throughout every Part file and doc 03/doc 06 is `TestCases-v<N>.md` / `SetupDoc-v<N>.md`** — use that, not the names below.
- **Part-release tags:** Section 2 below uses `part1-v1.0`. **The actual convention used in doc 02, doc 04, and every Part file's Completion Checkpoint is `part<N>-release`** (e.g. `part1-release`) — use that, not `part1-v1.0`.
- **Branching:** Section 2 below sketches a `release/*` branch. Doc 02 (the authoritative Git Standards file) now formally defines this as `release/part-<N>`, used for Part-6 (multi-region) onward — see doc 02 for the current definition.

**Rule going forward: wherever this file and docs 01–07 disagree, docs 01–07 govern.** This file's Sections 1–6 are kept for the narrative sprint-lifecycle walkthrough (useful context), not as the source of truth for exact conventions. **Sections 7 (Version Numbering Freeze) and 8 (Cross-Part Dependency Tracking) have no equivalent anywhere else and remain fully authoritative here.**

---

## 1. VM Setup — Per Version

Every version's sprint documentation includes a **VM Setup / Launch Checklist** so you can start from a clean or existing VM and get to a working state.

### Standard structure (produced for every version):
```
### VM Setup — Version N

**Prerequisites (carried from previous version):**
- [What must already be running/configured]

**New in this version:**
- [Any new software/service to install — e.g., IBM MQ, NGINX]

**Steps:**
1. Power on VM / boot to snapshot [if applicable]
2. Start WAS processes (DMgr, Node Agent, AppServers) — exact commands
3. Start any new services introduced this version
4. Verify: [specific URL/command to confirm the environment is up]

**Shutdown sequence (end of session):**
1. [Reverse order of startup, with exact commands]

**Snapshot recommendation:** Take a VM snapshot after this version is approved, tagged `digistack-vN-approved`, so you can roll back cleanly if a later version breaks something.
```

This checklist will be included in every version's deliverable set going forward, scaled to what's actually new in that version (early versions are short; later versions with MQ/LB/multi-VM setups will be longer).

---

## 2. Git Strategy — Organization-Standard Branching

### Repository structure
Two repositories (matching the two-app architecture):
- `digistack-banking-portal` (or a monorepo with `/portal` and `/cbs` — your call; monorepo recommended for solo learning to keep it simple, noted as a deviation from "true" enterprise multi-repo if so)
- `digistack-cbs`

### Branching model (simplified GitFlow — appropriate for a solo learner simulating enterprise practice)

```
main            ── production-ready code only, tagged per release
  │
release/*       ── release candidate branches, e.g. release/part-1
  │
develop         ── integration branch, always reflects latest completed & approved version
  │
feature/*       ── one branch per version/feature, e.g. feature/v1-project-setup
```

### Standard workflow per version
1. Branch from `develop`: `feature/vN-short-description` (e.g., `feature/v5-was-clustering`)
2. Commit frequently with **Conventional Commits** format:
   - `feat(v5): add cluster member configuration`
   - `fix(v3): correct fund transfer rollback logic`
   - `docs(v5): add VM setup and test cases`
   - `chore(v5): update plugin-cfg.xml`
3. Open a "Pull Request" (can be self-reviewed if solo) from `feature/vN-*` → `develop`
4. On approval (your sprint sign-off), merge to `develop`, delete feature branch
5. At the end of each **Part** (e.g., after v14), branch `release/part-1` from `develop`, promote through Dev → UAT → Prod (see Section 4), then merge to `main` and tag: `part1-release` (per doc 02's authoritative tag convention — supersedes the `part1-v1.0` example this section originally used)

### Commit message standard (Conventional Commits)
```
<type>(vN): <short description>

[optional longer body]

[optional footer, e.g., Closes #issue]
```
Types: `feat`, `fix`, `docs`, `test`, `chore`, `refactor`, `perf`, `security`

### .gitignore essentials for this project
```
*.class
target/
build/
*.ear
*.war
*.log
.metadata/
.settings/
application.properties.local
*.env
```
Never commit: DB passwords, keystore files (`.jks`/`.p12`), API keys — use placeholders and a separate untracked config.

### Tagging convention
- Per version (optional, lightweight): `v15-jms-async`
- Per Part release: `part1-release`, `part2-release`, etc. (matches doc 02/doc 04's authoritative convention — see Document Status note above; do not use `part1-v1.0`)

---

## 3. Test Cases — Separate `.md` Per Version

Every version produces its **own** test case file, named:
```
TESTCASES-vN-<short-name>.md
```
e.g., `TESTCASES-v5-was-clustering.md`

### Standard template (organization-style test case documentation):

```markdown
# Test Cases — Version N: <Feature Name>

**Module:** <Portal / CBS / Both>
**Environment:** Dev
**Tester:** <name>
**Date:** <date>
**Build/Tag:** <git tag or commit hash>

## Test Summary
| Total Cases | Passed | Failed | Blocked | Not Run |
|---|---|---|---|---|
|   |   |   |   |   |

## Test Cases

| TC ID | Title | Precondition | Steps | Expected Result | Actual Result | Status (Pass/Fail) | Priority |
|---|---|---|---|---|---|---|---|
| TC-vN-001 | | | 1. ...<br>2. ...<br>3. ... | | | | High/Med/Low |
| TC-vN-002 | | | | | | | |

## WebSphere-Specific Verification
| Check | Expected | Actual | Status |
|---|---|---|---|
| e.g., Cluster member 2 responds after member 1 stopped | Request succeeds via failover | | |

## Defects Logged
| Defect ID | Description | Severity | Status |
|---|---|---|---|

## Sign-off
- [ ] All High priority test cases passed
- [ ] No open Critical/High defects
- [ ] Approved for promotion to next environment
```

Every version's sprint will produce this file with real test cases derived from that version's Sprint Deliverable and Banking Features.

---

## 4. Environment Promotion — Dev → UAT → Prod (Per Part)

Promotion happens **once per completed Part**, not per version — versions are built and tested in Dev only; the Part's Completion Checkpoint is the gate for promotion.

### Environment topology (simulated on your single VM, or additional VMs if available)
| Environment | Purpose | Typical differences from Dev |
|---|---|---|
| **Dev** | Active development, one version at a time | Debug logging on, relaxed security, self-signed certs |
| **UAT** | User Acceptance Testing — simulates "the business" validating the release | Prod-like config, real test data volumes, all Part versions integrated |
| **Prod** | Simulated production | Hardened security, monitoring active, change-controlled |

### Promotion checklist template (per Part):
```markdown
# Promotion Checklist — Part N → UAT

**Source:** develop branch @ commit <hash> / tag <part-N-uat-candidate>
**Target Environment:** UAT

## Pre-Promotion Gate
- [ ] All versions in this Part have Approved status in Progress Log
- [ ] All TESTCASES-vN-*.md files show 100% High-priority pass rate
- [ ] No open Critical/High defects
- [ ] Part Completion Checkpoint (from Part roadmap file) fully checked off
- [ ] DB migration scripts reviewed (see Section 5)
- [ ] Release notes drafted

## Promotion Steps
1. Build EAR from `release/part-N` branch
2. Deploy to UAT WAS profile/cell (document exact wsadmin/Admin Console steps)
3. Run DB migration scripts against UAT database
4. Smoke test (subset of critical test cases from each version)
5. Sign-off

## Post-Promotion
- [ ] UAT sign-off obtained (simulate as self-review against acceptance criteria)
- [ ] Proceed to Prod promotion using same checklist structure
```

Same checklist structure repeats for **UAT → Prod**, with stricter gates (e.g., change window, rollback plan required, backup taken immediately before deployment).

### Rollback plan (required before every Prod promotion)
- Previous EAR version retained and ready to redeploy
- DB rollback script tested (see Section 5)
- Documented "abort criteria" — what failure triggers a rollback decision

---

## 5. Database — SQL Scripts & DB Deployment Standard

### Migration-based approach (like Flyway/Liquibase conventions, done manually here for learning)

**File naming convention:**
```
db/migrations/
  V1__initial_schema.sql
  V2__add_accounts_table.sql
  V3__add_beneficiary_table.sql
  V15__add_jms_audit_table.sql
  ...
```
Numbering aligns with roadmap **Version numbers** where a version introduces schema changes — not every version needs one.

**Every migration script includes a paired rollback script:**
```
db/rollback/
  V3__add_beneficiary_table_rollback.sql
```

### Standard script header (organization convention):
```sql
-- =====================================================
-- Migration: V3__add_beneficiary_table.sql
-- Version:   Version 3 - Banking Modules
-- Author:    Venkatesh
-- Date:      YYYY-MM-DD
-- Purpose:   Adds beneficiary table to support fund transfer feature
-- Rollback:  V3__add_beneficiary_table_rollback.sql
-- =====================================================

BEGIN;

CREATE TABLE beneficiary (
    beneficiary_id  SERIAL PRIMARY KEY,
    account_id      INTEGER NOT NULL REFERENCES account(account_id),
    beneficiary_name VARCHAR(100) NOT NULL,
    beneficiary_account VARCHAR(20) NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

COMMIT;
```

### DB deployment checklist (per Part promotion, and per version in Dev)
```markdown
## DB Deployment — Version N

- [ ] Migration script written and peer-reviewed (self-review acceptable for solo project)
- [ ] Rollback script written and tested in Dev
- [ ] Backup taken before applying (pg_dump) — command documented
- [ ] Migration applied to target environment
- [ ] Schema verified (e.g., \dt / \d table_name in psql)
- [ ] Application smoke-tested against new schema
```

### Environment-specific DB naming convention
```
digistack_dev
digistack_uat
digistack_prod
```

Connection details (host/port/credentials) are **never** committed to Git — tracked only in the Progress Log's Environment Notes section (already set up for this) or a local untracked `.env` file.

---

## 6. End-to-End Setup Documentation — Per Version

Every version's sprint produces one consolidated document:
```
SETUP-vN-<short-name>.md
```

### Standard template:
```markdown
# Setup Documentation — Version N: <Feature Name>

## 1. Overview
[1-2 sentences: what this version adds]

## 2. Prerequisites
- Previous version(s) completed and verified
- [Any new software required]

## 3. VM Setup
[Pulled from Section 1 template above]

## 4. WebSphere Configuration Steps
[Exact Admin Console navigation OR wsadmin script, with expected output shown inline — per your existing "no paste-back checkpoints" preference]

## 5. Database Changes
[Reference to migration script, if any — see Section 5]

## 6. Application Deployment
[EAR/WAR build and deploy steps, exact commands/screens]

## 7. Verification Steps
[How to confirm this version works — ties to Test Cases file]

## 8. Git Reference
- Branch: feature/vN-...
- Commits: ...
- Tag (if applicable): ...

## 9. Rollback Instructions
[How to undo this version's changes if something goes wrong]

## 10. Known Issues / Notes
[Anything discovered during this sprint worth remembering]
```

This becomes the **single file you'd hand to "someone new"** (or your future self) to stand up that exact version from scratch — matching your requirement to "launch the VM and configure using that given document."

---

## 7. Version Numbering Freeze (applies across all Parts)

Once a Part's roadmap file is marked "✅ Roadmap ready" (per the MASTER INDEX Part Index table), its version numbers are considered **frozen**. Do not renumber versions once implementation could plausibly reference them — version numbers show up everywhere (branch names, tags, migration script filenames, `TestCases-vN.md`/`SetupDoc-vN.md` filenames, the Progress Log, cross-Part references like "reusing v15's JMS foundation") and renumbering after the fact silently breaks all of those references.

**Rule:** If a new topic or feature needs to be inserted after a Part is frozen:
1. **Prefer pushing it to a later, not-yet-roadmapped Part** rather than inserting into a frozen one.
2. If it genuinely must slot into an already-frozen Part, use a **suffix** on the nearest appropriate version (e.g., `v30A`) rather than renumbering everything after it.
3. Never silently renumber a frozen Part. If a renumbering is unavoidable, it must be done as one deliberate, fully-documented pass — not an incremental drift.

**Precedent — how to do it correctly, if it's ever unavoidable:** Part-3 underwent exactly one deliberate renumbering pass during its own roadmap review, before any version in it had been implemented. It is documented in full at the bottom of `Digistack Bank Roadmap - Part-3.md` under "🔍 Module Sufficiency Review — Resolved," including an explicit **Renumbering Summary** table mapping old version numbers/titles to new ones (e.g., old v26 "ATM, POS & Card Channel Simulation" split into new v27/v28; old v29 "Mobile Banking Channel" renumbered to v26). That table is the reference model: any future renumbering must produce an equivalent before/after mapping table in the affected Part file, not just a changed number with no trail.

**Current frozen state (per MASTER INDEX Part Index):**
- Part-1: Versions 1–14 — frozen
- Part-2: Versions 15–22 — frozen
- Part-3: Versions 23–30 — frozen (already includes its one renumbering pass, documented above)
- Part-4: Versions 31–35 — frozen (Enterprise Observability, SRE & Production Operations; included one pre-implementation renumbering pass from an initial 28–32 draft, documented in the Part-4 file)
- Part-5: Versions 36–38 — frozen (Enterprise HA, DR & Business Continuity; included one pre-implementation renumbering pass from an initial 33–34 draft, documented in the Part-5 file)
- Part-6: Versions 39–43 — frozen (Multi-Region Enterprise Banking & Middleware Architecture; title conflict with "WebSphere Migration" resolved in favor of Multi-Region, per MASTER INDEX Open Decisions; included one pre-implementation **offset** — not a full renumbering — from an initial 38–42 draft that collided with Part-5's frozen 36–38, documented in the Part-6 file)
- Part-7: Versions 44–48 — frozen (Enterprise WebSphere Migration & Modernization; deferred from Part-6 per the title-conflict resolution; included one pre-implementation renumbering pass from an initial 43–47 draft that collided with Part-6's frozen 39–43, documented with a full mapping table in the Part-7 file. Adds zero new banking functionality — migrates/upgrades the WebSphere platform underneath the existing 9 applications.)
- Part-8: Versions 49–53 — frozen (Enterprise DevOps & End-to-End Automation; retitled from an earlier "AWS Migration" placeholder — see MASTER INDEX Open Decisions. Included one pre-implementation renumbering pass from an initial 48–52 draft that collided with Part-7's frozen 44–48, documented with a full mapping table in the Part-8 file. Adds zero new banking functionality — automates Git/branching governance, CI/CD, infrastructure-as-code, and deployment steps performed manually since Part-1, culminating in a region-aware end-to-end pipeline.)
- Part-9: Versions 54–73 — frozen (Enterprise Hybrid Cloud & AWS Migration; included one pre-implementation renumbering pass from an initial 53–72 draft that collided with Part-8's frozen 49–53, documented with a full mapping table in the Part-9 file. Also corrected a MySQL-vs-PostgreSQL inconsistency in the source draft — PostgreSQL/Amazon RDS for PostgreSQL throughout, per the project-wide standard. Adds zero new banking functionality — migrates the existing 9 applications from on-premises to a fully AWS-native platform across four phases, and is the first Part promoted via the Part-8 v53 automated pipeline rather than manually.)
- Part-10: not yet roadmapped — version numbers TBD, not frozen until its roadmap file is marked ready. Proposed Containerization content (bumped from its former Part-9 slot).

---

## 8. Cross-Part Dependency Tracking

Every version, once actually implemented (not at roadmap-design time — this is populated as work happens, not pre-filled with guesses), should have its dependency chain recorded: what it depended on, what it produced, and what later versions consumed that output. This is tracked in the **Progress Log** (`Digistack Bank Roadmap - Progress Log.md`), in a dedicated "Cross-Part Dependency Chain" table, alongside the Detailed Version Log — not duplicated here, since this file is a process standard and the Progress Log is the implementation record.

Format:
```
| Version | Depends On | Produces | Used By |
|---|---|---|---|
```
See the Progress Log file for the live table.

---

## Updated Sprint Lifecycle (supersedes the shorter version in Part files)

Every version now produces **five artifacts**, not just code:

1. **Code** (Portal + CBS changes, in `feature/vN-*` branch)
2. **SETUP-vN-*.md** (end-to-end setup doc, Section 6)
3. **TESTCASES-vN-*.md** (Section 3)
4. **DB migration + rollback scripts** (if applicable, Section 5)
5. **Git commits/PR** following the standard (Section 2)

Sprint flow per version:
```
Requirements
   │
   ▼
Development (code + inline teaching)
   │
   ▼
DB Migration (if needed) written + tested
   │
   ▼
Deployment to Dev WAS + VM setup doc written
   │
   ▼
Testing → TESTCASES-vN-*.md completed
   │
   ▼
SETUP-vN-*.md finalized
   │
   ▼
Git commit/PR → merge to develop
   │
   ▼
Pause for your approval
   │
   ▼
(At end of Part) → Promotion checklist → UAT → Prod
```

---

*This Engineering Standards document applies to every Part (1 onward — see Section 7's frozen-state list, which already tracks through Part-9 and the not-yet-roadmapped Part-10). Upload it alongside the MASTER INDEX, docs 01–07, and the relevant Part file in every new chat, so version builds automatically follow this process without needing to be re-explained. Where this file's Sections 1–6 disagree with docs 01–07 on an exact convention (filenames, tags, branches), docs 01–07 govern — see the Document Status note near the top of this file.*
