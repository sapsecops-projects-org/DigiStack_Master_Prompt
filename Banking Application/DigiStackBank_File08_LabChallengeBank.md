# DigiStack Bank — File 08: Lab Challenge Bank
**Version:** 2.0 | **Last Updated:** July 2026
**Purpose:** Tiered hands-on challenges across 19 domains, plus the Production Simulation
Day template. Use these to go beyond the guided sprint labs and build real muscle memory.

---

## TIER DEFINITIONS

| Tier | Description |
|------|-------------|
| **Beginner** | Follow documented steps, single component, no troubleshooting required |
| **Intermediate** | Multi-step task, minor troubleshooting, some steps not explicitly documented |
| **Advanced** | Multi-component task, real troubleshooting required, time-boxed |
| **Expert** | Production-incident style, ambiguous symptoms, must diagnose root cause under time pressure |

---

## DOMAIN 1 — WAS ND CELL / TOPOLOGY

- **Beginner:** Start DMGR, Node Agent, and both cluster members from a cold stop. Verify all show green in Admin Console.
- **Intermediate:** Federate a new (simulated) node into the cell without referring to notes.
- **Advanced:** DMGR is down. Node Agents and Application Servers are still running. Diagnose whether the app is still serving traffic and explain why.
- **Expert:** A node shows "unsynchronized" in Admin Console. Diagnose the cause and force a full resync without restarting the node.

---

## DOMAIN 2 — APPLICATION SERVER CONFIGURATION

- **Beginner:** Create a new Application Server from the existing template.
- **Intermediate:** Change JVM heap settings on one cluster member only (not both) and verify via Admin Console.
- **Advanced:** One cluster member has different JVM arguments than the other due to manual drift. Detect the drift and reconcile it.
- **Expert:** AppServer2 fails to start with a port conflict. Diagnose the conflicting port and resolve without restarting AppServer1.

---

## DOMAIN 3 — IHS + PLUGIN

- **Beginner:** Restart IHS and verify the app is still reachable.
- **Intermediate:** Regenerate plugin-cfg.xml after adding a change, and propagate it to IHS manually.
- **Advanced:** IHS is running but all requests return 503. Diagnose whether the issue is IHS, plugin, or WAS-side.
- **Expert:** Users report intermittent failures only during high load. Use the plugin log to determine if it's a load balancing, timeout, or backend issue.

---

## DOMAIN 4 — CLUSTERING + SESSION MANAGEMENT

- **Beginner:** Verify session replication is active by checking DRS status.
- **Intermediate:** Kill a cluster member mid-session and confirm the user is not logged out.
- **Advanced:** Sessions are not replicating — users get logged out on failover. Diagnose the M2M configuration issue.
- **Expert:** Under sustained load, session replication causes a performance drop. Propose and implement a tuning fix.

---

## DOMAIN 5 — JDBC / DATASOURCE

- **Beginner:** Test the DataSource connection from Admin Console.
- **Intermediate:** Change the max connection pool size and verify the change is live without restart (if possible) or explain why a restart is needed.
- **Advanced:** The application throws "ConnectionWaitTimeoutException" under load. Diagnose and tune the connection pool.
- **Expert:** Connections are leaking — pool slowly exhausts over hours. Use PMI and application logs to find the leaking code path.

---

## DOMAIN 6 — CLASS LOADING

- **Beginner:** View the class loader hierarchy for DigiStackBank in the Class Loader Viewer.
- **Intermediate:** Change class loader policy from PARENT_FIRST to PARENT_LAST and observe the effect.
- **Advanced:** Deploying an updated library causes a ClassCastException. Diagnose whether it's a class loader isolation issue.
- **Expert:** Two applications on the same server conflict due to shared library versions. Resolve without affecting either application's functionality.

---

## DOMAIN 7 — SECURITY (GLOBAL SECURITY / LTPA / SSL)

- **Beginner:** Enable Global Security and verify login is now required.
- **Intermediate:** Configure a new user in the file-based registry and map them to the EMPLOYEE role.
- **Advanced:** LTPA tokens are expiring faster than expected, causing frequent forced logouts. Diagnose the LTPA timeout configuration.
- **Expert:** SSL handshake fails between IHS and WAS after a certificate rotation. Diagnose and fix without full cell restart.

---

## DOMAIN 8 — IBM MQ / MESSAGING

- **Beginner:** Use runmqsc to check the depth of TRANSFER.REQUEST.QUEUE.
- **Intermediate:** Simulate a poison message and observe it land in the DLQ.
- **Advanced:** Queue depth is rising and MDB isn't consuming messages. Diagnose whether it's a Listener Port, channel, or MDB code issue.
- **Expert:** A production-style incident: MQ Queue Manager restarted unexpectedly, in-flight transactions are stuck. Diagnose and recover without data loss.

---

## DOMAIN 9 — MDB / JMS INTEGRATION

- **Beginner:** Verify the MDB is deployed and its Listener Port is running.
- **Intermediate:** Stop the Listener Port, send a transfer, observe queue backlog, restart Listener Port, observe drain.
- **Advanced:** MDB is consuming messages but notifications aren't appearing. Diagnose whether it's a JMS, MDB code, or database issue.
- **Expert:** Under load, MDB processing falls behind message production. Tune concurrency/Listener Port settings to catch up.

---

## DOMAIN 10 — PERFORMANCE TUNING (THREADS / HEAP / GC)

- **Beginner:** Enable verbose GC and locate the GC log file.
- **Intermediate:** Run a load test and observe thread pool utilization in TPV.
- **Advanced:** Response times degrade under sustained load, but CPU is low. Diagnose whether it's thread pool starvation or something else.
- **Expert:** Application experiences periodic multi-second pauses. Analyze GC logs to determine if it's a GC pause issue and propose a policy change.

---

## DOMAIN 11 — CACHING

- **Beginner:** Enable Dynamic Cache Service on the cluster.
- **Intermediate:** Write a cachespec.xml entry for a reporting page and verify cache hits in PMI.
- **Advanced:** Cached data is stale after an update. Diagnose the cache invalidation gap and fix it.
- **Expert:** Cache hit ratio is low despite caching being enabled. Diagnose why (e.g., cache key granularity issue).

---

## DOMAIN 12 — LOGGING / DIAGNOSTICS

- **Beginner:** Locate and read SystemOut.log for the last application startup.
- **Intermediate:** Enable HPEL and query it for ERROR-level entries in the last hour.
- **Advanced:** An error occurs intermittently with no clear log entry. Enable targeted diagnostic trace to capture it.
- **Expert:** Use FFDC logs alone (no application logs available) to determine the root cause of an NPE in production code.

---

## DOMAIN 13 — DEPLOYMENT / APPLICATION MANAGEMENT

- **Beginner:** Deploy a new EAR version via Admin Console.
- **Intermediate:** Deploy the same EAR via wsadmin only, with no Admin Console access.
- **Advanced:** A deployment appears to succeed but the old version is still being served. Diagnose (cache, sync, or class loader issue).
- **Expert:** Perform a zero-downtime rolling deployment across the two-member cluster without dropping a single request.

---

## DOMAIN 14 — BACKUP / RESTORE / DR

- **Beginner:** Run backupConfig.sh and verify the backup file exists.
- **Intermediate:** Restore a WAS ND profile from backup into a test profile.
- **Advanced:** Simulate DMGR VM loss. Rebuild DMGR from backup and re-federate nodes.
- **Expert:** Full DR drill — MySQL, WAS ND, and MQ all fail simultaneously. Execute the complete recovery runbook and measure actual RTO/RPO.

---

## DOMAIN 15 — AUTOMATION (WSADMIN / ANSIBLE)

- **Beginner:** Run an existing wsadmin script to check server status.
- **Intermediate:** Write a new wsadmin script to create a JMS queue.
- **Advanced:** Write an Ansible playbook that deploys a new EAR version and verifies it started successfully.
- **Expert:** Build a single Ansible playbook that performs a complete WAS ND environment health check across all 5 VMs and reports pass/fail per component.

---

## DOMAIN 16 — INCIDENT RESPONSE

- **Beginner:** Given a stopped AppServer, identify it's down and restart it.
- **Intermediate:** Given a slow application, use PMI to identify whether it's DB, thread pool, or GC related.
- **Advanced:** Given an OutOfMemoryError in logs, generate and analyze a heap dump to find the leak source.
- **Expert:** Full simulated production incident: application is unresponsive, users are complaining, multiple possible causes exist. Diagnose from symptoms alone, following an incident response process, and document root cause + resolution + prevention.

---

## DOMAIN 17 — DATABASE ADMINISTRATION

- **Beginner:** Connect to MySQL and run basic SELECT queries against DSB_ACCOUNTS.
- **Intermediate:** Write and apply a new versioned migration script (e.g., V1.3.0) adding a column.
- **Advanced:** A query is running slowly in production. Use EXPLAIN to diagnose and add an appropriate index.
- **Expert:** Simulate replication lag in a MySQL DR setup and diagnose the cause and impact on the application.

---

## DOMAIN 18 — OBSERVABILITY

- **Beginner:** View current PMI statistics for the cluster in TPV.
- **Intermediate:** Export PMI data and build a simple trend chart of thread pool usage over an hour.
- **Advanced:** Establish a performance baseline for DigiStack Bank and detect a 20% regression after a code change.
- **Expert:** Build a lightweight observability dashboard combining WAS PMI, MQ queue depth, and MySQL connection stats into one view.

---

## DOMAIN 19 — SECURITY TESTING / DEVSECOPS

- **Beginner:** Run a basic security test case from File 07 (Security Hardening module).
- **Intermediate:** Write an automated test that verifies unauthenticated access is blocked.
- **Advanced:** Integrate a security test suite into the Maven build so it runs on every `mvn package`.
- **Expert:** Design and execute a basic penetration-style test against DigiStack Bank's authentication flow (e.g., session fixation, brute-force protection) and document findings.

---

## PRODUCTION SIMULATION DAY — TEMPLATE

*(Used on Days 15, 30, 45, 60, 75, 90, 105, 120, 135)*

### Structure

```
1. SCENARIO BRIEFING (5 min)
   - Read the scenario. No prior notes allowed except File 02 (Concept Index) for reference.

2. INVESTIGATION (30–45 min)
   - Use only Admin Console, wsadmin, logs, and command line.
   - Document every step taken and every command run.

3. RESOLUTION (15–30 min)
   - Implement the fix.
   - Verify the fix resolves the issue end-to-end.

4. DOCUMENTATION (15 min)
   - Write a short incident report:
     - Symptom
     - Root Cause
     - Resolution Steps
     - Prevention Recommendation

5. DEBRIEF
   - Compare your approach against the "expected" resolution path (ask Claude to generate one).
   - Log any gaps in File 02 Concept Index for revision.
```

### Sample Scenario Bank (rotate through these across simulation days)

1. **App won't start after deployment** — class loader conflict introduced by a shared library update.
2. **Users report random logouts** — session replication misconfigured after a cluster change.
3. **Slow transfers reported by customers** — connection pool exhaustion under load.
4. **MQ messages piling up** — MDB Listener Port stopped after a server restart.
5. **SSL certificate expired** — IHS to WAS handshake failing in production.
6. **One cluster member silently drops out of rotation** — plugin-cfg.xml not regenerated after a change.
7. **Nightly report job never completes** — WAS Scheduler task stuck or misconfigured.
8. **Customer data mismatch after DR failover** — MySQL replication lag not accounted for.
9. **Admin Console won't load** — DMGR resource exhaustion or JVM heap issue.

---

## HOW TO SELECT CHALLENGES DURING WEEKLY LAB (DAY 7)

- Pick 1 domain relevant to that week's sprints
- Attempt Beginner → Intermediate → Advanced in sequence
- Attempt Expert only if time remains and prior tiers were solid
- Log results informally — formal test cases live in File 07

---

*DigiStack Bank — File 08: Lab Challenge Bank v2.0 | July 2026*
*19 Domains | 4 Tiers per Domain | 9 Production Simulation Scenarios*
