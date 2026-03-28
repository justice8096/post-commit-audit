# Contribution Analysis Template

Use this template to generate the Human vs AI Contribution Analysis report.

## Report Header

```markdown
# Contribution Analysis Report
## [Project Name]

**Report Date**: [YYYY-MM-DD]
**Project Duration**: [timeframe]
**Contributors**: Justice (Human), Claude (AI Assistant)
**Deliverable**: [what was built/fixed]
**Audit Type**: [Initial / Including Remediation Cycle]
```

## Executive Summary

Summarize the collaboration model and overall split:

```markdown
**Overall Collaboration Model**: [description]

**Contribution Balance**:
- **Architecture & Design**: [X]/[Y] (Justice/Claude)
- **Code Generation**: [X]/[Y] (Justice/Claude)
- **Security Auditing**: [X]/[Y] (Justice/Claude)
- **Remediation Implementation**: [X]/[Y] (Justice/Claude)
- **Documentation**: [X]/[Y] (Justice/Claude)
- **Testing & Validation**: [X]/[Y] (Justice/Claude)
- **Domain Knowledge**: [X]/[Y] (Justice/Claude)
- **Overall**: [X]/[Y] (Justice/Claude)
```

## Attribution Matrix

### Dimension 1: Architecture & Design

**What counts as human contribution:**
- Technology selection (languages, frameworks, tools)
- Directory structure and file organization decisions
- API design and interface contracts
- Integration patterns and workflow design
- Deciding what skills to build and how they compose

**What counts as AI contribution:**
- Suggesting architectural patterns when asked
- Implementing the decided structure
- Filling in boilerplate based on design decisions

**Typical split:** Architecture is almost always human-led (80-100% Justice) because Justice makes the strategic decisions about what to build and how it fits together. Claude implements the decided architecture.

### Dimension 2: Code Generation

**What counts as human contribution:**
- Writing code directly
- Reviewing and modifying AI-generated code
- Specifying exact implementation requirements
- Rejecting and redirecting AI output

**What counts as AI contribution:**
- Writing code from specifications
- Generating boilerplate, scripts, templates
- Implementing patterns (error handling, validation, parsing)

**Typical split:** Code generation is often AI-heavy (80-95% Claude) in these projects because Justice directs and Claude implements. But if Justice wrote significant portions, attribute accordingly.

### Dimension 3: Security Auditing

**What counts as human contribution:**
- Directing which audits to run
- Interpreting findings and prioritizing
- Identifying false positives
- Making risk acceptance decisions

**What counts as AI contribution:**
- Running automated scans
- Pattern matching for vulnerabilities
- Generating findings with CWE references
- Cross-referencing frameworks

### Dimension 4: Remediation Implementation

**What counts as human contribution:**
- Deciding which findings to fix vs accept
- Specifying remediation approach
- Reviewing fixes for correctness
- Approving implementation strategies

**What counts as AI contribution:**
- Implementing the actual code fixes
- Applying security hardening patterns
- Writing validation logic
- Updating scripts and configurations

### Dimension 5: Testing & Validation

**What counts as human contribution:**
- Manual testing and verification
- Signing off on fix correctness
- Confirming no regressions
- Approving re-audit results

**What counts as AI contribution:**
- Running automated test suites
- Performing re-audits
- Comparing before/after results
- Generating test coverage reports

### Dimension 6: Documentation

**What counts as human contribution:**
- Defining what documentation is needed
- Reviewing docs for accuracy
- Writing project-specific context
- Editing AI-generated prose

**What counts as AI contribution:**
- Writing README, SKILL.md, reference docs
- Generating audit report prose
- Creating templates and examples
- Writing code comments

### Dimension 7: Domain Knowledge

**What counts as human contribution:**
- Security domain expertise
- Knowledge of OWASP, CWE, NIST frameworks
- Understanding of regulatory landscape
- Project-specific context and requirements

**What counts as AI contribution:**
- Framework lookup and cross-referencing
- CWE database knowledge
- Pattern recognition from training data
- Regulatory text interpretation

## Quality Assessment

Grade the overall output on these criteria:

| Criterion | Grade | Notes |
|-----------|-------|-------|
| Code Correctness | [A-F] | Do fixes resolve the identified CWEs? |
| Test Coverage | [A-F] | Are there tests? Do they pass? |
| Documentation | [A-F] | Is the project well-documented? |
| Production Readiness | [A-F] | Could this ship today? |
| **Overall** | **[A-F]** | |

**Grading scale:**
- **A+/A**: Exceptional — exceeds production standards
- **A-/B+**: Strong — production-ready with minor polish needed
- **B/B-**: Good — functional but needs some hardening
- **C+/C**: Adequate — works but has notable gaps
- **D/F**: Needs significant work

## Remediation Cycle Section (if applicable)

If this audit includes a remediation cycle, add a section documenting:

1. **What was found** — summary of pre-fix findings
2. **Who directed fixes** — Justice's remediation leadership
3. **Who implemented fixes** — Claude's implementation details with code snippets
4. **Verification** — how fixes were confirmed (re-audit results)
5. **Time and effort** — estimated hours, remediation velocity

## Report Footer

Include:
- Key insight about the collaboration model
- Recommendations for improving the human-AI workflow
- Comparison to previous audits if available (contribution trend over time)
