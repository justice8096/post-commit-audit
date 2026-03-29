# SAST/DAST Security Scan Report

**Project:** post-commit-audit
**Scan Date:** 2026-03-29 (Third-pass Re-audit — post CI/CD + signing)
**Scanner:** Manual SAST/DAST review (LLM-driven)
**Files Scanned:** 10 (added: .github/workflows/lint.yml, .claude-plugin/plugin.json, updated SKILL.md, README.md)
**Commits Since Last Audit:** 0bbc390, 535b5e1, 9c8facc, a72687a, 819c50a

---

## Before/After Summary (This Cycle)

| Severity | Previous Audit | This Audit | Delta |
|----------|---------------|------------|-------|
| CRITICAL | 0 | 0 | — |
| HIGH | 0 | 0 | — |
| MEDIUM | 1 | 1 | — |
| LOW | 0 | 0 | — |
| INFO | 2 | 2 | — |
| **Total** | **3** | **3** | **—** |

No new findings introduced by the 5 new commits. Existing medium and info findings carry forward unchanged.

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

---

## New Commits — Security Assessment

### 0bbc390 — `test: verify SSH commit signing` (.gitignore +1 line)
- Added a comment line to `.gitignore`. No security impact.
- SSH commit signing configured and verified — all commits from this point show `G` (good signature).
- **Assessment:** CLEAN

### 535b5e1 — `ci: add ShellCheck lint workflow` (.github/workflows/lint.yml)
- Workflow triggers on `push` and `pull_request`.
- Uses `actions/checkout@v4` (SHA not pinned — see supply chain audit).
- Uses `ludeeus/action-shellcheck@2.0.0` (version-pinned to tag, not SHA — see supply chain audit).
- No secrets in workflow. `scandir` scoped to `skills/post-commit-audit/scripts`.
- **Assessment:** No SAST findings. Supply chain notes in supply-chain-audit.md.

### 9c8facc — `fix: resolve skill-reviewer findings` (SKILL.md, run-audit-suite.sh, README.md)
- `run-audit-suite.sh` changes: cosmetic status label changes (`INCOMPLETE` → `CONDITIONAL PASS`), finding-count improvements to AUDIT_SUMMARY output format.
- No new shell constructs, no new variable interpolations, no new external commands.
- **Assessment:** CLEAN

### a72687a — `chore: add plugin.json` (.claude-plugin/plugin.json)
- JSON manifest file. No executable code. No secrets.
- **Assessment:** CLEAN

### 819c50a — `chore: add CI and release badges` (README.md)
- Markdown only. No executable code.
- **Assessment:** CLEAN

---

## Remaining Findings (Carried Forward)

### MEDIUM — TOCTOU on Report File Existence Checks

- **CWE:** CWE-367 (Time-of-Check Time-of-Use Race Condition)
- **File:** `skills/post-commit-audit/scripts/run-audit-suite.sh:78-134`
- **Description:** File existence checks (`[ -f ... ]`) have a TOCTOU window. Between the check and summary generation, a file could be modified or replaced. No checksum or freshness validation.
- **Risk context:** Single-user CLI tool. Exploitation requires local access and race timing. Acceptable residual risk.
- **Remediation:** Add freshness check (e.g., compare mtime or add SHA-256 verification of report files before summary generation).

### INFO — Summary File Overwritten Without Backup

- **CWE:** CWE-367
- **File:** `skills/post-commit-audit/scripts/run-audit-suite.sh:164`
- **Description:** `AUDIT_SUMMARY.txt` is unconditionally overwritten. Acceptable for an audit tool — latest summary is authoritative. Prior summaries preserved via git history.

### INFO — Hardcoded Secrets Check: CLEAN

- No API keys, tokens, passwords, or credentials found in any file across all 10 scanned files.

---

## DAST Findings

N/A — no web-facing components.

---

## Overall Assessment

**PASS** — 0 critical, 0 high, 1 medium (accepted residual risk). All high-severity findings from prior cycles are resolved. No regressions introduced by the 5 new commits.
