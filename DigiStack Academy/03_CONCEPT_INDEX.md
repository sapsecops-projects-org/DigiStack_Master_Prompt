# Concept Index — WebSphere ND Mastery

Mark `[x]` when a concept has been taught AND practiced hands-on. Organized by Part (see `02_CURRICULUM_PLAN.md`).

## Part 1 — Core Administration Fundamentals

### Wave 1 — Build the Environment

#### Foundations
- [x] Linux fundamentals (RHEL) for admins — filesystem hierarchy (FHS), permissions/ownership/SELinux flag, process & service management (`ps`, `systemctl`, signals), package management (DNF/RPM), log navigation (`journalctl`, `tail`/`grep`/`less`), disk/storage management (`df`/`du`/`lsblk`), environment variables/`PATH`/`JAVA_HOME` (Days 1–3)
- [ ] Networking: TCP/IP, DNS, load balancers, firewalls
- [ ] SSL/TLS basics (certs, keystores, truststores)
- [ ] Java EE literacy: JVM, servlets, EJB, JDBC, JNDI, JMS (concepts only)

#### Core ND Architecture
- [x] Cell / Node / Node Agent / Deployment Manager / Cluster mental model
- [ ] Profiles: Dmgr profile, custom profile, standalone profile
- [ ] Federating a node to a Dmgr
- [ ] Building a 2-node cluster (hands-on lab)
- [ ] Workload management (WLM) & core groups (HA fundamentals)

#### Install & Configuration
- [ ] IBM Installation Manager
- [ ] Silent installation
- [ ] IHS (IBM HTTP Server) + WebSphere plugin
- [ ] Virtual hosts

### Wave 2 — Operate & Harden

#### App Deployment & Admin
- [ ] EAR/WAR deployment (console + wsadmin)
- [ ] JDBC data sources & connection pools
- [ ] JMS integration with IBM MQ
- [ ] Class loading (parent-first vs parent-last)
- [ ] Session management

#### Security
- [ ] Global security setup
- [ ] LDAP integration
- [ ] SSL certificate management
- [ ] J2C authentication aliases
- [ ] Admin roles

#### Integration
- [ ] IBM MQ admin basics
- [ ] DB2/Oracle datasource tuning
- [ ] Batch scheduling integration

#### Automation Basics
- [ ] wsadmin scripting (Jython) fundamentals
- [ ] Basic deployment scripts

## Part 2 — Performance Tuning
- [ ] Heap sizing strategy
- [ ] GC algorithm selection & tuning (verbose GC log reading)
- [ ] Thread pool sizing
- [ ] Connection pool sizing
- [ ] Capacity planning for peak load (month-end, seasonal spikes)

## Part 3 — Real-Time Troubleshooting
- [x] OutOfMemoryError diagnosis (intro example)
- [ ] Thread dump analysis (hung threads, deadlocks)
- [ ] Heap dump analysis (leaks vs. sizing)
- [ ] Connection pool exhaustion patterns
- [ ] Symptom-first drill practice (ongoing)
- [ ] Multi-day incident chain simulations (ongoing)

## Part 4 — Disaster Recovery (Banking, Real-Time)
- [ ] RTO/RPO concepts in a banking context
- [ ] Backup & restore procedures (config + data)
- [ ] Cross-site failover design
- [ ] Core group bridging across sites
- [ ] DR drill simulation (real scenario walkthrough)

## Part 5 — WebSphere Migration
- [ ] Version upgrade planning (e.g., 8.5.5 → 9.0)
- [ ] WASPreUpgrade / WASPostUpgrade tools
- [ ] Profile & cell migration
- [ ] Traditional-to-Liberty migration considerations
- [ ] Downtime minimization & rollback planning

## Part 6 — Observability (Banking, Real-Time)
- [ ] PMI (Performance Monitoring Infrastructure)
- [ ] APM tooling concepts (Dynatrace/AppDynamics/ITCAM-style)
- [ ] Log aggregation & correlation
- [ ] Dashboards & alerting thresholds
- [ ] SLA/SLO monitoring for transaction systems

## Part 7 — Incident Management (Real Incidents & Solutions)
- [ ] ITIL incident/problem/change process overview
- [ ] Severity classification (Sev1/2/3)
- [ ] Major incident war-room roles & communication
- [ ] Postmortem / RCA writeups
- [ ] Real banking incident case study #1
- [ ] Real banking incident case study #2 (ongoing library)

## Part 8 — DevSecOps for WebSphere Admin
- [ ] CI/CD pipeline concepts for WAS deployments
- [ ] Infrastructure as Code (Ansible) for WAS provisioning
- [ ] wsadmin integrated into pipelines
- [ ] Security/vulnerability scanning of deployables
- [ ] Secrets management
- [ ] Compliance-as-code (PCI-DSS-style controls)

## Architect Track (cross-cutting — see `05_ARCHITECT_TRACK.md`)
- [ ] Topology design (single-cell vs. multi-cell) & DMZ placement
- [ ] Licensing architecture (PVU-based)
- [ ] Enterprise security architecture (SSO/SAML/Kerberos/OAuth)
- [ ] Capacity planning models (SLA → JVM/heap/thread math)
- [ ] Caching architecture decisions (Dynacache vs. Redis vs. eXtreme Scale)
- [ ] Blast radius / bulkhead design & escalation tiers (L1/L2/L3)
- [ ] Active-active vs. active-passive DR trade-offs
- [ ] RPO/RTO negotiation & multi-region regulatory constraints
- [ ] Migration risk assessment & rollback architecture
- [ ] APM tool governance & SLA/SLO definition
- [ ] Major incident commander role & RCA quality
- [ ] CAB participation & change governance
- [ ] Pipeline architecture ownership & compliance-as-code strategy
- [ ] Secrets/key management architecture
- [ ] Leadership: review boards, stakeholder presentation, mentoring runbooks

## Part 9 — Capstone: Resilience
- [ ] Load- the 5-VM lab under concurrency
- [ ] Diagnose bottlenecks (thread/JDBC/JVM/MQ)
- [ ] Inject failures; validate failover, HAManager, session replication

## Part 10 — Capstone: DR & Migration
- [ ] Multi-site DR drill (replication, failback)
- [ ] ND→ND version migration planning
- [ ] Traditional→Liberty migration planning

## Extension — Advanced Architect Topics (Optional / Pullable)
- [ ] WAS Traditional vs. Liberty + containerization (Docker/OpenShift/Kubernetes)
- [ ] License compliance (PVU, ILMT, sub-capacity reporting)
- [ ] IBM Support engagement (PMR process, MustGather packages)
- [ ] Regulatory & compliance context (audit trails, segregation of duties, PCI-DSS)
- [ ] Advanced diagnostics (TMDA for thread dumps, Eclipse MAT for heap dumps)
- [ ] Multi-cell & cross-cell architecture, federated SSO
- [ ] Shared filesystem strategy (NFS vs. per-node)
- [ ] Capacity & HA sizing exercise + written architecture proposal + mock defense

## Operational Governance & Career Simulation (cross-cutting)
- [x] Company induction: HR onboarding, IT account setup (SR-000001), security training, environment access (SR-000002) (Day 0) — username locked to `petave`
- [ ] Probation Phase 1 complete (Days 1–30)
- [ ] Probation Phase 2 complete (Days 31–60)
- [ ] Probation Phase 3 complete (Days 61–90)
- [ ] Probation Review / confirmation (Day 90)
- [ ] First CAB submission (co-authored)
- [ ] First solo CAB submission
- [ ] First monthly patching cycle
- [ ] First quarterly DR drill
- [ ] First on-call shadow shift
- [ ] First solo on-call rotation week

## Final Real-World Assessment
- [ ] Locked until all parts above are complete — see `12_FINAL_ASSESSMENT.md`
