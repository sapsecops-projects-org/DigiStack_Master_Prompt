# SESSION PROMPT TEMPLATE

> **Purpose:** Copy the message below into a new Claude session/account (along with uploading the other five files) to resume the DigiStack Bank project with full context restored. Fill in the bracketed part before sending.

---

## Message to paste into a new Claude session

```
I'm continuing a long-running project called DigiStack Bank — a realistic
enterprise banking simulation used as a hands-on lab to close a 10-year
WebSphere ND administration experience gap. This project spans roughly 12
months part-time and is being built across multiple Claude sessions.

I've attached six files that contain everything you need:

1. 00_MASTER_CONTEXT.md — the permanent project charter: who I am, the
   architecture, the golden rules, the Definition of Done, and how we work
   together. Treat everything in this file as standing instructions for
   this entire project.

2. 01_PHASE_ROADMAP.md — the full, detailed phase-by-phase breakdown for
   both Part 1 (App Development) and Part 2 (WebSphere Admin Mastery),
   including every deliverable per phase.

3. 02_CONCEPT_INDEX.md — a checklist of every banking and WebSphere admin
   concept this project covers, with status markers for what's been
   covered so far.

4. 03_PROGRESS_LOG.md — the current state of the project: which sprint we're
   on, what's been completed, VM/environment status, and any open issues.
   This is the source of truth for "where are we right now."

5. 04_SPRINT_PLAN_180_DAYS.md — the lightweight pacing guide mapping Part 1's
   sprints to a realistic part-time calendar.

6. 05_DECISIONS_LOG.md — a running record of ad hoc architectural/design
   decisions made along the way, including any still-open decisions that
   need to be resolved at a specific upcoming phase's HLD step.

Please read all six files first, then confirm back to me:
- What phase and sprint we're currently on (from 03_PROGRESS_LOG.md)
- What the next sprint's objective is
- Anything flagged in the Open Issues section that I should know about
- Any open decisions in 05_DECISIONS_LOG.md that need resolving during this phase's HLD step

If this sprint builds on previous code, I will paste in `git log --oneline -10`
output and any specific file contents you ask for — please ask for these
before writing new code rather than assuming or regenerating prior work
from memory. Our Git remote and repo details are in 03_PROGRESS_LOG.md's
Environment Reference table.

Then wait for my go-ahead before starting any new work. Follow the
Pacing rule strictly: one sprint at a time, explicit approval required
before moving to the next. If I seem to be moving too fast (multiple
sprints at once, skipping approval), push back and redirect to the
pacing rule — that's expected and welcome.

[Optional: add anything sprint-specific here, e.g. "I completed the VM
builds for Phase 0 since our last session — here's what I did: ..." or
"Let's resume exactly where we left off."]
```

---

## Checklist Before Starting a New Session

- [ ] Upload 00_MASTER_CONTEXT.md
- [ ] Upload 01_PHASE_ROADMAP.md
- [ ] Upload 02_CONCEPT_INDEX.md
- [ ] Upload 03_PROGRESS_LOG.md
- [ ] Upload 04_SPRINT_PLAN_180_DAYS.md
- [ ] Upload 05_DECISIONS_LOG.md
- [ ] Paste the message above, filling in any session-specific notes
- [ ] Confirm Claude's summary of current state matches your own understanding before proceeding
- [ ] At the end of the session, ask Claude to give you the updated 03_PROGRESS_LOG.md (and 02_CONCEPT_INDEX.md, if concepts were covered) so you can save the new version for next time

---

## Important Reminder

These files are living documents. After every session where a sprint is completed:
1. Get the updated 03_PROGRESS_LOG.md content from Claude before ending the session.
2. Save it, replacing your local copy.
3. Do the same for 02_CONCEPT_INDEX.md if new concepts were checked off.
4. 00_MASTER_CONTEXT.md and 04_SPRINT_PLAN_180_DAYS.md should rarely change — only update them if you deliberately change the project's rules or pacing.

This is what makes it possible to pause for weeks, switch Claude accounts, or move devices without losing project continuity.
