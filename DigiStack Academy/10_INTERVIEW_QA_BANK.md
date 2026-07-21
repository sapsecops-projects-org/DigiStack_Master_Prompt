# Interview Q&A Bank — WebSphere ND

Built up phase by phase, not crammed at the end. Each entry: question → strong answer → what a weak answer misses.

---

## Part 1 — Core ND Architecture (Core Administration Fundamentals)

**Q: What is the difference between a Cell and a Cluster?**
A: A Cell is the entire administrative domain — every node and server managed under one Deployment Manager. A Cluster is a subset within (or across) that cell: a group of application server instances configured identically to run the same application for redundancy and load distribution.
*Weak answer misses:* Treating them as synonyms, or not mentioning that a cluster's members can span multiple nodes.

**Q: What happens if the Deployment Manager goes down — does the cluster stop serving requests?**
A: No. The Dmgr is for administration/config push, not runtime traffic. Node Agents and running Application Servers continue serving requests independently. You lose the ability to make config changes or see centralized status until Dmgr is back, but existing traffic keeps flowing.
*Weak answer misses:* Assuming Dmgr downtime causes an outage — this is a common misconception and a good interview differentiator.

**Q: Why would a bank use a Cluster instead of a single Application Server?**
A: Redundancy (one server can fail without an outage) and horizontal scaling for load, especially critical during peak transaction windows or month-end batch when a single teller can't handle volume.
*Weak answer misses:* Only mentioning "high availability" without connecting it to a concrete banking load scenario.

**Q: A monitoring alert says the Deployment Manager is down. Is this a production outage?**
A: Not by itself. The Dmgr handles administration and config push, not runtime traffic — Node Agents and running Application Servers keep serving requests independently once they have their last-known-good config. Confirm actual cluster/application health separately before assuming customer impact, and classify severity from that, not from the Dmgr alert alone.
*Weak answer misses:* Treating any "Dmgr down" alert as automatic Sev1, or not knowing runtime and administration are architecturally decoupled in WebSphere ND.

**Q: Why does WebSphere separate the Deployment Manager from the Application Servers instead of one process managing everything?**
A: A blast-radius trade-off. Centralizing config management means changes push consistently and auditably across every node from one place — but it makes the Dmgr a single point of *administrative* failure. Decoupling runtime from administration means that failure mode doesn't take down live traffic, which is the higher priority to protect in production banking.
*Weak answer misses:* Describing only what the Dmgr does, without naming the trade-off the split is designed around.

---

## Part 1 — Foundations (Linux fundamentals for admins)

**Q: Why would binding to port 80 fail for a non-root process on Linux, and what are the standard ways to fix it in an enterprise setting?**
A: Ports 0–1023 are privileged by default — only root, or a process explicitly granted the `CAP_NET_BIND_SERVICE` capability, can bind them. Standard enterprise fixes: start as root and drop privileges immediately after binding (what IHS does natively), grant the specific capability via `setcap` instead of running as root at all, or front the service with a firewall redirect from port 80 to an unprivileged high port.
*Weak answer misses:* Suggesting "just run it as root" as the fix without acknowledging the security trade-off, or not knowing `setcap` exists as a least-privilege alternative.

**Q: What's the difference between `systemctl stop` and `systemctl disable`, and why does mixing them up cause real incidents?**
A: `stop` affects the *current* running state only — the service goes down now, but will start again on next boot if it's still enabled. `disable` affects *boot-time* behavior only — it won't auto-start next boot, but doesn't touch whatever's currently running. A real incident pattern: someone stops a service to troubleshoot, forgets to also disable it, and it silently comes back after a patch-cycle reboot with the same unresolved issue.
*Weak answer misses:* Treating the two as interchangeable, or not recognizing this exact confusion as a real, recurring on-call pattern.

**Q: A disk-usage alert fires at 96% on a production box. What's your diagnostic sequence?**
A: Start broad with `df -h` to confirm which filesystem and how severe, then narrow with `du -sh` on likely directories (`/var/log`, `/var/cache`, application data/work directories) to find the actual consumer before touching anything. Fix the immediate space issue, then address root cause — usually missing log rotation or an unmanaged cache — so it doesn't recur.
*Weak answer misses:* Deleting files indiscriminately to "free up space" without first identifying what's safe to remove, or fixing the symptom without addressing why nothing was cleaning up automatically.

**Q: Why is disk-full considered one of the most preventable production incident categories?**
A: Unlike a sudden crash or a network partition, disk growth is almost always gradual and predictable — it's a trend, not a surprise. It becomes an incident specifically because nobody set up log rotation, cache cleanup, or trend-based alerting ahead of time, not because it was unforeseeable. Prevention here is process, not luck.
*Weak answer misses:* Treating it as an unpredictable failure mode rather than a monitoring/process gap.

---

## Template for New Entries

```
**Q:**
A:
*Weak answer misses:*
```
