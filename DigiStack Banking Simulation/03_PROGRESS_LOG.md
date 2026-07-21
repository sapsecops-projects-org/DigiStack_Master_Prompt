# PROGRESS LOG — DigiStack Bank

> **Purpose:** The single source of truth for "where are we right now." At the start of any new Claude session, Claude should read this file first to know the current state before doing anything else. Update this file at the end of every completed sprint — never skip.

---

## Current Status

**Project Start Date:** (fill in the date Phase 0, Sprint 1 actually begins — this is the anchor for all day-range comparisons in 04_SPRINT_PLAN_180_DAYS.md; e.g., if start date is Aug 1 and today is Sep 15, that's ~day 46)
**Current Phase:** Not yet started
**Current Sprint:** None started — ready to begin Phase 0, Sprint 1
**Last Updated:** 2026-07-10 (pre-Phase-0 setup: VM sizing and Git provider decided)
**Part 1 Sprints Completed:** 0 / 25
**Part 2 Sprints Completed:** 0 / 24

---

## VM / Environment Status

| VM | Built? | OS Installed? | Static IP Set? | Notes |
|---|---|---|---|---|
| dgs-dev-dmgr-01 | ⬜ | ⬜ | ⬜ | Sized 4 GB RAM / 1 vCPU / 30 GB disk per revised spec |
| dgs-dev-node-01 | ⬜ | ⬜ | ⬜ | Sized 4 GB RAM / 2 vCPU / 40 GB disk per revised spec |
| dgs-dev-node-02 | ⬜ | ⬜ | ⬜ | Sized 4 GB RAM / 2 vCPU / 40 GB disk per revised spec |
| dgs-dev-web-01 | ⬜ | ⬜ | ⬜ | Sized 2 GB RAM / 1 vCPU / 20 GB disk per revised spec |
| dgs-dev-db-01 | ⬜ | ⬜ | ⬜ | Sized 4 GB RAM / 2 vCPU / 50 GB disk per revised spec |

**WAS ND Cell Status:** Not yet created
**PostgreSQL Status:** Not yet installed
**IBM MQ Status:** Not yet installed
**IHS Status:** Not yet installed

---

## Environment Reference

> Fill in as each item is established during Phase 0/1 — this is the single place to look up naming/config decisions instead of re-deciding them each session.

| Item | Value | Notes |
|---|---|---|
| Git remote provider | **GitHub** | Decided 2026-07-10 — see 05_DECISIONS_LOG.md |
| Git repository URL | (not yet created — create when Sprint 1 begins) | |
| Local clone location | (not yet created) | e.g., path on dgs-dev-dmgr-01 |
| Default branch | (not yet decided, e.g. `main`) | |
| Last known commit / tag | (none) | Update after every sprint's code handoff (commit + push) |
| CBS database name | (not yet decided) | PostgreSQL DB name for OLTP schema |
| GL database/schema name | (not yet decided) | Separate from OLTP per architecture |
| PostgreSQL port | (default 5432 assumed) | Confirm once installed |
| IBM MQ Queue Manager name | (not yet decided) | |
| WAS ND Cell name | (not yet decided) | |
| WAS ND Cluster name(s) | (not yet created — Phase 4) | |

---

## Sprint Completion Log

> Add one entry per completed sprint, most recent at the top. Do not mark a sprint here until all 7 Definition of Done criteria (see 00_MASTER_CONTEXT.md) are met and explicitly approved.

<!--
Template for each entry:

### Sprint [Phase.Number] — [Sprint Name]
- **Completed:** [date]
- **What was built:** [1-2 sentence summary]
- **WAS admin work done:** [Console / wsadmin / Ansible — brief summary]
- **Key decisions / gotchas:** [anything worth remembering]
- **Definition of Done met:** ✅ all 7 criteria confirmed
-->

*(No sprints completed yet. First entry will be added after Phase 0, Sprint 1 is approved.)*

---

## Open Issues / Parking Lot

> Anything flagged during a sprint that needs revisiting later but isn't blocking current progress.

- **API Gateway implementation shape** — unresolved; must be settled explicitly in Phase 2's HLD step. See 05_DECISIONS_LOG.md.
- **EOD batch singleton design for future clustering** — unresolved; must be addressed as a forward-looking design note in Phase 3.5's HLD step. See 05_DECISIONS_LOG.md.

---

## Next Action

**Next up:** Phase 0, Sprint 1 — Environment & Foundation (RHEL/VMware topology planning, first VM build steps)
**Waiting on:** Venkatesh to say "start Sprint 1" or equivalent in a new session. As of 2026-07-10, Venkatesh has confirmed he is not yet ready to begin.

---
*After every sprint: update Current Status, add a Sprint Completion Log entry, update VM/Environment Status and Environment Reference if changed, and update Next Action before ending the session.*
