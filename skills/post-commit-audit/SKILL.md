---
name: post-commit-audit
description: >
  Unified security and compliance audit suite that runs after every major git check-in. Orchestrates
  all three security scanners (sast-dast-scanner, supply-chain-security, cwe-mapper), generates an
  LLM Compliance report, and produces a human-vs-AI Contribution Analysis matrix. Use this skill
  whenever the user mentions: "run the full audit", "post-commit audit", "security check after merge",
  "run all security scanners", "compliance sweep", "audit this commit", "run the standard checks",
  "full security pass", or after any major feature branch merge, release tag, or significant code push.
  Also trigger proactively when the user completes a substantial coding task and pushes to git —
  this is the standard quality gate.
version: 1.0.0
author: Justice
license: MIT
---

# Post-Commit Audit Skill

A unified orchestration skill that runs the full security-and-compliance audit suite after every major git check-in. This is Justice's standard quality gate — it ensures no code ships without being scanned, classified, mapped to compliance frameworks, and attributed.

## When to Run

This skill is the standard post-commit quality gate. Run it:

- After merging a feature branch to main/master
- After tagging a release
- After pushing a significant batch of changes (new features, refactors, dependency updates)
- Before opening a PR for review (so findings ship with the PR)
- Whenever the user says "run the checks", "audit this", or "full security pass"

The goal is to catch issues early while the context is fresh, and to maintain a continuous compliance paper trail.

## What It Produces

Five audit reports per project, saved to `audits/` in the project root:

| # | Report | Source Skill | File |
|---|--------|-------------|------|
| 1 | SAST/DAST Scan | sast-dast-scanner | `audits/sast-dast-scan.md` |
| 2 | Supply Chain Audit | supply-chain-security | `audits/supply-chain-audit.md` |
| 3 | CWE Mapping | cwe-mapper | `audits/cwe-mapping.md` |
| 4 | LLM Compliance Report | (this skill) | `audits/llm-compliance-report.md` |
| 5 | Contribution Analysis | (this skill) | `audits/contribution-analysis.md` |

Plus an index file: `audits/AUDIT_SUMMARY.txt` with a one-line status per report.

## Audit Sequence

Run the five audits in this order. Steps 1-3 can run in parallel if subagents are available. Steps 4-5 depend on the findings from 1-3.

### Phase 1: Security Scanning (parallel)

These three scans are independent and can run concurrently.

#### Step 1 — SAST/DAST Scan

Use the **sast-dast-scanner** skill. If the skill is installed, trigger it. If not, perform the scan manually following the patterns below.

**SAST checks:**
- Injection patterns: SQL, command, XSS, path traversal, LDAP/XML
- Deserialization of untrusted data (pickle, eval, yaml.load without SafeLoader)
- Hardcoded secrets (API keys, tokens, passwords, private keys)
- ReDoS-vulnerable regex patterns (unbounded quantifiers, nested alternation)
- Cryptographic weaknesses (MD5/SHA1 for passwords, ECB mode, hardcoded IVs)
- Race conditions and TOCTOU vulnerabilities

**DAST checks:**
- HTTP security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- Cookie security flags (Secure, HttpOnly, SameSite)
- CORS configuration (overly permissive origins)
- TLS configuration

**Output format:** Markdown report with findings grouped by severity (CRITICAL → INFO), each finding with CWE reference, affected file/line, code snippet, and remediation guidance.

#### Step 2 — Supply Chain Audit

Use the **supply-chain-security** skill (supply-chain-auditor). Key checks:

- Dependency pinning: exact versions in lockfiles, no floating ranges in production
- Lockfile integrity: lockfile present, consistent with manifest, no orphaned deps
- CI/CD secret handling: no hardcoded tokens in workflows, pinned action versions, least-privilege permissions
- SBOM generation: CycloneDX 1.4 format bill of materials
- SLSA level assessment: L0 (no provenance) through L4 (hermetic build)

**Output format:** Markdown report with risk matrix, SLSA level, and framework compliance table.

#### Step 3 — CWE Mapping

Use the **cwe-mapper** skill. Takes the findings from Steps 1 and 2 and:

- Identifies CWE IDs for each finding using pattern-based detection
- Maps CWEs to 8 compliance frameworks:
  - OWASP Top 10 2021
  - OWASP LLM Top 10 2025
  - NIST SP 800-53
  - EU AI Act (Art. 25)
  - ISO 27001
  - SOC 2
  - MITRE ATT&CK
  - MITRE ATLAS
- Generates a compliance coverage matrix (CWE × Framework)

**Output format:** Markdown report with per-CWE framework mappings and an aggregate compliance matrix.

### Phase 2: Compliance & Attribution (sequential, after Phase 1)

These two reports synthesize the findings from Phase 1, so they run after scanning completes.

#### Step 4 — LLM Compliance Report

Read `references/llm-compliance-template.md` for the full template and scoring rubric.

This report evaluates the project across **8 compliance dimensions**, each scored 0-100:

1. **System Transparency** — Does the project disclose AI involvement and limitations?
2. **Training Data Disclosure** — Are framework sources and model provenance documented?
3. **Risk Classification** — How accurately does the project identify and classify risks?
4. **Supply Chain Security** — Is the development pipeline hardened?
5. **Consent & Authorization** — Does the user maintain control? Is the tool opt-in?
6. **Sensitive Data Handling** — Are secrets, PII, and credentials protected?
7. **Incident Response** — Are vulnerability remediation procedures in place?
8. **Bias Assessment** — Are false positive/negative rates fair and documented?

**Scoring context:** The report should reference specific findings from Phase 1. If a CWE was found and fixed, that improves Incident Response. If the supply chain audit found unpinned deps, that lowers Supply Chain Security. The scores should reflect the actual state of the code at this commit.

**Regulatory mappings:** Each dimension maps to specific articles/controls in EU AI Act, NIST SP 800-218A, ISO 27001, and SOC 2. See the reference doc for the exact mappings.

**If this is a re-audit** (previous compliance report exists in `audits/`), include a before/after delta table showing score changes per dimension.

#### Step 5 — Contribution Analysis

Read `references/contribution-analysis-template.md` for the full template.

This report documents the human-vs-AI contribution breakdown across the work that led to this commit. The matrix covers these dimensions:

| Dimension | What to Measure |
|-----------|----------------|
| Architecture & Design | Who made the structural decisions? Tech choices, file layout, API design |
| Code Generation | Who wrote the actual code? Line-by-line attribution where possible |
| Security Auditing | Who identified the vulnerabilities? Human review vs automated scanning |
| Remediation | Who implemented the fixes? |
| Testing & Validation | Who verified correctness? Manual testing, code review, re-audits |
| Documentation | Who wrote the docs, comments, READMEs? |
| Domain Knowledge | Who contributed security expertise, framework knowledge? |

**Attribution format:** Each dimension gets a percentage split (e.g., "85/15 Justice/Claude") with a brief explanation of who did what.

**Quality assessment:** Include an overall quality grade (A+ through F) based on:
- Code correctness (do the fixes actually resolve the CWEs?)
- Test coverage (are there tests? do they pass?)
- Documentation completeness
- Production readiness

### Phase 3: Wrap-Up

#### Step 6 — Generate Summary

Create `audits/AUDIT_SUMMARY.txt` with:

```
POST-COMMIT AUDIT SUMMARY
==========================
Date: [timestamp]
Commit: [short SHA if available]
Branch: [branch name]

1. SAST/DAST Scan:        [PASS/FAIL] — [N] findings ([critical] critical, [high] high)
2. Supply Chain Audit:     [PASS/FAIL] — SLSA Level [N], [N] issues
3. CWE Mapping:           [PASS/FAIL] — [N] CWEs mapped to [N] frameworks
4. LLM Compliance:        [SCORE]/100 — [STATUS]
5. Contribution Analysis:  [X]% Human / [Y]% AI

Overall: [PASS/CONDITIONAL PASS/FAIL]
Action Required: [yes/no] — [summary if yes]
```

#### Step 7 — Push to Git (if requested)

If the user wants the audit reports committed:
- Stage only the `audits/` directory
- Commit message: `audit: post-commit security & compliance sweep [date]`
- Push to the current branch

Do not push automatically — wait for the user to confirm.

## Remediation Workflow

If Phase 1 finds actionable issues:

1. Present findings to the user with severity and effort estimates
2. If user says "fix it" or "fix any problems":
   - Apply fixes following the remediation guidance in each finding
   - Re-run the full audit suite (back to Phase 1)
   - The LLM Compliance report becomes a re-audit with before/after deltas
   - The Contribution Analysis captures the remediation cycle
3. Continue until all findings are resolved or the user accepts the remaining risk

This fix-then-reaudit loop is the standard remediation pattern. The goal is zero critical/high findings before shipping.

## Reference Files

Read these when generating the LLM Compliance and Contribution Analysis reports:

- `references/llm-compliance-template.md` — Full 8-dimension scoring rubric with regulatory mappings
- `references/contribution-analysis-template.md` — Attribution matrix template with quality grading criteria

## Integration with Other Skills

This skill orchestrates the three security scanner skills. They should be installed:

- **sast-dast-scanner** — [GitHub](https://github.com/justice8096/sast-dast-scanner)
- **supply-chain-security** — [GitHub](https://github.com/justice8096/supply-chain-security)
- **cwe-mapper** — [GitHub](https://github.com/justice8096/cwe-mapper)

If any are missing, the audit can still run — this skill contains enough context to perform each scan manually. The dedicated skills just do it better and faster.
