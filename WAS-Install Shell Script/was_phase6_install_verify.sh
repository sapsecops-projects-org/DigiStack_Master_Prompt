#!/usr/bin/env bash
# WebSphere ND 9 - Phase 6 post-install verification
# Run as wasadmin after the imcl install of com.ibm.websphere.ND.v90 completes.
#
#   bash was_phase6_install_verify.sh

WAS_HOME="/opt/IBM/WebSphere/AppServer"
INSTALL_LOG="/data/websphere/logs/was_install.log"   # adjust to match your -log path
SHARED_RES="/opt/IBM/IMShared"                        # adjust to match your -sharedResourcesDirectory

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Core install verification ==="
if [ -x "$WAS_HOME/bin/versionInfo.sh" ]; then
  pass "versionInfo.sh found"
  "$WAS_HOME/bin/versionInfo.sh" 2>/dev/null
else
  fail "$WAS_HOME/bin/versionInfo.sh not found - core install did not complete"
fi

echo
echo "=== Expected binaries and templates ==="
for f in bin/startServer.sh bin/manageprofiles.sh profileTemplates/management/dmgr profileTemplates/managed; do
  if [ -e "$WAS_HOME/$f" ]; then
    pass "$f present"
  else
    fail "$f missing - reinstall or check the install log"
  fi
done

echo
echo "=== Samples feature check (should be absent in production) ==="
if find "$WAS_HOME" -iname "*snoop*" 2>/dev/null | grep -q .; then
  warn "Samples-related content (e.g. snoop) found under $WAS_HOME - confirm this is intentional; these are common audit/pentest findings in production"
else
  pass "No samples content detected"
fi

echo
echo "=== Install log review (regardless of exit code) ==="
if [ -f "$INSTALL_LOG" ]; then
  ERR_COUNT=$(grep -ci "ERROR" "$INSTALL_LOG")
  WARN_COUNT=$(grep -ci "WARNING" "$INSTALL_LOG")
  echo "  ERROR lines: $ERR_COUNT, WARNING lines: $WARN_COUNT"
  if [ "$ERR_COUNT" -gt 0 ]; then
    fail "Install log contains ERROR entries - review $INSTALL_LOG before proceeding, even if the install reported success"
  elif [ "$WARN_COUNT" -gt 0 ]; then
    warn "Install log contains WARNING entries - review $INSTALL_LOG; exit code alone does not guarantee a clean install"
  else
    pass "No ERROR/WARNING entries found in install log"
  fi
else
  warn "Install log not found at $INSTALL_LOG - update the path in this script to match your actual -log location"
fi

echo
echo "=== Shared resources directory hygiene ==="
if [ -d "$SHARED_RES" ]; then
  STALE_LOCKS=$(find "$SHARED_RES" -iname "*.lock" 2>/dev/null | wc -l)
  if [ "$STALE_LOCKS" -gt 0 ]; then
    warn "$STALE_LOCKS stale lock file(s) found in $SHARED_RES - clean these before any future install/update here"
  else
    pass "No stale lock files in $SHARED_RES"
  fi
else
  warn "$SHARED_RES not found - confirm your actual -sharedResourcesDirectory path"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before applying the fix pack (Phase 7) or creating profiles (Phase 8)."
fi
