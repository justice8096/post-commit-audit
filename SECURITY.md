# Security Policy

## Reporting Vulnerabilities

To report a security vulnerability, open a private issue on GitHub or email the maintainer directly.

Do not open a public issue for security vulnerabilities.

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | Yes       |

## Scope

This project is a Claude Code skill (bash scripts + markdown). It does not:

- Serve HTTP or handle web traffic
- Process untrusted user input at runtime (beyond file paths passed as CLI arguments)
- Manage secrets or credentials
- Have third-party dependencies

The primary attack surface is the `run-audit-suite.sh` script, which accepts a filesystem path argument and reads/writes files in an `audits/` directory.

## Known Limitations

- **Detection coverage:** The skill's manual scanning patterns focus on common vulnerability classes (OWASP Top 10, CWE Top 25). Language-specific or framework-specific vulnerabilities may not be detected.
- **False positive rate:** Not formally measured. The grep-based finding counter in `run-audit-suite.sh` counts severity keywords in freeform markdown, which can overcount.
- **Language coverage:** Shell script analysis is the primary strength. Other languages are scanned via the orchestrated skills (sast-dast-scanner, supply-chain-security, cwe-mapper).

## Dependencies

This project intentionally has zero third-party dependencies. It requires only:

- `bash` >= 4.0
- `git`
- `coreutils` (`date`, `cat`, `mkdir`, `grep`)

This is by design to minimize supply chain attack surface.
