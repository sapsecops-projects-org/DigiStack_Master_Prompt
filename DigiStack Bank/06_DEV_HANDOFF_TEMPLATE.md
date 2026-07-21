# DEVELOPER HANDOFF PACKAGE — Template

Fill this out at the **end of every Application Development sprint** (Phase 2, and any later sprint that changes deployable code — e.g., 4.10 Ops Utility app, 6.8 Dynacache, 6.9 stale-connection variant). Save each as `handoff_sprint_X.X.md` alongside the Progress Log entry for that sprint. The consolidated version at Sprint 5.8 rolls all of these into the final one-page operational runbook.

---

## Handoff Package — Sprint [X.X] — [Module/Feature Name]

**Date:**
**Prepared by:** (Claude — code; user — deploy/verify)

### Deployment Identity
- **EAR Name:**
- **Version:** (matches build-version-stamp footer)
- **Context Root:**
- **Java Version:**

### Change Control
- **Ticket:** (CHG/ECHG ID from the Ticket ID Log — `03_PROGRESS_LOG.md`; SR if no CAB was required)
- **CAB Approval:** (approved / changes requested / deferred / N/A — see CAB Decision Log)
- **Maintenance Window:** (if applicable — rule #28; N/A for dev-only or same-day changes)

### Runtime Configuration
- **Required JVM Settings:** (custom properties, `-D` flags, etc.)
- **Heap Recommendation:** (initial/max, and rationale if load-test-informed)
- **Datasource Name(s):**
- **JNDI Name(s):**
- **MQ Queue Name(s):** (if applicable this sprint)
- **Connection Factory:** (if applicable)
- **Activation Specification:** (if applicable — MDB sprints only)
- **Environment Variables:**
- **Shared Libraries:** (if any referenced)

### Deployment Notes
(Step-order dependencies, config that must exist before this deploy, anything a fresh admin would need to know)

### Rollback Notes
(How to revert — previous EAR version, config changes to undo, DB migrations to reverse if any. This is the engineering-facing detail; the business-readable Rollback Plan artifact for CAB, rule #23, can point here rather than duplicating it.)

### Known Issues
(Anything not yet fixed, deliberately deferred, or a documented limitation)

### Smoke Test Checklist
(Quick post-deploy sanity checks — 3-6 items, pass/fail, references the relevant section of `07_TEST_CASE_SUITE.md`)
- [ ]
- [ ]
- [ ]

---

*Template fields per user specification, 2026-07-10. Applies to every app-dev sprint — not just the Phase 5 consolidated handoff. Change Control section added 2026-07-11 to link each handoff to its ticket and CAB outcome (Master Context rules #22, #27).*
