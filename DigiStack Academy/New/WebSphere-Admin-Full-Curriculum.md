# WebSphere Admin Enterprise Curriculum — Full Topic List (Master Reference)
### Organized by Version, with Advanced Topics Split into Separate Phases

> **Scope note:** This curriculum covers WebSphere/MQ on distributed platforms (Linux/VMware/Cloud) only. It intentionally excludes z/OS-specific topics (Sysplex, RRS, shared queues, z/OS Connect). If mainframe WebSphere/MQ administration is in scope for your role, that should be added as a separate track.

---

## Version 0 — Enterprise Foundation

### Phase 0.0 — Enterprise IT Foundation
- Enterprise Organization
- Enterprise IT Overview
- Banking IT Structure
- Roles and Responsibilities
  - Infrastructure Team
  - Middleware Team
  - Linux Team
  - DBA Team
  - Network Team
  - Security Team
  - Storage Team
  - DevOps Team
  - Application Team
  - Release Team
  - Monitoring Team
  - NOC
  - SOC
- Enterprise Environments
  - Development
  - SIT
  - UAT
  - Pre-Production
  - Production
  - Disaster Recovery
  - Sandbox
- SDLC
  - Software Development Lifecycle
  - Agile
  - Scrum
  - Sprint
  - Release Cycle
- ITIL Foundation
  - Incident
  - Problem
  - Change
  - Service Request
  - Major Incident
  - RCA
- Enterprise Tools
  - ServiceNow
  - Jira
  - Confluence
  - Teams
  - Outlook
- Documentation
  - SOP
  - Runbook
  - KB
  - RCA
  - Change Plan

### Phase 0.5 — Enterprise Communication & Professional Skills (New)
- Email Etiquette
- Production Communication
- Shift Handover
- Incident Communication
- Executive Status Updates
- Customer Communication
- CAB Communication
- RCA Writing
- Documentation Standards
- Meeting Etiquette
- Technical Presentation Skills

---

## Version 1 — Linux Administration

### Phase 1.0 — Linux Foundation
- Installation
- Boot Process
- File System
- Directory Structure
- Users
- Groups
- Permissions
- ACL
- Process Management
- Services
- SSH
- SCP
- rsync
- Cron
- Shell
- Networking Commands
- Firewall
- SELinux
- Package Management
- Bash Scripting

### Phase 1.5 — Enterprise Linux (Advanced)
- LVM
- Multipath
- NFS
- CIFS
- Mount Points
- fstab
- systemd
- journald
- CPU Monitoring
- Memory Monitoring
- Disk Monitoring
- IO Monitoring
- Performance Monitoring
- Disk Expansion
- Swap
- Huge Pages
- Kernel Parameters
- Log Rotation
- Troubleshooting

### Phase 1.8 — Linux Performance & Diagnostics (New)
- top
- htop
- vmstat
- mpstat
- sar
- iostat
- pidstat
- free
- dmesg
- journalctl
- strace
- lsof
- perf
- sysctl
- sysstat
- Process Analysis
- Memory Analysis
- CPU Analysis
- IO Analysis
- Network Analysis

---

## Version 2 — Networking

### Phase 2.0 — Networking Foundation
- OSI
- TCP/IP
- HTTP
- HTTPS
- DNS
- Ports
- SSL Basics
- Routing Basics

### Phase 2.5 — Enterprise Networking (Advanced)
- TCP Handshake
- SSL Handshake
- HTTP Flow
- Packet Journey
- DNS
- NAT
- VIP
- CIDR
- Routing
- Reverse Proxy
- Firewall
- Load Balancer
- Proxy
- F5 Concepts
- Wireshark
- tcpdump
- netstat
- ss
- dig
- nslookup
- traceroute

### Phase 2.8 — Enterprise Traffic Analysis (New)
- HTTP/2
- HTTP/3
- TCP Window
- MTU
- Jumbo Frames
- KeepAlive
- SYN
- FIN
- TIME_WAIT
- Ephemeral Ports
- Packet Capture
- SSL Packet Analysis
- TCP Retransmissions
- Network Bottlenecks
- Latency Analysis

---

## Version 3 — Middleware Fundamentals

### Phase 3.0 — Java & Enterprise Applications
- Java
  - JDK
  - JRE
  - JVM
  - Heap
  - GC
- Enterprise Applications
  - Client
  - Browser
  - HTTP Request
  - IBM HTTP Server
  - WebSphere
  - Database
- Packaging
  - WAR
  - EAR
  - JAR
  - Deployment Flow
- Web Server
  - Apache
  - IBM HTTP Server
  - Reverse Proxy
  - Load Balancer

### Phase 3.5 — Enterprise Storage (Advanced)
- SAN
- NAS
- LUN
- Disk Groups
- Storage Array
- Shared Storage
- Snapshots
- Backup Storage

### Phase 3.8 — JVM Internals (New)
- JVM Architecture
- Class Loader
- JIT Compiler
- Code Cache
- Native Memory
- Metaspace
- Object Allocation
- Escape Analysis
- Java Memory Model
- Garbage Collection Internals
- Heap Regions
- Native Threads

---

## Version 4 — IBM WebSphere Administration

### Phase 4.0 — Installation, Profiles & Architecture
- Installation
  - IBM Installation Manager
  - Packaging Utility
  - Repository
  - Silent Installation
  - Fix Packs
  - Rollback
- Profiles
  - Standalone
  - DMGR
  - Custom
- App Server Architecture
  - Cell
  - Node
  - Node Agent
  - DMGR
  - Cluster
  - Managed Server
- Administration
  - Admin Console
  - wsadmin
  - Jython
  - Synchronization
  - Federation
  - Backup
  - Restore
- Deployment
  - EAR
  - WAR
  - Shared Library
  - Virtual Host
  - Context Root
- Classloading (Expanded)
  - Classloader Policy (PARENT_FIRST / PARENT_LAST)
  - WAR Classloader Scope (Application vs Module)
  - Shared Library Classloader Conflicts
  - ClassNotFoundException / NoClassDefFoundError Troubleshooting
  - Classloader Viewer
- Resource Scoping & WLM
  - Cell/Node/Cluster/Server Resource Scope Hierarchy
  - Workload Management (WLM) — EJB and Web
  - Work Manager
  - Asynchronous Beans
  - Resource Environment Providers
  - Scheduler Service
  - On Demand Router (ODR)
  - Intelligent Management / Autonomic Request Flow Manager
- Dynacache
  - Distributed Map
  - Cache Instances
  - Servlet Cache
  - Cache Replication (DRS)
  - Cache Monitor
- wsadmin Object Model (Practical)
  - AdminControl
  - AdminConfig
  - AdminApp
  - AdminTask
  - backupConfig / restoreConfig
  - syncNode
  - addNode / removeNode

### Phase 4.5 — Database Administration for Middleware (Advanced)
- PostgreSQL
- Oracle Basics
- DB2 Basics
- JDBC Drivers
- Datasources
- Connection Pool
- XA Datasource
- Transactions
- Backup
- Restore
- Monitoring

### Phase 4.8 — Enterprise Security (New)
- PKI
- SSL/TLS
- Certificate Authority
- CSR
- Keystore
- Truststore
- GSKit
- JKS
- PKCS12
- Cipher Suites
- Mutual SSL
- TLS Versions
- LDAP Security
- Active Directory
- Kerberos
- SPNEGO
- OAuth Basics
- SAML Basics
- Vault Basics
- Security Hardening
- WAS Administrative Roles (Monitor / Configurator / Operator / Administrator / Deployer)
- CSIv2 / IIOP Security
- RunAs Roles
- J2C Authentication Aliases
- Admin Console Lockdown & Hardening

---

## Version 5 — Production Administration

### Phase 5.0 — JVM Administration
- Log Analysis
- SSL
- Virtual Host
- Datasource
- JMS
- Thread Pool
- Connection Pool
- Session Management
- CPU Monitoring
- Heap Monitoring
- Thread Dumps
- Heap Dumps
- FFDC
- Incident Handling

### Phase 5.5 — Enterprise Application Support (Advanced)
- Maven
- Gradle
- Build Pipeline
- EAR Creation
- WAR Creation
- Deployment Pipeline
- Smoke Testing
- Health Checks
- Rollback

### Phase 5.8 — Logging & Diagnostics (New)
- SystemOut.log
- SystemErr.log
- FFDC
- native_stdout
- native_stderr
- Plugin Logs
- HTTP Access Logs
- HTTP Error Logs
- GC Logs
- Heap Dumps
- Thread Dumps
- Core Dumps
- javacore
- hs_err_pid
- Log Correlation
- Root Cause Analysis

---

## Version 6 — Enterprise Banking Project

### Phase 6.0 — DigiStack Bank Enterprise
**Infrastructure:**
- Linux
- IBM HTTP Server
- WebSphere ND
- DMGR
- Node 1
- Node 2
- Cluster
- PostgreSQL
- SSL
- LDAP
- Monitoring

**Application Modules:**
- Login
- Dashboard
- Customer
- Accounts
- Deposit
- Withdrawal
- Fund Transfer
- Transactions
- Profile
- Reports
- Admin

**Administration:**
- Deployment
- Clustering
- Session Replication
- Backup
- Restore

### Phase 6.5 — Enterprise Banking Technologies (New)
- Core Banking System
- Payment Gateway
- NEFT
- RTGS
- IMPS
- UPI
- SWIFT
- AML
- KYC
- PCI DSS
- SOX
- Banking Compliance
- Banking Security
- Banking Availability

---

## Version 7 — Automation

### Phase 7.0 — Automation & CI/CD (Advanced)
- Shell
- Python
- wsadmin Automation
- Jython
- Ansible
- Jenkins
- CI/CD

### Phase 7.5 — Enterprise Automation (New)
- Python Automation
- REST API Automation
- JSON
- YAML
- XML
- Shell Framework
- wsadmin Library
- Jenkins Pipeline
- GitHub Actions
- Health Check Automation
- Deployment Automation
- Certificate Automation
- Log Cleanup
- Backup Automation
- Reporting Automation

---

## Version 8 — Advanced WebSphere

### Phase 8.0 — Advanced Clustering & Tuning (Advanced)
- Horizontal Cluster
- Vertical Cluster
- Core Groups
- HAManager
- SIBus
- JMS
- MQ
- LDAP
- Active Directory
- LTPA
- SSO
- JVM Tuning
- GC Tuning
- Thread Pool Tuning
- JDBC Pool Tuning
- Session Optimization
- JTA
- XA
- Two Version Commit
- On Demand Router (ODR)
- Intelligent Management / Autonomic Clustering

### Phase 8.5 — Enterprise Performance Engineering (New)
- Throughput
- Latency
- TPS
- Concurrent Users
- Bottleneck Analysis
- Capacity Planning
- Load Testing
- Stress Testing
- Spike Testing
- Soak Testing
- Memory Profiling
- CPU Profiling
- Performance Baselines
- JVM Profiling

---

## Version 9 — Enterprise Operations

### Phase 9.0 — Operational Cadence (Advanced)
**Daily:**
- Health Check
- Cluster Status
- Node Status
- JVM Status
- Datasource Status
- Plugin Status

**Weekly:**
- Cleanup
- Backup Validation
- Node Sync
- Capacity Review

**Monthly:**
- Java Patch
- WAS Fix Pack
- SSL Validation
- Audit

**Quarterly:**
- Migration
- DR Drill
- Performance Review

### Phase 9.5 — Production Support Operations (New)
- Incident Bridge
- War Room
- Escalation Matrix
- Stakeholder Management
- Vendor Coordination
- Maintenance Window
- Emergency Change
- CAB
- PIR
- SLA
- SLO
- SLI
- MTTR
- MTBF
- Error Budget
- Software Asset Management
  - ILMT (IBM License Metric Tool)
  - Sub-Capacity Licensing
  - License Compliance Audits
- Product Lifecycle Management
  - IBM WAS/MQ End-of-Support (EOS) Tracking
  - Upgrade Planning Around EOS Dates
  - Version Roadmap Management

---

## Version 10 — Production Troubleshooting

### Phase 10.0 — 150+ Production Scenarios (Advanced)
Each scenario includes: Symptoms, Investigation, Logs, Commands, Root Cause, Resolution, Prevention.

**Example scenarios:**
- JVM won't start
- NodeAgent Down
- DMGR Down
- Deployment Failure
- SOAP Failure
- SSL Expired
- LDAP Failure
- Database Down
- MQ Failure
- Hung Thread
- High CPU
- Memory Leak
- Plugin Error
- Disk Full
- DNS Issue
- Firewall Block
- Core Group Failure
- Session Replication Failure

### Phase 10.5 — Enterprise Ticket Simulation (New)
- P1 Incidents
- P2 Incidents
- P3 Incidents
- P4 Incidents
- Service Requests
- Change Requests
- Problem Management
- RCA Practice
- Customer Updates
- Ticket Documentation
- Resolution Validation
- Preventive Actions

---

## Version 11 — Monitoring

### Phase 11.0 — Monitoring Tool Stack (Advanced)
- Splunk
- Dynatrace
- AppDynamics
- Grafana
- Prometheus
- IBM Instana
- OpenTelemetry
- IBM Health Center
- GC Viewer
- IBM PMAT
- Alert Management

### Phase 11.5 — Enterprise Observability (New)
- Metrics
- Logs
- Traces
- Dashboards
- Alert Design
- Alert Noise Reduction
- Alert Suppression
- Synthetic Monitoring
- Availability Monitoring
- Business Monitoring
- Capacity Monitoring
- Trend Analysis

---

## Version 12 — Disaster Recovery

### Phase 12.0 — DR & Migration (Advanced)
- Backup Strategy
- Restore
- DR Testing
- Failover
- Entire Cell Recovery
- Node Recovery
- VM Recovery
- Storage Recovery
- Migration
- Profile Migration
- Plugin Migration
- Java Upgrade

### Phase 12.5 — Backup & Recovery Strategy (New)
- Backup Policies
- Backup Validation
- Profile Backup
- Cell Backup
- Database Backup
- Storage Snapshot
- VM Snapshot
- Restore Validation
- Recovery Testing
- Business Continuity

---

## Version 13 — Cloud & DevOps

### Phase 13.0 — Cloud & Containers (Advanced)
- Git
- GitHub
- Docker
- Kubernetes Concepts
- OpenShift
- AWS Basics
- Azure Basics
- VMware
- Infrastructure as Code

### Phase 13.5 — Infrastructure as Code (New)
- Terraform Basics
- Ansible Roles
- Ansible Collections
- Vagrant
- VMware Automation
- Cloud Networking
- IAM Basics
- Secrets Management
- Kubernetes Networking
- Helm Basics

---

## Version 14 — Enterprise Documentation

### Phase 14.0 — Professional Documentation Set (Advanced)
- Installation Guide
- Administration Guide
- SOP
- Runbook
- Troubleshooting Guide
- RCA Template
- Health Check Checklist
- Deployment Checklist
- Migration Checklist
- Knowledge Base

### Phase 14.5 — Knowledge Management (New)
- Architecture Documents
- Standard Templates
- Operational Manuals
- Disaster Recovery Documents
- Deployment Guides
- Build Books
- Configuration Documents
- Knowledge Transfer
- Audit Documentation
- Compliance Documentation

---

## Version 15 — Real Enterprise Simulation

### Phase 15.0 — Full Production Workday Simulation (Advanced)
- Morning Health Checks
- Ticket Assignment
- Incident Response
- Emergency Calls
- Production Deployments
- Change Requests
- RCA Meetings
- Shift Handovers
- Maintenance Windows
- Certificate Renewals
- Patch Activities

### Phase 15.5 — Enterprise Failure Simulation (New)
- Complete Data Center Failure
- DMGR Failure
- Node Failure
- Cluster Failure
- LDAP Failure
- Database Failure
- MQ Failure
- SSL Expiry
- Certificate Renewal
- Storage Failure
- DNS Failure
- Network Failure
- Firewall Failure
- Disaster Recovery Activation

---

## Version 16 — Interview & Career Mastery

### Phase 16.0 — Career Readiness (Advanced)
- Resume Preparation
- Architecture Explanation
- Whiteboard Sessions
- Scenario-Based Interviews
- Mock Technical Interviews
- HR Interviews
- Salary Negotiation
- Career Growth Planning
- Capstone Project

**Capstone deliverable — production-grade DigiStack Bank Enterprise Platform, including:**
- IBM WebSphere ND Cell
- IBM HTTP Server
- Enterprise Banking Application
- PostgreSQL
- Monitoring Stack
- Automation
- Disaster Recovery
- Security
- Performance Tuning
- Complete Documentation
- Troubleshooting Labs
- CI/CD
- Operational Runbooks

### Phase 16.5 — Enterprise Solution Architecture (New)
- Enterprise Architecture Design
- Banking Infrastructure Design
- High Availability
- Fault Tolerance
- Scalability
- Active-Active
- Active-Passive
- Multi-Data Center
- Capacity Planning
- Infrastructure Sizing
- Security Architecture
- Performance Architecture
- Complete Enterprise Design Review

---

## Version 17 — IBM MQ Administration (New)

### Phase 17.0 — IBM MQ Foundation
- Introduction to IBM MQ
- Messaging Concepts
- Queue Manager
- Local Queue
- Remote Queue
- Alias Queue
- Model Queue
- Transmission Queue
- Dead Letter Queue
- Message Flow
- MQ Architecture
- MQ Components
- MQ Installation
- MQ Directory Structure
- MQ Services
- MQ Explorer
- MQSC Commands
- Basic Administration

### Phase 17.5 — Enterprise IBM MQ Administration (Advanced)
- Channels
- Sender Channel
- Receiver Channel
- Server Connection Channel
- Client Channel
- Listeners
- Triggering
- Security
- SSL/TLS
- Channel Authentication (CHLAUTH)
- OAM Security
- MQ Clustering
- JMS Integration
- WebSphere MQ Integration
- Connection Factory
- Activation Specification
- High Availability
- Multi-instance Queue Manager
- RDQM (Replicated Data Queue Manager)
- MFT (Managed File Transfer)
- Backup
- Recovery
- Monitoring
- Performance Tuning
- Troubleshooting
- Automation
- Production Scenarios

---

## Version 18 — IBM HTTP Server & Apache Administration (New)

### Phase 18.0 — IBM HTTP Server Foundation
- Web Server Architecture
- Apache Architecture
- IBM HTTP Server Architecture
- Installation
- Configuration Files
- Directory Structure
- Startup
- Shutdown
- Virtual Hosts
- HTTP Request Flow
- HTTPS Request Flow
- Reverse Proxy
- URL Mapping
- Plugin-cfg.xml
- Plugin Generation
- Plugin Propagation
- WebSphere Plugin
- SSL Configuration
- GSKit
- Key Database
- Certificate Management

### Phase 18.5 — Enterprise IBM HTTP Server Administration (Advanced)
- mod_ibm_websphere
- mod_ssl
- mod_headers
- mod_rewrite
- mod_alias
- Compression
- Caching
- KeepAlive
- Security Headers
- HTTP Hardening
- Access Control
- Log Rotation
- Access Logs
- Error Logs
- Performance Tuning
- Thread Configuration
- Worker Processes
- Request Routing
- Static Content
- Dynamic Content
- Zero Downtime Plugin Refresh
- Monitoring
- Troubleshooting
- Automation
- Production Scenarios

---

## Version 19 — Enterprise Load Balancers (New)

### Phase 19.0 — Load Balancer Fundamentals
- Why Load Balancers
- High Availability
- Reverse Proxy
- SSL Offloading
- SSL Bridging
- Layer 4 Load Balancing
- Layer 7 Load Balancing
- Virtual IP (VIP)
- Pools
- Pool Members
- Health Monitors
- Persistence
- Session Affinity
- Sticky Sessions
- Load Balancing Algorithms
- Failover
- Active-Active
- Active-Passive

### Phase 19.5 — Enterprise Load Balancer Administration (Advanced)
- F5 BIG-IP
  - BIG-IP Architecture
  - Virtual Server
  - Pool
  - Node
  - Monitor
  - iRules (Basics)
  - SNAT
  - Persistence Profiles
  - SSL Profiles
  - Troubleshooting
- HAProxy
  - Installation
  - Configuration
  - ACLs
  - Backend Pools
  - Frontend Configuration
  - Health Checks
  - Logging
  - SSL
  - Monitoring
- NGINX
  - Reverse Proxy
  - Load Balancing
  - SSL Termination
  - Health Checks
  - URL Rewriting
  - Compression
  - Caching
  - Performance Tuning
- Citrix ADC (NetScaler)
  - Architecture
  - Virtual Server
  - Services
  - SSL Offload
  - Load Balancing Policies
  - Health Checks
  - Monitoring
  - Troubleshooting

---

## Version 20 — Enterprise Middleware Architect Capstone (New)

### Phase 20.0 — Enterprise Architecture Design (Advanced)
- Enterprise Design
- Banking Infrastructure Design
- Enterprise Topology
- Environment Planning
- Naming Standards
- IP Planning
- Port Planning
- Capacity Planning
- Sizing
- HA Design
- DR Design
- Security Design
- Network Design
- Storage Design
- Monitoring Design
- Automation Design

**Complete Enterprise Stack:**
- VMware
- Linux
- IBM HTTP Server
- Load Balancer
- IBM WebSphere ND
- IBM MQ
- PostgreSQL
- LDAP
- SSL
- Monitoring
- Backup
- Disaster Recovery
- Jenkins
- Ansible
- Git
- DNS
- NTP
- Firewall
- Storage

**Production Architecture:**
- DMZ Design
- Multi-tier Architecture
- Active-Active Data Center
- Active-Passive Data Center
- Multi-Cluster Design
- Horizontal Scaling
- Vertical Scaling
- Session Replication
- Failover Strategy
- Disaster Recovery
- Capacity Planning
- Performance Design

**Enterprise Operations:**
- Standard Operating Procedures
- Runbooks
- Health Checks
- Incident Response
- Change Management
- Deployment Strategy
- Patch Management
- Certificate Lifecycle
- Monitoring Strategy
- Automation Strategy
- Knowledge Transfer

---

## Version 21 — WebSphere Liberty Administration (New — Gap Fill)

### Phase 21.0 — Liberty Foundation
- Liberty vs Traditional WAS (tWAS) — Architecture Differences
- Open Liberty vs WebSphere Liberty vs WebSphere Hybrid Edition
- server.xml Configuration
- featureManager and Feature List
- Liberty Directory Structure
- Server Templates
- Liberty Installation (Archive, RPM, Container Image)
- Starting/Stopping Liberty Servers
- Dropins Deployment
- Application Configuration (web.xml, ibm-web-ext.xml)

### Phase 21.5 — Enterprise Liberty Administration (Advanced)
- Liberty Collective (Controller/Member Topology)
- Liberty in Docker
- Liberty in Kubernetes/OpenShift
- Liberty Operator (OpenShift)
- Config Dropins and Variable Substitution
- SSL/TLS Configuration in Liberty
- Datasource Configuration in Liberty
- JMS Configuration in Liberty
- Liberty Monitoring (MicroProfile Metrics, Health)
- Liberty Logging (messages.log, trace.log, JSON logging)
- Liberty Performance Tuning
- tWAS to Liberty Migration Assessment and Planning
- Liberty Troubleshooting

---

*Note: Versions 22–23 were not included in the source material and are not listed here.*

---

## Version 24 — Enterprise Release & Change Management (New)

### Phase 24.0 — Production Release Process
- Release Planning
- CAB Process
- Change Window
- Deployment Calendar
- Emergency Change
- Rollback Planning
- Go/No-Go Meeting
- Post Deployment Validation
- Release Documentation
- Release Audit

---

## Version 25 — Enterprise Compliance & Governance (New)

### Phase 25.0 — Banking Compliance
- PCI DSS
- SOX
- ISO 27001
- ITIL
- Audit Process
- Security Compliance
- Password Policies
- Access Reviews
- Segregation of Duties
- Data Retention
- Log Retention
- Compliance Reporting

---

## Version 26 — Enterprise Testing (New)

### Phase 26.0 — Testing Strategy
- Unit Testing
- Integration Testing
- SIT
- UAT
- Smoke Testing
- Sanity Testing
- Regression Testing
- Load Testing
- Stress Testing
- Spike Testing
- Endurance Testing
- Failover Testing
- DR Testing
- User Acceptance Testing

---

*Note: Versions 27–28 were not included in the source material and are not listed here.*

---

## Phase 29.0 — 500+ Enterprise Incidents (New)

Organized by category:

**Infrastructure**
- Linux
- Storage
- VMware
- DNS
- NTP
- Firewall

**Middleware**
- WebSphere
- IBM HTTP Server
- IBM MQ
- JVM
- Cluster
- Plugin
- Session
- Deployment

**Database**
- PostgreSQL
- Oracle
- DB2

**Security**
- SSL
- LDAP
- Certificates
- Authentication
- Authorization

**Performance**
- High CPU
- Memory Leak
- Hung Thread
- Slow Response
- JDBC Pool Exhaustion

Each incident should include:
- Symptoms
- Business Impact
- Investigation
- Commands
- Logs
- Root Cause
- Resolution
- Prevention
- Customer Communication
- RCA

---

## DigiStack Bank Enterprise Final Project (New)

Design, build, deploy, secure, operate, troubleshoot, and document a complete enterprise banking platform containing:

- Enterprise Network
- DNS
- NTP
- VMware Infrastructure
- Linux Servers
- IBM HTTP Server
- IBM WebSphere ND Cell
- Deployment Manager (DMGR)
- Multiple Custom Nodes
- Horizontal Cluster
- Vertical Cluster
- WebSphere Liberty (Containerized Component)
- IBM MQ
- PostgreSQL Database
- LDAP Integration
- SSL/TLS End-to-End
- Enterprise Banking Application (DigiStack Bank)
- Session Replication
- Load Balancer
- Monitoring Stack
- CI/CD Pipeline
- Ansible Automation
- Backup & Restore
- Disaster Recovery Site
- Performance Tuning
- Production Troubleshooting
- Complete Documentation
- Operations Runbooks
- 200+ Production Incident Simulations
- Final Mock Interview & Architecture Review

---

## Standard Module Structure (Applies to Every Version/Phase Above)

Every Version and Phase listed above should be studied/built with all of the following components:

- Business Purpose
- Theory & Concepts
- Enterprise Architecture
- Banking Use Case
- Hands-on Lab
- Configuration
- Administration
- Security
- Performance
- Monitoring
- Troubleshooting
- Automation
- Documentation (SOP/Runbook)
- Best Practices
- Naming Standards
- Common Mistakes
- Production Scenarios
- Assessments
- Interview Questions
- Real-World Operations

---

## ⚠️ Known gaps in this source document

- **Versions 22–23** — not included in the source material.
- **Versions 27–28** — not included in the source material.

These are open gaps in the curriculum as originally written, not omissions introduced later. See the companion Day-Wise Plan file for how they're flagged there too.
