# DigiStack Health Enterprise — Realism Enhancements

Companion to `01_MASTER_CONTEXT.md`. This file holds the detailed design for four realism upgrades folded into the existing sprints — no new sprints added, no renumbering. Each section says exactly which sprint it plugs into and what changes there.

---

## 1. FHIR-Aligned Data Model — plugs into Sprint 1.4 (Database Design)

Rather than inventing patient/appointment fields from nothing, the schema is loosely shaped after three core **HL7 FHIR** resources — structurally only, not the full FHIR REST API or wire format. This is a free, widely recognized healthcare data standard; modeling field names and relationships after it (while still building a plain PostgreSQL schema, not a FHIR server) is a legitimate, resume-relevant detail with almost no added build cost.

### Patient (maps to FHIR `Patient`)
| DB Column | FHIR-inspired concept | Notes |
|---|---|---|
| `patient_id` | `identifier` | Internal synthetic ID, never a real MRN |
| `first_name`, `last_name` | `name.given` / `name.family` | |
| `date_of_birth` | `birthDate` | |
| `gender` | `gender` | Use FHIR's administrative-gender value set (male/female/other/unknown) as the allowed values |
| `phone`, `email` | `telecom` | |
| `address_line`, `city`, `state`, `zip` | `address` | |
| `synthetic_mrn` | `identifier` (secondary) | Clearly synthetic format, e.g. `SYN-000123` |

### Appointment (maps to FHIR `Appointment`)
| DB Column | FHIR-inspired concept | Notes |
|---|---|---|
| `appointment_id` | `id` | |
| `patient_id` (FK) | `participant` (Patient reference) | |
| `clinician_id` (FK) | `participant` (Practitioner reference) | |
| `status` | `status` | Use FHIR's appointment status value set: `booked`, `arrived`, `fulfilled`, `cancelled`, `noshow` — this directly powers Sprint 2.11/2.12's booking and cancellation logic |
| `start_time`, `end_time` | `start` / `end` | |
| `service_type` | `serviceType` | e.g. "general checkup", "follow-up" |
| `notes` | `comment` | |

### Lab Order / Referral (maps to FHIR `ServiceRequest`) — feeds Sprint 2.17
| DB Column | FHIR-inspired concept | Notes |
|---|---|---|
| `request_id` | `id` | |
| `patient_id` (FK) | `subject` | |
| `requesting_clinician_id` (FK) | `requester` | |
| `request_type` | `category` | `LAB_ORDER` or `REFERRAL` |
| `code_description` | `code` | What's being requested, e.g. "CBC panel" or "Cardiology referral" |
| `priority` | `priority` | `routine` / `urgent` / `stat` |
| `status` | `status` | See Section 2 below — this column is what the real-time feature reads and writes |
| `created_at`, `updated_at` | — | Standard audit timestamps |

**When you reach Sprint 1.4:** design these three tables using the columns above as your starting point, adjusting as needed once you see the actual UI wireframes from Sprint 1.5.

---

## 2. Real-Time Referral/Lab Order Status — plugs into Sprint 2.17

Sprint 2.17 already builds the async MQ → MDB → audit-table flow. This adds a small, era-appropriate real-time feel on top of it, using only what Java 8 / Servlet / JSP already gives you — no WebSocket module, no new stack component.

**Status lifecycle (the `status` column from Section 1 above):**
```
SUBMITTED → QUEUED → PROCESSING → ACCEPTED | REJECTED → COMPLETED
```

**Flow:**
1. Physician submits a lab order/referral → Servlet writes the row with `status = SUBMITTED`, then puts a message on the MQ queue.
2. MDB picks up the message → updates `status = PROCESSING` → runs its simulated processing logic → updates `status = ACCEPTED`, `REJECTED`, or `COMPLETED` → writes the audit table entry (as already planned in Sprint 2.17).
3. A lightweight status-check Servlet endpoint (e.g., `/api/labOrderStatus?id=123`) returns the current status as JSON.
4. The Visit History / Dashboard JSP page includes a small JavaScript `fetch()` call on a `setInterval` (e.g., every 5 seconds) that polls that endpoint and updates a status badge in place — no full page reload.

**Why polling instead of a WebSocket push:** true server push (WebSocket, Server-Sent Events) is realistically outside a traditional WAS ND / Servlet 3.x-era stack without extra configuration this project isn't otherwise touching. Short-interval polling is the pragmatic, period-correct choice — and "why polling, given the constraints of this stack" is itself a legitimate interview question this design lets you answer honestly.

**What this teaches beyond the original Sprint 2.17 scope:** it makes the MDB's work *visible* — instead of "a message goes in, an audit row appears," you can watch a request move through its actual lifecycle in the browser, which is what "async status" means in a real hospital ordering system.

---

## 3. Realistic Troubleshooting Incidents — plugs into Sprints 3.5–3.8

Rather than inventing incidents from scratch, seed the 50+ Phase 3 troubleshooting labs from well-known, general categories of real WebSphere/Java operational failures. These are common, publicly-documented failure patterns (not specific to any one proprietary source) — treat the list below as a starting menu, then write your own specific seeded-incident scripts per Section 10's format (Symptoms → Investigation → Logs → Commands → Root Cause → Resolution → Prevention).

**Batch 1 — App/Deployment (3.5):**
- App stuck in "starting" state because a servlet context listener throws an unhandled exception on startup
- `ClassNotFoundException` after a WAR is redeployed without a full app restart (stale classloader cache)
- Node reports "out of sync" because a config change was made directly against a node instead of through the DMGR

**Batch 2 — JVM/Memory (3.6):**
- `OutOfMemoryError` caused by an unbounded in-memory cache (e.g., a `HashMap` never evicted)
- Hung threads from a synchronized block under contention during a load spike
- High CPU from excessive garbage collection due to undersized young generation

**Batch 3 — Data/Messaging (3.7):**
- JDBC connection leak from a DAO that doesn't close connections in a `finally` block
- MQ queue depth climbing because the consumer (MDB) is down
- Dead Letter Queue filling up after a message format changes without updating the consumer

**Batch 4 — Network/Security/Plugin (3.8):**
- SSL handshake failures from an expired keystore certificate
- Stale `plugin-cfg.xml` after scaling the cluster without regenerating/repropagating it
- Session affinity breaking after an IHS restart resets its routing state

Use these as seeds; the goal by the end of Phase 3 is 50+ *distinct* incidents, so vary root cause, affected component, and symptom presentation rather than repeating the same failure with different labels.

---

## 4. OpenMRS as an Architecture Reference — informs Sprint 1.2 and general context

**OpenMRS** is a long-running, widely deployed open-source electronic health record platform, used in real clinics (heavily in resource-constrained settings). It's worth a conceptual skim — **not cloning, not copying code or schema** — for two things:

- **Module boundaries:** OpenMRS separates a small core (patients, encounters, concept dictionary) from independently pluggable modules (registration, lab results, appointment scheduling, reporting). This is a useful sanity check when you do your own MVC layering in Sprint 1.2 — does your Service/DAO boundary hold up if a new module were added later?
- **Concept dictionary pattern:** rather than hardcoding every possible lab test or diagnosis as a column, mature health systems store them as reference data (a "concept" table) that the rest of the schema points to. Even a light version of this idea (e.g., a small `service_type` or `code_description` lookup table instead of a free-text field) makes Sprint 1.4's schema noticeably more realistic.

This is architectural inspiration only — DigiStack Health stays on its own Java 8 / Servlet / JDBC / PostgreSQL stack; nothing from OpenMRS is imported or reused directly.

---

## Where to bring this up in each sprint

| Sprint | What to reference from this file |
|---|---|
| 1.2 (Architecture & MVC Design) | Section 4 — module-boundary sanity check |
| 1.4 (Database Design) | Section 1 — FHIR-aligned schema |
| 2.17 (Lab Order & Referral Routing) | Section 2 — real-time status feature |
| 3.5–3.8 (Troubleshooting Batches) | Section 3 — incident seed list |
