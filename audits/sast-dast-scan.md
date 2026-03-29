# SAST/DAST Security Scan Report

**Project:** post-commit-audit
**Scan Date:** 2026-03-29 (Fourth-pass Re-audit — post SHA-pin + dead-code removal)
**Scanner:** Manual SAST/DAST review (LLM-driven)
**Files Scanned:** 12 (updated: .github/workflows/lint.yml, skills/post-commit-audit/scripts/run-audit-suite.sh, .claude-plugin/plugin.json)
**Commits Since Last Audit:** 26c388a, ed7892b

---

## Before/After Summary (This Cycle)

| Severity | Cycle 3 | Cycle 4 | Delta |
|----------|---------|---------|-------|
| CRITICAL | 0 | 0 | — |
| HIGH | 0 | 0 | — |
| MEDIUM | 1 | 1 | — |
| LOW | 0 | 0 | — |
| INFO | 2 | 2 | — |
| **Total** | **3** | **3** | **—** |

No new findings. Both new commits improve the security posture without introducing new issues.

---

## Historical Resolved Findings (Cumulative Record)

### RESOLVED — Path Traversal Guard (was HIGH, CWE-22)
- **Fix:** Canonicalization-first approach via `cd && pwd` with error handling.
- **Commit:** 1ec805c

### RESOLVED — Unsanitized Variable in Commit Message (was MEDIUM, CWE-78)
- **Fix:** ISO 8601 format validation on `$TIMESTAMP` before interpolation.
- **Commit:** 1ec805c

### RESOLVED — Arithmetic Injection via grep Output (was MEDIUM, CWE-78)
- **Fix:** Numeric validation (`^[0-9]+$`) before arithmetic use.
- **Commit:** 1ec805c

### RESOLVED — Overly Permissive `git add` Scope (was LOW, CWE-732)
- **Fix:** Explicit loop staging only the 6 expected report filenames.
- **Commit:** 1ec805c

### RESOLVED — Missing `--push` Confirmation Gate (was LOW, CWE-862)
- **Fix:** Interactive `read -rp` confirmation before `git push`.
- **Commit:** 1ec805c

### RESOLVED — No ShellCheck Directive (was INFO, CWE-710)
- **Fix:** `# shellcheck shell=bash` directive added.
- **Commit:** 1ec805c

### RESOLVED — Unused Variable Assignments (was INFO, CWE-710)
- **Fix:** Removed unused `DO_FIX` variable and `SCRIPT_DIR` assignment. Eliminates dead code paths that ShellCheck flagged as SC2034.
- **Commit:** ed7892b

---

## New Commits — Security Assessment

### 26c388a — `chore: v1.0.1 — SHA-pin CI actions, add permissions block, bump version`

**`.github/workflows/lint.yml` changes:**
- `actions/checkout@v4` → `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683` (immutable SHA)
- `ludeeus/action-shellcheck@2.0.0` → `ludeeus/action-shellcheck@00cae500b08a931fb5698e11e79bfbd38e612a38` (immutable SHA)
- Added `permissions: contents: read` at workflow level

These are security hardening changes. SHA-pinning eliminates the supply chain attack surface of mutable tags. The `permissions: contents: read` block explicitly restricts the workflow token to read-only — a defense-in-depth measure that prevents the workflow from writing to the repo even if a step is compromised.

**Assessment:** SAST CLEAN — no new code paths, only tightening of existing controls.

**`.claude-plugin/plugin.json` changes:**
- Version bumped from 1.0.0 → 1.0.1. No executable code.

**Assessment:** CLEAN

### ed7892b — `fix: resolve SC2034 ShellCheck warnings — unused variable assignments`

**`skills/post-commit-audit/scripts/run-audit-suite.sh` changes:**
- Removed `DO_FIX=false` and the `--fix` case branch (dead code — no code invoked `DO_FIX`)
- Removed `SCRIPT_DIR="$(cd ... && pwd)"` assignment (assigned but never used)

Removes dead code. The `--fix` case branch was never functional — it set a variable that was never read. Removing it tightens the script's behavior contract and eliminates a potential future confusion vector. The `SCRIPT_DIR` removal slightly reduces the script's attack surface (one fewer `cd` invocation at startup).

**Assessment:** CLEAN. Positive change — reduces code surface and eliminates ShellCheck SC2034 violations.

---

## Remaining Findings (Carried Forward)

### MEDIUM — TOCTOU on Report File Existence Checks

- **CWE:** CWE-367 (Time-of-Check Time-of-Use Race Condition)
- **File:** `skills/post-commit-audit/scripts/run-audit-suite.sh:75-131`
- **Description:** File existence checks (`[ -f ... ]`) have a TOCTOU window between check and summary generation. No checksum or freshness validation on report files.
- **Risk context:** Single-user CLI tool. Exploitation requires local access and race timing. Accepted residual risk — unchanged since Cycle 2.
- **Remediation:** Add freshness check (e.g., compare mtime or SHA-256 verification of report files before summary generation).

### INFO — Summary File Overwritten Without Backup

- **CWE:** CWE-367
- **File:** `skills/post-commit-audit/scripts/run-audit-suite.sh:168`
- **Description:** `AUDIT_SUMMARY.txt` is unconditionally overwritten. Acceptable for an audit tool — latest summary is authoritative. Prior summaries preserved via git history.

### INFO — Hardcoded Secrets Check: CLEAN

- No API keys, tokens, passwords, or credentials found in any file across all 12 scanned files.

---

## DAST Findings

N/A — no web-facing components.

---

## Overall Assessment

**PASS** — 0 critical, 0 high, 1 medium (accepted residual risk). Two new commits both represent pure security improvements. No regressions. Dead code removed, CI hardened with SHA-pinned actions and explicit permissions restriction.
