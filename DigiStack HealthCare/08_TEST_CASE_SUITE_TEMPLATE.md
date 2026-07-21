# DigiStack Health Enterprise — Manual Test Case Suite Template & Automation Roadmap

**Current stage:** manual testing, executed by hand as each module is built (ties to Sprint 2.23 — Testing & Code Review — and to the Smoke Test Checklist in `07_DEV_HANDOFF_TEMPLATE.md`).
**Future stage:** DevSecOps automation, once Phase 4/5 tooling exists (Sprint 4.9 Automation Wrap-up, Sprint 5.10 Production Automation). Every test case below is written so it converts cleanly into an automated test later — that's the reason for the "Automation Candidate" and "Suggested Automation Approach" fields even while you're still executing everything by hand.

All test data is synthetic per the project's data hygiene rule — no real names, no real MRNs, no real PHI, ever.

---

## Test Case Template (one row = one test case)

| Field | Meaning |
|---|---|
| **Test Case ID** | e.g., `TC-LOGIN-001` — module prefix + sequence number |
| **Module** | Which of the 9 business modules |
| **Linked Requirement** | Ties back to the user story/acceptance criteria from Sprint 1.1 |
| **Linked Ticket** *(optional)* | The CHG/SR ticket ID (Master Context Section 10d) this test case was written under, if tracking that level of detail |
| **Priority** | Critical / High / Medium / Low |
| **Type** | Functional / Negative / Boundary / Security / Concurrency / Integration |
| **Preconditions** | State the system must be in before the test starts |
| **Test Steps** | Numbered, exact, repeatable |
| **Test Data** | Synthetic values used |
| **Expected Result** | What "pass" looks like, precisely |
| **Actual Result** | Filled in during execution |
| **Status** | Pass / Fail / Blocked |
| **Automation Candidate** | Y/N — is this worth automating first? |
| **Suggested Automation Approach** | UI (Selenium/Playwright), API (REST-assured/Postman-Newman), DB-level assertion, or JMeter (for concurrency/load-flavored cases) |
| **Notes** | Anything an executor needs to know |

---

## Example Suites (representative, not exhaustive — expand per module as each is built)

### Login (Sprint 2.1)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-LOGIN-001 | Functional | Critical | Enter valid synthetic clinician credentials, submit | Redirects to Dashboard, JSESSIONID set | Y | UI (Selenium) |
| TC-LOGIN-002 | Negative | Critical | Enter wrong password 1x | Generic "invalid credentials" error, no session created | Y | UI (Selenium) |
| TC-LOGIN-003 | Security | Critical | Enter wrong password 5x consecutively | Account locks or delays per lockout policy (once defined) | Y | UI + DB check |
| TC-LOGIN-004 | Boundary | Medium | Submit with empty username and/or password fields | Client + server-side validation error, no request reaches DB | Y | UI (Selenium) |
| TC-LOGIN-005 | Security | High | Attempt SQL-injection string in username field (e.g., `' OR '1'='1`) | Rejected/escaped, no auth bypass, no stack trace leaked to user | Y | API (REST-assured) |

### Dashboard (Sprint 2.2)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-DASH-001 | Functional | High | Log in, land on Dashboard | Correct summary widgets render for the logged-in user's role | Y | UI (Selenium) |
| TC-DASH-002 | Functional | Medium | Navigate Dashboard → another module → back | Dashboard state reloads correctly, no stale session data shown | Y | UI (Selenium) |
| TC-DASH-003 | Security | High | Access Dashboard URL directly without logging in | Redirects to Login, no data exposed | Y | API (REST-assured) |

### Patient Registration (Sprint 2.10)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-PREG-001 | Functional | Critical | Register a new synthetic patient with all required fields valid | Record saves, appears in patient list with correct data | Y | API (REST-assured) |
| TC-PREG-002 | Negative | High | Submit with a required field missing (e.g., DOB) | Server-side validation blocks save, clear error returned | Y | API (REST-assured) |
| TC-PREG-003 | Boundary | Medium | Submit DOB of today (newborn) and DOB 120 years ago | Both accepted if plausible; reject DOB in the future | Y | API (REST-assured) |
| TC-PREG-004 | Functional | High | Register two synthetic patients with identical name but different DOB | Both save as distinct records, no false duplicate-merge | Y | API + DB check |
| TC-PREG-005 | Security | Critical | Confirm no real-looking PHI patterns are hard-coded anywhere in test fixtures | All fixtures are clearly synthetic | N | Manual review only |

### Book Appointment (Sprint 2.11)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-BOOK-001 | Functional | Critical | Book an open slot for a synthetic patient | Appointment saves, slot marked unavailable | Y | API (REST-assured) |
| TC-BOOK-002 | Concurrency | Critical | Two near-simultaneous booking requests for the same slot | Exactly one succeeds, one gets a clean "slot no longer available," no double-booking | Y | JMeter (concurrent threads) |
| TC-BOOK-003 | Functional | High | Interrupt a booking mid-transaction (e.g., simulate DB error after partial write) | Transaction rolls back fully, no orphaned row | Y | API + DB check |
| TC-BOOK-004 | Boundary | Medium | Attempt to book a slot in the past | Rejected with clear validation message | Y | API (REST-assured) |

### Cancel/Reschedule Appointment (Sprint 2.12)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-CANC-001 | Functional | High | Cancel an appointment more than 24 hours out | Cancels successfully, slot reopens | Y | API (REST-assured) |
| TC-CANC-002 | Negative | Critical | Attempt to cancel within the 24-hour window | Blocked with the business-rule error message | Y | API (REST-assured) |
| TC-CANC-003 | Functional | Medium | Reschedule to a new valid open slot | Old slot reopens, new slot reserved, single consistent record | Y | API + DB check |

### Profile (Sprint 2.13)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-PROF-001 | Functional | Medium | View own profile after login | Correct data displayed for logged-in user only | Y | UI (Selenium) |
| TC-PROF-002 | Security | Critical | Attempt to view/edit another user's profile by manipulating a URL/ID parameter | Access denied (no IDOR) | Y | API (REST-assured) |

### Visit History (Sprint 2.14)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-VISIT-001 | Functional | High | View visit history for a patient with 50+ synthetic visit records | Pagination works, correct records per page, correct ordering | Y | UI + API |
| TC-VISIT-002 | Boundary | Medium | View visit history for a patient with zero visits | Empty state displays cleanly, no error | Y | UI (Selenium) |
| TC-VISIT-003 | Functional | Medium | Jump to last page of a large result set | Correct final page shown, no off-by-one error | Y | API (REST-assured) |

### Logout (Sprint 2.15)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-LOGOUT-001 | Functional | Critical | Click Logout | Session invalidates, redirected to Login | Y | UI (Selenium) |
| TC-LOGOUT-002 | Security | Critical | After logout, use browser back button | Cannot reach authenticated pages from cache | Y | UI (Selenium) |
| TC-LOGOUT-003 | Functional | Medium | Leave session idle past timeout threshold | Session auto-invalidates, next action redirects to Login | Y | UI + timer-based test |

### Lab Order & Referral Routing (Sprint 2.17)

| ID | Type | Priority | Steps (summary) | Expected Result | Automation Candidate | Suggested Approach |
|---|---|---|---|---|---|---|
| TC-LABQ-001 | Functional | Critical | Submit a lab order/referral | Message lands on MQ queue, MDB consumes it, audit row appears in PostgreSQL | Y | API + MQ + DB check |
| TC-LABQ-002 | Negative | High | Submit a malformed order (missing required field) | Rejected before reaching MQ, or lands on DLQ with clear reason if rejected downstream | Y | API + MQ check |
| TC-LABQ-003 | Integration | Critical | Submit 10 orders rapidly | All 10 processed, in order, no duplicates, all audited | Y | JMeter + DB check |
| TC-LABQ-004 | Security | High | Confirm audit trail captures who submitted each order and when | Every record has a complete, tamper-evident audit entry | Y | DB check |

---

## Automation Roadmap (for later — don't build this yet)

When Phase 4/5 tooling comes online, this suite maps to:

| Layer | Tool | What moves here first |
|---|---|---|
| API-level functional/negative/boundary | REST-assured or Postman/Newman | Anything marked "API" above — fastest ROI, least brittle |
| UI-level smoke tests | Selenium or Playwright | Login, Logout, Dashboard — high-traffic, stable paths |
| Concurrency/load-flavored cases | JMeter | TC-BOOK-002, TC-LABQ-003 — already ties into Sprint 3.9 |
| Security | OWASP ZAP (or similar) | TC-LOGIN-003/005, TC-PROF-002 — ties into Sprint 3.1/4.7 |
| Pipeline wiring | Jenkins/Ansible concepts | Sprint 4.9 and 5.10 — where all of the above gets triggered on every build |

**Rule of thumb:** automate a test only after it's been run manually, correctly, at least twice — automating a test you don't yet trust just automates the wrong answer.
