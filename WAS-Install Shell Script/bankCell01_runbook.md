# bankCell01 — Production Support Runbook

Handover from: Middleware Build Team &nbsp;&nbsp;|&nbsp;&nbsp; Handover to: Production Support / L1-L2
Reference CR: ______________

## 1. Environment overview

- Cell: `bankCell01` &nbsp; Dmgr host: `dmgr01.bank.internal`
- Retail banking cluster: 8 members &nbsp; | &nbsp; RTGS/NEFT gateway cluster: 3 members (isolated, separate thread pools)
- Profile locations: `/data/websphere/profiles/` (never under `AppServer/profiles`)
- Response files / build artifacts (Git): ______________

## 2. Start / stop sequence

**Start:** Dmgr → node agents → application servers
**Stop:** application servers → node agents → Dmgr (reverse order — never stop the Dmgr first)

```bash
/data/websphere/profiles/Dmgr01/bin/startManager.sh
/data/websphere/profiles/AppSrv01/bin/startNode.sh
# then start individual servers/cluster members via the console or startServer.sh
```

## 3. Environment-specific quirks — read this before touching anything

| Quirk | What to do about it |
|---|---|
| Ulimits set via `/etc/security/limits.d` don't always apply to non-interactive launches (cron, systemd, automation SSH) | After any change to *how* a server is started, verify `/proc/<pid>/limits` directly — don't trust the config file alone |
| Firewall tickets used planned port values; real ports are auto-assigned per profile | `AboutThisProfile.txt` in each profile directory is the source of truth for actual ports, not the original ticket |
| Federation replaces node config, it does not merge it | Never configure anything meaningful on a node profile before `addNode.sh` |
| Console "Synchronized" status reflects the *last poll*, not real-time state | For urgent config pushes, run `syncNode.sh` manually rather than waiting on the interval |
| VM guest clock can drift if the hypervisor's time-sync fights chronyd | Confirm only one time authority is active per host |
| A local break-glass admin account is intentionally preserved alongside LDAP | Location: ______________ — never remove it, it's the only path in if LDAP itself is down |
| Personal certs and trust stores are separate; rotating one without the other breaks trust | Always update trust stores on Dmgr *and* every node before/with any personal cert rotation |
| This cell uses HPEL logging, not classic text logs by default | Confirm HPEL's text-log compatibility is enabled before assuming a generic log forwarder is working |
| APM agent coverage is set per-server; manual multi-server rollouts can silently miss one | Verify coverage from the APM tool's own inventory after any change, not by console click-through |
| `backupConfig.sh` does NOT capture transaction logs or runtime data | Tranlog protection relies on separate, synchronous storage replication — confirmed with Storage, not this backup |

## 4. Alert thresholds (see Phase 13 monitoring setup for detail)

- Thread pool utilization sustained near 100%
- Heap used % post-GC trending upward
- Connection pool wait time / exhaustion events
- Tranlog volume free space and write latency
- Node/server down events

## 5. Escalation matrix

| Area | Contact | Notes |
|---|---|---|
| Middleware / WebSphere | ______________ | |
| Network | ______________ | |
| Storage | ______________ | |
| DBA | ______________ | |
| Security | ______________ | |

## 6. Key locations

- Config backups: `/data/websphere/backup`
- Response files / install artifacts: ______________ (Git)
- This runbook (version-controlled): ______________

## 7. DR / restore drill log

| Date | Performed by | Result | Notes |
|---|---|---|---|
| | | | |

## 8. Sign-off

| Role | Name | Date |
|---|---|---|
| Middleware admin (outgoing) | | |
| Production Support lead (incoming) | | |
| Change Manager | | |
