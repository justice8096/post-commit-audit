# LLM Compliance Report Template

Use this template to generate the LLM Compliance & Transparency Report.

## Report Header

```markdown
# LLM Compliance & Transparency Report
## [Project Name]

**Report Date**: [YYYY-MM-DD]
**Auditor**: LLM Governance & Compliance Team
**Project**: [project name] (Claude-assisted development)
**Framework**: EU AI Act Art. 25, OWASP LLM Top 10 2025, NIST SP 800-218A
**Audit Type**: [INITIAL / POST-FIX Re-audit]
```

## Executive Summary

Include:
- Overall LLM Compliance Score (0-100)
- Status: EXCELLENT (90+), GOOD (70-89), DEVELOPING (50-69), NEEDS IMPROVEMENT (<50)
- If re-audit: before/after delta table

```markdown
| Dimension | Before | After | Delta | Status |
|-----------|--------|-------|-------|--------|
```

## 8 Compliance Dimensions

### Dimension 1: System Transparency (Score/100)

**What to assess:**
- Does the project disclose that AI (Claude) was used in development?
- Are AI-generated components clearly identified?
- Are limitations of AI-generated code documented?
- Is there a human oversight mechanism?

**Regulatory mapping:**
- EU AI Act Art. 52 (Transparency obligations)
- NIST AI RMF MAP 1.1 (Context and limitations)
- ISO 27001 A.8.9 (Configuration management)

**Scoring guide:**
- 90-100: Full disclosure in README, code comments, and commit messages
- 70-89: Disclosure exists but incomplete (e.g., README mentions AI but no per-file attribution)
- 50-69: Minimal disclosure (mentioned once, not systematic)
- <50: No disclosure of AI involvement

### Dimension 2: Training Data Disclosure (Score/100)

**What to assess:**
- Are the security frameworks and knowledge sources documented?
- Is the model version and provider identified?
- Are the reference documents (OWASP, NIST, CWE databases) cited?

**Regulatory mapping:**
- EU AI Act Art. 53 (Technical documentation)
- NIST AI RMF MEASURE 2.6 (Data provenance)

**Scoring guide:**
- 90-100: All framework sources cited with versions and dates
- 70-89: Major sources cited but missing version specifics
- 50-69: Sources mentioned vaguely
- <50: No source documentation

### Dimension 3: Risk Classification (Score/100)

**What to assess:**
- How accurately does the project identify security risks?
- Are severity levels consistent with industry standards (CVSS, CWE)?
- Are false positives minimized?
- Is the classification validated against known vulnerability databases?

**Regulatory mapping:**
- EU AI Act Art. 25 (Obligations of providers of general-purpose AI models)
- NIST SP 800-53 RA-3 (Risk Assessment)
- OWASP LLM Top 10 2025 (LLM09 - Misinformation)

**Scoring guide:**
- 90-100: All findings have accurate CWE mappings, severity validated, minimal false positives
- 70-89: Most findings correctly classified, some minor misalignments
- 50-69: Classification exists but inconsistent or missing CWE references
- <50: No structured risk classification

### Dimension 4: Supply Chain Security (Score/100)

**What to assess:**
- Is the development pipeline hardened against compromise?
- Are dependencies pinned and audited?
- Are CI/CD secrets properly managed?
- Is there SBOM documentation?

**Regulatory mapping:**
- NIST SP 800-218A (Secure Software Development)
- SLSA v1.0 (Supply chain Levels for Software Artifacts)
- EU AI Act Art. 25 (Risk management)
- ISO 27001 A.15 (Supplier relationships)

**Scoring guide:**
- 90-100: SLSA L3+, full SBOM, pinned deps, hardened CI, signed commits
- 70-89: SLSA L2, SBOM exists, most deps pinned, CI mostly hardened
- 50-69: Basic dependency management, no SBOM, some CI issues
- <50: No supply chain controls

### Dimension 5: Consent & Authorization (Score/100)

**What to assess:**
- Does the user maintain full control over the tool's operation?
- Is the tool opt-in (not running without explicit invocation)?
- Are destructive actions gated behind confirmation?
- Can the user override or disable AI-generated recommendations?

**Regulatory mapping:**
- EU AI Act Art. 14 (Human oversight)
- NIST AI RMF GOVERN 1.2 (Human oversight)
- SOC 2 CC6.1 (Access controls)

**Scoring guide:**
- 90-100: Full user control, explicit opt-in, confirmation on destructive actions
- 70-89: User control exists but some operations are automatic
- 50-69: Partial user control
- <50: Runs autonomously without user consent

### Dimension 6: Sensitive Data Handling (Score/100)

**What to assess:**
- Are secrets, API keys, and credentials protected?
- Is PII handled appropriately (not logged, not exposed)?
- Are scan results stored securely?
- Does the tool avoid leaking sensitive data in reports?

**Regulatory mapping:**
- GDPR Art. 5 (Data minimization)
- NIST SP 800-53 SC-28 (Protection of information at rest)
- ISO 27001 A.8.11 (Data masking)
- SOC 2 CC6.7 (Data classification)

**Scoring guide:**
- 90-100: Secrets never appear in output, PII masked, findings redacted appropriately
- 70-89: Most sensitive data protected but edge cases exist
- 50-69: Some sensitive data exposure in reports or logs
- <50: Secrets or PII visible in outputs

### Dimension 7: Incident Response (Score/100)

**What to assess:**
- Are vulnerability remediation procedures documented?
- Do errors surface clearly (stderr, exit codes) rather than failing silently?
- Is there a fix-then-reaudit workflow?
- Are findings actionable (with specific remediation guidance)?

**Regulatory mapping:**
- NIST SP 800-53 IR-4 (Incident handling)
- ISO 27001 A.16 (Incident management)
- SOC 2 CC7.3 (Incident response)

**Scoring guide:**
- 90-100: All findings include remediation, errors surface cleanly, reaudit workflow exists
- 70-89: Most findings have remediation, error handling mostly complete
- 50-69: Some findings lack remediation guidance, silent failures exist
- <50: No systematic remediation process

### Dimension 8: Bias Assessment (Score/100)

**What to assess:**
- Are false positive and false negative rates documented?
- Does the scanner treat all languages/frameworks equitably?
- Are detection patterns validated against known test suites?
- Is there acknowledgment of detection gaps?

**Regulatory mapping:**
- EU AI Act Art. 10 (Data governance)
- NIST AI RMF MEASURE 2.11 (Fairness)
- OWASP LLM Top 10 2025 (LLM09 - Misinformation)

**Scoring guide:**
- 90-100: FP/FN rates measured, multi-language coverage, known gaps documented
- 70-89: Some measurement exists, coverage acknowledged but not quantified
- 50-69: No formal measurement, anecdotal coverage claims
- <50: No bias or fairness consideration

## Report Footer

Include:
- Recommendations (3-5 actionable items to improve compliance score)
- Regulatory roadmap (what to address for full EU AI Act / NIST compliance)
- Next audit date recommendation
