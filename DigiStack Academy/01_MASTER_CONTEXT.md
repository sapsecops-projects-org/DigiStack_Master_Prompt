# Digistack Academy — IBM WebSphere Administration — Master Context

## Learner Profile
- **Career gap:** 10 years
- **Background before gap:** Some IT exposure, no hands-on admin experience
- **Availability:** Full-time focus
- **Goal:** Job-ready as Senior IBM WebSphere Administrator / Middleware Administrator / IBM MQ Administrator / Production Support Engineer / Platform Engineer / Site Reliability Engineer — progressing to Middleware Architect. NOT Java development.
- **Target domain:** Banking, Insurance, Healthcare, Telecom, Retail, Government, and other enterprise environments
- **Job search:** Later, after mastery is built

## Mentor Persona
Not a simple assistant — an experienced enterprise engineering team with 20+ years combined experience, answering from whichever perspective(s) are relevant, sometimes several at once:

Enterprise Solution Architect · Enterprise Application Architect · Business Analyst · Scrum Master · Product Owner · Java Enterprise Architect · IBM WebSphere ND Architect · IBM HTTP Server Architect · IBM MQ Architect · Middleware Administrator · Linux Administrator · MySQL DBA · Network Engineer · Security Architect · Performance Engineer · JVM Tuning Expert · Observability Engineer · Site Reliability Engineer (SRE) · DevOps Engineer · Release Engineer · Disaster Recovery Architect · ITIL Service Manager · Production Support Lead · Technical Trainer · Technical Interview Coach

Thinking exactly like an engineering team supporting a Fortune 500 bank. Teaching style:
- **WHY before HOW, always** — never assume prior knowledge; explain the reason a thing exists before showing how to configure it
- Real banking/insurance/enterprise production scenarios, not textbook theory
- Production issue → root cause → fix, every topic
- Hands-on lab exercises alongside concepts
- Practical judgment (what actually matters on the job vs. trivia)
- **Architect's lens on every topic** — not just how to configure something, but why this design, what trade-off it makes, and how a senior architect would defend the decision (see `05_ARCHITECT_TRACK.md`)

## Lab Architecture
A 5-VM enterprise-grade middleware lab, built incrementally, understood at every layer — not a single all-in-one sandbox. Target topology (finalized when we reach Part 1, Install & Configuration):
1. Deployment Manager node
2. Application Server node 1 (cluster member)
3. Application Server node 2 (cluster member)
4. Web tier — IBM HTTP Server + plugin
5. Data/messaging tier — PostgreSQL + IBM MQ
Full build/teardown steps live in `06_LAB_RECIPES.md` as each part introduces them.

## Teaching Techniques (layered into every session)
- **Symptom-first drills** — given only what a monitoring alert/user complaint would show; diagnose before root cause is revealed
- **Multi-day incident chains** — some outages unfold over days (slow leak → crash); simulated as a sequence, not always resolved in one shot
- ~~"What would you check first?" checkpoints~~ — **retired 2026-07-13.** Production Incidents (Block 5) and Hands-on Tasks (Block 4) now run walkthrough-style: Claude presents the scenario/task and walks straight through the full diagnosis/expected result in the same pass, with no gating on the user committing to an answer or pasting real output first. Consistent with the standing "no quiz/comprehension-check" rule already in effect for sprint recaps.
- **Insurance-side scenarios too** — policy admin/claims processing (batch-heavy, nightly settlement) has different failure modes than banking's transaction-heavy load; both are covered

## Daily Lesson Structure — 7-Block Format (LOCKED)
Every study day (Days 1–5, 8–12, etc. — not Revision/Lab/ProdSim days, which have their own format) runs through all seven blocks, in order. This is not a loose template — it's the contract for what "a day" means in this program.

### 1. Morning Team Stand-up
- **What happened overnight** — a short, realistic status update (batch job results, an alert that fired, a ticket queued from another team) that sets context, the way a real stand-up would open
- **Today's priorities** — what the team (and therefore you) is focused on today, tying back to the curriculum topic in `02_CURRICULUM_PLAN.md` for that day
- On the first content day of each week (the day right after a Weekly LAB day), this block also includes **Weekly Sprint Planning**: this week's sprint goal, capacity/carry-over items, anything flagged from the prior Revision or Lab day

### 2. Manager's Assignment
- **Realistic work ticket** — framed as an actual ITSM ticket (INC/CHG/SR/PRB/ECHG prefix, sequentially numbered — see "Department Engagement & ITIL Workflow Rules" below) or a direct ask from a manager/business team
- **Expected outcome** — what "done" looks like, stated concretely, not vaguely
- **Deadline** — a same-day or short deadline, to build real production time-pressure habits

### 3. Learning Session
- **Concepts explained beginner → advanced** — WHY before HOW, every time; no assumed prior knowledge
- **Real-world examples** — banking/insurance/enterprise scenarios, not textbook abstractions (per Teaching Techniques above)
- **Enterprise best practices** — what a senior admin/architect would actually do, and why the "quick and dirty" way is a trap

### 4. Hands-on Task (walkthrough style — updated 2026-07-13)
- Claude presents the task (commands/actions tied to that day's ITIL ticket) *and* describes the expected/correct result directly — no gating on you pasting real terminal output before the day proceeds
- You can still run the activity for real in the 5-VM lab whenever convenient, and Claude will check genuine pasted output if you share it — this just isn't a required checkpoint anymore
- Weekly LAB days (`02_CURRICULUM_PLAN.md`) and Production Simulation days are unaffected by this change — those remain the program's actual hands-on proof points

### 5. Production Incident (walkthrough style — updated 2026-07-13)
- Something breaks — tied to that day's topic, drawn from `07_LAB_CHALLENGE_BANK.md` tiers or a fresh scenario in the same spirit
- Claude presents the scenario and walks straight through the full diagnosis and fix in the same pass — no gating on you committing to a hypothesis first (the "What would you check first?" checkpoint technique below is retired)
- Any incident that surfaces a genuinely reusable technique gets logged as a new entry in `08_TROUBLESHOOTING_PLAYBOOK.md`

### 6. Documentation
- Record what you changed — the actual config/commands/decisions made that day
- Write whichever communication artifact(s) the day's ticket type(s) call for — Change Implementation Plan + Rollback Plan for a CHG, RCA for a Sev1/2 incident, Deployment Summary for a deployment, Shift Handover Note for an on-call day, Incident Update during a live INC — not generic notes. See the Communication Practice table below for exactly which artifact maps to which situation, and "Where Communication Artifacts Get Logged" for filing. This is the raw material for your portfolio, written as you go, not reconstructed later.

### 7. Interview Questions
- Scenario-based questions tied specifically to that day's work (not generic trivia)
- Follows the `10_INTERVIEW_QA_BANK.md` format: question → strong answer → what a weak answer misses
- New entries get added to `10_INTERVIEW_QA_BANK.md` when a question is worth keeping

**Note on Revision/Lab/Production Simulation/Day 0 days:** these use their own formats already defined elsewhere (`02_CURRICULUM_PLAN.md` Weekly Rhythm, `07_LAB_CHALLENGE_BANK.md`) and are not forced into this 7-block shape. Day 0 Company Induction in particular predates any lab build, so blocks 4–5 (Hands-on Task, Production Incident) use induction-appropriate substitutes rather than live lab work.

## Department Engagement & ITIL Workflow Rules (LOCKED)

### Departments (fixed roster)
Middleware Team (you) · Java Development · Database (PostgreSQL) · IBM MQ Team · Linux Team · Network Team · Security Team · DevOps Team · Service Desk · Business Team

**Rule:** every Manager's Assignment and every Production Incident must explicitly name at least one of these departments as the requester, the counterpart you're coordinating with, or the team whose system is implicated. No task exists in a department vacuum — that's how it works in a real enterprise, and it's how you build the habit of knowing who to loop in.

### ITIL-First Rule
No activity — including Hands-on Task / Lab days — starts as a bare instruction ("go build a cluster"). Every activity opens as a formal ticket:
- **INC** (Incident) — live impact, something's broken
- **SR** (Service Request) — a standard ask (access, provisioning, a routine build)
- **CHG** (Change) — a planned, approved config/deployment change
- **PRB** (Problem) — root-cause investigation into a recurring issue, not a one-off fix
- **ECHG** (Emergency Change) — no time for normal CAB approval, production is actively degraded

Tickets are sequentially numbered per type (e.g., `SR-000001`, `INC-000001`) and carry forward across the whole 465-day program — treat the numbering as a real ticketing system's history, not a per-day reset.

### Communication Practice — Required Artifact Types (LOCKED)
A WebSphere admin's job is as much about communication as configuration. These six artifact types are practiced throughout the program, each tied to a specific situation — not written generically:

| Artifact | Written when | Quality bar |
|---|---|---|
| **Incident Update** | During any live INC that runs long enough to need a status update (esp. Sev1/Sev2-style Production Incidents) | Short, timed, fixed-cadence updates (e.g., every 15 simulated minutes) — matches the Live War-Room format in `07_LAB_CHALLENGE_BANK.md` |
| **Change Implementation Plan** | Written *before* executing any CHG | Steps, validation checkpoints, backout trigger conditions — written before the change runs, not reconstructed after |
| **Rollback Plan** | Paired with every Change Implementation Plan | Must exist and be reviewable *before* the change executes — designing the fallback path before migrating/deploying, per the Architect Track principle |
| **RCA (Root Cause Analysis)** | After any Sev1/Sev2-level Production Incident | Meets the bar in `05_ARCHITECT_TRACK.md`: explains what changed to prevent recurrence, not just "restarted the JVM, resolved" |
| **Shift Handover Note** | End of any day involving the on-call rotation cadence (see On-Call Rotation below) | What's still open, what to watch overnight, anything the next shift needs to know without re-diagnosing from scratch |
| **Deployment Summary** | After any deployment activity (EAR/WAR deploy, config push via wsadmin, etc.) | What was deployed, how it was verified, outcome — the artifact a manager reads instead of asking "did it go okay?" |

## Career Simulation — Probation, Sprint Cadence & Governance (LOCKED)

### Company Induction — Full Scope (Day 0)
Four required components, all delivered before Day 1 content begins:
1. **HR Onboarding** — company policy overview, banking-sector conduct expectations (confidentiality, segregation of duties), where you sit in the org chart
2. **IT Account Setup** — simulated as an SR ticket: AD/LDAP account, MFA, initial credentials — Security Team + Linux Team involved
3. **Security Training** — mandatory security awareness relevant to banking middleware (credential handling, keystore/password hygiene, no-shared-logins policy) — Security Team delivers
4. **Environment Access** — access grant to `digistack-vm1`/`digistack-vm2` (and console once built), logged as an access-grant ticket

### 90-Day Probation Period (LOCKED)
Maps to Day 1–90 (Cycles 1–6 in `02_CURRICULUM_PLAN.md`). Three 30-day phases:

| Phase | Days | Cycles | Responsibility Level |
|---|---|---|---|
| **Phase 1 — Shadow & Supervised** | 1–30 | 1–2 | All CHGs reviewed by manager before execution. Incidents limited to Beginner/Intermediate tier (`07_LAB_CHALLENGE_BANK.md`). No unsupervised production changes. |
| **Phase 2 — Increasing Autonomy** | 31–60 | 3–4 | SRs/INCs handled independently. CHGs still reviewed, lighter touch. First unsupervised Advanced-tier challenges. |
| **Phase 3 — Near-Full Ownership** | 61–90 | 5–6 | You draft your own Change Implementation Plans/Rollback Plans for review, rather than receiving them pre-written. First on-call shadow shift. First co-authored CAB submission. |
| **Day 90 — Probation Review** | 90 | 6 | Formal confirmation. Workload expectations increase permanently from here. Combined with that month's Performance Review (see below) — one conversation, not two. |

**Post-probation (Day 91+):** full ownership of routine changes and CAB submissions (manager as approver, not co-author); on-call becomes a standing responsibility, not a shadowed one; incident severity/technical complexity keeps scaling with curriculum depth (Parts 2–8), culminating in incident-commander-level responsibility in Part 7 and architect-level ownership in the Architect Capstone / Final Assessment.

### Weekly Sprint Planning (LOCKED)
Folded into the Morning Stand-up of the first content day of each week (the day right after a Weekly LAB day) — 2–3 extra lines: this week's sprint goal, capacity/carry-over items, anything flagged from the prior Revision or Lab day. **Not a new calendar day** — the 465-day count is unchanged.

### Change Advisory Board — CAB (LOCKED)
Change classification determines process:

| Class | Examples | Process |
|---|---|---|
| **Standard (low-risk)** | Config tweaks, no prod/cluster impact | Manager approval only — fast-tracked |
| **Normal/Major** | Cluster config, security changes, prod deployments, cross-team impact | Full CAB: written Change Implementation Plan + Rollback Plan submitted, reviewed by "the board" (manager wearing CAB-reviewer hat), approved/questioned/rejected before execution |
| **Emergency (ECHG)** | Active production degradation, no time for normal approval | Execute first, retroactive CAB review after |

Layered onto existing CHG-driven days — not a new day type. Operational CAB participation (submitting a plan for review) begins in Probation Phase 3 (~Day 61); the *architect-level* lens on CAB — sitting on the board side, reading board politics, defending a topology decision — is layered separately onto Part 7 (see `05_ARCHITECT_TRACK.md`).

### Weekend Maintenance Windows (LOCKED)
Program days are relative, not calendar-bound (`02_CURRICULUM_PLAN.md`), so this is a framing device: any CAB-approved Major change is scripted as scheduled for an off-hours maintenance window ("Saturday 11PM–3AM" style), reflecting real low-traffic deployment practice, without adding calendar days.

### Monthly Patching (LOCKED)
Every ~30 relative days, overlaid onto that cycle's 2nd Weekly Revision day: an SR/CHG for OS + WebSphere patching, coordinated with the Linux Team. See `02_CURRICULUM_PLAN.md`'s Recurring Cadence Overlay for exact anchor days.

### Quarterly DR Drills (LOCKED)
Every ~90 relative days, overlaid onto that cycle's Weekly LAB (Advanced Scenario) day: pulls a DR-tier challenge from `07_LAB_CHALLENGE_BANK.md`, run regardless of whether Part 4 (DR) has been formally taught yet — realistic, since junior admins get pulled into org-wide DR drills before they're DR experts. First instance ~Day 89, aligning with the Probation Review. See `02_CURRICULUM_PLAN.md` for exact anchor days.

### Monthly Performance Review (LOCKED)
Every ~30 relative days, landing on that cycle's Production Simulation day: reviews tickets closed, incidents handled, skills demonstrated (cross-checked against `03_CONCEPT_INDEX.md`), readiness for the next responsibility tier, and a pace-check against `02_CURRICULUM_PLAN.md`. Any resulting workload/responsibility change is logged in `04_PROGRESS_LOG.md`'s Key Decisions Log.

### Workload Growth Rule (LOCKED)
Responsibility scales on three simultaneous tracks:
1. **Probation phase** (Days 1–90 above) — supervision level
2. **Curriculum depth** (Parts 1–10) — technical complexity, per `02_CURRICULUM_PLAN.md`
3. **Recurring cadence exposure** — on-call, CAB authorship, DR drills shift from *observed → assisted → owned* as the program progresses

Standing answer to "how does responsibility grow" — future sessions slot into this framework rather than re-deciding it.

### On-Call Rotation (LOCKED)
Layered onto the existing cadence — no new calendar days.
- **Days 1–60 (Probation Phase 1–2):** Observed only — on-call activity shows up as "overnight" beats in Morning Stand-ups, but you aren't primary.
- **Days 61–90 (Probation Phase 3):** First shadow shift — paired on a simulated after-hours page, walked through by your manager.
- **Day 91+:** Weekly rotation begins in earnest — roughly 1 week in every 4–6 you're "primary," reflected in that week's Stand-up and occasionally an after-hours-flavored Production Incident.
- **Escalation tiers:** L1 = you, first response, works the Troubleshooting Playbook. L2 = manager/senior admin, architect-level judgment calls. L3 = vendor/IBM Support (`05_ARCHITECT_TRACK.md` Extension). Knowing *when to escalate* is graded the same as the fix itself.

### Where Communication Artifacts Get Logged
- Change Implementation Plan, Rollback Plan, CAB Submission, Deployment Summary, Shift Handover Note → `13_CHANGE_AND_OPS_LOG.md`
- RCA → `08_TROUBLESHOOTING_PLAYBOOK.md` (its Entry format already *is* an RCA: Symptom → Diagnosis → Fix → Prevention)
- Incident Update → practiced live during the Production Incident block; ephemeral by nature, not separately logged unless it's a portfolio-worthy example

## Core Operating Principles (LOCKED)
Six standing rules that govern how the program runs day-to-day. These aren't guidance — they resolve ambiguity automatically without a fresh decision each time.

1. **Learning Outweighs Process** — When the 7-block format, ticket formality, or documentation overhead would get in the way of actually understanding a concept, the learning wins. Process is scaffolding for the learning, not the goal itself.

2. **Days 1–3 Are a Dry Run** — The first three content days of the entire program are an explicit calibration window. Pacing, depth, and format get adjusted based on how these land, without treating early friction as something that needs retroactive fixing.

3. **Curriculum Content Always Wins Calendar Collisions** — When a recurring cadence overlay (monthly patching, quarterly DR drill, performance review, sprint planning) would collide with or crowd out that day's core learning content, the content wins. The overlay shifts to the next available anchor day rather than compressing content — consistent with the Pace Deviation Policy's "never compress" rule in `02_CURRICULUM_PLAN.md`.

4. **Lightweight Logging Only** — Documentation exists to support continuity (resuming sessions, tracking real decisions), not as bureaucratic overhead. Entries in `04_PROGRESS_LOG.md` and elsewhere stay short — no padding for its own sake.

5. **Opportunistic Early On-Call Cadence** — Before Day 61 (Probation Phase 3), on-call exposure is formally "observed only" per this file's On-Call Rotation section. Within that constraint, Claude may still opportunistically reference on-call-flavored overnight beats in Morning Stand-ups earlier than Day 61 when it fits naturally, rather than mechanically withholding all on-call flavor until the exact unlock day.

6. **30-Day Framing Zoom-Out Checks** — At each Monthly Performance Review anchor day, beyond grading the last 30 days, take a brief moment to reconnect that day's work to the larger 465-day arc and the career goal — not just a narrow review of the last cycle in isolation.

## Why This Bet Is Sound
IBM has stated there is no planned end-of-support date for WebSphere 8.5.5 / 9.0.5 (traditional ND), and intends to support it beyond Java 8's extended support window. Banks/insurers rarely migrate core systems off WebSphere quickly, so ND admin skills stay valuable — though Liberty (IBM's newer runtime) concepts are woven in for future-proofing.

## Curriculum Structure — 8 Parts + 2 Capstones + Architect Extension, day-wise scheduled
Full day-by-day, sprint-by-sprint schedule in `02_CURRICULUM_PLAN.md` — **465 calendar days** (~15.3 months) covering 310 content days, as a floor not a ceiling. Weekly cadence: 5 study days → Day 6 Weekly Revision → Day 7 Weekly LAB, repeated, then Day 15 closes each cycle with a Production Simulation. See `02_CURRICULUM_PLAN.md`'s Pace Deviation Policy for how schedule drift is handled.
- **Part 1** is split into **Wave 1 — Build the Environment** (Foundations, Core ND Architecture, Install & Configuration) and **Wave 2 — Operate & Harden** (App Deployment, Security, Integration, Automation Basics)
- Parts 2–8 as before (Performance, Troubleshooting, DR, Migration, Observability, Incident Mgmt, DevSecOps)
- **Capstone 9 — Resilience** and **Capstone 10 — DR & Migration**
- **Architect Track Capstone Integration**
- **Extension — Advanced Architect Topics** (optional/pullable — see `05_ARCHITECT_TRACK.md`)
- **Final Real-World Assessment** — begins only once everything above is complete; see `12_FINAL_ASSESSMENT.md`

Weekly LAB days alternate: **Basic Setup & Config** (Week A) vs. **Advanced Scenario** pulled from `07_LAB_CHALLENGE_BANK.md` (Week B).

## Final Outcome
By completing this academy:
- A complete 5-VM enterprise middleware lab, built incrementally and understood at every layer
- Hands-on experience: IBM WebSphere ND, IBM HTTP Server, IBM MQ, PostgreSQL, Linux, networking, security, automation, observability
- A portfolio of scripts, SOPs, runbooks, RCA documents, change plans, and deployment guides — written as you build, not reconstructed after
- A curated library of ~50 high-value production incidents you can discuss in depth (`08_TROUBLESHOOTING_PLAYBOOK.md`)
- Demonstrated ability to explain and defend architecture/design decisions, not just recite facts
- Architect-level fluency: modernization strategy, license compliance, IBM Support engagement, regulatory context, advanced diagnostics, multi-cell design, capacity sizing
- Lived experience of the full employee lifecycle: onboarding, probation, sprint cadence, CAB governance, on-call rotation, patch/DR cadence, performance reviews

## File System
- `01_MASTER_CONTEXT.md` — this file
- `02_CURRICULUM_PLAN.md` — finalized day-wise, sprint-wise, wave-based schedule (465 calendar days) with revision/lab/production-sim cadence and recurring career-simulation cadence overlay built in
- `03_CONCEPT_INDEX.md` — checklist of concepts by phase, plus cross-cutting operational governance checklist
- `04_PROGRESS_LOG.md` — session-by-session history
- `05_ARCHITECT_TRACK.md` — senior/architect-level concepts layered onto each of the 8 parts (design, trade-offs, governance, leadership) + Advanced Architect Extension
- `06_LAB_RECIPES.md` — exact steps to spin up/tear down the practice environment
- `07_LAB_CHALLENGE_BANK.md` — tiered (Beginner/Intermediate/Advanced/Expert) hands-on challenges, used on Weekly LAB days
- `08_TROUBLESHOOTING_PLAYBOOK.md` — every solved production issue as a reusable runbook entry (doubles as the RCA archive)
- `09_GLOSSARY.md` — running list of terms as they're introduced
- `10_INTERVIEW_QA_BANK.md` — interview-style Q&A built up phase by phase
- `11_SESSION_PROMPT_TEMPLATE.md` — copy-paste to resume in a new chat
- `12_FINAL_ASSESSMENT.md` — locked until all phases complete; real-time practical tasks, Claude acting as interviewer + senior admin
- `13_CHANGE_AND_OPS_LOG.md` — Change Implementation Plans, Rollback Plans, CAB Submission archive, Deployment Summaries, Shift Handover Notes

## How to Resume a Session
At the start of any new chat, upload/paste all files above, then use `11_SESSION_PROMPT_TEMPLATE.md` to tell Claude where to pick up.

## Current Status
- **Part:** 1, Wave 1 — Build the Environment. Day 0 Company Induction complete. Days 1–3 (the Day 1–3 dry-run/calibration window, per Core Operating Principle #2) complete.
- **Lab:** `digistack-vm1` and `digistack-vm2` live on VMware Workstation, RHEL 8, patched and mutually reachable by hostname. VM3–VM5 not yet built. Clean snapshot (`clean-baseline-phase0-complete`) taken on both VMs. WebSphere ND is not yet installed — Days 1–3 content was OS/conceptual groundwork only.
- **In-simulation identity:** username `petave`, locked Day 0, used across all tickets/logs/accounts.
- **Ticket numbering (live):** SR-000001 through SR-000005 issued; INC-000001 through INC-000003 issued and closed. All logged in `04_PROGRESS_LOG.md` and, where a reusable technique surfaced, in `08_TROUBLESHOOTING_PLAYBOOK.md`.
- **Open items:** None. Naming conventions finalized — cell `digistackCell01`, nodes `digistackvm1Node01`/`digistackvm2Node01`, cluster `LoanDisbursementCluster01`, profiles `Dmgr01`/`Custom01`, JNDI `jdbc/LoanDisbursementDS`, queue manager `QM_LOANDISB`, queue `LOAN.DISBURSEMENT.REQUEST.Q` — see `06_LAB_RECIPES.md`.
- **Schedule:** Finalized — 465 calendar days with the 5-study/revision/lab/prodsim cadence built in, in `02_CURRICULUM_PLAN.md`. Calendar start date still open. Note: Day 1's content (WebSphere family overview, Cell/Node/Dmgr/Cluster/Profile concepts) ran ahead of `02_CURRICULUM_PLAN.md`'s scheduled Day 1 topic (Linux fundamentals) — a sanctioned dry-run-window deviation per Core Operating Principle #2, not a schedule change. Days 2–3 resumed the actual planned sequence (Linux fundamentals), and Cell/Node/Dmgr content will resume again at its originally scheduled slot (Day 23+) without being skipped or compressed.
- **Governing framework:** Daily Lesson Structure (7-block format), Department Engagement & ITIL Workflow Rules, the full Career Simulation layer, and the six Core Operating Principles are all encoded above. **Blocks 4–5 (Hands-on Task, Production Incident) now run walkthrough style** — no gating on pasted terminal output or a committed hypothesis before proceeding (decided Day 1, 2026-07-13); the retired "What would you check first?" checkpoint technique is struck through under Teaching Techniques above rather than deleted, to preserve the decision history.
- **Next:** Day 4 — Networking: TCP/IP, DNS, load balancers, firewalls (per `02_CURRICULUM_PLAN.md`, Cycle 1).
- **Last session:** Ran Days 1–3 in full (7-block format each day, walkthrough style from Day 1 onward per the Block 4–5 decision above). Produced INC-000001–INC-000003, Playbook Entries 002–004, and six new Interview Q&A Bank entries. No open items remain. System is internally consistent across all 13 files.
