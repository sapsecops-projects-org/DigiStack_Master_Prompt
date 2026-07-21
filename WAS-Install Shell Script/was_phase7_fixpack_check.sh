#!/usr/bin/env bash
# WebSphere ND 9 - Phase 7 fix pack readiness check
# Run before applying a fix pack to the core install.
#
#   bash was_phase7_fixpack_check.sh

WAS_HOME="/opt/IBM/WebSphere/AppServer"
IMCL="/opt/IBM/InstallationManager/eclipse/tools/imcl"
FP_REPO="/software/repo/WAS90_FP"   # adjust to your staged fix pack repository path

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Current WAS build level ==="
if [ -x "$WAS_HOME/bin/versionInfo.sh" ]; then
  "$WAS_HOME/bin/versionInfo.sh" 2>/dev/null | grep -iE "Version|Build Level"
  pass "versionInfo.sh ran - confirm the reported level against your approved security baseline"
else
  fail "versionInfo.sh not found - confirm the base install (Phase 6) actually completed"
fi

echo
echo "=== Installation Manager version (fix packs require 1.8.5 or later) ==="
if [ -x "$IMCL" ]; then
  IMVER=$("$IMCL" version 2>/dev/null | head -1)
  echo "  Reported: ${IMVER:-unknown}"
  pass "imcl responded - manually confirm the version is 1.8.5 or later"
else
  fail "$IMCL not found - Installation Manager isn't where expected"
fi

echo
echo "=== Disk space for the fix pack (needs roughly 2-4GB free) ==="
AVAIL_KB=$(df --output=avail "$WAS_HOME" 2>/dev/null | tail -1)
AVAIL_GB=$((AVAIL_KB/1024/1024))
echo "  Available on the $WAS_HOME filesystem: ${AVAIL_GB}GB"
if [ "$AVAIL_GB" -ge 4 ]; then
  pass "Sufficient free space for the fix pack"
else
  warn "Less than 4GB free - the fix pack could fail partway through; free up space first"
fi

echo
echo "=== Staged fix pack repository ==="
if [ -d "$FP_REPO" ]; then
  pass "Fix pack repository found: $FP_REPO"
  find "$FP_REPO" -maxdepth 1 -type f \( -iname "*.zip" -o -iname "*.tar*" \) -print0 2>/dev/null | \
    while IFS= read -r -d '' f; do
      sum=$(sha256sum "$f" 2>/dev/null | awk '{print $1}')
      echo "    $(basename "$f"): $sum  (compare against IBM's published checksum/signature)"
    done
else
  fail "Fix pack repository not found: $FP_REPO - stage it before proceeding"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before applying the fix pack."
fi
echo
echo "Reminder: confirm this fix pack level against your bank's approved baseline, not just"
echo "the newest one IBM has published - check IBM's Recommended Updates page for the"
echo "current number, since a new fix pack ships every few months."
