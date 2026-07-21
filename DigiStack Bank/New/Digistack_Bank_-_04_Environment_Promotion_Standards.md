# DigiStack Bank — Environment Promotion Standards (Dev → UAT → Prod)

**Applies to:** Part-level promotion. Per your requirement: individual versions are built and tested in **Dev only**. Once an entire **Part** (e.g., all of Part-1, v1–v14) is complete, that whole Part is promoted through UAT to Prod as one release — mirroring how real banking releases batch multiple features into a release train rather than pushing every single commit to production.

---

## Environment Topology

| Environment | Purpose | VM Naming Convention |
|---|---|---|
| **Dev** | Where every version 1...N is built, unit-tested, and admin-configured first | `digistack-<role>-dev-01` |
| **UAT** | Mirrors Prod topology as closely as practical; full Part is regression-tested here | `digistack-<role>-uat-01` |
| **Prod** | Final environment; represents "go-live" for that Part | `digistack-<role>-prod-01` |

> On a single VMware host with limited resources, UAT and Prod can be separate **profiles/cells** on shared VM hardware rather than fully separate VMs — this will be called out explicitly when we reach the first promotion (end of Part-1) based on your actual VM capacity at that time.

## Promotion Trigger

A Part is eligible for promotion **only when:**
1. Every version in that Part has an "Approved" status in the Progress Log
2. Every version's `TestCases-v<N>.md` sign-off is fully checked
3. The Part's own "Completion Checkpoint" (found at the end of each Part's roadmap file) is fully checked
4. Git: `develop` branch is stable, all version feature branches merged, Part release tag applied on `develop`

## Promotion Pipeline (per Part)

```
develop (Dev, all versions merged & tested)
   │
   ▼
[UAT Promotion]
   │  - Build EAR/WAR from develop
   │  - Deploy to UAT WAS environment
   │  - Run full regression test pack (all TestCases-v1..vN.md re-executed)
   │  - Run any part-specific integration tests
   │  - UAT sign-off
   ▼
uat branch (tagged part<N>-uat)
   │
   ▼
[Prod Promotion]
   │  - Merge uat → main
   │  - Build final EAR/WAR from main
   │  - Deploy to Prod WAS environment following Change Management steps
   │  - Smoke test in Prod
   │  - Prod sign-off
   ▼
main (tagged part<N>-release)
```

## UAT Promotion Checklist (per Part)

- [ ] All version feature branches merged into `develop`
- [ ] Full regression: re-run every `TestCases-v<N>.md` in this Part against the UAT environment
- [ ] UAT-specific WAS admin re-verification (DataSources, SSL certs, security domains reconfigured for UAT hostnames — not copy-pasted from Dev)
- [ ] Performance baseline captured (even informally) for comparison against Prod later
- [ ] UAT sign-off recorded in Progress Log

## Prod Promotion Checklist (per Part)

- [ ] Change Request documented (even solo — simulate the artifact): what's changing, rollback plan, deployment window
- [ ] Backup of current Prod WAS config + DB taken **before** deployment (per Part-1 admin practice)
- [ ] Deploy during a defined "maintenance window" (practice discipline even without real users)
- [ ] Smoke test critical paths only (login, balance inquiry, fund transfer — not full regression, that already happened in UAT)
- [ ] Rollback plan tested at least once across the whole project (pick one Part promotion to deliberately practice a rollback)
- [ ] Prod sign-off recorded, `part<N>-release` tag applied on `main`

## Deployment Dependency / Startup-Order Matrix (required from Part-3 onward)

Once a Part has more than one deployable (Part-3 introduces 9), promotion isn't just "deploy everything" — order matters. Startup order (reverse for shutdown), required before any Part-3+ UAT/Prod promotion:

```
1. Infrastructure        — VMs, networking, LB, IHS, Tomcat host up
2. Database              — PostgreSQL (digistack_cbs + legacy, until retired)
3. MQ                    — IBM MQ Queue Manager
4. CBS                   — must be up before any service that calls it
5. Payment Hub           — depends on CBS
6. Notification Service  — depends on CBS (event consumer) + MQ
7. Reporting Service     — depends on CBS (data consumer)
8. Internet Banking Portal — depends on CBS
9. Branch Portal         — depends on CBS
10. Card Portal          — depends on CBS's Card Service
11. Mobile Banking (Tomcat) — depends on CBS REST + IHS virtual host routing
12. ATM Simulator (Tomcat)  — depends on CBS REST/SOAP + IHS virtual host routing
```

**Rule:** no deployable starts before everything above it in the list is confirmed healthy (via the `/health` endpoints introduced in Part-4 v31 — until then, manual verification). Each `SetupDoc-v<N>.md` from v23 onward should reference this table rather than restate it. Full detail and rationale: `Digistack Bank - 07 Configuration and Cross-Cutting Standards.md`, §3.

> **Duplication note (added 2026-07-19):** this table is intentionally duplicated verbatim in doc 07 §3, per that doc's own note that it "belongs" here. If you ever edit this table, mirror the edit into doc 07 §3 in the same sitting — the two copies have no automated way to stay in sync otherwise.

## Configuration Differences Per Environment

Maintain a simple config-per-environment table (grows over time) so Dev/UAT/Prod never accidentally share settings that should differ:

| Setting | Dev | UAT | Prod |
|---|---|---|---|
| DB host | `digistack-db-dev-01` | `digistack-db-uat-01` | `digistack-db-prod-01` |
| SSL cert | Self-signed | Self-signed (UAT CA if available) | Production-grade (or realistic self-signed for simulation) |
| Log level | DEBUG | INFO | WARN |
| MQ Queue Manager name | `QM_DEV` | `QM_UAT` | `QM_PROD` |

*(Populate fully once Part-1 reaches its first promotion — this table becomes a living document.)*

> **From Part-6 (v39) onward:** this table stays single-region (India/Dev-equivalent) as-is — don't add Singapore/Dubai columns here. Doc 07 §4 already extends the config-per-environment model to a full config-per-environment-**per-region** standard (`application-<env>-<region>.properties`) once regions exist; that's the authoritative place for the region axis, not a wider version of this table.

## Multi-Region Promotion (required from Part-6, v39 onward)

Part-6 introduces Singapore and Dubai alongside the existing India (former single-site) deployment. This does **not** change the "promote once per completed Part" rule — it changes what "Prod" means once you get there:

- **Dev remains single-region** (India only) — there's no value in building three parallel Dev environments for a solo learner; all Part-6 feature/config work is developed and unit-tested against India's Dev environment as before.
- **UAT and Prod become per-region promotions**, run sequentially off the same `release/part-6` branch (see doc 02's `release/part-<N>` branch definition): India → Singapore → Dubai (or whatever order you choose — pick one and document it in the Part-6 Promotion Checklist), not one combined "multi-region UAT."
- Each regional UAT/Prod promotion uses its own regional config file (`application-uat-<region>.properties` / `application-prod-<region>.properties`, per doc 07 §4) and its own regional VM set (per doc 01's regional naming convention).
- **Part-6 is only considered fully promoted once all three regions are independently signed off in Prod** — a two-of-three "mostly promoted" state is not a valid end state and should be called out explicitly in the Progress Log if it's ever the actual in-progress condition.
- Cross-region features (v41 integration, v42 identity/SSO) can only be smoke-tested meaningfully once **at least two** regions are live in the same environment tier — this is a hard prerequisite baked into the Part-6 Promotion Checklist, not an optional nice-to-have.

## Migration Part Promotion (required from Part-7, v44 onward)

Part-7 is both **multi-region** (per the Part-6 rules above) **and** a **platform migration** — old and new WAS platforms run in parallel (Side-by-Side, v44) before any traffic moves, and cutover itself is incremental (canary, v47), not a single event. Neither the standard "promote once per completed Part" flow nor the Multi-Region Promotion section above fully describes this shape on its own, so Part-7 (and any future platform-migration Part) follows this additional layer on top of both:

- **Dev stays single-region and single-platform-transition**, same as Part-6 — all of v44–v48's development and unit-testing happens against India's Dev environment only.
- Per doc 02's `release/part-<N>` branch definition, a `release/part-7` branch is cut from `develop` once Version 44 begins and is what all subsequent UAT/Prod passes (per region, across the parallel-environment and canary window) build from — `develop` keeps moving with any Part-8+ work in the meantime.
- **"UAT" for a migration Part means the new platform validated in parallel with the old one**, not a simple redeploy: the Version 44 Side-by-Side install, Version 45's full regression pack (all prior `TestCases-v1..v43.md` re-run against the new platform), and Version 46's infrastructure/security migration all complete and sign off *before* any cutover step is attempted — this is the migration-specific gate that replaces the standard "re-run regression in UAT" checklist item.
- **"Prod promotion" for a migration Part is not a single cutover event.** It is only complete when all of the following are true simultaneously, per region:
  1. The full Version 47 canary cutover (5% → 25% → 50% → 100%) has completed for that region, with session continuity and connection draining both proven.
  2. The Version 48 post-cutover observation window has closed cleanly for that region, with **no rollback triggered**.
  3. The old platform for that region has been formally decommissioned (not just idle — actually decommissioned, per Version 48's Migration Success Criteria).
- **All three regions must independently satisfy the above** before the Part as a whole is considered promoted — mirroring the Part-6 rule that a two-of-three "mostly promoted" state is not a valid end state.
- **While cutover is in progress**, the Part's status in the Progress Log must read an explicit **"Cutover in-flight"** state (naming which region(s) are on old platform, which are mid-canary, and which are fully cut over) — never rounded up to `part7-release` early just because one or two regions have finished.
- **Rollback during a migration Part promotion** is not a `hotfix/` branch (per the Rule below) — the application code isn't changing, the platform is. A rollback here means reverting traffic to the old platform (per v47's mechanics) and re-entering the parallel-environment state; this is documented per-phase in Version 48's Rollback Runbook, not treated as a code hotfix.
- `part7-release` (or the equivalent tag for any future migration Part) is applied on `main` **only after** every region has independently satisfied all three conditions above — consistent with how `part6-release` is gated on all three regions independently signing off in Prod.

## Phased Cloud Migration Promotion (required from Part-9, v54 onward)

> **Added per the 2026-07-19 cross-file audit.** Part-9 combines three shapes this doc already addresses individually — multi-region (per the Multi-Region Promotion section above), phased/progressive cutover with real intermediate production events (per the Migration Part Promotion section above), and pipeline-automated promotion (per Part-8 v53). No single existing section describes this combination, so Part-9 follows this explicit model, layered on top of both sections above:

- **Dev stays single-region** (India only), same as every other multi-pass Part.
- Part-9 is structured into four phases, each ending in a **capstone version** (v58 Phase-1, v63 Phase-2, v68 Phase-3, v73 Phase-4/final). **Each phase capstone is a Dev-only internal gate** — it confirms that phase's work is complete, regression-clean, and safe to build the next phase on top of. A phase capstone passing is **not** itself a UAT/Prod promotion event, and should not be logged as one in the Progress Log.
- **UAT and Prod promotion for Part-9 happens once, at the end of the Part** (after Version 73 is approved), across all three regions sequentially (India → Singapore → Dubai, or your chosen order — document it in the Part-9 Promotion Checklist) — exactly like every other standard Part's "promote once per completed Part" rule. The four phase capstones exist to de-risk that single promotion event, not to fragment it into four separate UAT/Prod passes.
- **Exception — infrastructure decommissioning is progressive, but Part-level promotion is not.** On-prem infrastructure for a given region may be formally decommissioned as early as Version 63 (Phase-2 Lift & Shift Capstone) once that region's post-cutover observation window closes cleanly, per Part-9's own Migration Success Criteria discipline (reused from Part-7 v48). This is an infrastructure-retirement event, tracked independently in the Progress Log's "AWS Migration Cutover Status" table — it is **not** the same thing as, and does not substitute for, the Part-level UAT/Prod promotion gate above.
- Per doc 02's `release/part-<N>` rule, a `release/part-9` branch is cut from `develop` once Version 54 begins, and all three regions' UAT/Prod passes build from it — consistent with how Parts 6, 7, and 8 each handled their own multi-pass promotion windows.
- **Part-9 is the first Part promoted via the Part-8 v53 automated pipeline** rather than the manual process this doc otherwise describes. The pipeline automates the *mechanics* of the rules above (build once, deploy the same artifact everywhere, gate on health/smoke/performance checks) — it does not change the gating rules themselves. If the pipeline and this doc's rules ever disagree, this doc governs; fix the pipeline, not the standard (same principle as doc 01 §"Rule" for Ansible playbooks in Part-8 v51).
- **While the phased cutover is in progress**, the Progress Log's Current Status Summary should reflect Part-9's actual state using the same discipline as Part-7's "Cutover in-flight" status — e.g., "Phase-2 in progress, India lift-and-shift complete" — rather than rounding up to "done."
- `part9-release` is applied on `main` **only after** every region has independently completed the standard Prod Promotion Checklist above **and** every region's "AWS Migration Cutover Status" row (Progress Log) reads "Cut over — old on-prem decommissioned" — mirroring the same "no two-of-three mostly-promoted state" rule already established for Parts 6 and 7.

## Rule

**Nothing skips Dev → UAT → Prod.** Even a one-line fix found in UAT goes back to a `hotfix/` branch off `develop`, gets retested, and re-promoted — no direct UAT/Prod edits, ever. This is the single most important real-world discipline this project is meant to teach.

---

*This file is a standing standard. The actual promotion event for Part-1 will be executed and logged once all of Part-1's versions are approved.*

---

**Change log for this revision (2026-07-19 cross-file audit):**
- Added the new "Phased Cloud Migration Promotion (required from Part-9, v54 onward)" section, resolving the ambiguity of whether Part-9's promotion happens once or per-phase.
- Added a duplication-drift warning note under the Deployment Dependency / Startup-Order Matrix, cross-referencing doc 07 §3.
