# DigiStack Bank — Test Case Standards

**Applies to:** Every version, every part. Each version gets its **own** test case file: `TestCases-v<N>.md`, committed to the repo alongside the code (per Git Standards).

---

## Why a Separate File Per Version

Real QA teams maintain traceable, versioned test suites — not one giant untracked test file. `TestCases-v<N>.md` lets you (or a fresh Claude chat) verify a version is actually done before promoting Dev → UAT → Prod.

## Standard Test Case Template

Copy this structure for every version's `TestCases-v<N>.md`:

```markdown
# Test Cases — Version <N>: <Title>

**Module:** <Portal / CBS / Both>
**Environment tested:** Dev
**Tester:** <you>
**Date:** <date>
**Related Sprint Deliverable:** <copy from roadmap>

---

## Test Summary

| Total Cases | Passed | Failed | Blocked | Not Run |
|---|---|---|---|---|
| | | | | |

---

## Functional Test Cases

| TC ID | Title | Precondition | Steps | Expected Result | Actual Result | Status (Pass/Fail) | Priority |
|---|---|---|---|---|---|---|---|
| TC-V<N>-001 | | | 1. 2. 3. | | | | High/Med/Low |
| TC-V<N>-002 | | | | | | | |

## Negative / Edge Case Test Cases

| TC ID | Title | Steps | Expected Result | Actual Result | Status | Priority |
|---|---|---|---|---|---|---|
| TC-V<N>-N01 | | | | | | |

## WebSphere Admin Verification Cases

> Specific to this project — verifying the WAS admin config, not just app behavior.

| TC ID | Title | Admin Console / wsadmin Step | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|
| TC-V<N>-A01 | | | | | |

## Non-Functional Cases (as applicable per version)

| TC ID | Category | Title | Steps | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| TC-V<N>-NF01 | Performance | | | | | |
| TC-V<N>-NF02 | Security | | | | | |
| TC-V<N>-NF03 | Failover/HA | | | | | |

## Defects Found

| Defect ID | Description | Severity | Status | Fixed In Commit |
|---|---|---|---|---|
| DEF-V<N>-001 | | Critical/High/Med/Low | Open/Fixed/Deferred | |

---

## Sign-off

- [ ] All High-priority cases passed
- [ ] No open Critical/High defects
- [ ] Sprint Deliverable (from roadmap) demonstrably met
- [ ] Ready to promote to UAT

**Approved by:** __________  **Date:** __________
```

## Test Case ID Convention

```
TC-V<N>-###     → functional
TC-V<N>-N##     → negative/edge case
TC-V<N>-A##     → WebSphere admin verification
TC-V<N>-NF##    → non-functional (performance/security/HA)
DEF-V<N>-###    → defects
```

## Minimum Coverage Expectations Per Version Type

- **Feature versions** (e.g., v2 Login, v13 Notifications): functional + negative cases covering every listed Banking Feature.
- **Infra/admin versions** (e.g., v4 WAS Deployment, v11 SSL): heavy on WebSphere Admin Verification cases — these are just as important as functional ones for this project's actual goal (WAS admin practice).
- **Clustering/HA versions** (v5, v9, v21): must include failover non-functional cases (kill a node, confirm session/traffic recovers).
- **Security versions** (v9, v10, v11, v12, v17): must include negative cases (wrong password lockout, expired session, invalid cert, unauthorized role access).

## Rule

**No version is marked "Approved" in the Progress Log until its `TestCases-v<N>.md` sign-off section is fully checked off.** This is the gate between Dev-complete and eligible-for-UAT-promotion (see Environment Promotion Standards).

---

*This file is a standing standard. Each version's actual test cases live in their own `TestCases-v<N>.md` file, built from this template.*
