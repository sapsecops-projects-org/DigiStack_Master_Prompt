# WebSphere/MQ Enterprise Admin Curriculum — Progress Log

> **How to use this file:** Update it yourself after every study session (takes 30 seconds). At the start of a new chat, upload this file along with the Day-Wise Plan and Full Curriculum files, and say "continue from where I left off." This file is the source of truth on where you are — if it ever conflicts with what you remember telling a past chat, trust this file.

---

## 📍 Current Position

- **Current Sprint:** Sprint 1
- **Current Day:** Day 0 — not yet started
- **Current Phase / Version:** Phase 0.0 — Enterprise IT Foundation
- **Last study date:** —
- **Status:** Not started

---

## ⚠️ Open Decision Needed — Sprint 23 Overlap

Sprint 23 of the Day-Wise Plan ("DigiStack Bank — Infrastructure Setup") uses a **generic, simpler spec** from the master topic list's Version 6 (PostgreSQL, single cluster). This is a *different* design from your separate, more detailed **DigiStack Bank** project (MySQL, IBM MQ, 5-VM topology, 91 sprints, 136 days), which is fully designed and finalized elsewhere.

Decide before you reach Sprint 23 (roughly 6 months out at 1 sprint/week):
- **Option A:** Run this curriculum's Sprint 23–24 as-is, as a lightweight practice pass, separate from the real DigiStack Bank build.
- **Option B:** Skip Sprint 23–24 here entirely and just reference your dedicated DigiStack Bank plan when you reach that point.
- **Option C:** Replace Sprint 23–24 in the Day-Wise Plan with a pointer to the real project's Sprint 1.1 onward.

*(Fill in your choice here once decided → )* Decision: _______________

---

## ✅ Sprints Completed

| Sprint # | Phase/Topic | Completed On | Notes |
|---|---|---|---|
| | | | |

*(Add a row each time you close out a full sprint — Days 1–7.)*

---

## 🔧 Running Deviations Log

> Anything where you did something different from what the plan said — skipped a day, merged two days, used a different tool/VM setup than assumed, etc. Log it immediately, don't batch it.

| Date | Sprint/Day | Deviation | Reason |
|---|---|---|---|

---

## 🗝️ Key Decisions Log

> Any standing choice that should carry forward automatically in future chats — e.g. "using RHEL 9 instead of RHEL 8," "skipping Citrix ADC depth, F5+HAProxy only," "compressing Phase 29 to 250 incidents not 500."

| Date | Decision |
|---|---|

---

## 🧗 Topics/Labs to Revisit

> Things you rushed through, didn't fully understand, or want to re-lab later (e.g. before the capstone).

-

---

## 🏦 DigiStack Bank Build State (if running the hands-on labs against a real environment)

- **VMs stood up:** _(e.g. DMGR + 2 nodes, no LB yet)_
- **Cluster status:** _(e.g. horizontal cluster running, vertical not yet configured)_
- **Known broken/pending items:** _(e.g. SSL cert expired on vm3-web-01, needs renewal)_

---

## 📅 Pace Tracking

- **Plan pace:** 1–2 hrs/day, 1 sprint/week (58 sprints total)
- **Sprints completed so far:** _(#)_
- **Weeks elapsed so far:** _(#)_
- **On pace for ~58–59 week completion?** Yes / No — _(if no, note by how much you're behind/ahead)_

---

## 🎓 Standing Teaching Persona (paste this into every new chat)

> This defines *how* Claude should teach across the whole curriculum, not just for one sprint. Keep it word-for-word so behavior stays consistent chat to chat.

```
Act as a Senior Enterprise IBM WebSphere ND Architect, Middleware SME, Linux
Administrator, Infrastructure Architect, DevSecOps Engineer, Network Engineer,
Storage Engineer, DBA, Security Consultant, and Banking Technology Architect
with more than 25 years of experience implementing IBM WebSphere environments
for large banking organizations such as SBI, HDFC, ICICI, HSBC, Citi, Barclays,
and JP Morgan.

Your responsibility is to train me exactly like a newly hired WebSphere
Administrator working on a real enterprise banking project. Never skip any
step or assume I already know something. Teach me from absolute beginner
level to senior administrator level.
```

**What this means in practice, sprint to sprint:**
- Explain the "why" (business purpose) before the "how" (steps), every topic.
- Never assume prior knowledge of a term, command, or concept — define it the first time it comes up, even if it seems basic.
- For every WebSphere/IHS/MQ hands-on task: Admin Console steps + wsadmin/Jython steps + shell/Ansible automation steps (the triad rule) — no exceptions.
- Use banking-specific examples (accounts, transactions, core banking flows) wherever a generic example would otherwise do.
- Check understanding before moving to the next topic rather than assuming it landed.

---

## 📝 Quick Copy-Paste for Starting a New Chat

```
I'm continuing my WebSphere/MQ Enterprise Admin curriculum. Attached:
1. Full Curriculum (master topic list)
2. Day-Wise Plan (58-sprint schedule)
3. This Progress Log (includes the Standing Teaching Persona above)

Current position: Sprint __, Day __, Phase __.
Please continue from there, following the Standing Teaching Persona.
```
