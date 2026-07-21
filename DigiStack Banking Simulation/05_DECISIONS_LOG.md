# DECISIONS LOG — DigiStack Bank

> **Purpose:** A running record of ad hoc architectural and design decisions made along the way — the "why did we do it this way" answers that 02_CONCEPT_INDEX.md (what's covered) and 03_PROGRESS_LOG.md (what's done) don't capture. Add an entry any time a non-trivial decision is made during a sprint's HLD/LLD steps, even if it seems obvious at the time — it won't be obvious in month 8. Paste this into new sessions alongside the other companion files.

**Format:** one entry per decision, most recent at the top. Keep entries short — a paragraph, not an essay.

---

<!--
Template for each entry:

### [Date] — [Short decision title]
- **Context:** what prompted this decision (which sprint/phase)
- **Decision:** what was decided
- **Alternatives considered:** what else was on the table, and why they were passed over
- **Revisit if:** conditions under which this decision should be reconsidered (optional — omit if none)
-->

## Open Decisions (not yet resolved — track here until decided)

### API Gateway implementation shape
- **Context:** 00_MASTER_CONTEXT.md describes the API Gateway as "simulated as a lightweight servlet filter or small dedicated component" — left deliberately ambiguous at charter-writing time.
- **Status:** Unresolved. Needs to be settled explicitly during Phase 2's HLD step, since it affects Phase 2's deployment topology and IHS plugin routing.
- **Options on the table:**
  - **Servlet filter inside Portal WAR** — simpler, one fewer deployable unit, but less realistic (real gateways are typically a separate tier) and can't be independently scaled/versioned later.
  - **Small standalone WAS application** — more realistic, gives genuine practice deploying/versioning a third component, but adds deployment and IHS routing complexity earlier than necessary.
- **Leaning:** not yet decided — resolve when Phase 2 HLD is actually written.

### EOD batch singleton design for future clustering
- **Context:** Phase 3.5 (EOD batch) is built before Phase 4 (clustering). If the batch job isn't designed with clustering in mind, every cluster member may fire it redundantly once Phase 4 converts the topology.
- **Status:** Unresolved. Should be addressed as a forward-looking design note in Phase 3.5's HLD, even though clustering itself doesn't happen until Phase 4.
- **Options on the table:**
  - Design the batch as singleton-aware from the start (e.g., WAS scheduler service with a "run on one member only" pattern).
  - Build it simple now, accept a rework in Phase 4.
- **Leaning:** design singleton-aware from the start if it doesn't meaningfully slow down Phase 3.5 — cheaper than a rework later.

---

## Resolved Decisions

### 2026-07-10 — Git remote provider: GitHub
- **Context:** Pre-Phase-0 setup. 00_MASTER_CONTEXT.md's Source Code & Environment Persistence section requires a free private remote repo (GitHub or GitLab) as the single source of truth for code, per the no-memory-between-sessions constraint.
- **Decision:** Use GitHub for the remote repository.
- **Alternatives considered:** GitLab — functionally equivalent for this project's needs (free private repos, standard Git workflow); passed over on straightforward preference, no technical blocker either way.
- **Revisit if:** none anticipated — this is a low-stakes, easily-reversible choice.

### 2026-07-10 — VM sizing revision adopted
- **Context:** VM_SIZING_REVISION.md pre-Phase-0 checklist flagged that the original topology (~12.5 GB RAM / 7 vCPU / 140 GB disk total) was sized for basic functionality only, not for later phases that stress the environment (Phase 4 clustering, Phase 14 JVM/GC tuning, Phase 16 heap/thread dump analysis).
- **Decision:** Adopted the revised specs — ~18 GB RAM / 8 vCPU / 180 GB disk total across the five VMs (Dmgr 4 GB/1 vCPU/30 GB, two managed nodes at 4 GB/2 vCPU/40 GB each, IHS at 2 GB/1 vCPU/20 GB, DB+MQ at 4 GB/2 vCPU/50 GB). Confirmed the hypervisor host has capacity to support this. 00_MASTER_CONTEXT.md's Dev Lab VM Topology table has been updated directly with these final specs.
- **Alternatives considered:** Keep the original lighter spec (risked disk/RAM pressure surfacing mid-project rather than being planned for upfront); partial revision prioritizing only Dmgr + the two managed nodes (passed over since full revision was affordable on the available host).
- **Revisit if:** actual resource usage during Phase 4 or Phase 14 shows the revised sizing is still insufficient — unlikely, but noted per VM_SIZING_REVISION.md's own guidance to keep an eye on disk pressure from Phase 16 dump accumulation specifically.

*(VM_SIZING_REVISION.md has now served its one-time purpose per its own closing note and has been archived — its content is folded into this entry and into 00_MASTER_CONTEXT.md's topology table.)*

*(Further resolved entries will be added as Phase 0/1 decisions are made: CBS/GL database naming, WAS Cell/Cluster naming, MQ Queue Manager naming, isolation level choice for monetary postings, etc. Many of these are already flagged as blanks in 03_PROGRESS_LOG.md's Environment Reference table — when they're filled in there, add the "why" here.)*

---
*Update this file any time a non-trivial decision is made, not just at sprint end — it's cheaper to log it in the moment than to reconstruct it later.*
