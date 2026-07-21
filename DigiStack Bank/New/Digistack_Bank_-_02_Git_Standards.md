# DigiStack Bank — Git Standards (Organization-Style)

**Applies to:** Every version, every part. Followed exactly like a real enterprise dev team would.

---

## Repository Structure

Two repos, matching the two-app architecture:

```
digistack-banking-portal/     (JSP/Servlet Portal — presentation only)
digistack-cbs/                (Core Banking System — all business logic)
```

Optionally a third repo for shared infra-as-code / DB scripts / WAS admin scripts:

```
digistack-infra/              (SQL scripts, wsadmin scripts, VM setup scripts, IHS/plugin configs)
```

## Branching Strategy — GitFlow-lite (right-sized for a solo learner simulating a team)

```
main            → always reflects PRODUCTION
uat             → release candidate, promoted from develop after UAT sign-off
develop         → integration branch, always reflects current DEV state
feature/v<N>-<short-description>   → one branch per version/feature
hotfix/v<N>-<short-description>    → emergency fixes off main
release/part-<N>                   → stable snapshot cut from develop, used only for
                                      multi-phase Part promotions (see below)
```

**Example:** `feature/v13-notifications`, `feature/v15-jms-async`, `hotfix/v9-session-timeout-bug`

**`release/part-<N>` — when it's used (added for Part-6 onward):** For a single-environment, single-pass Part promotion, the standard `develop → uat → main` flow above is sufficient — no dedicated release branch needed. From **Part-6 (multi-region) onward**, a Part's promotion can take multiple sequential passes (e.g., India → Singapore → Dubai UAT/Prod, run one at a time per doc 04's Multi-Region Promotion rules) or, for **Part-7 (migration)**, span a long parallel-environment/canary window (doc 04's Migration Part Promotion rules), or, for **Part-9 (phased cloud migration)**, span four phase capstones plus a progressive per-region cutover (doc 04's Phased Cloud Migration Promotion rules). In all of these cases, `develop` keeps moving with new work while the promotion is still in flight, so a stable `release/part-<N>` branch is cut from `develop` at the start of that Part's promotion window and is what each regional/phased UAT and Prod pass actually builds from — not a constantly-moving `develop`. The existing `uat`/`main` tagging convention (`part<N>-uat`, `part<N>-release`) still applies on top of this; `release/part-<N>` is only the stable source branch, not a new tag target.

## Commit Message Convention (Conventional Commits)

```
<type>(v<N>): <short summary>

<optional body>
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `config`

**Examples:**
```
feat(v15): add JMS queue and MDB for async fund transfer
docs(v15): add sprint deliverable and test cases
config(v19): configure MQ connection factory in WAS Admin Console
fix(v9): correct session timeout not applying on cluster failover
```

## Tagging Convention

Every **approved** version gets an annotated tag on `develop` (and again on `main` once it reaches Prod):

```
v1.0.0-dev       → Version 1 approved in Dev
v1.0.0-uat       → Version 1 promoted to UAT
v1.0.0           → Version 1 released to Prod (on main)
```

Part-level release tags (after a full Part's UAT→Prod promotion, per your requirement #4):

```
part1-release    → tagged on main once all of Part-1's versions are in Prod
part2-release    → same, for Part-2
```

## Pull Request Standard

Even solo, simulate the PR discipline:

1. Branch from `develop`: `feature/v<N>-<desc>`
2. Commit using the convention above
3. Open a PR: `feature/v<N>-<desc>` → `develop`
4. PR description template:
   ```
   ## Version
   v<N> — <title>

   ## What changed
   -

   ## WebSphere topics touched
   -

   ## Test cases
   Link to: TestCases-v<N>.md — all passed? Y/N

   ## Deployment notes
   -
   ```
5. Merge (squash or merge commit — pick one convention and stay consistent; squash is cleaner for a solo learner)
6. Delete the feature branch after merge

## EAR / Deployable Naming Standard (from Version 23 onward)

Part-1/Part-2 used a single deployable: `digistack-bank-v<N>.ear`. From Version 23, CBS, Payment Hub, Notification Service, Reporting Service, Branch Portal, and Card Portal each become independent EARs, and Mobile/ATM become independent Tomcat WARs. Naming standard (full table and rule in `Digistack Bank - 07 Configuration and Cross-Cutting Standards.md`, §1):

| Application | EAR/App Name |
|---|---|
| Internet Banking Portal | `digistack-portal-v<N>.ear` |
| CBS | `digistack-cbs-v<N>.ear` |
| Payment Hub | `digistack-paymenthub-v<N>.ear` |
| Notification Service | `digistack-notification-v<N>.ear` |
| Reporting Service | `digistack-reporting-v<N>.ear` |
| Branch Portal | `digistack-branch-v<N>.ear` |
| Card Portal | `digistack-cardportal-v<N>.ear` |
| Mobile Banking (Tomcat) | `digistack-mobile-v<N>.war` |
| ATM Simulator (Tomcat) | `digistack-atm-v<N>.war` |

`<N>` is always the version that **last modified** that specific deployable, not a per-app independent counter — keeps each filename traceable to "what version last touched this," matching how tags already tie to version numbers below.

> **Duplication note (added 2026-07-19):** this exact table is intentionally duplicated in doc 07 §1. If you ever edit this table, mirror the edit into doc 07 §1 in the same sitting — the two copies have no automated way to stay in sync otherwise.

## .gitignore Standards

Each repo should exclude, at minimum:
```
*.log
*.class
target/
build/
.metadata/
*.ear
*.war
.DS_Store
*.env
application.properties.local
```
(EAR/WAR build artifacts are generated, not committed — they're deployed straight to WAS or stored separately in a build artifact folder if you want deployment history.)

## What Gets Committed Per Version

- Source code changes (Portal and/or CBS repo)
- `TestCases-v<N>.md` (see Test Case Standards doc)
- `SetupDoc-v<N>.md` (see End-to-End Setup Documentation Standards)
- SQL scripts under `/db/vN/` (see DB Deployment Standards)
- Any WAS admin scripts (`wsadmin` Jython/Jacl scripts) used for that version's config changes

## Repo README Convention

Each repo's `README.md` maintains a **Version History** table, updated every merge:

```markdown
| Version | Title | Status | Merged Date | Tag |
|---|---|---|---|---|
| v1 | Project Setup & Enterprise Architecture | Prod | 2026-07-20 | v1.0.0 |
| v2 | Login & Dashboard | Dev | — | v2.0.0-dev |
```

---

*This file is a standing standard, not tied to a specific part. Every version's development work follows this exactly.*

---

**Change log for this revision (2026-07-19 cross-file audit):**
- Noted that Part-9 also qualifies for `release/part-<N>` under the existing rule (phased cloud migration + multi-region), matching the treatment already given to Parts 6–7.
- Added a duplication-drift warning note under the EAR/Deployable Naming table, cross-referencing doc 07 §1.
