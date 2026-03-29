---
name: post-commit-audit
description: >
  This skill should be used when the user asks to "run the full audit", "post-commit audit",
  "security check after merge", "run all security scanners", "compliance sweep", "audit this commit",
  "run the standard checks", "full security pass", or after any major feature branch merge, release
  tag, or significant code push. Also trigger proactively when the user completes a substantial
  coding task and pushes to git — this is the standard quality gate. Orchestrates sast-dast-scanner,
  supply-chain-security, and cwe-mapper in parallel, then generates an LLM Compliance report and
  Contribution Analysis matrix.
version: 1.0.0
author: Justice
license: MIT
---

# Post-Commit Audit Skill

Unified orchestration skill that runs the full security-and-compliance audit suite after every major git check-in. Ensures no code ships without being scanned, classified, mapped to compliance frameworks, and attributed.

## When to Run

Run this skill:

- After merging a feature branch to main/master
- After tagging a release
- After pushing significant changes (new features, refactors, dependency updates)
- Before opening a PR for review
- On any "run the checks", "audit this", or "full security pass" request

## What It Produces

Five audit reports in `audits/`, plus a summary index:

| # | Report | Source Skill | File |
|---|--------|-------------|------|
| 1 | SAST/DAST Scan | sast-dast-scanner | `audits/sast-dast-scan.md` |
| 2 | Supply Chain Audit | supply-chain-security | `audits/supply-chain-audit.md` |
| 3 | CWE Mapping | cwe-mapper | `audits/cwe-mapping.md` |
| 4 | LLM Compliance Report | (this skill) | `audits/llm-compliance-report.md` |
| 5 | Contribution Analysis | (this skill) | `audits/contribution-analysis.md` |
| - | Summary Index | (this skill) | `audits/AUDIT_SUMMARY.txt` |

## Audit Sequence

### Phase 1: Security Scanning (parallel)

Run these three scans concurrently. Each is independent.

**Step 1 — SAST/DAST Scan.** Trigger the **sast-dast-scanner** skill. If not installed, perform manually: scan for injection patterns (SQL, command, XSS, path traversal), deserialization risks, hardcoded secrets, ReDoS-vulnerable regex, cryptographic weaknesses, and race conditions. Check HTTP security headers, cookie flags, CORS, and TLS. Output as Markdown grouped by severity (CRITICAL to INFO) with CWE references, file/line, code snippets, and remediation.

**Step 2 — Supply Chain Audit.** Trigger the **supply-chain-security** skill. Key checks: dependency pinning, lockfile integrity, CI/CD secret handling, SBOM generation (CycloneDX 1.4), SLSA level assessment (L0-L4). Output as Markdown with risk matrix and framework compliance table.

**Step 3 — CWE Mapping.** Trigger the **cwe-mapper** skill. Identify CWE IDs for each finding, then map to 8 compliance frameworks: OWASP Top 10 2021, OWASP LLM Top 10 2025, NIST SP 800-53, EU AI Act (Art. 25), ISO 27001, SOC 2, MITRE ATT&CK, MITRE ATLAS. Output as Markdown with per-CWE mappings and an aggregate compliance matrix.

### Phase 2: Compliance & Attribution (sequential, after Phase 1)

These reports synthesize Phase 1 findings.

**Step 4 — LLM Compliance Report.** Read `references/llm-compliance-template.md` for the full scoring rubric and regulatory mappings. Score the project across 8 compliance dimensions (0-100 each): System Transparency, Training Data Disclosure, Risk Classification, Supply Chain Security, Consent & Authorization, Sensitive Data Handling, Incident Response, Bias Assessment. Reference specific Phase 1 findings — fixed CWEs improve Incident Response, unpinned deps lower Supply Chain Security. On re-audit (previous report exists), include a before/after delta table.

**Step 5 — Contribution Analysis.** Read `references/contribution-analysis-template.md` for the full template. Document the human-vs-AI contribution split across 7 dimensions: Architecture & Design, Code Generation, Security Auditing, Remediation, Testing & Validation, Documentation, Domain Knowledge. Each dimension gets a percentage split (e.g., "85/15 Justice/Claude") with explanation. Include an overall quality grade (A+ through F).

### Phase 3: Wrap-Up

**Step 6 — Generate Summary.** Create `audits/AUDIT_SUMMARY.txt`:

```
POST-COMMIT AUDIT SUMMARY
==========================
Date: [timestamp]
Commit: [short SHA]
Branch: [branch name]

1. SAST/DAST Scan:        [PASS/FAIL] — [N] findings ([critical] critical, [high] high)
2. Supply Chain Audit:     [PASS/FAIL] — SLSA Level [N], [N] issues
3. CWE Mapping:           [PASS/FAIL] — [N] CWEs mapped to [N] frameworks
4. LLM Compliance:        [SCORE]/100 — [STATUS]
5. Contribution Analysis:  [X]% Human / [Y]% AI

Overall: [PASS/CONDITIONAL PASS/FAIL]
Action Required: [yes/no] — [summary if yes]
```

**Step 7 — Push to Git (if requested).** Stage only `audits/`, commit as `audit: post-commit security & compliance sweep [date]`, push to current branch. Do not push automatically — wait for confirmation.

## Remediation Workflow

If Phase 1 finds actionable issues:

1. Present findings with severity and effort estimates
2. On "fix it" or "fix any problems" — apply fixes per remediation guidance
3. Re-run the full audit suite (back to Phase 1)
4. LLM Compliance becomes a re-audit with before/after deltas
5. Contribution Analysis captures the remediation cycle
6. Continue until zero critical/high findings or the user accepts remaining risk

## Reference Files

Load these when generating Phase 2 reports:

- **`references/llm-compliance-template.md`** — Full 8-dimension scoring rubric with regulatory mappings (EU AI Act, NIST SP 800-218A, ISO 27001, SOC 2)
- **`references/contribution-analysis-template.md`** — Attribution matrix template with quality grading criteria

## Integration with Other Skills

This skill orchestrates three security scanner skills:

- **sast-dast-scanner** — [GitHub](https://github.com/justice8096/sast-dast-scanner)
- **supply-chain-security** — [GitHub](https://github.com/justice8096/supply-chain-security)
- **cwe-mapper** — [GitHub](https://github.com/justice8096/cwe-mapper)

If any are missing, the audit can still run — this skill contains enough context to perform each scan manually. The dedicated skills produce better and faster results.
