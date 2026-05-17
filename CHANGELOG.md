<!-- SPDX-License-Identifier: CC0-1.0 -->

# Changelog

All notable changes to this skill are tracked here. Per the [Skill Versioning and Addendum Framework](https://github.com/justice8096/SecondBrainData/blob/main/SoftwarePractices/Skill-Versioning-and-Addendum-Framework.md), every change is classified by driver so downstream audit-artifact consumers can assess whether prior outputs need addendum filings.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) with **change-driver tags** appended per entry:

- `[authority]` — underlying regulation, standard, or evidence base changed
- `[defect]` — typo, broken citation, misspelled term, wrong CFR number, factual error
- `[structural]` — section restructure, new locale, new lifespan layer, new domain, new severity scale
- `[voice]` — wording refinement, tone adjustment, ambiguity fix, accessibility improvement

All four drivers affect admissibility / persuasive weight of downstream artifacts. Every change is tracked equally.

## [Unreleased]

## [1.2.0] — 2026-05-17

Skill Versioning and Addendum Framework integration. Aligns post-commit-audit with the framework piloted in dyscalculia-support-skill v1.3.0–v1.3.2 and applied to dyslexia-support-skill v1.3.0, LLMComplianceSkill v1.2.0, and ai-compliance-extractors v1.1.0.

### Added `[structural]`
- `CHANGELOG.md` (this file) adopting the four-driver classification with retroactive entries for v1.0.0, v1.0.1, and v1.1.0.
- Audit-Artifact Provenance Block section in `skills/post-commit-audit/SKILL.md`. Every generated AUDIT_SUMMARY.txt and each of the 5 downstream reports (SAST/DAST scan, supply-chain audit, CWE mapping, LLM compliance report, contribution analysis) must now begin with a provenance block capturing: orchestrator skill version, commit hash, generation date, target-project repo + commit, sources-current-as-of, downstream-scanner versions, changelog URL. This makes prior audits identifiable for addendum filings when authorities, evidence, defects, structure, or voice change.

### Added `[authority]`
- Inline "*Sources current as of 2026-05*" markers + authority-version pin block in `skills/post-commit-audit/SKILL.md` Phase 1 Step 3 (CWE Mapping). Pins all 8 compliance frameworks referenced by the orchestration: OWASP Top 10:2021, OWASP LLM Top 10 v1.1 (2024-10), NIST SP 800-53 Rev. 5 (2020-09), EU AI Act (Regulation (EU) 2024/1689) Art. 25 (cybersecurity requirements for high-risk AI), ISO/IEC 27001:2022, SOC 2 (AICPA TSC 2017 + 2022 updates), MITRE ATT&CK v17.1 (2025-04), MITRE ATLAS v4.7.0 (2025-01).

### Process notes
- Orchestrator version 1.1.0 → 1.2.0 in `skills/post-commit-audit/SKILL.md` frontmatter + `.claude-plugin/plugin.json`.
- No changes to the audit-sequence behavior; only documentation/governance artifacts. Downstream scanners (sast-dast-scanner, supply-chain-security, cwe-mapper) are still tracked separately and will adopt the framework in their own future releases.

## [1.1.0] — 2026-05-17 (retroactively documented at framework adoption)

### Added `[structural]`
- **Target Project routing.** Previously the orchestrator wrote its 6 audit artifacts (5 reports + AUDIT_SUMMARY.txt) to the post-commit-audit skill repo's own `audits/` directory, which (a) polluted the skill repo with non-source content and (b) produced audits that described the skill's own state, not the project the user actually wanted to audit. v1.1.0 routes reports to `{PROJECT_ROOT}/audits/` — the project under test, determined by explicit path, conversational context, or CLI cwd. For multi-repo projects, each repo's `audits/` directory gets the shared report set.

### Fixed `[defect]`
- Untracked the 6 stale `audits/*` files that had been committed in v1.0.0 before `audits/` was added to `.gitignore`. Future audit runs no longer dirty `git status` with regenerated reports inside the skill repo.

## [1.0.1] — 2026-04-22 (retroactively documented)

### Changed `[voice]`
- License migrated from MIT to CC0 1.0 Universal across all source files (commit `cb5051e`).

## [1.0.0] — 2026-03-29 (retroactively documented)

### Added `[structural]`
- Initial release of post-commit-audit orchestrator. Coordinates sast-dast-scanner + supply-chain-security + cwe-mapper in parallel (Phase 1), then runs LLM Compliance Report + Contribution Analysis sequentially (Phase 2), then emits AUDIT_SUMMARY.txt (Phase 3).
- Six audit artifacts per run: SAST/DAST scan, supply-chain audit, CWE mapping, LLM compliance report, contribution analysis, summary index.
- Multi-repo support: shared report set written to each repo's `audits/` directory.
- Initial SBOM generation (CycloneDX 1.4) at `sbom.cdx.json` describing this skill's own dependencies.
- SECURITY.md vulnerability-disclosure policy.

---

## Change-driver workflow

When making a change:

1. **Classify the driver** — one of `[authority]`, `[defect]`, `[structural]`, `[voice]`.
2. **Cite the trigger** — for `[authority]`: name the framework version that changed (e.g., MITRE ATT&CK v17.2). For `[defect]`: describe what was wrong. For `[structural]`/`[voice]`: explain why.
3. **Estimate addendum burden** — would any prior generated audit need addendum filings as a result of this change? If yes, flag it; consumers of audit artifacts (legal, compliance, security teams) rely on orchestrator versioning to decide whether to refresh audits.

## Audit-artifact provenance

Every AUDIT_SUMMARY.txt and each of the 5 downstream reports must begin with a provenance block of the form:

```
Generated YYYY-MM-DD by post-commit-audit vX.Y.Z (<git-short-hash>)
Target project: <repo-name> @ <commit-short-hash> on branch <branch-name>
Sources current as of YYYY-MM except where individual sections note otherwise.
Framework versions: OWASP Top 10:2021, OWASP LLM Top 10 v1.1, NIST SP 800-53 Rev. 5,
                    EU AI Act Art. 25, ISO/IEC 27001:2022, SOC 2 (AICPA TSC 2017+2022),
                    MITRE ATT&CK v17.1, MITRE ATLAS v4.7.0
Downstream scanners: sast-dast-scanner v?, supply-chain-security v?, cwe-mapper v?
Skill changelog: https://github.com/justice8096/post-commit-audit/blob/master/CHANGELOG.md
```

This is the linchpin of the addendum-filing workflow. Without it, prior audits can't be identified for refresh when frameworks/standards update.

## Related framework documentation

- [Skill Versioning and Addendum Framework](https://github.com/justice8096/SecondBrainData/blob/main/SoftwarePractices/Skill-Versioning-and-Addendum-Framework.md) — the cross-skill engineering principle this CHANGELOG implements.
- [Master Task List entry 17](https://github.com/justice8096/SecondBrainData) — rollout plan to remaining downstream skills: `supply-chain-security`, `sast-dast-scanner`, `cwe-mapper`.
- [Sister skills already on framework](https://github.com): [dyscalculia-support-skill v1.3.2](https://github.com/justice8096/dyscalculia-support-skill), [dyslexia-support-skill v1.3.0](https://github.com/justice8096/dyslexia-support-skill), [LLMComplianceSkill v1.2.0](https://github.com/justice8096/LLMComplianceSkill), [ai-compliance-extractors v1.1.0](https://github.com/justice8096/ai-compliance-extractors).
