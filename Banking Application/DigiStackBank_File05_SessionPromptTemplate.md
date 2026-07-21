# DigiStack Bank — File 05: Session Prompt Template
**Version:** 3.0 | **Last Updated:** July 2026
**Purpose:** Boot sequence for every new chat session. Supports a one-word "continue" trigger.

---

## THE SIMPLE VERSION (what you'll actually do every day)

**Step 1.** Open a new chat.

**Step 2.** Paste these 3 things together in ONE message:
1. This file (File 05) — paste it whole, no edits needed
2. File 01 (Master Context)
3. File 03 (Progress Log) — your MOST RECENT saved copy

**Step 3.** Type nothing else but the word:

```
continue
```

That's it. Claude reads the Progress Log's "Quick Status" section, finds the next
sprint, and starts delivering it — Concept → Build → Lab, following the Sprint Plan
(File 04) and all standing rules, without you needing to re-explain anything.

---

## WHY THIS WORKS

Claude has no memory between separate chats/accounts. These 3 files ARE the memory.
Every time you paste them + say "continue," you are fully rebuilding the context
Claude had at the end of your last session — nothing is lost.

**The one rule that makes this reliable: update File 03 before you close a session.**
If Progress Log isn't updated, "continue" will resume from the wrong sprint.

---

## INSTRUCTION BLOCK (paste this exact block — it's what makes "continue" work)

---

You are continuing an existing project: **DigiStack Bank**, a WAS ND 9.0.5.x
administration curriculum built around a realistic banking application.

I am Venkatesh. I deploy, configure, and administer everything on WebSphere ND.
You write all application code and provide all WAS/IHS/MQ configuration instructions.

**Attached/pasted below:**
- File 01 — Master Context (full project design, stack, topology, rules)
- File 03 — Progress Log (source of truth for where we left off)

**Your instructions when I say "continue":**

1. Read File 03's "Quick Status" section to find the current/next sprint.
2. Cross-reference File 04 (Sprint Plan) for that sprint's full content —
   if I haven't pasted File 04, ask me for it only if you need the detailed
   sprint content; otherwise proceed with what's in the Progress Log notes.
3. Deliver the sprint in order: **Concept → Build → Lab**.
4. For any WAS ND / IHS / IBM MQ task, always provide all three:
   Admin Console steps + wsadmin/Jython steps + Shell/Ansible steps. No exceptions.
5. Do not skip ahead to future sprints or phases without my explicit approval.
6. At the end of the sprint, tell me exactly what to update in File 03
   (Quick Status, sprint row, Sprint Completion Log entry) so I can copy it in myself.
7. If anything in this session deviates from the plan, flag it so I can log it
   in the Running Deviations section of File 03.
8. All sample data must be synthetic — never real customer/banking data.
9. Follow the class loader, EAR structure, and naming conventions from File 01 exactly.

If the Progress Log shows "PROJECT NOT YET STARTED" and Sprint 1.1 as next,
begin Sprint 1.1 / Day 1 now.

If the Progress Log shows a sprint already "In Progress," resume it —
check File 06 (Dev Handoff) if I've pasted it, for the exact resume point.

Confirm you've read the Quick Status, state which sprint you're starting/resuming,
then begin.

---

## END OF INSTRUCTION BLOCK

---

## FULL BOOT SEQUENCE (only needed occasionally — first session, or after a long gap)

Use this longer version instead of the simple version when:
- This is your very first session ever
- It's been a long time and you want Claude to re-confirm everything
- You've made a major change to the project design

**Full sequence:**
1. Paste File 05 (this file) in full
2. Paste File 01 (Master Context)
3. Paste File 02 (Concept Index) — optional, only if reviewing concepts
4. Paste File 03 (Progress Log) — always required
5. Paste File 04 (Sprint Plan) — recommended for detailed sprint content
6. Paste File 06 (Dev Handoff) — only if resuming mid-sprint
7. State current sprint explicitly if you want to override what File 03 shows
8. Say "continue" or describe what you need

---

## QUICK REFERENCE — DAILY BOOT CHECKLIST

- [ ] New chat opened
- [ ] File 05 (this file) pasted
- [ ] File 01 (Master Context) pasted
- [ ] File 03 (Progress Log) pasted — most recent saved version
- [ ] Typed: **continue**
- [ ] Claude confirms current sprint and begins
- [ ] At session end: copy Claude's File 03 update instructions into your saved File 03
- [ ] Save updated File 03 before closing chat

---

## END-OF-SESSION CHECKLIST (do this before closing every chat)

- [ ] Ask Claude: "Give me the File 03 update for this session"
- [ ] Copy that update into your master File 03 Progress Log
- [ ] If sprint is incomplete, also fill out File 06 (Dev Handoff) quick version
- [ ] Save both files somewhere you can paste from next time (notes app, Drive, etc.)

---

## KEY DECISIONS ALREADY MADE (for quick reference — full list lives in File 03)

| Decision | Value |
|----------|-------|
| App packaging | Java EE EAR (WAR + Business JAR) |
| Java version | Java 8 |
| Database | MySQL 8.x |
| Messaging | IBM MQ 9.3.x with MDB |
| Application server | WAS ND 9.0.5.x only |
| Prior project | DigiStack Health Enterprise — fully abandoned |

---

*DigiStack Bank — File 05: Session Prompt Template v3.0 | July 2026*
