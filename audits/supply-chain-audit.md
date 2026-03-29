# Supply Chain Security Audit Report

**Project:** post-commit-audit
**Audit Date:** 2026-03-29 (Fourth-pass Re-audit — post SHA-pin + permissions block)
**Branch:** master
**SLSA Level:** L1 (unchanged — scripted build via GitHub Actions)
**Commits Since Last Audit:** 26c388a, ed7892b

---

## Before/After Summary (Cumulative)

| Finding | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 (Now) | Status |
|---------|---------|---------|---------|---------------|--------|
| H-1: No `.gitignore` | HIGH | RESOLVED (1ec805c) | — | — | CLOSED |
| H-2: No commit signing | HIGH | OPEN | RESOLVED (0bbc390) | — | CLOSED |
| H-3: No CI/CD pipeline | HIGH | OPEN | RESOLVED (535b5e1) | — | CLOSED |
| M-1: No SBOM | MEDIUM | OPEN | OPEN | OPEN | OPEN |
| M-2: Unsigned auto-commits | MEDIUM | OPEN | OPEN | OPEN | OPEN |
| M-3: Incomplete path check | MEDIUM | RESOLVED (1ec805c) | — | — | CLOSED |
| M-4: No branch protection | MEDIUM | OPEN | OPEN | OPEN | OPEN |
| N-1: Action versions unpinned | — | — | OPEN (535b5e1) | RESOLVED (26c388a) | CLOSED |
| N-2: Overprivileged workflow token | — | — | — | RESOLVED (26c388a) | CLOSED |
| L-1: No dep manifest | LOW | INFO | INFO | INFO | DOCUMENTED |

**Resolved this cycle:** N-1 (MEDIUM), N-2 (new + resolved same cycle)
**Still open:** M-1, M-2, M-4 (all MEDIUM)

---

## SLSA Level Assessment: L1 (unchanged)

| SLSA Requirement | Cycle 3 | Cycle 4 | Notes |
|---|---|---|---|
| Source versioned | MET | MET | Git repo, SSH-signed commits |
| Build scripted | MET | MET | ShellCheck CI via lint.yml |
| Build service | MET | MET | GitHub Actions |
| Actions integrity | ABSENT | IMPROVED | SHA-pinned actions eliminate mutable tag risk |
| Provenance generated | ABSENT | ABSENT | No SLSA provenance action |
| Hermetic build | ABSENT | ABSENT | Not applicable for bash-only project |

Moving to L2 requires provenance generation (e.g., slsa-framework/slsa-github-generator).

---

## Current Risk Matrix

| Severity | Count | Delta (this cycle) |
|---|---|---|
| CRITICAL | 0 | — |
| HIGH | 0 | — |
| MEDIUM | 3 | -1 net (N-1 closed, N-2 added+closed) |
| LOW | 0 | — |
| INFO | 1 | — |

---

## Resolved This Cycle

**N-1: GitHub Actions Versions Not SHA-Pinned — RESOLVED (26c388a)**
- `actions/checkout@v4` → `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683`
- `ludeeus/action-shellcheck@2.0.0` → `ludeeus/action-shellcheck@00cae500b08a931fb5698e11e79bfbd38e612a38`
- Mutable tag pinning eliminated. CI pipeline is now resilient to action author tag force-push.
- **Impact:** CWE-829 (Inclusion of Functionality from Untrusted Control Sphere) RESOLVED.

**N-2: Overprivileged Workflow Token — NEW + RESOLVED (26c388a)**
- Previous workflow had no explicit `permissions` block, inheriting GitHub default token permissions.
- `permissions: contents: read` added at workflow level.
- The linting workflow has no need for write access. Read-only constraint is now explicit.
- **Impact:** CWE-269 (Improper Privilege Management) mitigated.

---

## Remaining Open Findings

### M-1: No SBOM (MEDIUM)
- No Software Bill of Materials artifact generated.
- The project has zero third-party code dependencies but relies on system tools: bash ≥ 4.0, git, coreutils, shellcheck (CI only).
- **Remediation:** Use `anchore/sbom-action` or generate a minimal CycloneDX 1.4 SBOM documenting system tool requirements and the ShellCheck action version.

### M-2: Automated Commits Not Signed (MEDIUM, Partial)
- `run-audit-suite.sh --push` codepath generates unsigned commits (`git commit` without `-S` flag).
- Manual commits by Justice are signed (H-2 resolved). Script-generated commits would not carry the SSH signature.
- **Remediation:** Add `-S` to the `git commit` call in the `--push` codepath at line 207, or set `commit.gpgsign=true` in the system git config so the flag is automatic.

### M-4: No Branch Protection (MEDIUM)
- No GitHub branch protection rules enforced on `master`.
- No required status checks, no required PR reviews.
- **Remediation:** Enable via GitHub Settings → Branches → Add rule for `master`. At minimum: require `lint` status check to pass before merge.

---

## New Positive Findings This Cycle

**P-4: SHA-Pinned GitHub Actions**
- Both workflow actions now reference immutable SHA digests.
- CI pipeline is no longer susceptible to supply chain injection via action tag manipulation.

**P-5: Explicit Read-Only Workflow Permissions**
- `permissions: contents: read` explicitly prevents the CI workflow from writing to the repository.
- Defense-in-depth: even if a future step is compromised, it cannot push code or modify branch refs.

---

## Framework Compliance (Updated)

| Framework | Requirement | Cycle 3 | Cycle 4 |
|---|---|---|---|
| NIST SP 800-218A PS.1 | Protect code | IMPROVED | IMPROVED — SHA-pinned pipeline |
| NIST SP 800-218A RV.1 | Identify vulnerabilities | GOOD | GOOD |
| NIST SP 800-218A PW.9 | Use automated testing | MET | MET |
| SLSA Source L1 | Version controlled | MET | MET |
| SLSA Build L1 | Scripted build | MET | MET |
| SLSA Build L2 | Build service + provenance | NOT MET | NOT MET |
| ISO 27001 A.12.6 | Vulnerability management | IMPROVED | IMPROVED |
| ISO 27001 A.14.2 | Secure development | IMPROVED | IMPROVED — SHA-pinned CI |
| ISO 27001 A.15 | Supplier relationships | PARTIAL | IMPROVED — SHA pinning + permissions |
