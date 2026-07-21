# PROGRESS LOG — DigiStack Bank

**This file is the source of truth.** If it ever conflicts with Master Context or Sprint Plan, this file wins. Update after every sprint — real issues, real resolutions, real deviations. Don't skip entries even for "easy" sprints.

---

## How to log a sprint

Copy this block and fill it in when a sprint completes (or at the end of each Day within a multi-day sprint, per Master Context rules #15/#19):

```
### Sprint X.X — [Title]
- Date completed:
- Day(s) worked: (from 04_SPRINT_PLAN.md's Day range for this sprint)
- Probation stage (if Day ≤90): shadow / joint / solo-with-backup / n/a (post-probation)
- What was actually done:
- Ticket(s) worked (if a Weekly Ticket Queue day): 
- CAB outcome (if a CHG/ECHG requiring approval): approved / changes requested / deferred
- On-call page received this week (if any) — outcome:
- Monthly/quarterly cadence event (if this day carries one per 04_SPRINT_PLAN.md's 📌 markers):
- Issues hit:
- How resolved:
- Deviation from plan (if any):
- Carry-forward notes for next sprint (Handover):
- Reflection: what went well / what was hard / one habit to carry forward:
```

---

## Ticket ID Log

(Tracks the last-issued number per ITSM prefix so tickets never collide or reset. Every day's Team Lead's Assignment draws from here now, not just the Weekly Ticket Queue — see Master Context rule #22. Update after every session that issues a ticket.)

- INC (Incident) — last issued: INC000133
- CHG (Change) — last issued: CHG000046
- SR (Service Request) — last issued: SR000100
- PRB (Problem) — last issued: PRB000033
- ECHG (Emergency Change) — last issued: ECHG000005

---

## CAB Decision Log

(Tracks the outcome of every CAB review — Master Context rule #27 — so approval history is easy to reference later, e.g. when writing an RCA or prepping interview stories. Update whenever a CHG/ECHG goes through CAB.)

```
| Ticket | Sprint/Day | Decision | Presented by | CAB Reviewers | Notes |
|---|---|---|---|---|---|
```

*(No entries yet — CHG000046 (Sprint 1.1, Day 3) was explicitly CAB-exempt per rule #27: dev-only change, pre-Phase-3, no shared production infrastructure exists yet. First real CAB review is still expected once Phase 3 introduces a real cluster to protect. Reviewers are typically Archana [Business, standing] plus whichever of Security/Network/Database/DevOps/MQ fits the change — see the named Department Directory in `01_MASTER_CONTEXT.md` rule #21.)*

---

## Employment Lifecycle Tracker

(Single-glance status for the onboarding/probation/recurring-cadence mechanics in Master Context rules #24–29. Update whenever one of these milestones happens — don't rely on memory of scattered Sprint History entries.)

- **Day 0 (Onboarding & Induction):** completed
- **Probation status:** in progress — Day 14, **shadow stage** (Days 1–30)
- **On-call participation level:** shadow (per rule #18's probation ramp) — no on-call page received yet
- **Last monthly patching cycle:** none yet (next due: Day 30)
- **Last monthly performance review:** none yet (next due: Day 30 — doubles as probation check-in through Day 90)
- **Last quarterly DR drill:** none yet (next due: Day 90 — Drill #1, observational)

---

## Key Decisions Log

(Explicit decisions made under the Pace Deviation Policy — phase extensions, dropped/shrunk topics, etc. Separate from the Standing Deviation Log below, which covers content/architecture changes.)

- **2026-07-10 (eighth pass):** Confirmed two pending flags from earlier passes.
  (a) Pace Deviation Policy prune-first candidate confirmed as **Part 6 (Interview Prep)** —
      interpretation was correct, no change needed.
  (b) `08_LAB_CHALLENGE_BANK.md` filename confirmed as final — no renumbering, to avoid
      disrupting cross-references across the other 7 files.
- **2026-07-10 (ninth pass):** Defined "buffer sprint" for Standing Rule #11 (Pace Deviation
  Policy), which referenced the term without ever tagging which sprints qualify. Decision:
  **Weekly Revision and Weekly Lab slots (positions 6/7 of each weekly cycle) are the
  designated buffer absorption points** — if a phase runs behind, the next Weekly
  Revision/Lab slot is compressed or skipped (not new content, so nothing is lost) to let
  the schedule catch up, rather than pushing the slip into real sprint content. Production
  Simulation Days are NOT buffer days — they stay fixed at every ~15th calendar day
  regardless of drift.
- **2026-07-11:** Confirmed total-day-count reconciliation under the new 9-to-5 workday
  simulation: user chose to stretch sprints across multiple workdays (rather than keep the
  old 1-day-per-sprint model), targeting the ~464-day figure the user specified. See
  Standing Deviation Log entry below for the full recalculation and Master Context rule #20
  for the resulting per-sprint day-length classification.
- **2026-07-11:** Resolved the database-engine conflict flagged in Master Context §2 —
  **Database Team runs MySQL**, not PostgreSQL. User's department-directory message
  explicitly listed "Database (MYSQL)," confirming what every prior sprint (1.5, 5.1, 6.9,
  etc.) had already assumed. No content changes needed elsewhere; only the department-
  directory entry and the now-removed TBD flags in `01_MASTER_CONTEXT.md` were updated.

---

## Standing Deviation Log

(Running list of any departures from Master Context / Sprint Plan — tool swaps, topology changes, skipped/reordered sprints, etc.)

- **2026-07-10:** Gap-check requested before Sprint 1.1 started. Added 7 missing topics into existing sprints rather than new standalone sprints (to avoid bloating count): silent install/response files (1.1), XA transactions (2.5, 3.7), certificate lifecycle management (folded into 4.1), LDAP/AD federation (new 4.6), Backup DMGR/Job Manager/Admin Agent (new 4.7), Dynamic Clusters/Intelligent Management (new 4.8). Phase 4 grew from 6 to 9 sprints; total sprint count updated from ~59 to ~62. See 04_SPRINT_PLAN.md and 02_CONCEPT_INDEX.md for details.
- **2026-07-10:** App development conventions locked in — no frameworks (plain Servlet/JSP/JDBC/DAO), single WAR with clean package structure, Bootstrap 5 CDN frontend, JNDI-bound datasource, basic validation + custom error pages, ~20–30 synthetic seed records, and a visible per-customer notification inbox for the dual-notification feature (instead of just a log line). Claude writes the actual code; user deploys/configures/troubleshoots. See 01_MASTER_CONTEXT.md § Application Development Conventions.
- **2026-07-10:** Added app instrumentation conventions for real WebSphere teaching value: externalized config via WAS variables, toggleable "slow endpoint" and "error-prone endpoint" for hang/error diagnosis practice, meaningful java.util.logging levels, visible Session ID + cluster-member footer, custom PMI counters, structured XML/JSON MQ payloads, and build version stamping. Tagged into sprints 2.1, 2.4, 2.6, 3.7, 4.3, 4.4, 6.1–6.3. See 01_MASTER_CONTEXT.md § App Instrumentation and 02_CONCEPT_INDEX.md.
- **2026-07-10, second pass:** Added 7 more admin-depth topics identified in a second gap-check: wsadmin object model detail — AdminConfig/AdminControl/AdminApp/AdminTask (1.2), Core Groups/HAManager/DCS transport (3.1), FFDC (4.3), start/stop dependency sequencing & split-brain avoidance (new sprint 5.5, Phase 5 grew from 5 to 6 sprints), connection leak detection (6.2), MustGather/collector tool for IBM PMR cases (6.3), and Dynacache (new sprint 6.8). Total sprint count updated from ~62 to ~65.
- **2026-07-10, third pass (senior architect review):** Added 6 more senior-level topics, each deliberately correlated with an app instrumentation hook already in place: health check endpoint (new 3.8, feeds IHS polling + Monitoring Policy + Part 2), configuration scope precedence (new 4.9, paired with a new "Environment Scope" app footer), external LB fix for the IHS SPOF — actually resolving what 4.2/4.3 only documented (new 4.10, Phase 4 now 11 sprints), property-based config management via wsadmin extract/edit/reapply (folded into 5.2), Monitoring Policy/auto-restart reusing the existing toggleable slow endpoint (new 5.6), and rolling deployment/simulated Blue-Green reusing the existing build-version-stamp footer (new 5.7, Phase 5 now 8 sprints). Total sprint count updated from ~65 to ~69.
- **2026-07-10, fourth pass (30-year architect review):** Added 6 more topics closing remaining production/architect-level gaps: TAI/custom JAAS SSO login module (new 4.7), multi-application cluster coexistence via a new "Ops Utility" companion app co-deployed on the cluster (new 4.10), MQ SPOF fix — multi-instance queue manager, closing the loop the SPOF audit opened for IHS/DMGR but left open for MQ (new 4.13, Phase 4 now 14 sprints), WebSphere licensing/PVU counting/ILMT sub-capacity as an architect-level compliance topic (new 5.9, Phase 5 now 9 sprints), stale connection handling via Purge Policy + connection validation using a new stale-connection variant of the existing error-prone endpoint (new 6.9), and closing the capacity-planning loop by reconciling Advanced Block load-test results against the original Sprint 1.3 NFR baseline (new 6.10). Total sprint count updated from ~69 to ~76.
- **2026-07-10, fifth pass:** Added two new portable files — `06_DEV_HANDOFF_TEMPLATE.md` and `07_TEST_CASE_SUITE.md`. Also formalized the Pace Deviation Policy as standing rule #11. Total sprint count updated from ~76 to ~77 (portable file count now 7).
- **2026-07-10, sixth pass:** Added `08_LAB_CHALLENGE_BANK.md` (portable file count now 8). Formalized Weekly Rhythm as new standing rule #12 in Master Context.
- **2026-07-10, seventh pass:** Bank renamed from SecureBank Enterprise to DigiStack Bank across all 8 files. Part 1 restructured into Wave 1 and Wave 2. Day N tags computed on fixed 1-day-per-sprint basis — superseded by 2026-07-11 recalculation.
- **2026-07-10, eighth pass:** Formalized Concept Teaching Format as new Master Context standing rule #14.
- **2026-07-11:** Formalized Daily Lesson Delivery Format as new Master Context standing rule #15.
- **2026-07-11:** Reframed program as workplace simulation, new Master Context rule #16. Rule #15's "Manager's Assignment" renamed to "Team Lead's Assignment."
- **2026-07-11:** Reframed as full 9-to-5 job simulation, new Master Context rules #17–#19. Weekly Lab slot → ITSM ticket queue; weekly unscheduled on-call incident added; daily format gained Handover + Reflection steps.
- **2026-07-11:** Recalculated Sprint Plan from fixed 1-day-per-sprint (136 total days) to variable multi-day model (464 total days). New Master Context rule #20 documents Light/Standard/Heavy classification for all 91 sprints.
- **2026-07-11:** Formalized Department Directory & Cross-Team Collaboration as new Master Context rule #21. Resolved database-engine conflict — MySQL confirmed.
- **2026-07-11:** Formalized ITIL Ticket-Driven Workflow as new Master Context rule #22. Added ECHG as fifth prefix to Ticket ID Log.
- **2026-07-11:** Formalized Cross-Team Communication Artifacts as new Master Context rule #23.
- **2026-07-11 (employment lifecycle pass):** Added full employment lifecycle as new Master Context rules #24–29.
- **2026-07-11 (gap-fill pass):** Reviewed all 8 files against rules #17–29 and closed gaps — extended Concept Index sections K and L, added Change Control section to Handoff Template, added CAB Decision Log and Employment Lifecycle Tracker to Progress Log.
- **2026-07-11 (polish pass):** Named contacts added to rule #21. Team Lead persona named Shivaji. CAB Decision Log gained Reviewers column. Concept Index reordered A–L.
- **2026-07-11 (consistency check):** Updated `08_LAB_CHALLENGE_BANK.md` Production Simulation Day template to use named contacts (Ben, Elena, Grace/Archana) instead of generic labels.
- **2026-07-12:** Note for continuity — live session's in-character personas (Shivaji/Team Lead, Manikandan/Manager, Geetha/Database, Priya Nair/Java Dev, Aisha Rahman/MQ, Padol Jonshon/Linux, Ganesh ACT/Network, Malik Johnson/Security, peta venkatesh/DevOps, Chaitanya Admin/Service Desk, Archana/Business) are drawn from `01_MASTER_CONTEXT.md` rule #21 as currently written — these are the source of truth, winning over any older changelog name sets.
- **2026-07-15:** Added three pre-dev design sessions — **Architecture & MVC Design**, **Database Design** (deepening the schema-design work already scoped here), and **Frontend UI Design** — folded into Sprint 1.5's existing Days 18–23 window at explicit user request: no sprint renumbering, no Day-range or tier change (still Heavy(6)). Taught at solution-architect/admin depth per user's second choice — enough to deploy, configure, and troubleshoot the app's structure, not hands-on coding — consistent with §1's "not a Java-dev exercise" identity. `04_SPRINT_PLAN.md`'s Sprint 1.5 entry expanded; `02_CONCEPT_INDEX.md` gained new Section M (Application Design Foundations); `01_MASTER_CONTEXT.md` §2 gained a matching Application Development Conventions bullet. While editing the Concept Index, corrected a pre-existing inconsistency: the "Schema design for banking domain" row was tagged Sprint 2.1, but the Sprint Plan has always scoped that work to Sprint 1.5 — corrected to 1.5 to match.
- **2026-07-15 (codebase continuity pass):** Added a 9th portable file, `09_CODEBASE_MANIFEST.md`, addressing a real gap: the existing 8 files anchor curriculum continuity across chat sessions, but nothing anchored *application code* continuity. The new file holds a recommended package architecture (locked now, ahead of Sprint 2.1, so every later app-dev sprint's code has an obvious home instead of forcing a refactor), a Name Registry for JNDI/table/queue names (prevents two chat sessions from inventing conflicting names for the same resource), and a pointer to a real Git repository recommended as the actual persistent source of truth for code — formalizing what rule #6 already implied but didn't operationalize. `01_MASTER_CONTEXT.md` rule #6 and §6 (Files in This Project) updated to reference it; `05_SESSION_PROMPT_TEMPLATE.md` updated to attach it from Phase 2 onward and check it before writing new code. Portable file count now 9.

---

## Sprint History

### Day 0 — Onboarding & Induction
- Date completed: 2026-07-12
- Day(s) worked: Day 0 (not counted in the 464-day total)
- Probation stage: n/a (probation begins Day 1)
- What was actually done: HR welcome, IT account/VM access provisioning (VM1 & VM4 confirmed live; VM2/VM3/VM5 confirmed as coming online later per topology), security awareness training, environment access grant, introductions to Team Lead (Shivaji) and named department contacts.
- Ticket(s) worked: none — light preview only, no ticket per rule #24.
- CAB outcome: n/a
- On-call page received this week: none
- Monthly/quarterly cadence event: none
- Issues hit: none
- How resolved: n/a
- Deviation from plan: none
- Carry-forward notes for next sprint (Handover): Environment provisioned, ready for Sprint 1.1 Day 1.
- Reflection: Clean start — no blockers heading into Sprint 1.1.

### Sprint 1.1 — WAS Architecture Overview; DMGR Install & Profile Creation; Silent Install/Response Files
- Date completed: 2026-07-12
- Day(s) worked: Days 1–3 (of Days 1–3 per `04_SPRINT_PLAN.md`) — **sprint complete**
- Probation stage: shadow (Days 1–3, within Days 1–30 range)
- What was actually done:
  - **Day 1:** WAS architecture theory (cell/node/server/profile hierarchy); DMGR profile `Dmgr01` created on VM1 via both Admin Console (Profile Management Tool) and `manageprofiles.sh` CLI; cell `DigiStackCell01`, node `DmgrNode01` established; verified DMGR reaches open state.
  - **Day 2:** Profile types reviewed (dmgr/application server/custom/cell); port plan for `Dmgr01` documented and verified via live wsadmin query (`AdminControl.getPort`) rather than assumed defaults; draft (dry-run only) Installation Manager response file created for future silent installs.
  - **Day 3:** Response file executed for real against an isolated scratch path (`/opt/IBM/WebSphere/AppServer_validate`) — live `Dmgr01` never touched; wrapped in an idempotent, parameterized Ansible role (`wasnd_install`) with a `stat`-based idempotency guard; package ID verified matching Day 1's manual install via `imcl listInstalledPackages`.
- Ticket(s) worked: SR000088, SR000089, CHG000046, INC000124, INC000125, INC000126
- CAB outcome: N/A for CHG000046 — explicitly CAB-exempt per rule #27 (dev-only, pre-Phase-3, no shared production infrastructure exists yet)
- On-call page received this week: none (on-call is shadow-stage per rule #18; no page sprung yet)
- Monthly/quarterly cadence event: none due yet (first patching/review mark is Day 30)
- Issues hit:
  - Day 1: DMGR failed to start post-profile-creation — port conflict on 9043 from a stray process.
  - Day 2: False-alarm port-collision escalation from Service Desk on port 9060 — different port than Dmgr01's actual admin console port.
  - Day 3: Ansible task failed with `imcl: command not found` despite the same command succeeding when run manually over SSH.
- How resolved:
  - Day 1: Identified via `netstat -tulnp`, killed the offending process, restarted DMGR cleanly — confirmed open-for-e-business in SystemOut.log.
  - Day 2: Verified via `netstat` + wsadmin-confirmed port truth (not a defaults table) — confirmed no actual collision with Dmgr01's real admin console port.
  - Day 3: Root cause was Ansible's non-interactive SSH shell not sourcing `.bashrc`/`.bash_profile`, so PATH additions set up interactively weren't present. Fixed by using absolute binary paths in the role (`{{ im_install_path }}/eclipse/tools/imcl`) instead of relying on PATH — now baked permanently into the role.
- Deviation from plan: none — sprint delivered exactly as scoped (architecture + DMGR install + silent install/response files), across its full Standard(3) day allocation per rule #20.
- Carry-forward notes for next sprint (Handover): DMGR live and stable on VM1. Ansible role `wasnd_install` committed to automation repo, reusable for future hosts. Port plan documented for Dmgr01 ahead of VM1 becoming a two-profile host. No open blockers.
- Reflection:
  - Went well: real-log-first triage instinct established Day 1, reused successfully Day 2's false alarm; PATH/environment gotcha on Day 3 caught and permanently fixed at the role level.
  - Was hard: idempotency and response-file parameterization are abstract until executed.
  - Habit to carry forward: verify against the live system (wsadmin, `netstat`, `imcl listInstalledPackages`) rather than trusting documentation or memory.

### Sprint 1.2 — Node Federation (Concept); wsadmin/Jython Fundamentals; Admin Console Deep Tour
- Date completed: 2026-07-13
- Day(s) worked: Days 4–6 (of Days 4–6 per `04_SPRINT_PLAN.md`) — **sprint complete**
- Probation stage: shadow (Days 4–6, within Days 1–30 range)
- What was actually done:
  - **Day 4:** Node federation theory — what `addNode.sh` does under the hood (config merge into DMGR repository, Node Agent install, standalone admin retired); federation documented and automation-scaffolded (`roles/wasnd_federate_node`) for Sprint 3.1 when VM2 arrives — not executed (VM2 doesn't exist yet). wsadmin fundamentals introduced: connected to live Dmgr01, ran `AdminConfig.list('Cell')`, `AdminConfig.list('Node')`, `AdminControl.queryNames('type=Server,*')`; `discover_topology.py` committed as first reusable wsadmin script. Premature-connection incident (INC000127) resolved — `startManager.sh` returning ≠ server ready.
  - **Day 5:** All four wsadmin objects covered in depth with DigiStack-specific examples: `AdminConfig` (blueprint editor — staged, requires save + node sync), `AdminControl` (live MBean tree — immediate, no save), `AdminApp` (application lifecycle — install/update/uninstall/isAppReady pattern), `AdminTask` (pre-packaged wizards — `createJDBCProvider` previewed ahead of Sprint 2.1). Baseline JVM values (initialHeapSize, maximumHeapSize, genericJvmArguments) captured via wsadmin against live Dmgr01 — saved as Sprint 1.3 NFR baseline starting point. `baseline_audit.py` committed after fixing AttributeNotFoundException incident (INC000128). JNDI name `jdbc/DigiStackDB` confirmed with Priya Nair (Java Dev) — locked in for Sprint 2.1.
  - **Day 6:** Full Admin Console navigational tour — all major sections walked (Servers, Applications, Resources, Security, Environment, System Administration, Monitoring and Tuning, Troubleshooting), each cross-referenced against its backing wsadmin object. Global security confirmed disabled via both console and `AdminConfig.showAttribute(securityID, 'enabled')` returning `false` — consistent with Malik Johnson's Day 4 flag, no action until Sprint 1.4. `console_to_wsadmin_crossref.md` committed to repo. Session-timeout incident (INC000129) absorbed as process lesson.
- Ticket(s) worked: SR000090, SR000091, SR000092, INC000127, INC000128, INC000129
- CAB outcome: n/a — all SRs, no CHG raised this sprint
- On-call page received this week: none (shadow stage)
- Monthly/quarterly cadence event: none (next due Day 30)
- Issues hit:
  - Day 4: wsadmin connection refused immediately after `startManager.sh` — premature connection attempt before DMGR fully initialized.
  - Day 5: `baseline_audit.py` failed on `AdminControl.getAttribute(jvmMBean, 'heapSize')` — AttributeNotFoundException due to MBean attribute name case mismatch between docs and live WAS 9.0.5.x MBean.
  - Day 6: Admin Console session timeout mid-navigation — unsaved wizard state lost.
- How resolved:
  - Day 4: Waited for `"server dmgr open for e-business"` in SystemOut.log before retrying wsadmin — connected cleanly.
  - Day 5: Used `AdminControl.getAttributeList(jvmMBean)` to introspect live MBean for exact attribute names; corrected script to match live casing. Lesson: introspect the live MBean, don't trust docs blindly.
  - Day 6: Re-authenticated and resumed tour. No config impact (nothing was mid-save). Process change adopted: prep multi-field config values in a text file before opening console wizards, or script via `AdminTask` instead.
- Deviation from plan: none — sprint delivered exactly as scoped across its full Standard(3) day allocation per rule #20.
- Carry-forward notes for next sprint (Handover): DMGR stable. Federation role scaffolded, ready for Sprint 3.1. Baseline JVM values captured. `baseline_audit.py`, `discover_topology.py`, `console_to_wsadmin_crossref.md` all committed. JNDI name `jdbc/DigiStackDB` locked. Global security disabled — Malik's flag noted, Sprint 1.4 action. Next: Day 7 Weekly Revision → Day 8 Weekly Lab → Sprint 1.3 (Days 9–12).
- Reflection:
  - Went well: wsadmin four-object model landed cleanly via contrast — AdminConfig-vs-AdminControl confusion surfaced and resolved via a real incident rather than a hypothetical; Admin Console tour as "same model, different lens" paid off immediately.
  - Was hard: four distinct object models in one day (Day 5) is dense; AdminTask vs AdminConfig still needs reinforcement in Sprint 2.1 when real resources are created.
  - Habit to carry forward: introspect before assuming — `AdminHelp`, `getAttributeList()`, `AdminTask.help()` are always available and always more reliable than documentation for version-specific details.

### Day 7 — Weekly Revision (Week 1)
- Date completed: 2026-07-13
- Day(s) worked: Day 7 (Weekly Revision slot, Week 1)
- Probation stage: shadow (Day 7, within Days 1–30 range)
- What was actually done: Full recall pass across all Week 1 material — seven structured prompts covering: WAS ND cell/node/server/profile hierarchy; profile types (dmgr/application server/custom/cell); silent install response file design and idempotency guard mechanics; node federation internals (three concrete changes `addNode.sh` makes); all four wsadmin objects (AdminConfig/AdminControl/AdminApp/AdminTask — operating model, staging behavior, concrete examples); Admin Console scope model (Cell/Node/Cluster/Server precedence, datasource scope implications); and all six incidents from the week (INC000124–INC000129) with root causes and the single cross-cutting habit they share. Gaps identified and flagged for Day 8: AdminConfig save→sync→restart sequence (when each step is required vs optional), addNode.sh "why not wsadmin" reasoning, and scope-model precedence tracing under time pressure.
- Ticket(s) worked: none — revision slot, no tickets per rule #12
- CAB outcome: n/a
- On-call page received this week: none (shadow stage — no page sprung across Week 1)
- Monthly/quarterly cadence event: none (next due Day 30)
- Issues hit: none — read-only revision session by design
- How resolved: n/a
- Deviation from plan: none
- Carry-forward notes for next sprint (Handover): Three recall gaps flagged for Day 8 attention — (1) AdminConfig full save→sync→restart sequence, (2) addNode.sh structural reasoning, (3) scope-model precedence tracing. No open config changes. No open tickets. Ready for Day 8 Weekly Lab (Weekly Ticket Queue).
- Reflection:
  - Went well: six incidents recalled cleanly with root causes and resolution steps — the log-first habit is already internalized enough to surface unprompted across multiple prompts.
  - Was hard: scope model is easy to state, harder to trace through a multi-scope example without hesitation — this needs Sprint 4.9's hands-on exercise to fully cement.
  - Habit to carry forward: revision surfaces what's genuinely retained vs. what felt understood in the moment — treating gaps honestly (flagging rather than glossing) is the only version of this that's actually useful.

### Day 8 — Weekly Lab (Weekly Ticket Queue, Week 1)
- Date completed: 2026-07-13
- Day(s) worked: Day 8 (Weekly Lab slot, Week 1)
- Probation stage: shadow (Day 8, within Days 1–30 range)
- What was actually done: Full ticket queue worked — SR000093 (Lab Pick: DMGR/Node Setup, Intermediate tier — timed, no-reference silent profile creation drill via `manageprofiles.sh`, verified via `-listProfiles`, scratch profile cleaned up after), INC000130 (reported admin console outage — verified false alarm via `netstat` + live MBean query; root cause was a stale bookmarked URL on the reporter's side, not an actual outage), SR000094 (consolidated `week1_dmgr_reference.md` from the Day 2 port table, Day 6 console-to-wsadmin cross-reference, and Day 4 federation prep notes), PRB000032 (first lightweight RCA written, ahead of formal Part 5 training — subject: Day 3's Ansible/`imcl` PATH incident, INC000126).
- Ticket(s) worked: SR000093, INC000130, SR000094, PRB000032
- CAB outcome: n/a
- On-call page received this week: none (shadow stage — no page sprung across Week 1)
- Monthly/quarterly cadence event: none (next due Day 30)
- Issues hit: none beyond the queue's own tickets — no unplanned incidents outside the queue today.
- How resolved: n/a (see ticket-by-ticket detail above)
- Deviation from plan: none
- Carry-forward notes for next sprint (Handover): All Week 1 tickets closed clean, no open config drift on live infrastructure (scratch profile from SR000093 deleted post-verification). Week 1 (Day 0 through Day 8) fully closed out. Ready for Sprint 1.3 (Days 9–12) pending explicit approval per rule #2.
- Reflection:
  - Went well: triaged the reported incident ahead of scheduled lab work despite suspecting it was minor — verified rather than assumed, consistent with the week's cross-cutting habit.
  - Was hard: writing a first RCA felt more structured than a plain incident explanation — expected, and the format will keep solidifying well ahead of its formal Part 5 sprint.
  - Habit to carry forward: a report of "it's down" gets verified against the live system every time, regardless of confidence it's a false alarm.

### Sprint 1.3 — NFR & Capacity Baseline; JVM Basics
- Date completed: 2026-07-14
- Day(s) worked: Days 9–12 (of Days 9–12 per `04_SPRINT_PLAN.md`) — **sprint complete**
- Probation stage: shadow (Days 9–12, within Days 1–30 range)
- What was actually done:
  - **Day 9:** NFR & capacity baseline established with real Business Team input (Archana) — load profile (500 → revised to 700 Month-1 registered customers after a same-day partner-pilot scope addition), performance targets per operation (login <2s, balance <1s, transfer <3s), throughput targets (5 TPS baseline / 15 TPS peak burst Month 1; 50/150 TPS Year 1 target), 99.9% business-hours availability target, and a documented scalability path (vertical Month 1 → horizontal by Year 1, tied to Phase 3 clustering). Salary-cycle peak pattern and Check-Balance's <1s target (a Dynacache/Sprint 6.8 forward-reference) both explicitly flagged. `nfr_capacity_baseline_v1.md` committed. Mid-session scope-change (partner-pilot +200 users) explicitly recalculated and logged as a revision rather than silently absorbed.
  - **Day 10:** JVM heap/GC fundamentals covered (nursery/tenured generations under gencon, `-Xms`/`-Xmx` relationship and resize-overhead tradeoff, gencon vs. optthruput named ahead of Sprint 6.2's real comparison). First *informed* JVM heap sizing pass on Dmgr01 — calculated from Day 9's concurrency estimate (~35–56 peak concurrent Month 1) plus WAS overhead and safety margin, landing on `-Xms512M -Xmx768M`; applied via Admin Console and wsadmin (verified identical resulting config), automated via new `apply_jvm_baseline.py` + `jvm_baseline_vars.yml`. Restart performed and new values confirmed live post-restart.
  - **Day 11:** Generic JVM Arguments mechanism covered (free-text escape hatch for JVM flags WAS doesn't expose natively). Verbose GC logging enabled on Dmgr01 (`-verbose:gc -Xverbosegclog:...,10,50000`) with rotation, ahead of Sprint 6.2/6.4's real GC analysis work. `apply_jvm_baseline.py`/`jvm_baseline_vars.yml` extended to carry the GC logging flags as a configurable variable rather than a hardcoded string.
  - **Day 12:** Full sprint checkpoint — re-verified all Days 9–11 artifacts live: `nfr_capacity_baseline_v1.md` confirmed complete and internally consistent (Day 9 revision + Day 10 addendum both present), Dmgr01's JVM heap and generic JVM arguments confirmed non-drifted via wsadmin, and the Ansible role confirmed idempotent via `--check` dry-run (zero changes reported against already-matching live config).
- Ticket(s) worked: SR000095, SR000096, SR000097, SR000098, INC000131, INC000132
- CAB outcome: n/a — DMGR's own JVM, pre-Phase-3, dev-only, exempt per rule #27
- On-call page received this week: none (shadow stage)
- Monthly/quarterly cadence event: none due yet (next mark: Day 30)
- Issues hit:
  - Day 9: Mid-session business requirement change (partner-pilot pool of 200 additional users) landed after the initial baseline draft.
  - Day 10: DMGR restart produced a `WSVR0605W` warning suggesting the requested 512MB heap didn't comfortably match available system memory on VM1.
  - Day 11: Verbose GC log file never appeared after an apparently successful configuration session.
  - Day 12: none — checkpoint day, verification only, nothing found out of place.
- How resolved:
  - Day 9: Explicitly recalculated (500→700 registered, concurrency estimate updated accordingly) and logged as a same-day revision rather than folded in silently — kept the baseline traceable to its actual inputs.
  - Day 10: Escalated to Padol Jonshon (Linux) — confirmed VM1's 16GB total RAM comfortably supports a 768MB max heap; the warning was a transient false-positive from a concurrent Linux-side backup job, not a real shortfall. Didn't recur on next restart. Process lesson: added an explicit system-memory sanity-check step to the capacity baseline process, logged as a Day 10 addendum to `nfr_capacity_baseline_v1.md`.
  - Day 11: Root cause was a malformed `AdminConfig.modify()` call (missing closing bracket) that silently failed to stage the change — no visible error in the wsadmin session. Re-ran the corrected `modify()`/`save()` pair, confirmed via `showAttribute()` before restarting, log file then appeared and was actively written to. Lesson: `showAttribute()` after `save()` is the actual proof a change landed, not a clean session return.
- Deviation from plan: none — sprint delivered exactly as scoped across its full Standard(4) day allocation per rule #20.
- Carry-forward notes for next sprint (Handover): `nfr_capacity_baseline_v1.md` complete and checkpoint-verified — ready for Sprint 6.10's reconciliation against real load-test data. Dmgr01 JVM heap live at `-Xms512M -Xmx768M`, verbose GC logging active with rotation, both confirmed non-drifted. `apply_jvm_baseline.py`/`jvm_baseline_vars.yml` confirmed idempotent. No open blockers. Next: Day 13 Weekly Revision → Day 14 Weekly Lab → Sprint 1.4 (Days 15–17).
- Reflection:
  - Went well (Day 9): grounding every baseline number in either a live system query or a named person's input (Archana) rather than inventing plausible figures; correctly treating the mid-session scope change as a logged revision, not a silent absorption.
  - Went well (Day 10): recognizing the heap-startup warning needed Linux-side context rather than a JVM-side fix — correctly identified as a cross-department diagnostic, not guesswork.
  - Went well (Day 11–12): the silent `modify()` failure extended Sprint 1.2's "verify, don't assume" lesson into a new failure mode (compound config calls), and the Day 12 checkpoint confirmed nothing had drifted since — verification found no problem, which is itself the correct and valuable outcome.
  - Was hard: internalizing that today's heap numbers are provisional by design, not a one-time correct answer — pending real correction from Sprint 6.1/6.2's load-test data. Also, resisting the urge to skip the checkpoint on Day 12 since everything already "felt" correct.
  - Habit to carry forward: a capacity number isn't complete until checked against the actual hardware it has to run on — application-layer math and infrastructure reality are two separate checks. And: "verified once" and "verified now" are different facts.

### Day 13 — Weekly Revision (Week 2)
- Date completed: 2026-07-14
- Day(s) worked: Day 13 (Weekly Revision slot, Week 2)
- Probation stage: shadow (Day 13, within Days 1–30 range)
- What was actually done: Full recall pass across Sprint 1.3's material — five structured prompts covering: functional vs. non-functional requirements and how Day 9's capacity baseline was actually built (inputs, and why sizing for average load instead of peak is a costly mistake); heap structure (nursery/tenured under gencon) and the -Xms/-Xmx resize-overhead tradeoff; Generic JVM Arguments mechanism and -Xverbosegclog rotation syntax, plus why verbose GC logging is typically left permanently enabled in production; both real Sprint 1.3 incidents (INC000131, INC000132) with root causes and the shared cross-cutting habit ("verify actual state, don't trust an apparent success"); and why artifact traceability in `nfr_capacity_baseline_v1.md` matters specifically for Sprint 6.10's future reconciliation. Gaps flagged for Day 14: the precise mechanism behind -Xms/-Xmx resize overhead, the -Xverbosegclog rotation parameter syntax, and whether the Day 11 "verify after compound modify()" lesson feels fully internalized yet.
- Ticket(s) worked: none — revision slot, no tickets per rule #12
- CAB outcome: n/a
- On-call page received this week: none (shadow stage)
- Monthly/quarterly cadence event: none (next due Day 30)
- Issues hit: none — read-only revision session by design
- How resolved: n/a
- Deviation from plan: none
- Carry-forward notes for next sprint (Handover): Three recall gaps flagged for Day 14 attention — (1) -Xms/-Xmx resize overhead mechanism, (2) -Xverbosegclog rotation parameter syntax, (3) internalization check on the Day 11 verify-after-modify() lesson. No open config changes, no open tickets. Ready for Day 14 Weekly Lab (Weekly Ticket Queue).
- Reflection:
  - Went well: both real incidents from the week were recalled cleanly with root causes and the shared verification-discipline thread identified without prompting.
  - Was hard: the -Xverbosegclog rotation syntax is dense and easy to blank on without reference — expected, and exactly what revision is for.
  - Habit to carry forward: naming the cross-cutting thread across two *different* incident types (infrastructure-layer vs. config-layer) rather than treating them as unrelated — the underlying discipline is the same even when the surface details differ.

### Day 14 — Weekly Lab (Weekly Ticket Queue, Week 2)
- Date completed: 2026-07-14
- Day(s) worked: Day 14 (Weekly Lab slot, Week 2)
- Probation stage: shadow (Day 14, within Days 1–30 range)
- What was actually done: Full ticket queue worked — SR000099 (Lab Pick: Tune the JVM, Intermediate tier, per `08_LAB_CHALLENGE_BANK.md` — verification method explicitly adapted from PMI to wsadmin since PMI isn't configured until Sprint 4.4; recalculated Dmgr01's heap for a hypothetical Year 1 load profile of ~250–400 peak concurrent users, landing on `-Xms1024M -Xmx1536M`, applied and verified, then explicitly reverted back to the real Month 1 values `-Xms512M -Xmx768M` and re-verified post-revert since Dmgr01 genuinely only serves Month 1 load), INC000133 (reported slow wsadmin connection after restart — correctly diagnosed as an expected side effect of larger heap allocation taking longer to initialize, not a fault, confirmed via live server-state query rather than assumption), PRB000033 (second lightweight RCA, subject: Day 11's silent `AdminConfig.modify()` failure, INC000132), SR000100 (committed `jvm_sizing_worksheet_template.md` — a reusable heap-sizing calculation format for Sprint 6.2's real tuning pass).
- Ticket(s) worked: SR000099, INC000133, PRB000033, SR000100
- CAB outcome: n/a
- On-call page received this week: none (shadow stage)
- Monthly/quarterly cadence event: none (next due Day 30)
- Issues hit: none beyond the queue's own tickets.
- How resolved: n/a (see ticket-by-ticket detail above)
- Deviation from plan: none — one adaptation noted and logged, not a deviation: the Lab Bank's PMI-based verification method for the JVM Tuning drill was substituted with wsadmin verification, since PMI isn't configured until Sprint 4.4.
- Carry-forward notes for next sprint (Handover): All Week 2 tickets closed clean. Dmgr01 confirmed back at its real Month 1 JVM values (`-Xms512M -Xmx768M`) post-drill — no net config change from today's exercise. `jvm_sizing_worksheet_template.md` committed, ready for Sprint 6.2. Week 2 (Sprint 1.3 plus Days 13–14) fully closed out. Ready for Sprint 1.4 (Days 15–17) pending explicit approval per rule #2.
- Reflection:
  - Went well: explicitly reverting the drill heap values afterward rather than leaving them live "since they worked fine" — a small discipline with real-world weight, since scratch changes have a way of becoming permanent by accident if not deliberately undone.
  - Was hard: distinguishing "this is slower than usual" from "this is actually broken" required connecting the symptom back to a specific recent change (the heap increase) rather than treating it as an unexplained anomaly.
  - Habit to carry forward: a drill or test change is only safely reversible if you deliberately revert it and verify the revert — "it'll probably reset itself" is not a real plan.

---

## Status: SPRINT 1.3 COMPLETE (INCL. WEEK 2 REVISION/LAB) — AWAITING APPROVAL TO ADVANCE

- Day 0, Sprint 1.1 (Days 1–3), Sprint 1.2 (Days 4–6), Day 7 (Weekly Revision), Day 8 (Weekly Lab/Ticket Queue), Sprint 1.3 (Days 9–12), Day 13 (Weekly Revision), and Day 14 (Weekly Lab/Ticket Queue) all fully logged above.
- **Next up: Sprint 1.4 — Security Domains, Global Security Setup, Admin User Roles (Days 15–17) per `04_SPRINT_PLAN.md`.**
- Curriculum finalized: 2026-07-09
- Waiting on: user approval to begin Sprint 1.4
