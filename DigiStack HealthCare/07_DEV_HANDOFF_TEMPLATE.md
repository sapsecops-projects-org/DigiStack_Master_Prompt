# DigiStack Health Enterprise — Developer Handoff Package Template

**Produced twice, at two different scales:**
- **Lightweight, per-module** — at the end of *every* Application Development sprint in Phase 2 that builds a module: **2.1 (Login), 2.2 (Dashboard), 2.10 (Patient Registration), 2.11 (Book Appointment), 2.12 (Cancel/Reschedule), 2.13 (Profile), 2.14 (Visit History), 2.15 (Logout), 2.17 (Lab Order & Referral Routing).** One filled copy of this template per module, capturing what's true *right now* for that module.
- **Consolidated, full package** — at **Sprint 2.24**, all per-module copies are merged, reconciled, and turned into the formal handoff package (README, deployment guide, config reference, DB schema/seed scripts, operational runbook) already described in Master Context.

Not every field applies to every module — leave a field as `N/A` rather than inventing a value. Conditions are noted inline below.

---

## Template

```
MODULE: [e.g., Patient Registration]
SPRINT: [e.g., 2.10]
TICKET ID(S): [e.g., CHG000004 — the Manager's Assignment ticket(s) this module's build was delivered under, per Master Context Section 10d]
CAB APPROVAL: [Y/N/N-A — did this ticket require Change Advisory Board sign-off per Master Context Section 10? "N/A — standard change" for routine lightweight-sprint CHGs]
DATE COMPLETED: [date]
AUTHOR/OWNER: [name]

EAR NAME:                  [ ]   — the enterprise archive this module ships inside
VERSION:                   [ ]   — semantic version or build number
CONTEXT ROOT:              [ ]   — URL path this module is mounted at
JAVA VERSION:               Java 8   (pinned project-wide — confirm no drift)

REQUIRED JVM SETTINGS:      [ ]   — any module-specific flags beyond cluster defaults; "None beyond cluster baseline" if none
HEAP RECOMMENDATION:        [ ]   — Xms/Xmx guidance if this module changes memory pressure; "No change from baseline" if none yet (real numbers come from Sprint 3.10 tuning)

DATASOURCE NAME(S):         [ ]   — e.g., jdbc/DigiStackHealthDS
JNDI NAME(S):                [ ]   — full JNDI lookup string(s) this module depends on

MQ QUEUE NAME(S):            [ ]   — N/A for every module except 2.17 (Lab Order & Referral Routing)
CONNECTION FACTORY:          [ ]   — N/A until MQ exists (Sprint 2.16+); only populated for 2.17
ACTIVATION SPECIFICATION:    [ ]   — N/A until MDB exists (Sprint 2.17); only populated for 2.17

ENVIRONMENT VARIABLES:       [ ]   — any custom env vars this module reads; "None" if standard
SHARED LIBRARIES:            [ ]   — N/A until Sprint 2.20 introduces shared libraries; list here once relevant

DEPLOYMENT NOTES:            [ ]   — anything a deployer needs to know beyond the standard triad steps (ordering dependencies, config that must exist first, etc.)
ROLLBACK NOTES:              [ ]   — exact steps to revert this module's deployment safely
KNOWN ISSUES:                [ ]   — anything left unresolved, deliberately deferred, or a workaround in place

SMOKE TEST CHECKLIST:
  [ ] Module loads without error in server log
  [ ] Primary happy-path action succeeds (specify: e.g., "new patient record saves and appears in list")
  [ ] Datasource connection confirmed live
  [ ] Session behavior confirmed (if module touches session state)
  [ ] [module-specific check]
  [ ] [module-specific check]
```

---

## Illustrative Example (format reference only — not real data)

This shows what a filled copy looks like. Real values get captured for real once Sprint 2.1 actually completes.

```
MODULE: Login
SPRINT: 2.1
TICKET ID(S): CHG000001 — first-ever deployment, standalone WAS server
CAB APPROVAL: N/A — pre-cluster standalone deployment, not yet a production cutover (Master Context Section 10, Hands-on Task note)
DATE COMPLETED: [pending — Sprint 1.1 not yet started]
AUTHOR/OWNER: Venkatesh

EAR NAME:                  DigiStackHealth.ear
VERSION:                   0.1.0
CONTEXT ROOT:               /digistack-health
JAVA VERSION:                Java 8

REQUIRED JVM SETTINGS:      None beyond cluster baseline
HEAP RECOMMENDATION:        No change from baseline (standalone server, Phase 1 sizing)

DATASOURCE NAME(S):         DigiStackHealthDS
JNDI NAME(S):                jdbc/DigiStackHealthDS

MQ QUEUE NAME(S):            N/A — no MQ dependency for Login
CONNECTION FACTORY:          N/A
ACTIVATION SPECIFICATION:    N/A

ENVIRONMENT VARIABLES:       None
SHARED LIBRARIES:            N/A — not introduced until Sprint 2.20

DEPLOYMENT NOTES:            First-ever deployment (Sprint 2.1) — deploys to the standalone WAS server from Phase 1, not yet the cluster (cluster doesn't exist until Sprint 2.5). Requires the datasource from Sprint 1.12 to already be configured and tested.
ROLLBACK NOTES:              Undeploy via Console (Applications > Enterprise Applications > select > Stop > Uninstall), or wsadmin AdminApp.uninstall(). No DB schema changes tied to this module, so no DB rollback needed.
KNOWN ISSUES:                None yet — first deployment, not yet run.

SMOKE TEST CHECKLIST:
  [ ] Module loads without error in server log
  [ ] Login with valid synthetic credentials succeeds and reaches Dashboard placeholder
  [ ] Login with invalid credentials shows correct error, does not create a session
  [ ] Datasource connection confirmed live (Console Test Connection)
  [ ] JSESSIONID cookie is set on successful login
```

---

## Notes

- Fields that say "N/A until Sprint X" exist because the underlying concept hasn't been taught yet at that point in the roadmap — per the project's Concept-before-Build rule, don't fill in a field for a concept you haven't covered. Leave it N/A and revisit once that sprint happens.
- At Sprint 2.24, go back through every per-module copy and reconcile: are JNDI names consistent everywhere they're referenced? Do any two modules disagree about an environment variable? That reconciliation pass *is* the value of doing this per-module instead of only once at the end.
