#!/usr/bin/env bash
# WebSphere ND 9 - Phase 10 node federation check
# Run on the NODE host after addNode.sh completes.
#
#   bash was_phase10_federation_check.sh

WAS_HOME="/opt/IBM/WebSphere/AppServer"
NODE_PROFILE="/data/websphere/profiles/AppSrv01"
DMGR_HOST="dmgr01.bank.internal"   # used only for the optional version comparison over SSH

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Node profile location ==="
if [ -d "$NODE_PROFILE" ]; then
  pass "Node profile found at $NODE_PROFILE"
else
  fail "Node profile not found at $NODE_PROFILE"
fi

echo
echo "=== Node agent process ==="
NA_PID=$(pgrep -f "nodeagent" | head -1)
if [ -n "$NA_PID" ]; then
  pass "nodeagent process running, PID $NA_PID"
else
  fail "No nodeagent process found - federation may not have completed, or nodeagent failed to start"
fi

echo
echo "=== Node sync status ==="
NA_LOG="$NODE_PROFILE/logs/nodeagent/SystemOut.log"
if [ -f "$NA_LOG" ]; then
  if grep -q "Node synchron" "$NA_LOG"; then
    pass "Found a node synchronization message in nodeagent SystemOut.log"
    grep "Node synchron" "$NA_LOG" | tail -3
  else
    warn "No synchronization message found yet - check the console's Nodes panel, or allow more time"
  fi
else
  warn "$NA_LOG not found"
fi

echo
echo "=== Local WAS build level (must match the Dmgr host exactly) ==="
if [ -x "$WAS_HOME/bin/versionInfo.sh" ]; then
  "$WAS_HOME/bin/versionInfo.sh" 2>/dev/null | grep -iE "Version|Build Level"
  pass "Captured local version"
  if command -v ssh &>/dev/null && ssh -o BatchMode=yes -o ConnectTimeout=3 "$DMGR_HOST" true 2>/dev/null; then
    echo "  --- Dmgr host reports ---"
    ssh "$DMGR_HOST" "$WAS_HOME/bin/versionInfo.sh" 2>/dev/null | grep -iE "Version|Build Level"
    echo "  Compare the two outputs above - they must match exactly, not just 'close'"
  else
    warn "Could not reach $DMGR_HOST over passwordless SSH for an automatic comparison - compare the two versionInfo.sh outputs by hand"
  fi
else
  fail "versionInfo.sh not found on this node - confirm the same IM/WAS/fix pack response files ran here as on the Dmgr host"
fi

echo
echo "=== Pre-federation local config sanity note ==="
RESOURCES_XML=$(find "$NODE_PROFILE/config" -iname "resources.xml" -path "*/nodes/*" 2>/dev/null | head -1)
if [ -n "$RESOURCES_XML" ]; then
  echo "  Found: $RESOURCES_XML"
  echo "  Anything configured here before addNode.sh ran was replaced by the cell's master config, not merged with it."
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before moving on to post-federation validation and app deployment."
fi
