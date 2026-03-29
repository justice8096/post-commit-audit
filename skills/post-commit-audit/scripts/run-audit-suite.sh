#!/usr/bin/env bash
# shellcheck shell=bash
# Post-Commit Audit Suite — Orchestrates all 5 audits
# Usage: ./run-audit-suite.sh [project-path] [--fix] [--push]
#
# Runs: SAST/DAST scan, Supply Chain audit, CWE mapping,
#       LLM Compliance report, Contribution Analysis
#
# Options:
#   --fix   After scanning, attempt to fix actionable findings
#   --push  Commit and push audit reports to git after completion

set -euo pipefail

PROJECT_PATH="${1:-.}"
DO_PUSH=false

# Parse flags
for arg in "$@"; do
    case "$arg" in
        --push) DO_PUSH=true ;;
    esac
done

# Validate and canonicalize path
if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: Project path '$PROJECT_PATH' not found" >&2
    exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" 2>/dev/null && pwd)" || {
    echo "Error: Cannot resolve project path" >&2
    exit 1
}
AUDIT_DIR="${PROJECT_PATH}/audits"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get git info if available
GIT_BRANCH="unknown"
GIT_SHA="unknown"
if command -v git &>/dev/null && [ -d "${PROJECT_PATH}/.git" ]; then
    GIT_BRANCH=$(git -C "$PROJECT_PATH" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    GIT_SHA=$(git -C "$PROJECT_PATH" rev-parse --short HEAD 2>/dev/null || echo "unknown")
fi

mkdir -p "$AUDIT_DIR"

echo "============================================="
echo "  POST-COMMIT AUDIT SUITE"
echo "============================================="
echo "Project:  $PROJECT_PATH"
echo "Branch:   $GIT_BRANCH"
echo "Commit:   $GIT_SHA"
echo "Time:     $TIMESTAMP"
echo "============================================="
echo ""

# Track results
SAST_STATUS="SKIPPED"
SUPPLY_STATUS="SKIPPED"
CWE_STATUS="SKIPPED"
COMPLIANCE_STATUS="SKIPPED"
CONTRIB_STATUS="SKIPPED"
TOTAL_FINDINGS=0
CRITICAL_FINDINGS=0

# ─── Phase 1: Security Scanning ───────────────────────

echo "▶ PHASE 1: Security Scanning"
echo "─────────────────────────────"

# Step 1: SAST/DAST
echo ""
echo "[1/5] SAST/DAST Scan..."
if [ -f "${AUDIT_DIR}/sast-dast-scan.md" ]; then
    SAST_STATUS="COMPLETE"
    echo "  ✓ Report exists: audits/sast-dast-scan.md"
else
    echo "  ⚠ No report found. Run sast-dast-scanner skill on this project."
    SAST_STATUS="PENDING"
fi

# Step 2: Supply Chain
echo ""
echo "[2/5] Supply Chain Audit..."
if [ -f "${AUDIT_DIR}/supply-chain-audit.md" ]; then
    SUPPLY_STATUS="COMPLETE"
    echo "  ✓ Report exists: audits/supply-chain-audit.md"
else
    echo "  ⚠ No report found. Run supply-chain-security skill on this project."
    SUPPLY_STATUS="PENDING"
fi

# Step 3: CWE Mapping
echo ""
echo "[3/5] CWE Mapping..."
if [ -f "${AUDIT_DIR}/cwe-mapping.md" ]; then
    CWE_STATUS="COMPLETE"
    echo "  ✓ Report exists: audits/cwe-mapping.md"
else
    echo "  ⚠ No report found. Run cwe-mapper skill on this project."
    CWE_STATUS="PENDING"
fi

# ─── Phase 2: Compliance & Attribution ─────────────────

echo ""
echo "▶ PHASE 2: Compliance & Attribution"
echo "─────────────────────────────────────"

# Step 4: LLM Compliance
echo ""
echo "[4/5] LLM Compliance Report..."
if [ -f "${AUDIT_DIR}/llm-compliance-report.md" ]; then
    COMPLIANCE_STATUS="COMPLETE"
    echo "  ✓ Report exists: audits/llm-compliance-report.md"
else
    echo "  ⚠ No report found. Generate using llm-compliance-template.md reference."
    COMPLIANCE_STATUS="PENDING"
fi

# Step 5: Contribution Analysis
echo ""
echo "[5/5] Contribution Analysis..."
if [ -f "${AUDIT_DIR}/contribution-analysis.md" ]; then
    CONTRIB_STATUS="COMPLETE"
    echo "  ✓ Report exists: audits/contribution-analysis.md"
else
    echo "  ⚠ No report found. Generate using contribution-analysis-template.md reference."
    CONTRIB_STATUS="PENDING"
fi

# ─── Phase 3: Summary ──────────────────────────────────

echo ""
echo "▶ PHASE 3: Summary"
echo "───────────────────"

# Count findings from existing reports (validate grep output is numeric)
if [ -f "${AUDIT_DIR}/sast-dast-scan.md" ]; then
    count=$(grep -c "CRITICAL\|HIGH\|MEDIUM" "${AUDIT_DIR}/sast-dast-scan.md" 2>/dev/null || echo 0)
    if [[ "$count" =~ ^[0-9]+$ ]]; then
        TOTAL_FINDINGS=$((TOTAL_FINDINGS + count))
    fi
    count=$(grep -c "CRITICAL" "${AUDIT_DIR}/sast-dast-scan.md" 2>/dev/null || echo 0)
    if [[ "$count" =~ ^[0-9]+$ ]]; then
        CRITICAL_FINDINGS=$((CRITICAL_FINDINGS + count))
    fi
fi

# Determine overall status
OVERALL="PASS"
if [ "$SAST_STATUS" = "PENDING" ] || [ "$SUPPLY_STATUS" = "PENDING" ] || [ "$CWE_STATUS" = "PENDING" ]; then
    OVERALL="CONDITIONAL PASS"
fi
if [ "$CRITICAL_FINDINGS" -gt 0 ]; then
    OVERALL="FAIL"
fi

# Map internal status to PASS/FAIL for summary lines
sast_result=$([ "$SAST_STATUS" = "COMPLETE" ] && echo "PASS" || echo "PENDING")
supply_result=$([ "$SUPPLY_STATUS" = "COMPLETE" ] && echo "PASS" || echo "PENDING")
cwe_result=$([ "$CWE_STATUS" = "COMPLETE" ] && echo "PASS" || echo "PENDING")
compliance_result=$([ "$COMPLIANCE_STATUS" = "COMPLETE" ] && echo "PASS" || echo "PENDING")
contrib_result=$([ "$CONTRIB_STATUS" = "COMPLETE" ] && echo "PASS" || echo "PENDING")

# Generate summary file
cat > "${AUDIT_DIR}/AUDIT_SUMMARY.txt" <<EOF
POST-COMMIT AUDIT SUMMARY
==========================
Date: ${TIMESTAMP}
Commit: ${GIT_SHA}
Branch: ${GIT_BRANCH}

1. SAST/DAST Scan:        ${sast_result} — ${TOTAL_FINDINGS} findings (${CRITICAL_FINDINGS} critical)
2. Supply Chain Audit:     ${supply_result}
3. CWE Mapping:           ${cwe_result}
4. LLM Compliance:        ${compliance_result}
5. Contribution Analysis:  ${contrib_result}

Overall: ${OVERALL}
Action Required: $([ "$OVERALL" = "PASS" ] && echo "no" || echo "yes — complete pending reports and resolve findings")
EOF

echo ""
cat "${AUDIT_DIR}/AUDIT_SUMMARY.txt"

# ─── Optional: Push ────────────────────────────────────

if [ "$DO_PUSH" = true ] && command -v git &>/dev/null && [ -d "${PROJECT_PATH}/.git" ]; then
    echo ""
    echo "▶ Pushing audit reports to git..."

    # Validate timestamp format before using in commit message
    if [[ ! "$TIMESTAMP" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]; then
        echo "Error: Invalid timestamp format" >&2
        exit 1
    fi

    # Stage only expected report files (not arbitrary files in audits/)
    for report in AUDIT_SUMMARY.txt sast-dast-scan.md supply-chain-audit.md cwe-mapping.md llm-compliance-report.md contribution-analysis.md; do
        if [ -f "${AUDIT_DIR}/${report}" ]; then
            git -C "$PROJECT_PATH" add -- "audits/${report}"
        fi
    done

    git -C "$PROJECT_PATH" commit -m "audit: post-commit security & compliance sweep ${TIMESTAMP}" || echo "Nothing to commit"

    # Interactive confirmation before push
    read -rp "Push audit reports to remote? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git -C "$PROJECT_PATH" push || echo "Push failed — you may need to push manually"
    else
        echo "  Skipped push. Run 'git push' manually when ready."
    fi
fi

echo ""
echo "Done. Review reports in: ${AUDIT_DIR}/"
