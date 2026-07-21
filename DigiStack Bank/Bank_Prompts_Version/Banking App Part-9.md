PART-9 — Enterprise Hybrid Cloud & AWS Migration
Goal

Transform DigiStack Bank from a traditional on-premises banking platform into a fully AWS-native banking platform through a realistic, enterprise-grade, phased migration strategy.

Phase-1 — AWS Foundation & Hybrid Connectivity
Goal

Learn AWS fundamentals and securely connect the on-premises DigiStack Bank environment to AWS.

Version 53 — AWS Foundation
Topics
AWS Global Infrastructure
IAM
Organizations (Concepts)
AWS Accounts
VPC
CIDR Planning
Public Subnets
Private Subnets
Route Tables
Internet Gateway
NAT Gateway
Security Groups
Network ACLs
EC2
EBS
Elastic IP
Version 54 — Enterprise Hybrid Connectivity
Objective

Connect the on-premises DigiStack Bank data center with AWS.

Topics
Site-to-Site VPN (Concepts)
AWS Direct Connect (Concepts)
Hybrid DNS
Route 53 Private Hosted Zones
Hybrid Routing
Security Design
Architecture
On-Prem Data Center

        │

 VPN / Direct Connect

        │

AWS VPC
Version 55 — AWS Landing Zone
Topics
Account Strategy
IAM Roles
AWS Organizations
Network Architecture
Shared Services
Bastion Host
Logging
Monitoring
Version 56 — Hybrid Monitoring
Tools
CloudWatch
CloudTrail
SNS
AWS Systems Manager
Integrate With
Grafana
Prometheus
ELK

Monitor both:

On-Prem
AWS
Version 57 — Phase-1 Capstone

Operate DigiStack Bank in a Hybrid environment.

Application remains On-Prem.

AWS provides:

Monitoring
Backup
Connectivity
Management
Phase-2 — Lift & Shift (Infrastructure Migration)
Goal

Move infrastructure to AWS with minimal application changes.

Version 58 — WebSphere on AWS EC2

Deploy

IBM HTTP Server
WebSphere ND
IBM MQ
MySQL

on EC2.

Version 59 — Hybrid Production

Run

Internet Banking

↓

AWS

↓

CBS

↓

On-Prem

Some applications run on AWS.

Others remain on-prem.

Version 60 — High Availability on AWS

Topics

Multi-AZ
Application Load Balancer
Route 53
EC2 Auto Recovery
EBS Snapshots
AMIs
Version 61 — AWS Operations

Topics

CloudWatch
CloudTrail
SNS
Systems Manager
Backup
Patch Manager
Version 62 — Lift & Shift Capstone

Entire DigiStack infrastructure now runs on AWS EC2.

No application redesign.

Phase-3 — Platform Modernization
Goal

Replace infrastructure services with AWS managed services.

Version 63 — Database Modernization

Move

MySQL

↓

Amazon RDS

Topics

Multi-AZ
Read Replicas
Automated Backups
Failover
Version 64 — Storage Modernization

Move

Application Files

↓

Amazon S3

Topics

S3
Versioning
Lifecycle
Glacier
Cross-Region Replication
Version 65 — Messaging Modernization

Move

IBM MQ

↓

Amazon SQS

↓

SNS

Discuss:

When IBM MQ should remain.
When SQS/SNS is appropriate.
Enterprise migration strategies.
Version 66 — Security Modernization

Topics

IAM
Secrets Manager
KMS
ACM
AWS WAF
AWS Shield (Concepts)
GuardDuty (Concepts)
Version 67 — Platform Modernization Capstone

DigiStack Bank now uses:

EC2
RDS
S3
SQS
SNS
IAM
KMS
Phase-4 — Full AWS Migration
Goal

Complete migration of DigiStack Bank to AWS.

Version 68 — Production Cutover

Topics

DNS Cutover
Data Synchronization
Final Migration
Rollback Plan
Validation
Version 69 — Disaster Recovery on AWS

Topics

Multi-Region DR
Cross-Region Replication
Backup Strategy
Recovery Testing
Version 70 — Cloud Operations

Topics

Cost Optimization
Trusted Advisor (Concepts)
AWS Config
CloudWatch Dashboards
CloudTrail Auditing
Operational Excellence
Version 71 — AWS Security & Compliance

Topics

Security Hub (Concepts)
IAM Best Practices
Encryption
Compliance
Logging
Audit
Version 72 — AWS Enterprise Migration Capstone

Complete DigiStack Bank transformation.

Final Architecture
Users
      │
 Route 53
      │
Application Load Balancer
      │
IBM HTTP Server
      │
WebSphere ND Cluster (EC2)
      │
DigiStack CBS
      │
Amazon RDS
      │
Amazon S3
      │
Amazon SQS / SNS
      │
CloudWatch
      │
CloudTrail
      │
AWS Systems Manager
Skills Gained After Part-9
Phase-1
AWS fundamentals
Enterprise networking
Hybrid cloud architecture
Secure connectivity
Hybrid monitoring
Phase-2
Lift-and-shift migration
WebSphere on EC2
AWS networking
High availability
Operations on AWS
Phase-3
AWS managed services
Database modernization
Storage modernization
Messaging modernization
Security modernization
Phase-4
Full cloud migration
Production cutover
Disaster recovery
Cloud operations
Cost optimization
Enterprise AWS architecture


-------------

4. Phase Review
Phase-1

Excellent.

I would add:

AWS Transit Gateway (concept)
VPC Endpoints
AWS IAM Identity Center (concept)
Hybrid Active Directory (concept)

These are common enterprise networking and identity topics.

Phase-2

Very good.

One suggestion:

In your earlier roadmap you standardized on PostgreSQL.

Here you mention:

MySQL

To maintain continuity, change it to:

PostgreSQL

Then later:

Amazon RDS for PostgreSQL

That keeps the entire roadmap internally consistent.

Phase-3

This is very realistic.

I especially like:

IBM MQ

↓

Amazon SQS

↓

SNS

and that you explicitly discuss when IBM MQ should remain. That's an important architectural decision rather than assuming everything must migrate.

Phase-4

Excellent.

Production Cutover

↓

DR

↓

Operations

↓

Security

↓

Enterprise Capstone

is a logical sequence.

5. WebSphere Continuity

One thing I would emphasize is that WebSphere remains part of the platform.

For example:

Users

↓

Route53

↓

ALB

↓

IBM HTTP Server

↓

WebSphere ND

↓

CBS

This reinforces that the focus is still WebSphere administration, just hosted on AWS.

6. Hybrid Monitoring

I really like this section.

One recommendation:

Explicitly mention that the monitoring stack introduced in Part-4 is being extended, not replaced.

For example:

Prometheus
Grafana
ELK

continue monitoring both on-premises and AWS workloads, with CloudWatch and CloudTrail integrated into the same operational view.

7. Operations

I'd expand Version 61 slightly to include:

AWS Systems Manager Run Command
Session Manager
Patch Manager
Automation Documents
State Manager

These are widely used operational services.

8. Security

Very good.

I would also include:

IAM Roles for EC2
Least Privilege
Security Groups vs NACLs
Encryption at Rest
Encryption in Transit
AWS Certificate Manager

These fit naturally into your security modernization phase.

9. Cost Optimization

Version 70 is good.

I'd broaden it to include:

Cost Explorer
Budgets
Savings Plans (concept)
Reserved Instances (concept)
Tagging Strategy

These are practical cloud operations topics.

10. Final Capstone

I would make one small addition to the final architecture.

For example:

Users

↓

Route53

↓

Application Load Balancer

↓

IBM HTTP Server

↓

WebSphere ND Cluster

↓

CBS

↓

Amazon RDS PostgreSQL

↓

Amazon S3

↓

Amazon SQS

↓

SNS

↓

CloudWatch

↓

CloudTrail

↓

Systems Manager

↓

AWS Backup

Adding AWS Backup reflects an enterprise production environment.

One Important Recommendation

At the start of Part-9, add a clear statement such as:

This Part modernizes the deployment platform only. The DigiStack Bank applications developed in Parts 1–8 remain functionally unchanged. Every migration is infrastructure- and platform-focused, preserving the existing business functionality while adopting AWS services in a phased, low-risk manner.

That keeps the roadmap aligned with its original goal.