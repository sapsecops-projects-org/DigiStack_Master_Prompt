# DigiStack Bank — Cross-File Consistency Audit & Gap Fill

**Audit date:** 2026-07-19
**Files reviewed:** Master Index, Progress Log, Engineering Standards, Docs 01–07, Part-1 through Part-9 (17 files total)
**Scope of this audit:** (1) application/version continuity across Parts, (2) file-to-file sync, (3) Part-to-Part sync, (4) recommendations, (5) concrete fills for every gap found.

---

## 1. Continuity Matrix — Version Numbering Across All Parts

| Part | Title | Versions | Count | Starts right after prior Part ends? |
|---|---|---|---|---|
| 1 | Enterprise Banking Application Development | 1–14 | 14 | n/a (first Part) |
| 2 | Enterprise Middleware Integration | 15–22 | 8 | ✅ (14→15) |
| 3 | Enterprise Banking Systems (CBS, Payments, Channel Simulators, Loans) | 23–30 | 8 | ✅ (22→23) |
| 4 | Enterprise Observability, SRE & Production Operations | 31–35 | 5 | ✅ (30→31) |
| 5 | Enterprise HA, DR & Business Continuity | 36–38 | 3 | ✅ (35→36) |
| 6 | Multi-Region Enterprise Banking & Middleware Architecture | 39–43 | 5 | ✅ (38→39) |
| 7 | Enterprise WebSphere Migration & Modernization | 44–48 | 5 | ✅ (43→44) |
| 8 | Enterprise DevOps & End-to-End Automation | 49–53 | 5 | ✅ (48→49) |
| 9 | Enterprise Hybrid Cloud & AWS Migration | 54–73 | 20 | ✅ (53→54) |
| 10 | Containerization (proposed) | TBD (should start at 74) | — | Awaiting roadmap |

**Verdict: Continuity is fully intact.** Every renumbering/offset table in Parts 3–9 sums correctly, every Part's "Application State After Part-N" section matches the next Part's "Prerequisite" section, and the Engineering Standards §7 frozen-state list matches every Part file's own numbering-correction section. This is the strongest area of the whole project — no fix needed here.

---

## 2. Standing-Standard Cross-Reference Check (Docs 01–07 + Engineering Standards)

| Check | Result |
|---|---|
| VM inventory (doc 01) vs. actual "New VM introduced" notes in Parts 2–9 | ✅ Matches (was/db/ihs/lb/mq/tomcat/monitoring/elk/tracing/DR/regional/GSVC VMs all land in the version the Part says they do) |
| EAR naming table: doc 02 vs. doc 07 §1 | ✅ Identical (intentional duplication — see Finding F13) |
| Deployment Dependency/Startup-Order Matrix: doc 04 vs. doc 07 §3 | ✅ Identical (intentional duplication — see Finding F13) |
| Certificate Inventory (doc 07 §7) vs. version that actually introduces each cert | ✅ Matches every entry, v11 through v67 |
| Port Matrix (doc 07 §6) vs. version that introduces each service | ✅ Matches, including the explicit DR-site "reuses same ports" note |
| DB-authority-after-v23 rule: doc 05 vs. doc 07 §2 vs. Part-3 v23 | ✅ Stated identically in all three places |
| Filename/tag/branch convention conflicts: Engineering Standards vs. docs 01–07 | ✅ Correctly flagged as superseded by Engineering Standards' own "Document Status" note — no lingering contradiction |
| Multi-Region Promotion rule (doc 04) vs. Part-6 | ✅ Matches |
| Migration Part Promotion rule (doc 04) vs. Part-7 | ✅ Matches |
| **Phased Cloud Migration Promotion rule (doc 04) vs. Part-9** | ⚠️ **Gap — see F3** |

---

## 3. Findings

### 🔴 Moderate-priority (affects how work will actually get done)

**F1 — Master Index and Progress Log tracker tables disagree with each other, and are internally inconsistent.**

- Master Index Progress Tracker shows Part 4's "Next Version To Build" as `—`.
- Progress Log's Current Status Summary shows Part 4's "Next Version To Build" as `Version 31`.
- Both files also leave Part 2 and Part 3's "Next Version To Build" blank (`—`), while every other row (1, 4-in-Progress-Log, 5, 6, 7, 8, 9) states the actual next version number.

Since the Progress Log's own header says it must be "kept in sync with the MASTER INDEX Progress Tracker," this is a real, checkable drift.

**Fix — apply to both files identically:**

| Part | Next Version To Build (corrected) |
|---|---|
| 2 | Version 15 |
| 3 | Version 23 |
| 4 | Version 31 *(already correct in Progress Log — fix Master Index to match)* |

---

**F3 — doc 04 has no promotion model for Part-9's specific shape (multi-region + pipeline-automated + 4-phase progressive cutover).**

Doc 04 already has bespoke sections for Part-6 ("Multi-Region Promotion") and Part-7 ("Migration Part Promotion," because Part-7 runs old/new platforms in parallel with incremental cutover). Part-9 is arguably a superset of both: it's multi-region *and* it has real, progressive production cutover events at intermediate versions (v60 Hybrid Production, v63 regional on-prem decommission, v69 final cutover, v73 capstone) *and* it's the first Part meant to be promoted via the Part-8 v53 pipeline rather than manually. Nothing currently states whether Part-9's actual Dev→UAT→Prod promotion happens **once** (at v73, per the default "once per completed Part" rule) or **per phase** (like Part-7's per-region canary gating).

**Fix — add this new subsection to doc 04, after "Migration Part Promotion":**

> ## Phased Cloud Migration Promotion (required from Part-9, v54 onward)
>
> Part-9 combines three shapes doc 04 already addresses individually: multi-region (per the Part-6 rules), phased/progressive cutover (per the Part-7 Migration Part Promotion rules), and pipeline-automated promotion (per Part-8 v53). None of the existing sections alone describes it, so Part-9 follows this explicit combined model:
>
> - **Dev stays single-region** (India only), same as every other multi-pass Part.
> - Each of Part-9's four phase capstones (v58, v63, v68, v73) is a **Dev-only internal gate** — it confirms that phase's work is complete and regression-clean, but it is **not** itself a UAT/Prod promotion event.
> - **UAT and Prod promotion for Part-9 happens once, at the end of the Part** (after v73), across all three regions sequentially (India → Singapore → Dubai), exactly like every other standard Part — the phase capstones de-risk the work beforehand, they don't fragment the promotion into four separate UAT/Prod passes.
> - **Exception — decommissioning is progressive, promotion is not.** On-prem infrastructure for a given region may be formally decommissioned as early as v63 (Phase-2 capstone) once that region's observation window closes cleanly — this is an infrastructure retirement event, tracked in the Progress Log's cutover-status table, and is independent of the Part-level UAT/Prod promotion gate above.
> - `release/part-9` is cut from `develop` per doc 02's rule (multi-pass Part), used for all three regions' UAT/Prod passes.
> - Part-9 is the first Part promoted via the Part-8 v53 automated pipeline rather than the manual process (doc 04's standard flow) — the pipeline automates the *mechanics* of this section, it does not change the gating rules above.
> - `part9-release` is applied on `main` only after all three regions have independently completed the standard Prod Promotion Checklist, mirroring the "no two-of-three mostly-promoted state" rule already established for Part-6.

---

**F4 — Progress Log's cutover-tracking table is scoped only to Part-7; Part-9 has an equally real (arguably more complex) progressive cutover with no tracking table.**

Part-7 gets a "Migration Cutover Status" table (region × platform-state × canary% × observation-window × decommission-status). Part-9 has the same shape of event — progressively, per region, across v60 (hybrid production), v63 (regional decommission), v69 (final cutover) — but nothing tracks it.

**Fix — add this table to the Progress Log, right after the existing "Migration Cutover Status" table:**

> ## AWS Migration Cutover Status (populate only once Part-9 v60 is reached)
>
> Per doc 04's new "Phased Cloud Migration Promotion" section: track each region's AWS migration state independently. Part-9 is not `part9-release` until every region reads "Cut over — on-prem decommissioned" here.
>
> | Region | On-Prem/AWS Split (v60) | Lift-and-Shift Complete? (v63) | Platform Modernized? (v68) | Final Cutover % (v69) | Old On-Prem Decommissioned? |
> |---|---|---|---|---|---|
> | India | Not started | — | — | — | — |
> | Singapore | Not started | — | — | — | — |
> | Dubai | Not started | — | — | — | — |

---

**F7 — Ambiguous relationship between Part-2 v18's "Operations Dashboard" and Part-4 v31's Prometheus/Grafana foundation.**

Part-2 v18 builds a custom PMI/JMX-based Operations Dashboard covering JVM health, session count, JMS queue depth, and DB pool usage. Part-4 v31 then builds "Grafana (dashboard shell only)" over Prometheus/Node/JMX/PostgreSQL exporters, covering — almost verbatim — the same ground (JVM heap/GC/thread pools, JDBC pools, session count, cluster health). Neither file says whether v31 supersedes, replaces, or coexists with v18's dashboard. A fresh reader picking up Part-4 would reasonably wonder why they're rebuilding something that sounds like it already exists.

**Fix — add this paragraph to Part-4, Version 31, right after "Minimum App Needed":**

> **Relationship to Part-2 v18's Operations Dashboard:** v18 built a minimal, single-purpose PMI/JMX viewer specifically to prove WAS admin fluency at that point in the roadmap — it was never intended as the project's permanent monitoring solution. Version 31 formally **supersedes and retires** v18's custom dashboard: the same underlying PMI/JMX data sources are re-pointed into the Prometheus/Grafana stack built here, and v18's standalone dashboard code is decommissioned once v31's Grafana instance reaches parity. This is called out explicitly so v18 isn't mistaken for redundant scope, or v31 for accidental duplication — v18 was the "does the data exist" proof; v31 is the enterprise-grade permanent home for it.

---

### 🟡 Minor-priority (cosmetic / clarity, low risk of causing real confusion)

**F2 — Progress Log's Part-3 title doesn't match the canonical title.**
Progress Log says "Enterprise Banking Systems (CBS, Payments, ATM)"; the Master Index and Part-3 file itself say "Enterprise Banking Systems (CBS, Payments, Channel Simulators, Loans)."
**Fix:** Update the Progress Log's Current Status Summary row 3 title to match exactly.

**F5 — doc 01 doesn't point outward to Part-9's Cloud Resource Inventory.**
Part-9 introduces a parallel "Cloud Resource Inventory" (since AWS resources aren't on-prem VMs) and explains this itself — but doc 01, which every other Part cross-references *into*, never cross-references *out* to it.
**Fix — add one line to doc 01, at the end of the VM inventory table's surrounding text:**
> **From Part-9 (v54) onward:** AWS resources are tracked in a separate **Cloud Resource Inventory** (defined in `Digistack Bank Roadmap - Part-9.md`), not folded into this table — on-prem/EC2-hosted VMs continue to use this doc's naming convention; managed AWS services (RDS, S3, SQS/SNS) use the Part-9 convention (`digistack-aws-<role>-<region>-01`).

**F6 — doc 07 §6 Port Matrix's "reuse same ports" note covers DR-site VMs but not Part-6's regional VMs.**
**Fix — add one line to doc 07 §6, next to the existing DR-site note:**
> (Singapore/Dubai regional VMs — introduced Part-6 v39 — likewise reuse the same port numbers as their India counterparts, since it's a replicated topology, not new services.)

**F8 — doc 03's "Security versions" list incorrectly includes v9.**
v9 (Session Management — sticky sessions, replication, timeout) is already correctly listed under "Clustering/HA versions." Its appearance in "Security versions (v9, v10, v11, v12, v17)" looks like a copy/paste artifact rather than a deliberate double-classification.
**Fix:** Change to "Security versions (v10, v11, v12, v17)."

**F9 — doc 03's illustrative version lists were never refreshed for later Parts.**
Not a functional bug (the coverage *rule* applies project-wide regardless of the example list), but the "e.g." lists only cite Part-1/2 versions and now look stale next to Parts 5–9's HA/DR/Security work.
**Fix (optional, low urgency):** Expand the illustrative lists, e.g.:
> - Clustering/HA versions (e.g., v5, v9, v21, v36, v37, v40, v43, v61)
> - Security versions (e.g., v10, v11, v12, v17, v42, v46, v67, v72)

**F10 — Part-7's "Side-by-Side"/"Parallel Environment" language could be misread as requiring new hardware that's never actually provisioned anywhere in doc 01.**
v44's own VM Setup Note says "No new VM introduced... upgraded in place, one node at a time," while the strategy section calls Side-by-Side the Part's primary strategy and v47 talks about a "Parallel Environment (Old + New platforms both live)." Taken together, this is realized as *mixed-version cluster membership within the existing VM inventory* during the rolling window — not literally separate new infrastructure — but that resolution is never stated outright.
**Fix — add one sentence to Part-7, v44, at the end of the "Migration Strategy Options" subsection:**
> **Clarification for this project's scale:** "Side-by-Side" and "Parallel Environment" (v47) are realized here as *mixed-version cluster membership on the existing VM inventory* (some cluster members on the old WAS version, some on the new, during the rolling window) — not as a second, separately-provisioned set of hardware. No new VM is introduced anywhere in doc 01 for this migration; that's a deliberate scope decision consistent with this project's lab scale, not an oversight.

**F11 — Part-9 never explicitly states it uses a `release/part-9` branch, unlike Parts 6, 7, and 8.**
**Fix — add one sentence to Part-9, near the Cloud Resource Inventory note:**
> Per doc 02's `release/part-<N>` rule (required for any Part whose promotion spans multiple regional passes or a long cutover window), a `release/part-9` branch is cut from `develop` once Version 54 begins, and all three regions' UAT/Prod passes build from it — consistent with how Parts 6, 7, and 8 each handled their own multi-pass promotion windows.

**F13 — Intentionally duplicated tables (EAR naming; Deployment/Startup-Order Matrix) risk silent drift.**
Both duplicate pairs state which file is "authoritative," but nothing marks *when* each was last verified identical.
**Fix (process, not content):** Add a one-line footer to each duplicated table: `*Last synced with [other doc]: 2026-07-19*` — update the date whenever either copy is edited, so future drift is at least detectable.

---

### 🟢 Open item carried forward (not new, just resurfaced)

**F12 — Fixed Deposits & Recurring Deposits remain unscoped.**
Flagged since Part-2 v22, still sitting as an open question in the Progress Log with a "default to Part-10" assumption that's never been explicitly confirmed. Now that Part-9 is fully scoped and Part-10 is the only open slot left, this is a good time to actually confirm the default rather than let it ride indefinitely.
**Recommendation:** Explicitly confirm "Fixed/Recurring Deposits → deferred to Part-10" as a resolved decision (move it from "Open Questions" to "Resolved" in the Progress Log) the next time Part-10 scoping starts — or decide now if you'd rather close it early.

---

## 4. Summary Table of All Findings

| ID | Severity | File(s) affected | One-line fix |
|---|---|---|---|
| F1 | 🔴 Moderate | Master Index, Progress Log | Sync "Next Version To Build" for Parts 2, 3, 4 |
| F3 | 🔴 Moderate | doc 04 | Add "Phased Cloud Migration Promotion" section |
| F4 | 🔴 Moderate | Progress Log | Add "AWS Migration Cutover Status" table |
| F7 | 🔴 Moderate | Part-4 (v31) | Add note: v31 supersedes Part-2 v18's dashboard |
| F2 | 🟡 Minor | Progress Log | Fix Part-3 title text |
| F5 | 🟡 Minor | doc 01 | Cross-reference Part-9's Cloud Resource Inventory |
| F6 | 🟡 Minor | doc 07 §6 | Note Singapore/Dubai VMs reuse India's ports |
| F8 | 🟡 Minor | doc 03 | Remove v9 from "Security versions" list |
| F9 | 🟡 Minor | doc 03 | Refresh illustrative version-list examples |
| F10 | 🟡 Minor | Part-7 (v44) | Clarify "Side-by-Side" = mixed-version cluster, not new hardware |
| F11 | 🟡 Minor | Part-9 | State explicitly that `release/part-9` is used |
| F13 | 🟡 Minor | doc 02/doc 07, doc 04/doc 07 | Add "last synced" markers to duplicated tables |
| F12 | 🟢 Open | Progress Log | Confirm or resolve Fixed/Recurring Deposits deferral |

---

## 5. Overall Recommendation

This is an unusually well-maintained multi-file spec — the version-numbering discipline (Engineering Standards §7) has clearly been followed rigorously, and every Part's renumbering table, prerequisite handoff, and governing-rule reference checks out. The gaps found here are all in the *bookkeeping layer* (tracker tables, cross-reference notes) rather than the *architecture layer* — nothing here requires re-numbering, re-scoping, or touching a frozen Part.

**Suggested order of operations:**
1. Fix F1 (tracker sync) and F2 (title) — 5-minute edits, zero risk.
2. Add F3 and F4 (Part-9 promotion model + cutover table) — do this **before** starting Part-9's build, since it resolves an ambiguity that would otherwise surface mid-Part.
3. Add F7 (v18/v31 relationship note) — do this **before** starting Part-4, for the same reason.
4. F5, F6, F8–F11, F13 can be batched in at any convenient time — none are blocking.
5. Revisit F12 when Part-10 scoping actually begins.

---

*This audit reflects the state of all 17 uploaded files as of 2026-07-19. Re-run this audit after any future renumbering pass or new Part addition, per the same discipline this project already applies to its own version-numbering freezes.*
