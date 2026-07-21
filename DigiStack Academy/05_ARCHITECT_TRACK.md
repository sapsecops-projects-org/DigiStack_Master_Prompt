# Architect Track — Senior WebSphere ND Architect Concepts

The 8-part curriculum teaches you to **operate and troubleshoot**. This track teaches you to **design, decide, and govern** — the gap between an admin executing a config and an architect who owns the "why." Layered in alongside each part, not taught separately.

## Cross-Cutting Architect Mindset
- Every decision trades off cost vs. performance vs. availability vs. security — name the trade-off explicitly, don't hide it
- **ADRs (Architecture Decision Records)** — document why a design choice was made, not just what was configured
- Non-functional requirements (NFRs) drive topology: TPS targets, RTO/RPO, concurrent users, data residency rules (core to banking/insurance regulatory compliance)

## Layered on Part 1 — Core Administration Fundamentals
- **Topology design** — single-cell vs. multi-cell; when to split (org boundaries, blast-radius isolation, independent patch cycles)
- **DMZ placement** — where IHS/reverse proxy sits relative to app servers; why app servers never sit directly in the DMZ
- **Licensing architecture** — PVU (Processor Value Unit) based licensing; how core count/virtualization drives cost conversations
- **Enterprise security architecture** — SSO design (SAML/Kerberos/OAuth in front of WebSphere), how J2C/LDAP fits a broader IAM strategy
- **Standards & hardening baselines** — writing the "gold config" every new cell must follow

## Layered on Part 2 — Performance Tuning
- **Capacity planning models** — translating a business SLA ("5,000 TPS during month-end") into JVM count/heap/thread math, not guesswork
- **Caching architecture** — Dynacache vs. external cache (Redis) vs. WebSphere eXtreme Scale, and why legacy banking apps often over-rely on in-JVM caching
- **Vertical vs. horizontal scaling trade-offs** in regulated environments (audit implications of scaling out)

## Layered on Part 3 — Real-Time Troubleshooting
- **Blast radius thinking** — bulkhead pattern applied to clusters so one node's failure doesn't cascade
- **Escalation tier ownership** — architects define L1/L2/L3 boundaries and what each tier is authorized to touch in production (operational L1/L2/L3 definitions now live in `01_MASTER_CONTEXT.md`'s On-Call Rotation section; this layer is about *owning and revising* those boundaries, not just following them)

## Layered on Part 4 — Disaster Recovery
- **Active-active vs. active-passive** — cost/complexity trade-offs; why most banks still run active-passive for core systems
- **RPO/RTO negotiation** — translating "we can't lose any transactions" into an achievable, funded number
- **Multi-region regulatory constraints** — data residency laws restricting where a DR site can physically sit

## Layered on Part 5 — WebSphere Migration
- **Migration risk assessment** — owning the go/no-go decision, not just the technical steps
- **Traditional-to-Liberty strategy** — when the investment is worth it vs. "if it ain't broke" for legacy core banking
- **Rollback architecture** — designing the fallback path before migrating, not after something breaks

## Layered on Part 6 — Observability
- **Tool governance** — standardizing APM tooling enterprise-wide, not just using what's installed
- **SLA/SLO definition** — defining what "healthy" means numerically; ops monitors against it
- **Alert fatigue architecture** — thresholds designed so critical signals aren't buried in noise

## Layered on Part 7 — Incident Management
- **Major incident commander role** — architects often run point during Sev1 banking outages, coordinating rather than just diagnosing
- **RCA quality** — shallow RCA ("JVM restarted, resolved") vs. one that changes the architecture to prevent recurrence
- **CAB (Change Advisory Board) participation** — how decisions get vetted before hitting production in regulated environments
  - *Note (2026-07-11):* Operational CAB participation — submitting a Change Implementation Plan + Rollback Plan for review — begins in Probation Phase 3 (~Day 61), per `01_MASTER_CONTEXT.md`'s Career Simulation layer, long before Part 7. What's layered here specifically is the *architect* lens: sitting on the board side, reading board politics, and defending a topology decision rather than just submitting one.

## Layered on Part 8 — DevSecOps
- **Pipeline architecture ownership** — designing stages/gates/approvals, not just running the pipeline
- **Compliance-as-code strategy** — translating regulatory requirements (PCI-DSS, SOX-style controls) into automated pipeline gates
- **Secrets & key management architecture** — enterprise-wide strategy (e.g., Vault), not per-app configuration

## Leadership & Soft Architect Skills
- Running an architecture review board session
- Presenting a topology decision to non-technical stakeholders — business risk framing, not just tech specs
- Mentoring L1/L2 admins — writing runbooks that scale a team, not just solve one incident

## Extension — Advanced Architect Topics (Optional / Pullable)
Not part of the core 465-day schedule. Take as a dedicated block after the core program, or pull individual items forward into a relevant cycle's Revision or Advanced Lab day (e.g., licensing alongside Part 1, Liberty alongside Part 5).

- **WAS Traditional vs. Liberty + containerization** — Docker/OpenShift/Kubernetes concepts; hands-on: deploy a test app to Liberty, compare admin/ops experience vs. ND
- **License compliance** — PVU model, ILMT (IBM License Metric Tool), sub-capacity reporting
- **IBM Support engagement** — PMR/case process, MustGather packages by issue type
- **Regulatory & compliance context** — audit trails, segregation of duties, PCI-DSS, local banking regulator guidelines
- **Advanced diagnostic tooling** — TMDA for thread dumps, Eclipse MAT for heap dumps
- **Multi-cell & cross-cell architecture** — cross-cell trust, federated SSO across cells
- **Shared filesystem strategy** — NFS-mounted binaries vs. per-node, patching trade-offs
- **Capacity & HA sizing exercise** — size a cluster from a load profile, justify the HA pattern chosen; write it up as a mini architecture proposal; defend it in a mock architect review (explain-it-back)

---
Going forward, every operational lesson gets an "architect's lens" follow-up: not just *how* to configure something, but *why this way* and *what's the trade-off*.
