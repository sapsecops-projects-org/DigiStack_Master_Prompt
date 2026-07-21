# DigiStack Bank — Progress Log

**Instructions:** Update this file yourself after each version is approved (or ask Claude to update it at the end of a sprint). Upload this file — along with the MASTER INDEX and the relevant Part file — at the start of every new chat so Claude knows exactly where to resume.

---

## Current Status Summary

> Kept in sync with the MASTER INDEX Progress Tracker — this table is the detailed source of truth; the MASTER INDEX table should be a short pointer to it, not a duplicate with different wording.

| Part | Title | Last Approved Version | Next Version To Build | Status |
|---|---|---|---|---|
| 1 | Enterprise Banking Application Development (Simple Banking) | — (none yet) | Version 1 | Roadmap reviewed & gap-filled. Not started. |
| 2 | Enterprise Middleware Integration | — | Version 15 | Roadmap reviewed & gap-filled. Not started. |
| 3 | Enterprise Banking Systems (CBS, Payments, Channel Simulators, Loans) | — | Version 23 | Roadmap reviewed & gap-filled (v23–v30 renumbering pass documented in Part-3 file). Not started. |
| 4 | Enterprise Observability, SRE & Production Operations (v31–35) | — | Version 31 | Roadmap reviewed & gap-filled (renumbered 28–32 draft → 31–35). Not started. |
| 5 | Enterprise HA, DR & Business Continuity (v36–38) | — | Version 36 | Roadmap reviewed & gap-filled (renumbered 33–34 draft → 36–38). Not started. |
| 6 | Multi-Region Enterprise Banking & Middleware Architecture (v39–43) | — | Version 39 | Roadmap reviewed & gap-filled (offset 38–42 draft → 39–43). Title conflict resolved. Not started. |
| 7 | Enterprise WebSphere Migration & Modernization (v44–48) | — | Version 44 | Roadmap reviewed & gap-filled (renumbered 43–47 draft → 44–48). Not started. |
| 8 | Enterprise DevOps & End-to-End Automation (v49–53) | — | Version 49 | Roadmap reviewed & gap-filled (renumbered 48–52 draft → 49–53). Retitled from "AWS Migration" placeholder. Not started. |
| 9 | Enterprise Hybrid Cloud & AWS Migration (v54–73) | — | Version 54 | Roadmap reviewed & gap-filled (renumbered 53–72 draft → 54–73). MySQL→PostgreSQL inconsistency corrected. Not started. |
| 10 | Containerization (proposed) | — | — | Not started — awaiting content (bumped from former Part-9 slot). Would begin at Version 74. |

---

## Detailed Version Log

> Add one row per version as it's completed. Keep the most recent entry at the bottom (or top — your preference, just stay consistent).

| Date | Part | Version | Feature | Status (Started / Dev Done / Deployed to WAS / Tested / Approved) | Notes / Issues |
|---|---|---|---|---|---|
| | | | | | |

---

## Cross-Part Dependency Chain

> Per Engineering Standards §8. Add one row per version **as it is actually implemented** — do not pre-fill with guesses at roadmap-design time. `Depends On` = what prior version(s)/artifact(s) this version required to exist first. `Produces` = the concrete artifact(s) this version adds (code module, EAR, table, endpoint, queue, etc.). `Used By` = later version(s) that consume what this version produced (fill in retroactively once that later version is built, or note "known future consumer" if the roadmap already documents the link).

| Version | Depends On | Produces | Used By |
|---|---|---|---|
| | | | |

*(Empty until Version 1 is implemented. Example row, for reference only — remove once real rows are added: `V15 | V3 (accounts table), V2 (users/session) | Customer/Account/Beneficiary/Fund Transfer tables, JMS Queue+MDB | V16 (REST Fund Transfer endpoint), V19 (external MQ leg), V23 (CBS migration)`.)*

---

## Migration Cutover Status (populate only once Part-7 v47 is reached)

> Per doc 04's "Migration Part Promotion" section: while Part-7's cutover is in progress, the Current Status Summary table above must show **`Cutover in-flight`** in Part-7's Status column (not "In progress" or left blank) — and this detailed per-region table must show explicit per-region state underneath it. The Part cannot be marked `part7-release` until every region reads "Cut over — decommissioned" here **and** the Current Status Summary above is updated to `part7-release` in the same edit.

| Region | Platform State | Canary % | Post-Cutover Observation Window Closed? | Old Platform Decommissioned? |
|---|---|---|---|---|
| India | Not started | — | — | — |
| Singapore | Not started | — | — | — |
| Dubai | Not started | — | — | — |

---

## AWS Migration Cutover Status (populate only once Part-9 v60 is reached)

> Added per the 2026-07-19 cross-file audit (Finding F4). Per doc 04's "Phased Cloud Migration Promotion" section: Part-9's progressive cutover is at least as complex as Part-7's — it spans four phase capstones (v58, v63, v68, v73) and region-by-region decommissioning that can happen well before the Part-level UAT/Prod promotion at the very end. Track each region's AWS migration state independently here. Part-9 is not `part9-release` until every region reads "Cut over — on-prem decommissioned" below **and** the Current Status Summary above is updated to `part9-release` in the same edit — mirroring the Migration Cutover Status table's own rule for Part-7.
>
> **Reminder:** unlike the promotion event itself (which happens once, at the end, per doc 04's Phased Cloud Migration Promotion section), the columns below can and should be updated incrementally as each phase/region reaches that milestone — don't wait until v73 to start filling this in.

| Region | On-Prem/AWS Split (v60) | Lift-and-Shift Complete? (v63) | Platform Modernized? (v68) | Final Cutover % (v69) | Old On-Prem Decommissioned? |
|---|---|---|---|---|---|
| India | Not started | — | — | — | — |
| Singapore | Not started | — | — | — | — |
| Dubai | Not started | — | — | — | — |

---

## Environment Notes

> Track anything about your actual VM/WAS setup that a fresh chat would need to know — things not in the roadmap files themselves.

- WAS ND version installed:
- Profile(s) created so far:
- Node/Cell/Cluster names in use:
- Database: PostgreSQL — version / connection details (host, port, DB name — no passwords here):
- IBM HTTP Server installed: (Y/N)
- Any deviations from the roadmap so far:

---

## Open Questions / Decisions Pending

> Anything you were mid-discussion on when a chat ended, so it isn't lost.

- **Fixed Deposits & Recurring Deposits — still unscoped.** Part-2 v22 (Capstone) explicitly dropped these from scope, noting they were never built anywhere in Part-1 or Part-2, and flagged "unscoped — flag if you want them added to a future Part." No decision has been made since. Candidate slots: a suffix version in an already-frozen Part (e.g., `v30A` in Part-3, per Engineering Standards §7's suffix rule) or a feature in the still-unroadmapped Part-10. Default assumption if not raised again: defer to Part-10 once roadmapped, since no frozen Part naturally needs it and the suffix approach is reserved for topics that "genuinely must slot into" a frozen Part. **Status as of the 2026-07-19 cross-file audit: still open — now that Part-9 is fully scoped and Part-10 is the only remaining open slot, this is a good time to either explicitly confirm the Part-10 default or make a final call rather than let it continue to ride unresolved.**

*(Resolved items below.)*

**Resolved:**
- Part-2, Version 22 — **Resolved: PostgreSQL selected as the standard database for the DigiStack Bank Enterprise project across all environments.** Original source material referenced MySQL for this version's end-to-end flow; standardized to PostgreSQL project-wide. See MASTER INDEX's "Open Decisions" section for full context.
- Part-8 scope — **Resolved: Part-8 is Enterprise DevOps & End-to-End Automation** (Versions 49–53, renumbered from an initial 48–52 draft that collided with Part-7's frozen 44–48). Former "AWS Migration" placeholder content bumped to Part-9; Containerization bumped to Part-10. See MASTER INDEX's "Open Decisions" section for full context.
- Part-9 scope — **Resolved: Part-9 is Enterprise Hybrid Cloud & AWS Migration** (Versions 54–73, renumbered from an initial 53–72 draft that collided with Part-8's frozen 49–53). Source draft's MySQL references corrected to PostgreSQL/Amazon RDS for PostgreSQL, consistent with the project-wide standard. Containerization remains proposed as Part-10. See MASTER INDEX's "Open Decisions" section for full context.
- Part-6 title conflict — **Resolved: Multi-Region Enterprise Banking & Middleware Architecture is Part-6** (Versions 39–43, offset from an initial 38–42 draft). WebSphere Migration deferred to Part-7. See MASTER INDEX's "Open Decisions" section for full context.
- **Progress Tracker / Master Index sync drift (2026-07-19 cross-file audit) — Resolved.** Parts 2, 3, and 4's "Next Version To Build" columns were blank/inconsistent between this file and the Master Index. Both files now consistently show Version 15 (Part 2), Version 23 (Part 3), and Version 31 (Part 4). Part-3's title in the Current Status Summary table was also corrected to match the canonical title used in the Master Index and the Part-3 file itself.
- **Part-9 promotion model ambiguity (2026-07-19 cross-file audit) — Resolved.** doc 04 previously had no explicit promotion model for a Part that is simultaneously multi-region, phased, and pipeline-automated. Added a "Phased Cloud Migration Promotion" section to doc 04 clarifying that Part-9's phase capstones (v58, v63, v68) are Dev-only gates, while actual UAT/Prod promotion happens once, at the end (post-v73), across all three regions — with regional on-prem decommissioning tracked independently via the new "AWS Migration Cutover Status" table above.

---

*Re-upload this file (updated) alongside the MASTER INDEX and current Part file at the start of every new chat.*
