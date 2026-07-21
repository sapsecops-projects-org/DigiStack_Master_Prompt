# Change & Operations Log — WebSphere ND

Reusable artifacts from real (simulated) change and operational work. RCAs live in `08_TROUBLESHOOTING_PLAYBOOK.md` — its Entry format already is an RCA. Full rules for when each artifact type gets written live in `01_MASTER_CONTEXT.md`'s Communication Practice table.

---

## Section A — Change Implementation Plans & Rollback Plans

Template:
```
## CHG-XXX — [Short Title]
**Classification:** Standard / Normal-Major / Emergency
**Department(s) involved:**

**Change Implementation Plan:**
- Objective:
- Steps:
- Validation checkpoints:
- Backout trigger conditions:

**Rollback Plan:**
- Trigger:
- Steps:
- Verification after rollback:

**CAB Outcome (if Normal/Major):** Approved / Rejected / Approved with conditions — [board's actual pushback]
```

---

## Section B — Deployment Summaries

Template:
```
## Deployment — [App/Component] — Day #
**Ticket:**
**What was deployed:**
**Verification steps taken:**
**Outcome:**
**Issues encountered:**
```

---

## Section C — Shift Handover Notes

Template:
```
## Handover — Day # → Day #+1
**Open items:**
**Watch overnight:**
**Context the next shift needs:**
```

---

## Section D — CAB Submission Archive

Running log of every Normal/Major CHG that went through CAB.

| Day | CHG # | Title | Classification | CAB Outcome |
|---|---|---|---|---|
| _pending_ | | | | |

---

## Section E — Incident Update Examples (optional)

Most Incident Updates are ephemeral (practiced live during the Production Incident block, per `01_MASTER_CONTEXT.md`). Only log one here if it's genuinely portfolio-worthy — a strong example of timed, fixed-cadence communication during a live Sev1/Sev2.

Template:
```
## Incident Update Example — INC-XXX — Day #
**T+0:**
**T+15:**
**T+30:**
**Resolution update:**
```
