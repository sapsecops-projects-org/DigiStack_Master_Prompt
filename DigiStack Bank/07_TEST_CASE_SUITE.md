# TEST CASE SUITE — DigiStack Bank

**Current mode: Manual execution** (Phase 2 onward, as each module is built).
**Future mode: Automated** — this suite becomes the regression pack automated in Part 3, Sprint 3.P8 (Test Automation), using JUnit/TestNG + Selenium/RestAssured wired into the CI pipeline. Do not delete or rewrite test cases when automating — convert them 1:1 so coverage doesn't silently shrink.

Each test case: **ID · Module · Type · Steps · Expected Result**. Log actual results and any defects found in the Progress Log entry for that sprint.

---

## 1. Create Account

| ID | Type | Steps | Expected Result |
|---|---|---|---|
| CA-01 | Functional | Create account with valid name, DOB, initial deposit | Account created, unique account number generated |
| CA-02 | Negative | Submit with empty required field | Validation error, no account created |
| CA-03 | Negative | Submit with negative initial deposit | Rejected with clear error message |
| CA-04 | Edge | Initial deposit = 0 | Confirm expected behavior (allowed or rejected — define business rule) |
| CA-05 | Negative | Duplicate account creation (same identity details) | System either blocks or clearly allows per business rule — verify actual behavior matches intent |
| CA-06 | Security-lite | Enter `<script>alert(1)</script>` in name field | Input sanitized/escaped, not executed or stored raw |
| CA-07 | Boundary | Very long name (255+ chars) | Handled gracefully — truncated or rejected, not a server error |

## 2. Customer Login

| ID | Type | Steps | Expected Result |
|---|---|---|---|
| LG-01 | Functional | Valid credentials | Login succeeds, redirected to dashboard |
| LG-02 | Negative | Wrong password | Login fails, generic error (no "user exists" leak) |
| LG-03 | Negative | Non-existent account number | Login fails, same generic error as LG-02 |
| LG-04 | Security-lite | SQL injection attempt in username field (e.g., `' OR '1'='1`) | Rejected/escaped, no auth bypass, no DB error surfaced to user |
| LG-05 | Session | Log in, then let session idle past timeout | Session expires, redirected to login on next action |
| LG-06 | Session | Log in on two devices/tabs with the same account | Verify actual behavior — both allowed, or second invalidates first (define and confirm business rule) |
| LG-07 | Functional (post-4.7) | TAI/pre-authenticated header path (once SSO sprint is built) | Trusted header bypasses normal login form as designed |

## 3. Check Balance

| ID | Type | Steps | Expected Result |
|---|---|---|---|
| CB-01 | Functional | View balance after login | Correct current balance displayed |
| CB-02 | Functional | Balance updates immediately after a completed transfer | New balance reflects the transfer with no stale cache (ties to Dynacache sprint 6.8 — verify cache invalidation on write) |
| CB-03 | Edge | Balance = 0 | Displays "0" cleanly, not blank/error |
| CB-04 | Negative | Direct URL access to balance page without logging in | Redirected to login, no data leak |

## 4. Manage Beneficiary

| ID | Type | Steps | Expected Result |
|---|---|---|---|
| MB-01 | Functional | Add a valid beneficiary | Beneficiary saved and listed |
| MB-02 | Negative | Add beneficiary with invalid/malformed account number | Rejected with clear error |
| MB-03 | Functional | Delete a beneficiary | Removed from list, no longer selectable for transfer |
| MB-04 | Edge | Add self as beneficiary | Verify actual behavior — block or allow per business rule |
| MB-05 | Security-lite | XSS attempt in beneficiary nickname field | Sanitized/escaped, not executed |
| MB-06 | Boundary | Add maximum allowed number of beneficiaries (if a cap exists) | Correct enforcement at the limit |

## 5. Transfer Money (+ Dual Notification)

| ID | Type | Steps | Expected Result |
|---|---|---|---|
| TM-01 | Functional | Transfer valid amount to a valid beneficiary | Balance debited, receiver credited, both notified |
| TM-02 | Negative | Transfer amount greater than available balance | Rejected, no partial debit, balance unchanged |
| TM-03 | Negative | Transfer negative or zero amount | Rejected with validation error |
| TM-04 | Edge | Transfer exact full balance to zero | Succeeds cleanly, balance shows 0, no rounding error |
| TM-05 | Concurrency | Two simultaneous transfer requests that would each individually succeed but together overdraw the account | Only one succeeds, or both succeed only if funds allow — no double-spend (this is the real XA/transaction-integrity test tied to sprint 2.5/3.7) |
| TM-06 | Dual Notification | Complete a transfer | Both sender and receiver notification inbox entries appear, correct amounts/timestamps |
| TM-07 | MQ Resilience | Simulate MQ queue manager down during transfer (ties to sprint 4.13 MQ HA) | Transfer either queues for later delivery or fails gracefully — no silent notification loss |
| TM-08 | MQ Payload | Inspect the MQ message during a transfer | Structured XML/JSON with transaction ID, timestamp, amount (per sprint 3.7 spec) |
| TM-09 | Stale Connection | Trigger the stale-connection endpoint variant during a transfer (sprint 6.9) | Purge Policy recovers cleanly, transfer eventually succeeds or fails cleanly — no hung request |
| TM-10 | Slow Endpoint | Trigger the toggleable slow endpoint during a transfer (Advanced Block / Monitoring Policy sprint 5.6) | Request eventually completes or times out gracefully; if hang persists, Node Agent auto-restart should engage per 5.6 |

## 6. Cross-Cutting / Infrastructure-Facing

| ID | Type | Steps | Expected Result |
|---|---|---|---|
| XC-01 | Failover | Kill one cluster member mid-session (ties to 3.1/5.4) | Session continues on surviving member (if replication configured) or user is cleanly re-prompted to log in |
| XC-02 | Health Check | Hit `/health` endpoint directly (sprint 3.8) | Reports DB connectivity status and correct cluster member identity |
| XC-03 | Version Verify | Check footer build-version stamp after a deploy | Matches the version just deployed — critical for rolling deployment sprint 5.7 |
| XC-04 | Environment Scope | Check "Environment Scope" footer after setting a property at multiple scopes (sprint 4.9) | Displays the value from the correct (winning) scope |
| XC-05 | Multi-App Coexistence | With Ops Utility app co-deployed (sprint 4.10), redeploy DigiStack Bank | Ops Utility app remains unaffected — proves class loader isolation |

---

## Notes on Automation (Part 3, Sprint 3.P8)
- Convert each row above into an automated test method, keeping the ID as the test name/tag for traceability.
- Functional + Negative + Boundary cases → good candidates for early automation (stable, deterministic).
- Concurrency (TM-05), MQ Resilience (TM-07), and Failover (XC-01) cases are harder to automate reliably — may need chaos-style scripting or may remain manual/scripted-manual even post-automation. Flag this honestly rather than faking green coverage.
