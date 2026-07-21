# WebSphere/MQ Enterprise Admin — Day-Wise & Sprint-Wise Study Plan (GAP-FILLED, COMPLETE)

**Pace:** 1–2 hrs/day | **Sprint length:** 1 week (5 study days + 1 lab day + 1 rest/buffer day)
**Revised target duration:** ~58–59 weeks (≈13–14 months) — extended from the original ~48–50 weeks because several sprints (MQ, IHS, Load Balancers, Troubleshooting, Career/Architecture) were compressed too tightly to fit every topic in the master list without dropping items.

**Weekly rhythm (unchanged):**
- Day 1–4: Learn 2–3 topics/day (theory + short notes)
- Day 5: Hands-on lab tying the week's topics together
- Day 6: Review + mini-documentation (SOP/notes)
- Day 7: Rest / buffer / catch-up

Every sprint still applies the **Standard Module Structure** lightly (Business Purpose, Hands-on Lab, Security angle, Troubleshooting angle, 1–2 Interview Questions) even where not spelled out day-by-day.

---

## 🔧 What changed vs. the original plan (read this first)

1. **Sprint 2** — added Documentation Standards, Meeting Etiquette, Technical Presentation Skills (were in the topic list but not scheduled).
2. **Sprint 26** — added Health Check Automation, Deployment Automation, Reporting Automation explicitly.
3. **Sprints 32–34a** — Troubleshooting expanded: the master list calls for "150+ Production Scenarios," but only ~18 example scenarios were ever named. Added a bridging sprint that uses the Phase 29 incident *categories* to multiply practice scenarios instead of just naming 18 and moving on.
4. **Sprint 42 (MQ)** split into **two sprints (42a/42b)** — the original single week silently dropped MQ Monitoring, Performance Tuning, Troubleshooting, Automation, and Production Scenarios.
5. **Sprint 43 (IHS)** split into **two sprints (43a/43b)** — added Access Control, Log Rotation detail, Static/Dynamic Content, Worker Processes/Thread Config, Monitoring, Troubleshooting, Automation, Production Scenarios.
6. **Sprint 44 (Load Balancers)** split into **two sprints (44a/44b)** — added full Citrix ADC depth and explicit Monitoring/Troubleshooting per-product.
7. **New Sprint (46.5)** — Phase 16.5 "Enterprise Solution Architecture" was in the master list but had **zero scheduled days anywhere** in the original plan. Added.
8. **Sprint 46** — expanded to explicitly include Capacity Planning, Sizing, Monitoring Design, Automation Design (Phase 20.0) and the "Production Architecture" sub-list (DMZ, multi-tier, active-active/passive DC, multi-cluster, scaling, session replication, failover, capacity, performance design).
9. **Sprint 52 (Capstone)** — added Mock Technical Interviews and HR Interviews explicitly (were named in Phase 16.0 but missing from the day-wise text).
10. **Sprints 48–49** — added explicit instruction to document Business Impact and Customer Communication for each incident (both required by the master list's "Each incident should include" spec, both missing from the original day text).
11. **Versions 22–23 and 27–28** — the master topic list itself states these were *not included in the source material*. I have not invented content for them — they're listed below as explicit placeholders so you know they're an open gap in the source, not something skipped by this plan.
12. Numbering below keeps original Sprint 1–41 as-is (they already covered their topics fully), then diverges from Sprint 42 onward. A renumbered "linear" sprint count is given in the final summary table.

---

## MONTH 1 — Foundations

### Sprint 1 — Phase 0.0: Enterprise IT Foundation
- Day 1: Enterprise Org, Enterprise IT Overview, Banking IT Structure
- Day 2: Roles & Responsibilities (Infra, Middleware, Linux, DBA, Network, Security teams)
- Day 3: Roles & Responsibilities (Storage, DevOps, App, Release, Monitoring, NOC, SOC)
- Day 4: Enterprise Environments (Dev→SIT→UAT→Pre-Prod→Prod→DR→Sandbox)
- Day 5 (Lab): Map out a fictional bank's team structure + environment flow diagram
- Day 6: SDLC, Agile/Scrum/Sprint, Release Cycle — notes + review
- Day 7: Buffer

### Sprint 2 — Phase 0.0 (cont'd) + Phase 0.5: Communication Skills 🔧
- Day 1: ITIL Foundation (Incident, Problem, Change, Service Request, Major Incident, RCA)
- Day 2: Enterprise Tools (ServiceNow, Jira, Confluence, Teams, Outlook)
- Day 3: Documentation types (SOP, Runbook, KB, RCA, Change Plan) + **Documentation Standards**
- Day 4: Email Etiquette, Production Communication, Shift Handover
- Day 5 (Lab): Write a sample incident email + shift handover note + one slide of a technical presentation
- Day 6: Incident Comms, Executive Updates, CAB Comms, RCA Writing, **Meeting Etiquette**, **Technical Presentation Skills** — review
- Day 7: Buffer

### Sprint 3 — Phase 1.0: Linux Foundation (Part 1)
- Day 1: Installation, Boot Process, File System, Directory Structure
- Day 2: Users, Groups, Permissions, ACL
- Day 3: Process Management, Services
- Day 4: SSH, SCP, rsync, Cron
- Day 5 (Lab): Set up SSH keys, cron jobs, and basic user/permission scenarios on a VM
- Day 6: Shell basics, Networking commands, Firewall, SELinux, Package Mgmt review
- Day 7: Buffer

### Sprint 4 — Phase 1.0 (Part 2) + Bash Scripting
- Day 1: Networking commands deep dive (ip, netstat basics), Firewall (firewalld/iptables)
- Day 2: SELinux modes and basics, Package Management (yum/dnf/apt)
- Day 3: Bash scripting fundamentals (variables, loops, conditionals)
- Day 4: Bash scripting — functions, scripts for automation
- Day 5 (Lab): Write a health-check bash script (disk, memory, service status)
- Day 6: Review all Phase 1.0 topics; document as a Linux Basics runbook
- Day 7: Buffer

---

## MONTH 2 — Linux Advanced & Networking

### Sprint 5 — Phase 1.5: Enterprise Linux (Part 1)
- Day 1: LVM, Multipath
- Day 2: NFS, CIFS, Mount Points, fstab
- Day 3: systemd, journald
- Day 4: CPU/Memory Monitoring basics
- Day 5 (Lab): Create/extend an LVM volume; mount an NFS share
- Day 6: Disk/IO Monitoring, Performance Monitoring — review
- Day 7: Buffer

### Sprint 6 — Phase 1.5 (Part 2)
- Day 1: Disk Expansion, Swap
- Day 2: Huge Pages, Kernel Parameters
- Day 3: Log Rotation
- Day 4: Troubleshooting methodology for Linux
- Day 5 (Lab): Simulate disk-full scenario and resolve it end-to-end
- Day 6: Review Phase 1.5; write Linux Advanced SOP
- Day 7: Buffer

### Sprint 7 — Phase 1.8: Linux Performance & Diagnostics
- Day 1: top, htop, vmstat, mpstat
- Day 2: sar, iostat, pidstat, free
- Day 3: dmesg, journalctl, strace, lsof
- Day 4: perf, sysctl, sysstat
- Day 5 (Lab): Diagnose a simulated high-CPU/high-IO process using these tools
- Day 6: Process/Memory/CPU/Network Analysis — consolidate into a diagnostics cheat-sheet
- Day 7: Buffer

### Sprint 8 — Phase 2.0: Networking Foundation
- Day 1: OSI model, TCP/IP
- Day 2: HTTP, HTTPS
- Day 3: DNS, Ports
- Day 4: SSL Basics, Routing Basics
- Day 5 (Lab): Trace a full HTTP request path on paper/diagram
- Day 6: Review; write a "networking basics" reference doc
- Day 7: Buffer

---

## MONTH 3 — Enterprise Networking & Java

### Sprint 9 — Phase 2.5: Enterprise Networking (Part 1)
- Day 1: TCP Handshake, SSL Handshake
- Day 2: HTTP Flow, Packet Journey
- Day 3: DNS deep dive, NAT, VIP, CIDR
- Day 4: Routing, Reverse Proxy, Firewall, Load Balancer, Proxy
- Day 5 (Lab): Use tcpdump/Wireshark to capture and inspect a TCP handshake
- Day 6: F5 Concepts intro, Wireshark, tcpdump — review
- Day 7: Buffer

### Sprint 10 — Phase 2.5 (Part 2) + Phase 2.8
- Day 1: netstat, ss, dig, nslookup, traceroute
- Day 2: HTTP/2, HTTP/3, TCP Window, MTU/Jumbo Frames
- Day 3: KeepAlive, SYN/FIN/TIME_WAIT, Ephemeral Ports
- Day 4: Packet Capture, SSL Packet Analysis
- Day 5 (Lab): Capture and analyze TCP retransmissions in a test scenario
- Day 6: Network Bottlenecks, Latency Analysis — review
- Day 7: Buffer

### Sprint 11 — Phase 3.0: Java & Enterprise Applications
- Day 1: Java basics — JDK, JRE, JVM, Heap, GC (conceptual)
- Day 2: Enterprise app flow — Client, Browser, HTTP Request, IBM HTTP Server, WebSphere, DB
- Day 3: Packaging — WAR, EAR, JAR, Deployment Flow
- Day 4: Web Server concepts — Apache, IBM HTTP Server, Reverse Proxy, Load Balancer
- Day 5 (Lab): Build a simple WAR file and trace its deployment flow on paper
- Day 6: Review; diagram the full "browser to database" enterprise app flow
- Day 7: Buffer

### Sprint 12 — Phase 3.5: Enterprise Storage + Phase 3.8 (Part 1)
- Day 1: SAN, NAS, LUN
- Day 2: Disk Groups, Storage Array, Shared Storage
- Day 3: Snapshots, Backup Storage
- Day 4: JVM Architecture, Class Loader (intro)
- Day 5 (Lab): Diagram SAN vs NAS vs local storage use cases for a bank
- Day 6: JIT Compiler, Code Cache — review
- Day 7: Buffer

---

## MONTH 4 — JVM Internals & WebSphere Install

### Sprint 13 — Phase 3.8: JVM Internals (Part 2)
- Day 1: Native Memory, Metaspace
- Day 2: Object Allocation, Escape Analysis
- Day 3: Java Memory Model
- Day 4: Garbage Collection Internals, Heap Regions, Native Threads
- Day 5 (Lab): Read a sample GC log and identify heap regions
- Day 6: Consolidate JVM internals into a reference diagram
- Day 7: Buffer

### Sprint 14 — Phase 4.0: WAS Installation, Profiles & Architecture (Part 1)
- Day 1: IBM Installation Manager, Packaging Utility, Repository
- Day 2: Silent Installation, Fix Packs, Rollback
- Day 3: Profiles — Standalone, DMGR, Custom
- Day 4: App Server Architecture — Cell, Node, Node Agent, DMGR, Cluster, Managed Server
- Day 5 (Lab): Install WebSphere ND and create a DMGR profile + a custom profile
- Day 6: Review install/profile flow; write an Installation Guide draft
- Day 7: Buffer

### Sprint 15 — Phase 4.0: Administration & Deployment (Part 2)
- Day 1: Admin Console tour, wsadmin intro, Jython basics
- Day 2: Synchronization, Federation, Backup, Restore
- Day 3: Deployment — EAR, WAR, Shared Library, Virtual Host, Context Root
- Day 4: wsadmin Object Model — AdminControl, AdminConfig, AdminApp, AdminTask
- Day 5 (Lab): Federate a custom node to the DMGR; deploy a sample EAR via console
- Day 6: backupConfig/restoreConfig, syncNode, addNode/removeNode — practice via wsadmin
- Day 7: Buffer

### Sprint 16 — Phase 4.0: Classloading, WLM, Dynacache (Part 3)
- Day 1: Classloader Policy (PARENT_FIRST/PARENT_LAST), WAR Classloader Scope
- Day 2: Shared Library Classloader Conflicts, ClassNotFoundException troubleshooting
- Day 3: Resource Scoping hierarchy, WLM (EJB/Web), Work Manager, Async Beans
- Day 4: Scheduler Service, ODR, Intelligent Management intro
- Day 5 (Lab): Deliberately break a classloader config, then diagnose and fix it
- Day 6: Dynacache — Distributed Map, Cache Instances, Servlet Cache, DRS, Cache Monitor
- Day 7: Buffer

---

## MONTH 5 — Databases & Security

### Sprint 17 — Phase 4.5: Database Administration for Middleware
- Day 1: PostgreSQL basics, Oracle basics, DB2 basics
- Day 2: JDBC Drivers, Datasources
- Day 3: Connection Pool, XA Datasource, Transactions
- Day 4: DB Backup, Restore, Monitoring
- Day 5 (Lab): Configure a PostgreSQL datasource + connection pool in WebSphere
- Day 6: Review; document datasource troubleshooting steps
- Day 7: Buffer

### Sprint 18 — Phase 4.8: Enterprise Security (Part 1 — PKI/SSL)
- Day 1: PKI, SSL/TLS concepts, Certificate Authority, CSR
- Day 2: Keystore, Truststore, GSKit, JKS, PKCS12
- Day 3: Cipher Suites, Mutual SSL, TLS Versions
- Day 4: LDAP Security, Active Directory
- Day 5 (Lab): Generate a CSR, create a keystore, configure SSL on a WAS profile
- Day 6: Review certificate lifecycle end-to-end
- Day 7: Buffer

### Sprint 19 — Phase 4.8: Enterprise Security (Part 2 — Identity/Admin)
- Day 1: Kerberos, SPNEGO
- Day 2: OAuth Basics, SAML Basics, Vault Basics
- Day 3: Security Hardening, WAS Administrative Roles
- Day 4: CSIv2/IIOP Security, RunAs Roles, J2C Authentication Aliases
- Day 5 (Lab): Configure LDAP-based security + admin role restrictions in WAS
- Day 6: Admin Console Lockdown & Hardening — review and document
- Day 7: Buffer

### Sprint 20 — Phase 5.0: JVM Administration
- Day 1: Log Analysis basics, SSL/Virtual Host/Datasource ops view
- Day 2: JMS intro, Thread Pool, Connection Pool, Session Management
- Day 3: CPU/Heap Monitoring
- Day 4: Thread Dumps, Heap Dumps
- Day 5 (Lab): Generate and read a thread dump and a heap dump
- Day 6: FFDC, Incident Handling — review
- Day 7: Buffer

---

## MONTH 6 — App Support, Logging, Banking Project Kickoff

### Sprint 21 — Phase 5.5: Enterprise Application Support
- Day 1: Maven, Gradle basics
- Day 2: Build Pipeline, EAR/WAR Creation
- Day 3: Deployment Pipeline, Smoke Testing
- Day 4: Health Checks, Rollback strategy
- Day 5 (Lab): Build a simple Maven-based EAR and deploy through a mini pipeline
- Day 6: Review; write a deployment pipeline SOP
- Day 7: Buffer

### Sprint 22 — Phase 5.8: Logging & Diagnostics
- Day 1: SystemOut.log, SystemErr.log, FFDC
- Day 2: native_stdout/stderr, Plugin Logs, HTTP Access/Error Logs
- Day 3: GC Logs, Heap Dumps, Thread Dumps, Core Dumps
- Day 4: javacore, hs_err_pid files
- Day 5 (Lab): Correlate a SystemOut.log error with a matching FFDC and thread dump
- Day 6: Log Correlation & Root Cause Analysis — review
- Day 7: Buffer

### Sprint 23 — Phase 6.0: DigiStack Bank — Infrastructure Setup
> Note: this sprint follows the generic Version 6 topic list from the master document (PostgreSQL, single cluster). If you're running this alongside your separate, more detailed **DigiStack Bank** project (MySQL, MQ, 5-VM topology, 91-sprint plan), treat this sprint as the condensed/generic version and defer to your dedicated project plan for exact specs — the two shouldn't be merged.
- Day 1: Plan infra: Linux, IBM HTTP Server, WebSphere ND, DMGR, Nodes
- Day 2: Set up Cluster, PostgreSQL connectivity
- Day 3: SSL end-to-end, LDAP integration
- Day 4: Monitoring hooks setup
- Day 5 (Lab): Stand up the base DigiStack infra (DMGR + 2 nodes + cluster)
- Day 6: Review infra; document architecture diagram
- Day 7: Buffer

### Sprint 24 — Phase 6.0: DigiStack Bank — Application & Admin
- Day 1: Application modules overview — Login, Dashboard, Customer
- Day 2: Accounts, Deposit, Withdrawal, Fund Transfer, Transactions
- Day 3: Profile, Reports, Admin modules
- Day 4: Deployment + Clustering of the app
- Day 5 (Lab): Deploy DigiStack app across the cluster with session replication
- Day 6: Backup/Restore drill for the app; review
- Day 7: Buffer

---

## MONTH 7 — Banking Domain, Automation, Advanced Clustering

### Sprint 25 — Phase 6.5: Enterprise Banking Technologies
- Day 1: Core Banking System concepts, Payment Gateway
- Day 2: NEFT, RTGS, IMPS, UPI, SWIFT
- Day 3: AML, KYC, PCI DSS, SOX
- Day 4: Banking Compliance, Security, Availability requirements
- Day 5 (Lab): Map DigiStack Bank's modules to these compliance/regulatory concepts
- Day 6: Review; write a compliance-mapping doc
- Day 7: Buffer

### Sprint 26 — Phase 7.0 + 7.5: Automation & CI/CD 🔧
- Day 1: Shell/Python for admin tasks, wsadmin Automation, Jython
- Day 2: Ansible basics, Jenkins basics, CI/CD concepts
- Day 3: REST API Automation, JSON/YAML/XML for configs
- Day 4: Jenkins Pipeline, GitHub Actions basics, **Health Check Automation**, **Deployment Automation**
- Day 5 (Lab): Write a Jenkins pipeline that automates a health check + deployment
- Day 6: Certificate Automation, Log Cleanup, Backup Automation, **Reporting Automation** — review
- Day 7: Buffer

### Sprint 27 — Phase 8.0: Advanced Clustering & Tuning (Part 1)
- Day 1: Horizontal vs Vertical Cluster, Core Groups, HAManager
- Day 2: SIBus, JMS, MQ intro (as WAS-integrated messaging)
- Day 3: LDAP/AD integration, LTPA, SSO
- Day 4: JVM Tuning, GC Tuning
- Day 5 (Lab): Configure Core Groups + HAManager failover test
- Day 6: Review; document HA cluster design
- Day 7: Buffer

### Sprint 28 — Phase 8.0 (Part 2) + Phase 8.5 (Part 1)
- Day 1: Thread Pool Tuning, JDBC Pool Tuning, Session Optimization
- Day 2: JTA, XA, Two-Phase Commit, ODR, Intelligent Management
- Day 3: Throughput, Latency, TPS, Concurrent Users
- Day 4: Bottleneck Analysis, Capacity Planning
- Day 5 (Lab): Tune thread/JDBC pools under a simulated load
- Day 6: Review tuning results; write a performance tuning checklist
- Day 7: Buffer

---

## MONTH 8 — Performance, Operations, Troubleshooting Begins

### Sprint 29 — Phase 8.5 (Part 2): Performance Engineering
- Day 1: Load Testing, Stress Testing
- Day 2: Spike Testing, Soak Testing
- Day 3: Memory Profiling, CPU Profiling
- Day 4: Performance Baselines, JVM Profiling
- Day 5 (Lab): Run a load test against DigiStack and record baseline metrics
- Day 6: Review results; write a performance report
- Day 7: Buffer

### Sprint 30 — Phase 9.0: Operational Cadence
- Day 1: Daily checks — Health Check, Cluster/Node/JVM/Datasource/Plugin Status
- Day 2: Weekly checks — Cleanup, Backup Validation, Node Sync, Capacity Review
- Day 3: Monthly checks — Java Patch, WAS Fix Pack, SSL Validation, Audit
- Day 4: Quarterly checks — Migration, DR Drill, Performance Review
- Day 5 (Lab): Build a daily health-check script/checklist for DigiStack
- Day 6: Review; assemble an "Operational Calendar" doc
- Day 7: Buffer

### Sprint 31 — Phase 9.5: Production Support Operations
- Day 1: Incident Bridge, War Room, Escalation Matrix
- Day 2: Stakeholder Mgmt, Vendor Coordination, Maintenance Window, Emergency Change
- Day 3: CAB, PIR, SLA/SLO/SLI, MTTR/MTBF, Error Budget
- Day 4: Software Asset Mgmt (ILMT, Sub-Capacity Licensing, Compliance Audits)
- Day 5 (Lab): Run a mock war-room exercise for a simulated P1 incident
- Day 6: EOS Tracking, Upgrade Planning, Version Roadmap — review
- Day 7: Buffer

### Sprint 32 — Phase 10.0: Production Troubleshooting (Part 1)
- Day 1: JVM won't start, NodeAgent Down, DMGR Down
- Day 2: Deployment Failure, SOAP Failure, SSL Expired
- Day 3: LDAP Failure, Database Down, MQ Failure
- Day 4: Hung Thread, High CPU
- Day 5 (Lab): Simulate 2 of the above scenarios end-to-end (break → diagnose → fix)
- Day 6: Document each as Symptoms/Investigation/Logs/Commands/Root Cause/Resolution/Prevention
- Day 7: Buffer

---

## MONTH 9 — Troubleshooting Continued, Monitoring, DR

### Sprint 33 — Phase 10.0: Production Troubleshooting (Part 2)
- Day 1: Memory Leak, Plugin Error
- Day 2: Disk Full, DNS Issue
- Day 3: Firewall Block, Core Group Failure
- Day 4: Session Replication Failure + review of all Phase 10 scenarios
- Day 5 (Lab): Simulate 2 more scenarios end-to-end
- Day 6: Build a personal "Top 20 WAS incidents" runbook
- Day 7: Buffer

### 🔧 New Sprint 33a — Bridging to "150+ Scenarios"
> The master list names Phase 10.0 as "150+ Production Scenarios" but only ever spells out 18 examples (covered in Sprints 32–33). This sprint closes that gap by having you generate additional scenarios yourself, using the Phase 29 incident categories as the multiplier — same 18 root issues, applied across different components, gets you well past 150 realistic variants over time.
- Day 1: Multiply infrastructure scenarios (same failure types across Linux/Storage/VMware/DNS/NTP/Firewall)
- Day 2: Multiply middleware scenarios (WebSphere/IHS/MQ/JVM/Cluster/Plugin/Session/Deployment)
- Day 3: Multiply database scenarios (PostgreSQL/Oracle/DB2 variants of "DB Down," "connection pool exhaustion," etc.)
- Day 4: Multiply security scenarios (SSL/LDAP/Certificates/Auth/Authz variants)
- Day 5 (Lab): Write up 10 new scenario variants in full Symptoms→Prevention format
- Day 6: Consolidate into a running "Scenario Bank" doc you'll keep adding to through Sprints 48–49
- Day 7: Buffer

### Sprint 34 — Phase 10.5: Enterprise Ticket Simulation
- Day 1: P1/P2 Incident handling practice
- Day 2: P3/P4 Incidents, Service Requests
- Day 3: Change Requests, Problem Management
- Day 4: RCA Practice, Customer Updates
- Day 5 (Lab): Full ticket lifecycle simulation (open → investigate → resolve → RCA)
- Day 6: Ticket Documentation, Resolution Validation, Preventive Actions — review
- Day 7: Buffer

### Sprint 35 — Phase 11.0: Monitoring Tool Stack
- Day 1: Splunk basics, Dynatrace basics
- Day 2: AppDynamics, Grafana, Prometheus
- Day 3: IBM Instana, OpenTelemetry
- Day 4: IBM Health Center, GC Viewer, IBM PMAT, Alert Management
- Day 5 (Lab): Set up a basic Grafana/Prometheus dashboard for a WAS JVM metric
- Day 6: Review monitoring stack options and when to use which
- Day 7: Buffer

### Sprint 36 — Phase 11.5: Enterprise Observability
- Day 1: Metrics, Logs, Traces (three pillars)
- Day 2: Dashboards, Alert Design
- Day 3: Alert Noise Reduction/Suppression, Synthetic Monitoring
- Day 4: Availability/Business/Capacity Monitoring, Trend Analysis
- Day 5 (Lab): Design an alerting strategy for DigiStack (what to alert on, thresholds)
- Day 6: Review; document observability strategy
- Day 7: Buffer

---

## MONTH 10 — DR, Cloud/DevOps, Documentation

### Sprint 37 — Phase 12.0 + 12.5: Disaster Recovery
- Day 1: Backup Strategy, Restore, DR Testing
- Day 2: Failover, Entire Cell Recovery, Node/VM/Storage Recovery
- Day 3: Migration, Profile/Plugin Migration, Java Upgrade
- Day 4: Backup Policies/Validation, Profile/Cell/DB Backup
- Day 5 (Lab): Run a DR drill — simulate cell failure and recover from backup
- Day 6: Storage/VM Snapshot, Restore Validation, Business Continuity — review
- Day 7: Buffer

### Sprint 38 — Phase 13.0 + 13.5: Cloud & DevOps
- Day 1: Git, GitHub, Docker basics
- Day 2: Kubernetes concepts, OpenShift basics
- Day 3: AWS/Azure basics, VMware, Infrastructure as Code
- Day 4: Terraform basics, Ansible Roles/Collections, Vagrant
- Day 5 (Lab): Containerize a simple Liberty app with Docker
- Day 6: Cloud Networking, IAM, Secrets Mgmt, K8s Networking, Helm — review
- Day 7: Buffer

### Sprint 39 — Phase 14.0 + 14.5: Enterprise Documentation
- Day 1: Installation Guide, Administration Guide templates
- Day 2: SOP, Runbook, Troubleshooting Guide templates
- Day 3: RCA Template, Health Check/Deployment/Migration Checklists
- Day 4: Architecture Documents, Build Books, Config Documents
- Day 5 (Lab): Write a full SOP + Runbook for DigiStack's deployment process
- Day 6: Knowledge Transfer, Audit/Compliance Documentation — review
- Day 7: Buffer

### Sprint 40 — Phase 15.0: Full Production Workday Simulation
- Day 1: Morning Health Checks, Ticket Assignment
- Day 2: Incident Response, Emergency Calls
- Day 3: Production Deployments, Change Requests, RCA Meetings
- Day 4: Shift Handovers, Maintenance Windows, Cert Renewals
- Day 5 (Lab): Simulate one complete "production workday" end-to-end
- Day 6: Review; note gaps to revisit
- Day 7: Buffer

---

## MONTH 11 — Failure Sim, MQ, IHS, Load Balancers

### Sprint 41 — Phase 15.5: Enterprise Failure Simulation
- Day 1: Complete Data Center Failure, DMGR/Node Failure
- Day 2: Cluster/LDAP/Database Failure
- Day 3: MQ Failure, SSL Expiry, Certificate Renewal
- Day 4: Storage/DNS/Network/Firewall Failure
- Day 5 (Lab): Run a chained-failure drill (e.g., DB down → app errors → cascading)
- Day 6: DR Activation drill — review
- Day 7: Buffer

### Sprint 42a — Phase 17.0: IBM MQ Foundation 🔧 (split from original single MQ sprint)
- Day 1: Introduction to IBM MQ, Messaging Concepts, Queue Manager
- Day 2: Local/Remote/Alias/Model Queue, Transmission Queue, Dead Letter Queue, Message Flow
- Day 3: MQ Architecture, MQ Components, MQ Installation, MQ Directory Structure
- Day 4: MQ Services, MQ Explorer, MQSC Commands, Basic Administration
- Day 5 (Lab): Set up a Queue Manager and a local queue via MQSC and MQ Explorer
- Day 6: Review Phase 17.0 end-to-end; document basic MQ admin cheat-sheet
- Day 7: Buffer

### Sprint 42b — Phase 17.5: Enterprise IBM MQ Administration 🔧
- Day 1: Channels (Sender, Receiver, Server Connection, Client), Listeners, Triggering
- Day 2: Security — SSL/TLS, Channel Authentication (CHLAUTH), OAM Security
- Day 3: MQ Clustering, JMS Integration, WebSphere MQ Integration, Connection Factory, Activation Specification
- Day 4: High Availability — Multi-instance Queue Manager, RDQM, MFT (Managed File Transfer)
- Day 5 (Lab): Configure a sender/receiver channel pair with CHLAUTH; set up a JMS connection factory
- Day 6: **MQ Backup, Recovery, Monitoring, Performance Tuning, Troubleshooting, Automation, Production Scenarios** — review and document (these five were previously unscheduled)
- Day 7: Buffer

### Sprint 43a — Phase 18.0: IBM HTTP Server Foundation 🔧 (split from original single IHS sprint)
- Day 1: Web Server Architecture, Apache Architecture, IBM HTTP Server Architecture, Installation
- Day 2: Configuration Files, Directory Structure, Startup, Shutdown, Virtual Hosts
- Day 3: HTTP/HTTPS Request Flow, Reverse Proxy, URL Mapping
- Day 4: Plugin-cfg.xml, Plugin Generation, Plugin Propagation, WebSphere Plugin
- Day 5 (Lab): Configure IHS + plugin to route to a WAS cluster
- Day 6: SSL Configuration, GSKit, Key Database, Certificate Management — review
- Day 7: Buffer

### Sprint 43b — Phase 18.5: Enterprise IBM HTTP Server Administration 🔧
- Day 1: mod_ibm_websphere, mod_ssl, mod_headers, mod_rewrite, mod_alias
- Day 2: Compression, Caching, KeepAlive, Security Headers, HTTP Hardening
- Day 3: **Access Control**, **Log Rotation**, Access Logs, Error Logs
- Day 4: Performance Tuning, **Thread Configuration**, **Worker Processes**, Request Routing, **Static Content**, **Dynamic Content**
- Day 5 (Lab): Perform a Zero Downtime Plugin Refresh; tune worker/thread config under load
- Day 6: **Monitoring, Troubleshooting, Automation, Production Scenarios** for IHS — review and document (previously unscheduled)
- Day 7: Buffer

---

## MONTH 12 — Load Balancers, Liberty, Architecture

### Sprint 44a — Phase 19.0: Load Balancer Fundamentals 🔧 (split from original single LB sprint)
- Day 1: Why Load Balancers, High Availability, Reverse Proxy
- Day 2: SSL Offloading, SSL Bridging, Layer 4 vs Layer 7 Load Balancing
- Day 3: Virtual IP (VIP), Pools, Pool Members, Health Monitors
- Day 4: Persistence, Session Affinity, Sticky Sessions, Load Balancing Algorithms, Failover, Active-Active, Active-Passive
- Day 5 (Lab): Diagram L4 vs L7 request flow for DigiStack; design a health-monitor policy
- Day 6: Review LB fundamentals end-to-end
- Day 7: Buffer

### Sprint 44b — Phase 19.5: Enterprise Load Balancer Administration 🔧
- Day 1: F5 BIG-IP — Architecture, Virtual Server, Pool, Node, Monitor, iRules (basics), SNAT, Persistence Profiles, SSL Profiles, Troubleshooting
- Day 2: HAProxy — Installation, Configuration, ACLs, Backend Pools, Frontend Configuration, Health Checks, Logging, SSL, Monitoring
- Day 3: NGINX — Reverse Proxy, Load Balancing, SSL Termination, Health Checks, URL Rewriting, Compression, Caching, Performance Tuning
- Day 4: **Citrix ADC (NetScaler)** — Architecture, Virtual Server, Services, SSL Offload, Load Balancing Policies, Health Checks, **Monitoring, Troubleshooting**
- Day 5 (Lab): Configure HAProxy or NGINX as a load balancer in front of DigiStack
- Day 6: Compare F5/HAProxy/NGINX/Citrix ADC — write a decision-matrix doc
- Day 7: Buffer

### Sprint 45 — Phase 21.0 + 21.5: WebSphere Liberty
- Day 1: Liberty vs tWAS, Open/WebSphere Liberty, server.xml, featureManager
- Day 2: Liberty install, dropins deployment, server templates
- Day 3: Liberty in Docker/Kubernetes/OpenShift, Liberty Operator
- Day 4: SSL/Datasource/JMS config in Liberty, Monitoring (MicroProfile Metrics/Health)
- Day 5 (Lab): Containerize and deploy a Liberty server with a datasource
- Day 6: tWAS-to-Liberty migration assessment — review
- Day 7: Buffer

### Sprint 46 — Phase 20.0 + 24.0: Architecture & Release Mgmt 🔧 (expanded)
- Day 1: Enterprise Topology, Environment/Naming/IP/Port Planning, **Capacity Planning, Sizing**
- Day 2: HA/DR Design, Security/Network/Storage Design, **Monitoring Design, Automation Design**
- Day 3: **Production Architecture** — DMZ Design, Multi-tier Architecture, Active-Active/Active-Passive Data Center, Multi-Cluster Design, Horizontal/Vertical Scaling, Session Replication, Failover Strategy
- Day 4: Release Planning, CAB Process, Change Window, Deployment Calendar, Emergency Change, Rollback Planning, Go/No-Go Meeting, Post Deployment Validation
- Day 5 (Lab): Design a full enterprise topology diagram for DigiStack v2, including DMZ and multi-cluster layout
- Day 6: Release Documentation & Audit; **Enterprise Operations** checklist (SOPs, Runbooks, Health Checks, Incident Response, Change Mgmt, Deployment Strategy, Patch Mgmt, Cert Lifecycle, Monitoring/Automation Strategy, Knowledge Transfer) — review
- Day 7: Buffer

### 🔧 New Sprint 46.5 — Phase 16.5: Enterprise Solution Architecture
> This phase existed in the master topic list but had no scheduled days anywhere in the original plan — it's added here as its own sprint, right after the related Phase 20.0 architecture work.
- Day 1: Enterprise Architecture Design, Banking Infrastructure Design
- Day 2: High Availability, Fault Tolerance, Scalability
- Day 3: Active-Active, Active-Passive, Multi-Data Center
- Day 4: Capacity Planning, Infrastructure Sizing
- Day 5 (Lab): Draft a Security Architecture and a Performance Architecture doc for DigiStack
- Day 6: Complete Enterprise Design Review — present/walk through the full architecture as if to a review board
- Day 7: Buffer

### Sprint 47 — Phase 25.0 + 26.0: Compliance & Testing
- Day 1: PCI DSS, SOX, ISO 27001, ITIL recap
- Day 2: Audit Process, Password Policies, Access Reviews, Segregation of Duties
- Day 3: Testing types — Unit, Integration, SIT, UAT, Smoke, Sanity, Regression
- Day 4: Load/Stress/Spike/Endurance/Failover/DR Testing
- Day 5 (Lab): Write a compliance checklist + a test plan for DigiStack
- Day 6: Data/Log Retention, Compliance Reporting — review
- Day 7: Buffer

---

## MONTH 13 — Incident Depth & Capstone

### Sprint 48–49 — Phase 29.0: 500+ Enterprise Incidents (Rapid Drill) 🔧
> Each incident you drill must include **all ten fields** from the master spec: Symptoms, **Business Impact**, Investigation, Commands, Logs, Root Cause, Resolution, Prevention, **Customer Communication**, RCA. The original day text only asked for RCA — the other two (Business Impact, Customer Communication) are added back in here since the master document requires them for every incident.
- Day 1: Infrastructure incidents (Linux, Storage, VMware, DNS, NTP, Firewall)
- Day 2: Middleware incidents (WebSphere, IHS, MQ, JVM, Cluster, Plugin, Session, Deployment)
- Day 3: Database incidents (PostgreSQL, Oracle, DB2)
- Day 4: Security incidents (SSL, LDAP, Certificates, Auth/Authz)
- Day 5 (Lab): Pick 5 incidents, run them as timed mock-tickets with full RCA (all 10 fields)
- Day 6: Performance incidents (High CPU, Memory Leak, Hung Thread, Slow Response, JDBC Pool Exhaustion)
- Day 7: Buffer
- **Sprint 49 repeats this pattern** with a fresh batch of incidents, pulling from your Sprint 33a "Scenario Bank" so you're not reusing the same 18 root causes.

### Sprint 50–52 — Capstone: DigiStack Bank Enterprise Final Project 🔧
- **Sprint 50 (Build):** Assemble full stack — Network/DNS/NTP, VMware, Linux, IHS, WAS ND Cell, DMGR, Nodes, Horizontal+Vertical Cluster, Liberty component, MQ, PostgreSQL, LDAP, SSL end-to-end, Banking App, Session Replication, Load Balancer
- **Sprint 51 (Operate):** Monitoring stack, CI/CD pipeline, Ansible automation, Backup/Restore, DR site, Performance tuning pass
- **Sprint 52 (Prove it):** Run 10–15 incident simulations against your own build, finalize documentation/runbooks, do a mock architecture review + mock technical interview + **Mock Technical Interviews** (structured, timed) + **HR Interview** practice, plus Resume Preparation, Architecture Explanation, Whiteboard Sessions, Scenario-Based Interviews, Salary Negotiation, Career Growth Planning (Phase 16.0, now fully explicit)

---

## ⚠️ Open gaps in the source material (not filled — flagged instead of invented)

The master topic list itself states:

- **Versions 22–23** — "not included in the source material"
- **Versions 27–28** — "not included in the source material"

No day-wise content exists for these because the source document you provided has no topics listed for them. If you have (or find) the missing topic lists for these versions, send them over and I'll slot them into the day-wise plan in the right place (22–23 would sit right after Liberty/Version 21, and 27–28 would sit between Release/Governance and Testing).

---

## Summary: linear sprint count after gap-filling

| Original sprint # | New sprint(s) | Reason |
|---|---|---|
| 1–41 | unchanged | Already complete against the master list |
| 42 | 42a, 42b | MQ topics didn't fit in one week without dropping 5 sub-areas |
| 43 | 43a, 43b | IHS topics didn't fit in one week without dropping ~7 sub-areas |
| 44 | 44a, 44b | LB topics (4 products) didn't fit in one week |
| — | **46.5 (new)** | Phase 16.5 had no home in the original plan |
| — | **33a (new)** | Bridges the 18-named-scenarios vs. "150+ scenarios" gap |
| 45–52 | unchanged numbering, content expanded in place | 46 and 52 gained missing sub-topics without needing a new week |

**Total sprints: 52 → 58.** **Total duration: ~48–50 weeks → ~58–59 weeks (≈13–14 months)** at the same 1–2 hr/day pace.
