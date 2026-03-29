# CWE Mapping Report

**Project:** post-commit-audit
**Date:** 2026-03-29
**Audit Cycle:** Fourth-pass Re-audit (post SHA-pin + permissions block + dead-code removal)
**Source Findings:** SAST/DAST Scan + Supply Chain Audit (cumulative)
**Unique CWEs:** 11 (10 prior + CWE-269 newly identified and resolved this cycle)

---

## CWE Inventory (Current Status)

| CWE ID | Name | Original Severity | Current Status | Introduced By |
|--------|------|-------------------|----------------|---------------|
| CWE-22 | Path Traversal | HIGH | RESOLVED (1ec805c) | SAST, Supply Chain |
| CWE-78 | OS Command Injection | MEDIUM | RESOLVED (1ec805c) | SAST |
| CWE-200 | Information Exposure | HIGH | RESOLVED (1ec805c) | Supply Chain |
| CWE-269 | Improper Privilege Management | MEDIUM | RESOLVED (26c388a) | Supply Chain (new) |
| CWE-345 | Insufficient Data Authenticity | HIGH | RESOLVED (0bbc390) | Supply Chain |
| CWE-367 | TOCTOU Race Condition | MEDIUM | OPEN (accepted risk) | SAST |
| CWE-693 | Protection Mechanism Failure | HIGH | SUBSTANTIALLY MITIGATED (535b5e1) | Supply Chain |
| CWE-710 | Improper Code Style | INFO | RESOLVED (ed7892b) | SAST |
| CWE-732 | Incorrect Permission Assignment | LOW | RESOLVED (1ec805c) | SAST |
| CWE-829 | Inclusion of Functionality from Untrusted Control Sphere | MEDIUM | RESOLVED (26c388a) | Supply Chain |
| CWE-862 | Missing Authorization | LOW | RESOLVED (1ec805c) | SAST |

**Active CWEs:** 1 (CWE-367 accepted residual risk)
**Resolved CWEs:** 10 of 11

---

## Compliance Framework Mapping

### CWE to Framework Cross-Reference

| CWE | Status | OWASP Top 10 2021 | OWASP LLM Top 10 2025 | NIST SP 800-53 | EU AI Act | ISO 27001 | SOC 2 | MITRE ATT&CK | MITRE ATLAS |
|-----|--------|-------------------|----------------------|----------------|-----------|-----------|-------|--------------|-------------|
| CWE-22 | RESOLVED | A01:2021 Broken Access Control | — | AC-6, SI-10 | Art. 25 (Risk Mgmt) | A.8.3 | CC6.1 | T1083 | — |
| CWE-78 | RESOLVED | A03:2021 Injection | LLM01 (Prompt Injection) | SI-10, SC-18 | Art. 25 | A.8.28 | CC6.1 | T1059 | AML.T0040 |
| CWE-200 | RESOLVED | A01:2021 Broken Access Control | LLM06 (Sensitive Info Disclosure) | SC-28, AC-3 | Art. 10 (Data Governance) | A.8.11 | CC6.7 | T1552 | — |
| CWE-269 | RESOLVED | A05:2021 Security Misconfiguration | LLM05 (Supply Chain) | AC-6, CM-7 | Art. 25 | A.9.4 | CC6.3 | T1078 | — |
| CWE-345 | RESOLVED | A08:2021 Software/Data Integrity | LLM05 (Supply Chain) | SA-12, SI-7 | Art. 25 | A.14.2 | CC7.1 | T1195 | AML.T0010 |
| CWE-367 | OPEN | A04:2021 Insecure Design | — | SI-7 | — | A.8.25 | CC7.2 | T1068 | — |
| CWE-693 | MITIGATED | A05:2021 Security Misconfiguration | LLM05 (Supply Chain) | SA-11, CA-2 | Art. 25 | A.14.2 | CC7.1 | T1195.002 | — |
| CWE-710 | RESOLVED | — | — | SA-15 | — | A.8.25 | — | — | — |
| CWE-732 | RESOLVED | A01:2021 Broken Access Control | — | AC-6 | — | A.8.3 | CC6.1 | T1222 | — |
| CWE-829 | RESOLVED | A08:2021 Software/Data Integrity | LLM05 (Supply Chain) | SA-12, CM-7 | Art. 25 | A.14.2 | CC7.1 | T1195.001 | AML.T0010 |
| CWE-862 | RESOLVED | A01:2021 Broken Access Control | — | AC-3 | Art. 14 (Human Oversight) | A.8.3 | CC6.1 | — | — |

---

## Delta: What Changed This Cycle

| CWE | Change | Commit |
|-----|--------|--------|
| CWE-829 | RESOLVED — GitHub Actions SHA-pinned | 26c388a |
| CWE-269 | NEW + RESOLVED — `permissions: contents: read` added to workflow | 26c388a |
| CWE-710 | FULLY RESOLVED — SC2034 unused variables removed (previously INFO) | ed7892b |

---

## Aggregate Compliance Matrix (Updated)

| Framework | CWEs Mapped | Active CWEs | Coverage |
|-----------|-------------|-------------|----------|
| OWASP Top 10 2021 | 10/10 | 1 | A01 (4 resolved), A03 (resolved), A04 (1 open), A05 (2 resolved + 1 mitigated), A08 (2 resolved) |
| OWASP LLM Top 10 2025 | 4/10 | 0 | LLM01 (resolved), LLM05 (2 resolved + 1 mitigated), LLM06 (resolved) |
| NIST SP 800-53 | 11/11 | 1 | AC (resolved), SI (1 open), SA (resolved + mitigated), SC (resolved), CA (mitigated), CM (resolved) |
| EU AI Act | 5/10 | 0 | Art. 10 (resolved), Art. 14 (resolved), Art. 25 (4 resolved + 1 mitigated) |
| ISO 27001 | 10/10 | 1 | A.8 (6, 5 resolved), A.9 (resolved), A.14 (2, 1 resolved + 1 mitigated) |
| SOC 2 | 9/10 | 1 | CC6 (4 resolved), CC7 (2 resolved + 1 open + 1 mitigated) |
| MITRE ATT&CK | 8/10 | 1 | T1195.001 (resolved), T1195 (resolved), T1059 (resolved), T1083 (resolved), T1222 (resolved), T1552 (resolved), T1068 (open/accepted), T1078 (resolved) |
| MITRE ATLAS | 2/10 | 0 | AML.T0010 (resolved), AML.T0040 (resolved) |

---

## Risk Trend

| Audit Cycle | Total CWEs | High | Medium | Low | Info | Resolved |
|-------------|-----------|------|--------|-----|------|---------|
| Cycle 1 (initial) | 8 | 4 | 2 | 2 | 0 | 0 |
| Cycle 2 (post-fix) | 8 | 2 | 1 | 0 | 0 | 6 |
| Cycle 3 (CI/signing) | 10 | 0 | 2 | 0 | 0 | 8 |
| Cycle 4 (now) | 11 | 0 | 1 | 0 | 0 | 10 |

---

## Overall Assessment

**11 unique CWEs** tracked across **8 compliance frameworks**. **10 of 11 CWEs resolved**. The sole active CWE is CWE-367 (TOCTOU, accepted residual risk for a single-user CLI tool). No HIGH or CRITICAL CWEs remain. OWASP LLM Top 10 2025 and MITRE ATLAS show zero active exposures. The project has achieved near-complete CWE resolution — remaining work is operational (SBOM, branch protection) rather than code-level.
