# Lab Recipes — WebSphere ND Practice Environment

Exact, repeatable steps for spinning up and tearing down your practice environment. Filled in as we build each piece — don't rebuild from memory each time, follow the recipe.

**Status:** Environment is live. Two VMs built on VMware Workstation — `digistack-vm1` and `digistack-vm2` — running **RHEL 8** (not Rocky Linux 9; earlier notes citing Rocky Linux 9 were a documentation error, corrected on record). Both VMs are patched and mutually reachable by hostname. Phase 0 (Sprints 0.1–0.4) is complete (~Day 7 equivalent). A clean VMware snapshot of both VMs has been taken. Naming conventions are finalized (see below).

**Open items:** None carried forward — both prior open items (snapshot, naming conventions) are resolved as of this session. Next open item, if any, will surface during Sprint 1.1+.

## Target Lab Topology — 5-VM Enterprise Middleware Lab
Built incrementally, not all at once — each VM gets added when the curriculum reaches it:
1. **VM 1 — Deployment Manager node** (Wave 1, Install & Configuration)
2. **VM 2 — Application Server node 1** (cluster member) (Wave 1, Core ND Architecture lab)
3. **VM 3 — Application Server node 2** (cluster member) (Wave 1, Core ND Architecture lab)
4. **VM 4 — Web tier** — IBM HTTP Server + WebSphere plugin (Wave 1, Install & Configuration)
5. **VM 5 — Data/messaging tier** — PostgreSQL + IBM MQ (Wave 2, Integration)

---

## Recipe 000 — Environment Choice (DECIDED)
Options evaluated:
- Docker containers per VM role (fastest to reset, closest to disposable lab habits)
- Local VMs (RHEL/Ubuntu) per role (closer to real enterprise ops experience)

**Decision:** Local VMs on VMware Workstation, RHEL 8 guest OS. `digistack-vm1` and `digistack-vm2` are built, patched, and mutually reachable by hostname. Remaining VMs (VM3–VM5) get added incrementally as the curriculum reaches each role, per the Target Lab Topology above.

**Resolved:** Clean VMware snapshot of VM1/VM2 taken — see Recipe 001 below.

---

## Recipe 001 — Clean Baseline Snapshot (DONE)

**Prerequisites:** VM1 and VM2 patched, mutually reachable by hostname, no in-progress config changes.

**Steps:**
1. Shut down `digistack-vm1` cleanly from inside the guest (`sudo shutdown -h now`).
2. In VMware Workstation: select the VM → **VM menu → Snapshot → Take Snapshot**.
3. Name the snapshot `clean-baseline-phase0-complete`.
4. Repeat steps 1–3 for `digistack-vm2`.
5. Power both VMs back on.

**Verification:** VM menu → Snapshot → Snapshot Manager shows `clean-baseline-phase0-complete` as the current snapshot for both VMs.

**Teardown:** Snapshot Manager → select `clean-baseline-phase0-complete` → **Go To** (reverts VM to this state) if a rollback is ever needed.

**Status:** ✅ Complete for both VMs.

---

## Naming Conventions (FINALIZED — Sprints 1.1–1.3)

| Item | Convention | Value |
|------|------------|-------|
| Cell name | `<project>Cell<##>` | `digistackCell01` |
| Node name (VM1, Dmgr's own node) | `<hostname>Node01` | `digistackvm1Node01` |
| Node name (VM2, custom node) | `<hostname>Node01` | `digistackvm2Node01` |
| Cluster name | `<AppDomain>Cluster<##>` | `LoanDisbursementCluster01` |
| Dmgr profile name | `Dmgr<##>` | `Dmgr01` |
| Custom profile name | `Custom<##>` | `Custom01` |
| JNDI name (datasource) | `jdbc/<AppName>DS` | `jdbc/LoanDisbursementDS` |
| Queue manager name | `QM_<DOMAIN>` | `QM_LOANDISB` |
| Queue names | `<DOMAIN>.<SUBDOMAIN>.<PURPOSE>.Q` | `LOAN.DISBURSEMENT.REQUEST.Q` |

**Rationale:** Hostname-derived node names and domain-prefixed queue/JNDI names mean any resource is identifiable by name alone — no lookup needed during an incident. "Loan Disbursement" is used as the running business-domain theme, consistent with `08_TROUBLESHOOTING_PLAYBOOK.md` Entry 001.

**Status:** ✅ Finalized. Ready for use starting Sprint 1.4 (federation).

---

## Template for New Recipes

```
## Recipe XXX — [What This Builds]

**Prerequisites:**

**Steps:**
1.
2.
3.

**Verification:** (how to confirm it worked)

**Teardown:** (how to cleanly reset)
```

---

## Planned Recipes (to be filled in as parts progress)
- [ ] Install WAS ND trial via Installation Manager (VM 1 Dmgr)
- [ ] Create Deployment Manager profile (VM 1)
- [ ] Create + federate custom nodes (VM 2, VM 3)
- [ ] Build a 2-server cluster (VM 2 + VM 3)
- [ ] Install IHS + WebSphere plugin (VM 4)
- [ ] Install & configure PostgreSQL + IBM MQ (VM 5)
- [ ] Configure a JDBC datasource (pointing to VM 5)
- [ ] Full 5-VM environment teardown / reset script
