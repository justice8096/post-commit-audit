# Supply Chain Security Audit Report

**Project:** post-commit-audit
**Audit Date:** 2026-03-29 (Third-pass Re-audit — post CI/CD + signing)
**Branch:** master
**SLSA Level:** L1 (Scripted Build — upgraded from L0)
**Commits Since Last Audit:** 0bbc390, 535b5e1, 9c8facc, a72687a, 819c50a

---

## Before/After Summary (Cumulative)

| Finding | Cycle 1 | Cycle 2 | Cycle 3 (Now) | Status |
|---------|---------|---------|---------------|--------|
| H-1: No `.gitignore` | HIGH | RESOLVED (1ec805c) | — | CLOSED |
| H-2: No commit signing | HIGH | OPEN | RESOLVED (0bbc390) | CLOSED |
| H-3: No CI/CD pipeline | HIGH | OPEN | RESOLVED (535b5e1) | CLOSED |
| M-1: No SBOM | MEDIUM | OPEN | OPEN | OPEN |
| M-2: Unsigned auto-commits | MEDIUM | OPEN | IMPROVED | PARTIAL |
| M-3: Incomplete path check | MEDIUM | RESOLVED (1ec805c) | — | CLOSED |
| M-4: No branch protection | MEDIUM | OPEN | OPEN | OPEN |
| N-1: Action versions unpinned | — | — | NEW (535b5e1) | NEW/MEDIUM |
| L-1: No dep manifest | LOW | INFO | INFO | DOCUMENTED |
| L-2: Fragile grep counter | LOW | RESOLVED (1ec805c) | — | CLOSED |

**Resolved this cycle:** H-2, H-3 (both HIGH)
**New finding this cycle:** N-1 (MEDIUM — GitHub Actions versions not SHA-pinned)
**Still open:** M-1, M-2 (partial), M-4, N-1

---

## SLSA Level Assessment: L1 (upgraded from L0)

| SLSA Requirement | Previous | Current | Notes |
|---|---|---|---|
| Source versioned | PARTIAL | MET | Git repo, SSH-signed commits |
| Build scripted | PARTIAL | MET | ShellCheck CI via lint.yml |
| Build service | ABSENT | MET | GitHub Actions (ludeeus/action-shellcheck@2.0.0) |
| Provenance generated | ABSENT | ABSENT | No SLSA provenance action |
| Hermetic build | ABSENT | ABSENT | Not applicable for bash-only project |

**Upgraded to L1** by adding a CI pipeline with scripted, automated linting. Moving to L2 requires provenance generation (e.g., slsa-framework/slsa-github-generator).

---

## Current Risk Matrix

| Severity | Count | Delta (this cycle) |
|---|---|---|
| CRITICAL | 0 | — |
| HIGH | 0 | -2 |
| MEDIUM | 3 | +1 net (N-1 added, no others closed) |
| LOW | 0 | — |
| INFO | 1 | — |

---

## Resolved This Cycle

**H-2: Commit Signing — RESOLVED**
- SSH commit signing configured and verified via `test: verify SSH commit signing` (0bbc390).
- All subsequent commits (535b5e1, 9c8facc, a72687a, 819c50a) show `G` (good/verified SSH signature).
- Signing key: `justice8096@gmail.com` (SSH key).
- **Impact:** CWE-345 (Insufficient Data Authenticity) RESOLVED for new commits. Pre-signing commits remain unsigned in history — acceptable given they are in a public audit repo.

**H-3: No CI/CD Pipeline — RESOLVED**
- GitHub Actions ShellCheck workflow added (535b5e1): `.github/workflows/lint.yml`.
- Triggers on `push` and `pull_request`. Scans `skills/post-commit-audit/scripts`.
- ShellCheck enforced on every push — automated security gate now active.
- **Impact:** CWE-693 (Protection Mechanism Failure) substantially mitigated.

---

## New Finding This Cycle

### N-1 — GitHub Actions Versions Not SHA-Pinned (MEDIUM, CWE-829)

- **File:** `.github/workflows/lint.yml`
- **Finding:** `actions/checkout@v4` and `ludeeus/action-shellcheck@2.0.0` are pinned to mutable tags, not immutable SHA digests.
- **Risk:** A tag can be force-pushed by the action author to point to different code, enabling supply chain injection into the CI pipeline.
- **Remediation:** Pin to full SHA:
  ```yaml
  - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4.2.2
  - uses: ludeeus/action-shellcheck@00cae500b08a931fb5698e11e79bfbd38e612a38  # 2.0.0
  ```
- **Severity rationale:** MEDIUM (not HIGH) because the project is a bash-only skill with no production secrets, no deployment pipeline, and no token exposure in the workflow.

---

## Remaining Open Findings

### M-1: No SBOM
- No Software Bill of Materials artifact generated.
- **Remediation:** Use `anchore/sbom-action` or `cyclonedx-cli` to generate CycloneDX 1.4 SBOM documenting system tool requirements (bash, git, shellcheck).

### M-2: Automated Commits Not Signed (Partial)
- `run-audit-suite.sh --push` codepath commits without `--gpg-sign` or `--no-gpg-sign`.
- Manual commits by Justice are now signed (H-2 resolved). Automated script-generated commits would be unsigned.
- **Remediation:** Add `-S` or `--gpg-sign` to the `git commit` call in the script's `--push` codepath; or rely on `commit.gpgsign=true` in git config.

### M-4: No Branch Protection
- No GitHub branch protection rules enforced on `master`.
- No required status checks, no required PR reviews, no dismiss-stale-reviews.
- **Remediation:** Enable via GitHub Settings → Branches → Add rule for `master`. Require `lint` status check to pass.

---

## New Positive Findings This Cycle

**P-1: SSH Commit Signing Active**
- All commits from 0bbc390 onward carry verified SSH signatures.
- Establishes non-repudiation for authorship.

**P-2: ShellCheck CI Enforced**
- Every push and PR now runs ShellCheck against the orchestration script.
- Catches CWE-78/CWE-710 class issues automatically before merge.

**P-3: plugin.json Manifest Added**
- `.claude-plugin/plugin.json` documents the skill for Claude Code discovery.
- Improves supply chain transparency — dependency consumers can identify the skill version.

---

## Framework Compliance (Updated)

| Framework | Requirement | Cycle 2 | Cycle 3 |
|---|---|---|---|
| NIST SP 800-218A PS.1 | Protect code | IMPROVED | IMPROVED — signing active |
| NIST SP 800-218A RV.1 | Identify vulnerabilities | IMPROVED | IMPROVED — CI/CD active |
| NIST SP 800-218A PW.9 | Use automated testing | NOT MET | MET — ShellCheck CI |
| SLSA Source L1 | Version controlled | MET | MET |
| SLSA Build L1 | Scripted build | NOT MET | MET — GitHub Actions |
| SLSA Build L2 | Build service + provenance | NOT MET | NOT MET |
| ISO 27001 A.12.6 | Vulnerability management | PARTIAL | IMPROVED — CI gates |
| ISO 27001 A.14.2 | Secure development | PARTIAL | IMPROVED — signing |
