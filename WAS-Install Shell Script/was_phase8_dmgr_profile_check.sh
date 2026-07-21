#!/usr/bin/env bash
# WebSphere ND 9 - Phase 8 Deployment Manager profile check
# Run as wasadmin after manageprofiles.sh -create completes for the Dmgr profile.
#
#   bash was_phase8_dmgr_profile_check.sh

WAS_HOME="/opt/IBM/WebSphere/AppServer"
PROFILE_PATH="/data/websphere/profiles/Dmgr01"

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Profile location (should NOT be under AppServer/profiles) ==="
if [ -d "$PROFILE_PATH" ]; then
  pass "Profile found at $PROFILE_PATH"
  mnt=$(df --output=target "$PROFILE_PATH" 2>/dev/null | tail -1)
  if [ "$mnt" = "/" ] || [[ "$PROFILE_PATH" == "$WAS_HOME"* ]]; then
    warn "Profile appears to be on the root filesystem or under WAS_HOME - confirm it's on its own mount per the Phase 1/3 storage design"
  else
    pass "Profile is on its own mount: $mnt"
  fi
else
  fail "Profile not found at $PROFILE_PATH - check manageprofiles.sh output/log"
fi

echo
echo "=== Profile registered with WAS_HOME ==="
if [ -x "$WAS_HOME/bin/manageprofiles.sh" ]; then
  "$WAS_HOME/bin/manageprofiles.sh" -listProfiles 2>/dev/null
else
  fail "manageprofiles.sh not found under $WAS_HOME"
fi

echo
echo "=== Ownership ==="
if [ -d "$PROFILE_PATH" ]; then
  owner=$(stat -c '%U' "$PROFILE_PATH" 2>/dev/null)
  if [ "$owner" = "wasadmin" ]; then
    pass "Profile owned by wasadmin"
  else
    warn "Profile owned by '$owner', not wasadmin - confirm this is intentional"
  fi
fi

echo
echo "=== Assigned ports (AboutThisProfile.txt) ==="
ABOUT_FILE=$(find "$PROFILE_PATH" -iname "AboutThisProfile.txt" 2>/dev/null | head -1)
if [ -n "$ABOUT_FILE" ]; then
  pass "Found $ABOUT_FILE"
  echo "  --- Send these real port values back to Network to confirm against their ticket ---"
  grep -iE "port|address" "$ABOUT_FILE" 2>/dev/null | head -20
else
  warn "AboutThisProfile.txt not found - check the profile creation log for errors"
fi

echo
echo "=== Admin security status ==="
SECURITY_XML=$(find "$PROFILE_PATH/config" -iname "security.xml" 2>/dev/null | head -1)
if [ -n "$SECURITY_XML" ]; then
  if grep -qi 'enabled="true"' "$SECURITY_XML" 2>/dev/null; then
    pass "Admin security appears enabled in $SECURITY_XML"
  else
    fail "Admin security does NOT appear enabled - do not defer this, enable it now, not in a later phase"
  fi
else
  warn "security.xml not found under $PROFILE_PATH/config - verify the profile completed correctly"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before starting the Dmgr and federating nodes (Phase 9-10)."
fi
