# DigiStack Health Enterprise — Sprint Pacing Plan
*(Filename kept as `04_SPRINT_PLAN_180_DAYS.md` for cross-file reference continuity — the plan itself now targets **~464 days / 31 fifteen-day cycles**, per the 2026-07-11 decision to spread the same 70 sprints out more slowly. See `03_PROGRESS_LOG.md` Key Decisions Log for the full rationale and math. v9 — 2026-07-12 — fixed a dangling "Part 26" reference in the Pace Deviation Policy below; this project has no "Parts," only Phases/Sprints.)*

**This is a target rhythm, not a hard deadline.** Per Master Context Section 4: the 70-sprint list is the real backbone. If a sprint needs more time, take it — never compress a sprint just to hit a date on this calendar. This file exists so there's a rough sense of pace, not a contract.

---

## The 15-Day Cycle (Revised Weekly Rhythm)

> **Note:** this revises the rhythm originally described in Master Context Section 4. Total cycle length is unchanged (still 15 days) — only the *internal* structure of each 7-day week changed: an explicit Weekly Revision day was added, and the Lab day now opens with a ticket queue and closes with an after-hours on-call page (see below). Separately, the overall program length was extended from 180 days (12 cycles) to **~464 days (31 cycles)** on 2026-07-11 — same 70 sprints, same 15-day cycle shape, just spread across roughly 2.6x the calendar time. The Projected Cycle Map below reflects the new 31-cycle math. Master Context and the Progress Log's Key Decisions Log have both been updated to match — no outstanding conflict. Check `03_PROGRESS_LOG.md`'s Document Version Map for Master Context's current version rather than relying on a hardcoded number here, since that's what drifted last time.

**Week A — Days 1–7** *(in-fiction: Monday–Sunday)*:
| Day | Weekday | Activity |
|---|---|---|
| 1 | Mon | **Weekly Sprint Planning** (see below), then Study — Concept → Build/Configure, per Master Context Section 10 |
| 2–5 | Tue–Fri | Study — Concept → Build/Configure, per Master Context Section 10, one sprint at a time |
| 6 | Sat | **Weekly Revision** — no new material; re-explain, re-derive, and consolidate anything shaky from Days 1–5 |
| 7 | Sun | **Weekly LAB / Weekend Maintenance Window** (see structure below) |

**Week B — Days 8–14** *(Monday–Sunday again)*: same structure as Week A (Day 8 = Weekly Sprint Planning + study, Days 9–12 study, Day 13 = Weekly Revision, Day 14 = Weekly LAB / Weekend Maintenance Window).

**Day 15 — Production Simulation:** one continuous session treating the two weeks' work as a live production environment — a deployment/change executed under time pressure, followed by 1–2 injected incidents to resolve live, closing with a short retro. Not a new-content day. (Falls outside the Mon–Sun frame above — treat it as a compressed stand-in for "the next stretch of production weeks," not a specific weekday.)

Then the next 15-day cycle begins.

**Weekly Sprint Planning (Day 1 and Day 8 of every cycle):** before that day's Manager's Assignment ticket, Priya runs a short preview of the week ahead — which tickets/topics are coming, any known risk (a CAB-gated change, an upcoming Monthly Patching or Quarterly DR Drill window), and anything left over from last week's Handover & Reflection. A few lines, not a full meeting — sets context, doesn't replace the daily ticket.

### Weekly LAB Structure (Day 7 and Day 14) — Weekend Maintenance Window

In-fiction this is Sunday — the lowest-traffic day for the patient portal — which is exactly why the riskier, higher-blast-radius work (tiered failure injection, cluster changes, the after-hours page) happens here rather than on a weekday. Same underlying content as before, framed as the maintenance window a real ops team would actually use for this kind of work.

The day opens as a **ticket queue**, not a syllabus — Priya (or the queue itself) hands over **3–5 tickets** spanning multiple ITSM types (Section 10d of Master Context), mixing routine and cold-incident work — the example below is what a Cycle 5+ queue looks like once Venkatesh is off the SR-only Trainee restriction (Master Context Section 1c); see the stage-by-stage breakdown just below for what Cycles 1–4 look like instead:

```
SR000012  – Configure a new JDBC datasource for the reporting service
CHG000009 – Deploy the Dashboard module v0.2 to the standalone server
INC000004 – Login intermittently fails after last night's redeploy
PRB000002 – Recurring session drops during shift-change login rush
```

**Ticket 1 (always a CHG-type) — Basic Setup & Config**
Hands-on repeat of that week's Concept → Build steps end-to-end — the same deployment/configuration work already walked through during Days 1–5. During Cycles 1–2 (Trainee, Master Context Section 1c) Priya reviews it closely before it counts as done; from Cycle 3 on it's done solo, from memory, to prove it actually stuck.

**Remaining tickets — Advanced LAB (real-time scenarios & incidents), scaled to probation stage**
Tiered challenge menu — **Beginner / Intermediate / Advanced / Expert** — drawn from that week's topics, each one delivered as its own ticket. Full topic-by-topic challenge bank lives in `06_LAB_CHALLENGE_BANK.md`. Which challenges to run on a given Day 7/14 depends on which sprints that week covered — cross-reference `02_CONCEPT_INDEX.md` to confirm a topic has actually been taught before drawing a challenge from it. Composition follows Section 1c's staging, not just concept-readiness:
- **Cycles 1–2 (Trainee):** SR tickets only, Beginner/Intermediate tier — matches "tickets are SR-only" in Section 1c.
- **Cycles 3–4 (Supervised Contributor):** SR and CHG, up through Advanced tier, with Priya reviewing.
- **Cycle 5 onward (Independent Contributor and beyond):** full SR/CHG/INC/PRB mix, Advanced/Expert tier included, run solo — e.g. the example queue above.

**Closing the day — After-Hours On-Call Page (once a week)**
After the ticket queue is cleared, one after-hours page lands — staged as a real out-of-hours call, separate in tone from the daytime tickets:

> *"It's 2:15 AM. The patient portal is unavailable. Clinicians can't log in. What do you check first?"*

Drawn from the same Advanced/Expert pool in `06_LAB_CHALLENGE_BANK.md` (matched to concepts already taught, per `02_CONCEPT_INDEX.md`), but delivered cold, with no daytime build-up — the way a real page actually arrives. Ownership follows Section 1c: **Cycles 1–4 (Trainee/Supervised Contributor)** — Priya takes the page, narrating her own diagnosis while Venkatesh shadows and answers her questions, per Section 1c's "no [solo] on-call" rule; **Cycle 5 onward (Independent Contributor and beyond)** — Venkatesh takes it solo. Either way it opens as its own `INC` ticket per Master Context Section 10d — paired with an `ECHG` if the fix needs an actual config/deployment change that can't wait for the next normal change window — and gets the same Symptoms→Investigation→Logs→Commands→Root Cause→Resolution→Prevention treatment as any Production Incident, with at least one Incident Update written mid-investigation (Section 10e). At least one other department (Section 1a — most often Service Desk, who took the original call, or Network/Security if the fix touches their layer) gets named and looped in before the page closes. Closes with the fix applied and verified before whoever's driving "goes back to bed."

---

## Recurring Operational Cadences

Layered on top of the 15-day cycle — all anchored to cycle boundaries so they slide together if a cycle runs long, the same way Weekly Labs/Revision Days already do:

| Cadence | Anchor | Notes |
|---|---|---|
| **90-Day Probation** | Cycles 1–6 (Days 1–90) | Three staged-responsibility levels ending in a Day 90 End-of-Probation Review — full detail in Master Context Section 1c |
| **Weekly Sprint Planning** | Day 1 and Day 8 of every cycle | Priya's short preview of the week ahead, before that day's Manager's Assignment (see above) |
| **Weekend Maintenance Window** | Day 7 and Day 14 of every cycle | The existing Weekly LAB structure above, reframed as the in-fiction Sunday |
| **Monthly Patching** | Day 14 of every even-numbered cycle (Cycles 2, 4, 6, ... — roughly every 30 days) | A CHG for OS/middleware patches, coordinated with the Linux Team and Middleware Team (Master Context Section 1a), run during that day's Weekend Maintenance Window. Cycle 2's falls inside the Trainee stage (Section 1c) — Priya drives it with Venkatesh shadowing; Cycle 4's (Supervised Contributor) he runs it with review; Cycle 6 onward, independently — matching "first full Monthly Patching window handled independently" in Section 1c |
| **Monthly Performance Review** | Day 15 of every even-numbered cycle (~Day 30, 60, 90, 120, ...) | Priya's review — tickets closed, incident/RCA quality, Interview Questions performance, one area to grow (Master Context Section 1c). Day 90's is the fuller End-of-Probation Review |
| **Quarterly DR Drill** | Day 15 of every 6th cycle (Cycles 6, 12, 18, 24, 30 — ~Day 90, 180, 270, 360, 450) | A full DR drill (drawing on `06_LAB_CHALLENGE_BANK.md`'s DR Planning & Drills tier) once Phase 4's DR content (Sprints 4.2/4.3) has actually been taught; before that, a lighter DR-readiness check (backup verification, runbook review) instead — same "don't draw on untaught concepts" rule as everything else. Multi-department by nature: Database Team (PostgreSQL restore), IBM MQ Team, Network Team, and Security/Business (RTO/RPO sign-off) all get named per Master Context Section 1a |

None of these are hard triggers — if a cycle runs long or a milestone sprint needs the extra day, the cadence slides with it rather than forcing a collision. Log anything that lands (a patching CHG, a DR drill, a performance-review outcome) the normal way in `03_PROGRESS_LOG.md`.

---

## Projected Cycle Map

| Cycle | Days | Phase(s) covered | Sprints (target) |
|---|---|---|---|
| 1–4 | 1–60 | Phase 1 — Foundations | 1.1 – 1.12 (all 12) |
| 5–6 | 61–90 | Phase 2 — standalone build-out + cluster stand-up | 2.1 – 2.9 |
| 7–9 | 91–135 | Phase 2 — remaining modules + MQ | 2.10 – 2.17 |
| 10–11 | 136–165 | Phase 2 wrap-up | 2.18 – 2.24 |
| 12–14 | 166–210 | Phase 3 — Harden & Observe | 3.1 – 3.11 |
| 15–17 | 211–255 | Phase 4 — Resilience, Ops & Compliance | 4.1 – 4.9 |
| 18–20 | 256–300 | Phase 5 — Production Support | 5.1 – 5.10 |
| 21 | 301–315 | Phase 6 — Modernization + Capstone | 6.1 – 6.4 |
| 22–31 | 316–465 | **Buffer** — catch-up for any sprint that ran long, second passes on weak areas, interview-question review, portfolio polish, mock interviews | — |

*(31 cycles × 15 days = 465 days — 1 day over the ~464 target from rounding to whole cycles; per this file's own "target rhythm, not a contract" rule, that's close enough to not matter.)*

**Why the buffer is deliberately large (150 days / 10 cycles):** Phase 2 alone is 24 sprints covering the entire cluster stand-up — historically the part most likely to run long (node federation and plugin propagation in particular tend to need more than one attempt). Rather than pretend that risk away, the schedule assumes it and reserves roughly a third of the whole ~465 days to absorb it — the same ~1/3 buffer share as the original 180-day plan (60/180), just scaled up with everything else.

---

## How to use this file

- At the start of each 15-day cycle, check the Progress Log to see how many sprints from the *previous* cycle are still open, and adjust this cycle's target down accordingly.
- If a cycle finishes its sprints early, borrow from the next cycle rather than sitting idle — but don't skip ahead past an incomplete prerequisite sprint.
- If Cycles 1–21 are complete before Day 315, the remaining buffer time is best spent on: redoing the 50+ incident troubleshooting lab (Phase 3) from memory without notes, and doing a second mock interview (Sprint 6.4) cold.

---

## Milestone checkpoints (use these as go/no-go gates)

| Checkpoint | Should be true by... |
|---|---|
| Standalone WAS server running, Login deployed | End of Cycle 5 |
| **End-of-Probation Review passed — off probation, full CAB/on-call standing** | End of Cycle 6 (Day 90) |
| Full 2-node cluster + IHS live, all 9 modules deployed | End of Cycle 11 |
| App survives injected failures + load test without falling over | End of Cycle 14 |
| A full DR drill has been executed and recovery time measured | End of Cycle 17 |
| Comfortable running a live incident end-to-end without help | End of Cycle 20 |
| Resume-ready portfolio package exists | End of Cycle 21 |

If a checkpoint is missed, that's a signal to slow down and consolidate — not to skip ahead.

---

## Pace Deviation Policy

*If actual pace drifts from plan, apply this instead of deciding ad hoc:*

- **1 phase behind, on a buffer sprint due soon:** let the next buffer sprint absorb the slip. No plan change needed.
- **1 phase behind, no buffer sprint coming up soon:** compress the *current* phase's remaining sprints by merging adjacent low-risk sprints (e.g., a docs-update sprint can often merge into the checkpoint sprint). Do not compress troubleshooting or checkpoint sprints — those are where real understanding gets tested.
- **2+ phases behind:** stop and run the Periodic Gap-Check Prompt early, out of cycle. Decide explicitly whether to (a) extend total program days, or (b) permanently drop/shrink a lower-priority topic — Phase 6 (Modernization, Sprints 6.1–6.3) is the first candidate, since Master Context already flags it as lowest-priority/conceptual-only. Log the decision in PROGRESS_LOG.md's Key Decisions Log.
- **Ahead of pace:** do not skip ahead into new content. Use the extra time on buffer sprints for deeper documentation, extra incident entries, or revisiting a shaky checkpoint.

Rule of thumb: **never compress a checkpoint or troubleshooting sprint to save time** — those are the highest-value parts of the whole program.
