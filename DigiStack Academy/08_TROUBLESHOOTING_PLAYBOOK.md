# Troubleshooting Playbook — WebSphere ND

Format: Symptom → Diagnosis Steps → Fix → Prevention. Every issue we solve together gets logged here as a reusable runbook entry. This file also serves as the RCA archive — each entry below already follows RCA structure (see `01_MASTER_CONTEXT.md`'s Communication Practice table).

---

## Entry 001 — Nightly OutOfMemoryError During Batch (Banking, Loan Disbursement Cluster)

**Symptom:** `java.lang.OutOfMemoryError` thrown on one node every night during month-end batch processing; other nodes in the cluster unaffected.

**Diagnosis Steps:**
1. Pull a heap dump at time of failure (`wsadmin` or `kill -3` for a javacore/heap dump on IBM JVM)
2. Review verbose GC logs — check if old-gen shrinks back down after batch completes
3. If old-gen never returns to baseline → leak, not just undersized heap
4. Analyze heap dump with IBM Support Assistant / Memory Analyzer Tool — look for large retained objects (static caches, session objects)

**Fix:** Identified a static cache / un-invalidated HTTP sessions holding batch objects. Patched app-side caching logic. Interim mitigation: scheduled rolling JVM restart before nightly batch window.

**Prevention:** Add heap utilization alerting with trend analysis (not just threshold), not just point-in-time alerts. Code review checklist item: static caches must have eviction policy.

---

## Entry 002 — Dmgr Health Check Failure Misread as Outage (Banking, Loan Disbursement Cell)

**Symptom:** Automated health check flags Deployment Manager on digistack-vm1 as down (3 consecutive failures); Service Desk receives user reports assuming production impact.

**Diagnosis Steps:**
1. Confirm cluster members (Application Servers) independently — Dmgr downtime does not imply runtime downtime.
2. Clarify the actual user complaint — "console inaccessible" vs. "transactions failing" carry different severities.
3. Investigate the Dmgr process itself once customer impact is ruled out (crash / hang / resource exhaustion).
4. Restart Dmgr; verify resync with all Node Agents and current cell config state.

**Fix:** Dmgr process restarted (or equivalent once a real instance exists); config resync confirmed against both nodes.

**Prevention:** Route "Dmgr health check failed" alerts differently from "cluster/application down" alerts — different severity, different urgency, different on-call response. Conflating the two trains responders to over-escalate.

---

## Entry 003 — Non-Root Process Cannot Bind Privileged Port (Pre-Install Verification, Web Tier Prep)

**Symptom:** Non-root service account (petave) fails to bind port 80 with "Permission denied" (errno 13) during a pre-install readiness test.

**Diagnosis Steps:**
1. Confirm the account is intentionally non-privileged (least-privilege model, Day 0 policy) — this is expected OS behavior, not a fault.
2. Identify port range: 0–1023 requires root or an explicit capability grant by default on Linux.
3. Evaluate enterprise-standard options: start-as-root-then-drop-privileges (IHS's own default pattern), setcap capability grant, or firewall port redirect.

**Fix:** Applied `setcap 'cap_net_bind_service=+ep'` to the test binary — non-root bind succeeds without full root exposure.

**Prevention:** Document the chosen pattern (setcap vs. redirect vs. IHS's built-in drop-privilege behavior) in the eventual IHS install runbook (`06_LAB_RECIPES.md`, Wave 1 Install & Configuration) so it isn't rediscovered under time pressure on install day.

---

## Entry 004 — Root Filesystem Near-Full from Unmanaged Package Cache & Log Growth (Pre-Install, VM1)

**Symptom:** Disk usage alert — root filesystem (/) at 96% utilization on digistack-vm1.

**Diagnosis Steps:**
1. `df -h` to confirm which filesystem is affected and by how much.
2. `du -sh /var/log/*` and `/var/cache/*` to identify which directories are consuming the space.
3. Traced to: unmanaged dnf package cache from repeated test patch-runs, plus a verbose debug log with no rotation policy.

**Fix:** `dnf clean all` to clear the safely-redownloadable package cache; rotated/truncated the offending log; drafted a logrotate policy for WAS/IHS-relevant log paths ahead of install.

**Prevention:** Add disk-usage trend alerting (not just a hard threshold) so slow, predictable growth is caught early. Configure logrotate for all log-producing services as a standard step in every install runbook (`06_LAB_RECIPES.md`), not an afterthought discovered during an incident.

---

## Template for New Entries

```
## Entry XXX — [Short Title] ([Banking/Insurance], [System])

**Symptom:**

**Diagnosis Steps:**

**Fix:**

**Prevention:**
```
