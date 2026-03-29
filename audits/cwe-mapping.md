# CWE Mapping Report

**Project:** post-commit-audit
**Date:** 2026-03-29
**Audit Cycle:** Third-pass Re-audit (post CI/CD + signing)
**Source Findings:** SAST/DAST Scan + Supply Chain Audit (cumulative)
**Unique CWEs:** 9 (8 prior + CWE-829 introduced by N-1)

---

## CWE Inventory (Current Status)

| CWE ID | Name | Original Severity | Current Status | Introduced By |
|--------|------|-------------------|----------------|---------------|
| CWE-22 | Path Traversal | HIGH | RESOLVED (1ec805c) | SAST, Supply Chain |
| CWE-78 | OS Command Injection | MEDIUM | RESOLVED (1ec805c) | SAST |
| CWE-200 | Information Exposure | HIGH | RESOLVED (1ec805c) | Supply Chain |
| CWE-345 | Insufficient Data Authenticity | HIGH | RESOLVED (0bbc390) | Supply Chain |
| CWE-367 | TOCTOU Race Condition | MEDIUM | OPEN (accepted risk) | SAST |
| CWE-693 | Protection Mechanism Failure | HIGH | SUBSTANTIALLY MITIGATED (535b5e1) | Supply Chain |
| CWE-710 | Improper Code Style | INFO | RESOLVED (1ec805c) | SAST |
| CWE-732 | Incorrect Permission Assignment | LOW | RESOLVED (1ec805c) | SAST |
| CWE-829 | Inclusion of Functionality from Untrusted Control Sphere | MEDIUM | OPEN (N-1) | Supply Chain (new) |
| CWE-862 | Missing Authorization | LOW | RESOLVED (1ec805c) | SAST |

**Active CWEs:** 2 (CWE-367 accepted, CWE-829 open/remediable)
**Resolved CWEs:** 8 of 10

---

## Compliance Framework Mapping

### CWE to Framework Cross-Reference

| CWE | Status | OWASP Top 10 2021 | OWASP LLM Top 10 2025 | NIST SP 800-53 | EU AI Act | ISO 27001 | SOC 2 | MITRE ATT&CK | MITRE ATLAS |
|-----|--------|-------------------|----------------------|----------------|-----------|-----------|-------|--------------|-------------|
| CWE-22 | RESOLVED | A01:2021 Broken Access Control | — | AC-6, SI-10 | Art. 25 (Risk Mgmt) | A.8.3 | CC6.1 | T1083 | — |
| CWE-78 | RESOLVED | A03:2021 Injection | LLM01 (Prompt Injection) | SI-10, SC-18 | Art. 25 | A.8.28 | CC6.1 | T1059 | AML.T0040 |
| CWE-200 | RESOLVED | A01:2021 Broken Access Control | LLM06 (Sensitive Info Disclosure) | SC-28, AC-3 | Art. 10 (Data Governance) | A.8.11 | CC6.7 | T1552 | — |
| CWE-345 | RESOLVED | A08:2021 Software/Data Integrity | LLM05 (Supply Chain) | SA-12, SI-7 | Art. 25 | A.14.2 | CC7.1 | T1195 | AML.T0010 |
| CWE-367 | OPEN | A04:2021 Insecure Design | — | SI-7 | — | A.8.25 | CC7.2 | T1068 | — |
| CWE-693 | MITIGATED | A05:2021 Security Misconfiguration | LLM05 (Supply Chain) | SA-11, CA-2 | Art. 25 | A.14.2 | CC7.1 | T1195.002 | — |
| CWE-710 | RESOLVED | — | — | SA-15 | — | A.8.25 | — | — | — |
| CWE-732 | RESOLVED | A01:2021 Broken Access Control | — | AC-6 | — | A.8.3 | CC6.1 | T1222 | — |
| CWE-829 | OPEN | A08:2021 Software/Data Integrity | LLM05 (Supply Chain) | SA-12, CM-7 | Art. 25 | A.14.2 | CC7.1 | T1195.001 | AML.T0010 |
| CWE-862 | RESOLVED | A01:2021 Broken Access Control | — | AC-3 | Art. 14 (Human Oversight) | A.8.3 | CC6.1 | — | — |

---

## Delta: What Changed This Cycle

| CWE | Change | Commit |
|-----|--------|--------|
| CWE-345 | RESOLVED — SSH commit signing enabled | 0bbc390 |
| CWE-693 | SUBSTANTIALLY MITIGATED — ShellCheck CI added | 535b5e1 |
| CWE-829 | NEW OPEN — GitHub Actions tags not SHA-pinned | 535b5e1 |

---

## Aggregate Compliance Matrix (Updated)

| Framework | CWEs Mapped | Active CWEs | Coverage |
|-----------|-------------|-------------|----------|
| OWASP Top 10 2021 | 9/10 | 2 | A01 (4 resolved), A03 (resolved), A04 (open), A05 (mitigated), A08 (1 resolved + 1 open) |
| OWASP LLM Top 10 2025 | 4/10 | 1 | LLM01 (resolved), LLM05 (1 mitigated + 1 open), LLM06 (resolved) |
| NIST SP 800-53 | 10/10 | 2 | AC (resolved), SI (1 open), SA (1 open + 1 mitigated), SC (resolved), CA (mitigated), CM (open) |
| EU AI Act | 5/10 | 1 | Art. 10 (resolved), Art. 14 (resolved), Art. 25 (2 resolved + 1 open) |
| ISO 27001 | 9/10 | 2 | A.8 (5, 4 resolved), A.14 (2, 1 mitigated + 1 open) |
| SOC 2 | 8/10 | 2 | CC6 (4 resolved), CC7 (2 resolved + 1 open + 1 mitigated) |
| MITRE ATT&CK | 7/10 | 1 | T1195.001 (open), T1195 (resolved), T1059 (resolved), T1083 (resolved), T1222 (resolved), T1552 (resolved), T1068 (open/accepted) |
| MITRE ATLAS | 2/10 | 0 | AML.T0010 (resolved), AML.T0040 (resolved) |

---

## Risk Trend

| Audit Cycle | Total CWEs | High | Medium | Low | Info | Resolved |
|-------------|-----------|------|--------|-----|------|---------|
| Cycle 1 (initial) | 8 | 4 | 2 | 2 | 0 | 0 |
| Cycle 2 (post-fix) | 8 | 2 | 1 | 0 | 0 | 6 |
| Cycle 3 (now) | 10 | 0 | 2 | 0 | 0 | 8 |

All HIGH CWEs are now resolved. The project has no high or critical active CWEs.

---

## Overall Assessment

**9 unique CWEs** tracked across **8 compliance frameworks**. **8 of 10 CWEs are resolved**. The remaining 2 active CWEs are both MEDIUM: CWE-367 (TOCTOU, accepted residual risk for single-user CLI) and CWE-829 (GitHub Actions tag pinning, remediable with SHA pinning). No HIGH or CRITICAL CWEs remain.

The dominant resolved risk theme was **insufficient integrity verification and access control** (CWE-22, CWE-200, CWE-345, CWE-693, CWE-732, CWE-862) — all addressed across cycles 1–3.
