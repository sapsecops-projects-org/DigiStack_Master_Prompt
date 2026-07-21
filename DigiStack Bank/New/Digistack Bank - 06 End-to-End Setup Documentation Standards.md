# DigiStack Bank — End-to-End Setup Documentation Standards

**Applies to:** Every version gets its own `SetupDoc-v<N>.md` — a complete, self-contained runbook that lets you (or anyone) build that version's environment and deploy that version's code from a blank VM, using only that document.

---

## Why This Matters

This is the actual deliverable that fills your 10-year gap: real WebSphere admins live by exactly this kind of setup documentation. If `SetupDoc-v<N>.md` can't stand alone, it's not done.

## Standard Template — `SetupDoc-v<N>.md`

```markdown
# Setup Documentation — Version <N>: <Title>

**Part:** <Part number and title>
**Prerequisite versions completed:** v1...v<N-1>
**Estimated setup time:** <realistic estimate>

---

## 1. Overview
What this version adds, in 2-3 sentences. Link back to the roadmap entry.

## 2. VM Setup
(Per VM Setup Standards doc — reference it, don't repeat it verbatim; call out anything version-specific)
- VM(s) involved:
- New packages to install:
- Ports to open:

## 3. Pre-Deployment Checklist
- [ ] Previous version's SetupDoc completed and verified
- [ ] VM snapshot taken (pre-v<N>)
- [ ] Git branch `feature/v<N>-<desc>` created from latest `develop`

## 4. Step-by-Step Configuration

### 4.1 WebSphere Admin Console Steps
Numbered, exact clicks/fields, with **expected result shown inline** after each step (per your standing preference — no "run and paste back").

### 4.2 wsadmin / Command-Line Steps (if applicable)
Exact commands and expected console output shown inline.

### 4.3 Database Changes (if applicable)
Reference the specific migration script: `V<N>__<description>.sql` (per DB Deployment Standards). Show the exact command to run it and expected confirmation output.

### 4.4 Application Deployment
EAR/WAR build and deploy steps, referencing the artifact naming convention (`digistack-bank-v<N>.ear`).

## 5. Verification Steps
How to confirm the version actually works — cross-references `TestCases-v<N>.md`, doesn't duplicate it.

## 6. Rollback Procedure
Exact steps to undo this version's changes if something breaks — VM snapshot restore, or manual undo steps if snapshot isn't available (e.g., DB rollback script, EAR redeploy of previous version).

## 7. Known Issues / Troubleshooting
Populated as issues are actually found during your build — this section grows over time and becomes genuinely valuable.

## 8. Sign-off
- [ ] Setup completed successfully
- [ ] All verification steps passed
- [ ] Documentation reviewed for accuracy (i.e., you actually followed it start to finish, not just skimmed)

---
```

## Documentation Discipline Rules

1. **Write it as you go, not after.** The setup doc for v<N> is drafted *during* that version's sprint (development step), refined during testing, and finalized at approval — not reconstructed from memory afterward.
2. **No skipped steps.** If a step was "just click around until it worked," that's a documentation gap — go back and capture the actual click path.
3. **Screenshots optional but encouraged** for Admin Console-heavy steps (SSL, Security, Clustering) — real WAS admin documentation leans heavily on screenshots because the console UI isn't always intuitive to describe in words alone.
4. **Cross-reference, don't duplicate.** SetupDoc references TestCases and the DB migration script by filename rather than repeating their content — keeps each document focused and avoids drift when one gets updated.

## File Location

```
/docs
  /setup
    SetupDoc-v1.md
    SetupDoc-v2.md
    ...
  /testcases
    TestCases-v1.md
    TestCases-v2.md
    ...
```
Committed to Git alongside the code for that version (per Git Standards).

---

*This file is a standing standard. Each version's actual setup documentation is a new `SetupDoc-v<N>.md` built from this template, during that version's sprint.*
