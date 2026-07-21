# WebSphere ND 9 — Day-0 to Go-Live: A Banking Production Playbook

## Why this isn't "download installer, click next"

In a Fortune-500 bank, WebSphere is the middle tier that sits between the core banking engine (Finacle, Flexcube, in-house COBOL/CICS back-ends) and the channels — internet banking, mobile, ATM switch, NEFT/RTGS gateways. If it goes down during business hours, transactions queue up or fail, and that becomes a regulatory reportable incident (RBI/SEBI in India, FFIEC in the US, PRA in the UK). Because of that, nothing about this install is a single person's job. It is a change-managed, multi-team, audited activity, even for a "simple" install. That's the mindset for everything below.

Assumption for this playbook (stated so you can adapt): you have one clean RHEL 8 VM already provisioned (your Day-0 state), and we're building toward a realistic minimum ND topology — a **Deployment Manager (Dmgr)** node plus one **federated Managed/Custom node** — because that's the smallest setup that actually exercises what "ND" (Network Deployment, i.e. clustering) is for. Scale the same steps to 2, 4, or 8 managed nodes.

---

## 1. The cast — every team involved, and what they own

| Team | What they own in this project | Real artifact they produce |
|---|---|---|
| Enterprise/Solution Architect | Topology design, capacity sizing, HA/DR pattern, cell/cluster layout | Low-level design (LLD) document, sign-off |
| Change Management (ITIL/CAB) | Approves every change window, links CR to the install | Change Request (CR) number — nothing touches the box without one |
| Linux/Unix Server Admin | OS build, kernel tuning, filesystem layout, user/group creation | Hardened RHEL 8 baseline, OS handover checklist |
| Network Engineer | Firewall rules, DNS entries, load balancer/VIP config | Port-opening ticket, DNS records |
| Storage Engineer | LUN/volume provisioning, mount points, backup target | Mounted, permissioned filesystems |
| Security/InfoSec (CISO office) | SELinux policy sign-off, cert issuance from internal CA, hardening baseline (CIS/PCI-DSS), admin security policy | Signed certs, hardening attestation |
| Middleware Admin (WebSphere SME) | The actual WAS ND install, profiles, federation, tuning | Installed, federated, patched cell |
| DBA | JDBC provider setup for session/JMS persistence (comes right after install), schema for WAS-dependent apps | Data source configs (post-install phase) |
| Production Support / NOC / Ops | Monitoring hooks, runbooks, L1/L2 handover | SOP, monitoring dashboards |
| Project Manager / Scrum Master | Sequencing, dependency tracking across all the above | RACI, timeline |

The single most common real-world delay isn't the WebSphere install itself — it's **waiting on another team's ticket** (firewall rule, DNS entry, cert issuance). Raise those requests on Day-0, in parallel with OS work, not after.

---

## 2. Phase 0 — Demand & design (before you touch the RHEL box)

**Who:** Enterprise Architect, PM, CAB

**What happens:** Capacity inputs are gathered — expected TPS, peak concurrent sessions, EOD/EOM batch windows — because heap sizing and node count depend on it. A Low-Level Design is written covering: cell name, node names, cluster member count, whether an IBM HTTP Server (IHS) plug-in tier fronts it, and the DR pattern (active-passive vs active-active). A Change Request is raised in ServiceNow/Remedy even for a POC — this CR number is referenced in every subsequent ticket (firewall, storage, DBA).

**Real production issue:** A mid-size bank sized WAS heap based on average daily load and never modeled month-end batch concurrency. Come month-end closing, GC pauses spiked to 8+ seconds and the app server was marked unresponsive by the load balancer health check, triggering a cascading failover storm. **Root cause:** capacity planning used average, not peak, load. **Fix:** heap and node count must be sized against peak batch concurrency, not daily average — and this decision belongs in Phase 0, not discovered in production.

---

## 3. Phase 1 — RHEL 8 OS readiness (your actual Day-0 starting point)

**Who:** Linux Admin (owner), Security (sign-off), Middleware Admin (validates before install)

**Why it matters:** WebSphere is extremely sensitive to OS-level plumbing that looks unrelated at first glance — file descriptor limits, hostname resolution, temp filesystem mount options. Most "installation failed" tickets in real banking environments trace back to this phase, not to the WAS installer itself.

### 3.1 Create the non-root install user

Banks never install middleware as `root` — it's a hard security-audit finding if you do.

```bash
groupadd wasadmin
useradd -m -g wasadmin -d /home/wasadmin -s /bin/bash wasadmin
passwd wasadmin
```

### 3.2 Filesystem layout

```bash
mkdir -p /opt/IBM/WebSphere/AppServer
mkdir -p /opt/IBM/InstallationManager
mkdir -p /data/websphere/logs
mkdir -p /software/repo          # local repo copy — see note below
chown -R wasadmin:wasadmin /opt/IBM /data/websphere /software/repo
```

**Note on the repository:** in a real bank, the RHEL box has no internet access. The IBM Installation Manager repository and WAS ND installation image are pulled once from IBM Passport Advantage by a jump-box/proxy team, virus-scanned, and staged on an internal HTTP/NFS repo inside the DMZ. `/software/repo` above points at that internal mirror, not the internet.

### 3.3 Kernel and ulimits tuning

```bash
cat >> /etc/security/limits.d/wasadmin.conf << 'EOF'
wasadmin soft nofile 65536
wasadmin hard nofile 65536
wasadmin soft nproc  16384
wasadmin hard nproc  16384
EOF
```

### 3.4 Required RPMs (common gap on minimal RHEL 8 installs)

```bash
dnf install -y glibc glibc.i686 libstdc++ libstdc++.i686 ksh tar unzip
```

### 3.5 SELinux and firewalld

Banks rarely disable SELinux outright (that's an audit finding); Security instead signs off on a permissive-then-enforcing rollout, or a custom policy module.

```bash
sestatus
setenforce 0        # only for install-time validation, with Security's written sign-off
# firewalld: open the ports Network team confirmed (see Phase 2)
firewall-cmd --permanent --add-port=8879/tcp --add-port=9060/tcp --add-port=9043/tcp
firewall-cmd --reload
```

### 3.6 Hostname resolution and time sync — the two silent killers

```bash
hostnamectl set-hostname dmgr01.bank.internal
# /etc/hosts must have forward AND reverse entries for every WAS host
timedatectl set-timezone Asia/Kolkata
systemctl enable --now chronyd
chronyc sources
```

**Real production issue #1 — install fails on `/tmp`:** Installation Manager needs an executable temp directory. Banking RHEL builds frequently mount `/tmp` as `noexec` for security hardening. Installer fails with a cryptic Java exception. **Fix:** point IM at a writable, exec-enabled directory: `-DIATempDir=/data/websphere/tmp`.

**Real production issue #2 — federation fails days later:** Node federation (Phase 10) throws SSL handshake/LTPA errors that look like a certificate problem but are actually caused by clock drift greater than 5 minutes between Dmgr and node, because chronyd was never enabled during Day-0 OS build. **Fix:** validate NTP sync now, before it becomes someone else's mystery ticket next week.

---

## 4. Phase 2 — Network & firewall readiness

**Who:** Network Engineer (owner), Middleware Admin (specifies ports)

Typical port groups you must request (exact numbers are assigned per profile via a port template — always confirm against `AboutThisProfile.txt` after profile creation rather than hardcoding):

| Purpose | Typical port | Direction |
|---|---|---|
| Admin console (HTTP/HTTPS) | 9060 / 9043 | Browser → Dmgr, usually via bastion only |
| SOAP connector (federation, admin scripting) | 8879 | Node → Dmgr |
| Bootstrap/RMI | 2809 range | Node ↔ Dmgr |
| App HTTP/HTTPS | 9080 / 9443 | LB/IHS → Node |
| Node discovery | 7272/7273 | Node ↔ Dmgr |

**Real production practice:** in most banks, a firewall change ticket through ServiceNow takes 3–5 business days. Raise it on Day-0, in parallel with OS hardening, or your Phase 10 federation step will sit blocked waiting on this ticket alone. Also confirm: is the admin console reachable only via a jump/bastion host? (Almost always yes — direct browser access from a desktop to port 9060/9043 is a common audit finding.)

---

## 5. Phase 3 — Storage readiness

**Who:** Storage Engineer (owner)

Keep `WAS_HOME` (the actual product binaries and profile registry) on **local disk**, not NFS. This is a classic WebSphere gotcha: profile repository files use file locking, and NFS lock semantics are unreliable across implementations — banks have hit intermittent profile corruption from this. NFS/SAN is fine for log archival or shared config backups, never for the live profile directory.

```bash
df -h /opt/IBM /data/websphere
```

Confirm sizing: each profile (Dmgr, node) typically needs several GB for logs/temp/wstemp growth over time — undersized `/opt` partitions are a recurring "disk full, server hung" 2 a.m. page.

---

## 6. Phase 4 — DBA involvement (lighter at install time, critical soon after)

**Who:** DBA

At pure installation time, WAS ND doesn't need an external database — the Dmgr's own configuration repository is XML-file-based. DBA involvement becomes critical in the *next* phase after install: creating the Oracle/DB2 schema for session persistence and the JMS message store. Raise the DBA request now anyway, in parallel, since DB provisioning tickets also take days in a regulated bank.

---

## 7. Phase 5 — Installation Manager setup

**Who:** Middleware Admin

**Why IM, and why silent/response-file:** in an audited environment, every install must be repeatable and reviewable. Banks keep the IM and WAS response files version-controlled in Git so the exact install is reproducible on every node, and an auditor can review *what* was installed without re-running it interactively.

```bash
su - wasadmin
cd /software/repo/IM
./install -acceptLicense -installationDirectory /opt/IBM/InstallationManager -log /data/websphere/logs/im_install.log
```

**Real production issue:** on a freshly minimal-installed RHEL 8 box, IM's installer fails with a native library error. **Root cause:** missing 32-bit compatibility libraries (`glibc.i686`, `libstdc++.i686`) — common because minimal RHEL 8 ISOs don't include them by default. This is exactly why Phase 1.4 above exists.

---

## 8. Phase 6 — WebSphere ND 9 core installation (silent, response-file driven)

```bash
/opt/IBM/InstallationManager/eclipse/tools/imcl install com.ibm.websphere.ND.v90 \
  -repositories /software/repo/WAS90 \
  -installationDirectory /opt/IBM/WebSphere/AppServer \
  -sharedResourcesDirectory /opt/IBM/IMShared \
  -acceptLicense -showVerboseProgress \
  -log /data/websphere/logs/was_install.log
```

Verify:

```bash
/opt/IBM/WebSphere/AppServer/bin/versionInfo.sh
```

---

## 9. Phase 7 — Apply the latest recommended fix pack

**Who:** Middleware Admin, sign-off from Security

**Why:** every banking security audit (PCI-DSS, internal InfoSec scans with Nessus/Qualys) checks the WAS build level against known CVEs. Go-live is routinely blocked until the current recommended fix pack is applied — this is not optional polish, it's a gating requirement.

```bash
/opt/IBM/InstallationManager/eclipse/tools/imcl install com.ibm.websphere.ND.v90.fixpack.id \
  -repositories /software/repo/WAS90_FP -installationDirectory /opt/IBM/WebSphere/AppServer -acceptLicense
```

---

## 10. Phase 8 — Create the Deployment Manager profile

```bash
/opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create \
  -profileName Dmgr01 -profilePath /opt/IBM/WebSphere/AppServer/profiles/Dmgr01 \
  -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/management/dmgr \
  -nodeName dmgrNode01 -cellName bankCell01 -hostName dmgr01.bank.internal \
  -adminUserName wasadmin -adminPassword '********' -enableAdminSecurity true
```

**Real production issue:** on a shared VM already hosting another WAS instance, profile creation succeeds but the Dmgr fails to start — port conflict, because default ports collided with the existing instance. **Fix:** use `-startingPort` or a `-portsFile` to assign a non-overlapping port range, and always record the assigned ports in the handover doc (never assume the defaults).

---

## 11. Phase 9 — Start the Dmgr and verify the console

```bash
/opt/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/startManager.sh
tail -f /opt/IBM/WebSphere/AppServer/profiles/Dmgr01/logs/dmgr/SystemOut.log
```

Access `https://dmgr01.bank.internal:9043/ibm/console` — but in a real bank, only from a jump/bastion host per the network sign-off in Phase 2, never directly from a desktop.

---

## 12. Phase 10 — Node profile creation & federation

On the node host:

```bash
/opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create \
  -profileName AppSrv01 -profilePath /opt/IBM/WebSphere/AppServer/profiles/AppSrv01 \
  -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/managed \
  -nodeName appNode01 -hostName appnode01.bank.internal

/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/addNode.sh dmgr01.bank.internal 8879 \
  -username wasadmin -password '********' -conntype SOAP
```

**Real production issue #1:** `addNode.sh` times out on the SOAP connector. **Root cause:** the firewall ticket from Phase 2 hadn't actually been closed yet — a great example of why phases interlock and why you chase infra tickets early.

**Real production issue #2:** federation fails with an SSL/LTPA-token-related error that has nothing to do with certificates — it's clock skew greater than 5 minutes between the node and Dmgr, tracing straight back to the NTP step in Phase 1.6.

---

## 13. Phase 11 — Post-federation validation

```bash
/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/startNode.sh
```

Confirm in the admin console: System administration → Nodes → node shows "Synchronized." Check `SystemOut.log` on both Dmgr and node for clean startup with no `WSVR` or sync exceptions.

---

## 14. Phase 12 — Security hardening

**Who:** Security/InfoSec (owner of policy), Middleware Admin (implements)

- Enable WebSphere administrative security (never leave a production cell with security disabled — that's an immediate audit fail).
- Integrate the admin console with the bank's enterprise LDAP/Active Directory so admin logins are individually attributable — no shared `wasadmin` console logins in a regulated bank.
- Replace the self-signed default certificates with certs issued by the bank's internal CA.
- Disable weak SSL/TLS ciphers per the bank's PCI-DSS baseline.
- Enable security auditing (who changed what config, when).

---

## 15. Phase 13 — Monitoring & observability handover

**Who:** Ops/NOC, Middleware Admin

Enable PMI (Performance Monitoring Infrastructure), expose JMX/SNMP for the bank's central monitoring stack (Dynatrace/AppDynamics/ITM), and ship logs to the central SIEM/log platform (Splunk is common). Production Support cannot own the environment without dashboards and alert thresholds in place.

---

## 16. Phase 14 — DR setup & documentation handover

```bash
/opt/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/backupConfig.sh /data/websphere/backup/cell_backup.zip
```

Replicate this configuration backup to the DR site, write the runbook (start/stop sequence, common alarms, escalation matrix), and formally hand the cell to L1/L2 Production Support. This handover, not the install, is what actually closes the Change Request.

---

## 17. Go-live sign-off checklist (what CAB actually checks before closing the CR)

- [ ] OS hardening baseline signed off by Security
- [ ] All requested firewall rules confirmed open and tested
- [ ] Fix pack level matches current security scan requirement
- [ ] Admin security enabled, LDAP integrated, default certs replaced
- [ ] Node shows "Synchronized" in the admin console
- [ ] Monitoring dashboards live, alert thresholds set
- [ ] Config backup taken and replicated to DR
- [ ] Runbook handed to Production Support, L1/L2 trained

---

## 18. Production issues cheat-sheet (quick reference across every phase)

| Symptom | Root cause | Fix |
|---|---|---|
| GC pauses / hangs during month-end | Capacity planning used average, not peak, load | Re-size heap/node count against peak batch concurrency |
| IM/WAS installer fails cryptically | `/tmp` mounted `noexec` | Point installer at an exec-enabled temp dir |
| IM installer native library error | Missing `glibc.i686`/`libstdc++.i686` on minimal RHEL 8 | Install 32-bit compat libraries before install |
| Profile creation succeeds, server won't start | Port conflict with another WAS instance on shared host | Use `-portsFile`/`-startingPort`, document assigned ports |
| `addNode.sh` times out | Firewall rule for SOAP port not actually open yet | Confirm with Network team before retrying, don't assume the ticket closed |
| Federation fails with SSL/LTPA errors | Clock skew >5 min between node and Dmgr | Enable and verify chronyd/NTP sync on both hosts |
| Disk-full page at 2 a.m. | Undersized `/opt` partition, log/temp growth unaccounted for | Size storage for growth, not just Day-0 footprint |
| Profile registry intermittently corrupts | `WAS_HOME`/profile directory placed on NFS | Keep profile registry on local disk only |

---

## 19. Hands-on lab — run this end-to-end on your RHEL 8 box

A condensed sequence to actually execute, given your starting state is a clean RHEL 8 install:

1. Create `wasadmin` user and group, set ulimits (§3.1, §3.3)
2. Install required RPMs, confirm with `rpm -q glibc.i686 libstdc++.i686` (§3.4)
3. Set hostname, verify `/etc/hosts`, enable chronyd (§3.6)
4. Confirm SELinux/firewalld state with Security/Network sign-off (§3.5, §4)
5. Install IBM Installation Manager silently (§7)
6. Install WebSphere ND 9 silently, verify with `versionInfo.sh` (§8)
7. Apply the latest fix pack (§9)
8. Create the Dmgr profile, start it, reach the console via bastion (§10–11)
9. Create a node profile on the second host, federate it (§12)
10. Confirm "Synchronized" in the console, enable admin security (§13–14)

Work through it in this order — skipping ahead (e.g. installing WAS before OS prereqs are confirmed) is exactly how the cheat-sheet issues above get reintroduced.
