#!/usr/bin/env bash
# WebSphere ND 9 - Phase 11 post-federation sync validation
# Run on the NODE host.
#
#   bash was_phase11_sync_check.sh

NODE_PROFILE="/data/websphere/profiles/AppSrv01"
DMGR_HOST="dmgr01.bank.internal"
DMGR_SOAP_PORT=8879

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Sync-related log entries ==="
NA_LOG="$NODE_PROFILE/logs/nodeagent/SystemOut.log"
if [ -f "$NA_LOG" ]; then
  LAST_SYNC_LINE=$(grep -i "ADMU05\|synchroniz" "$NA_LOG" | tail -1)
  echo "  Last relevant log line: ${LAST_SYNC_LINE:-none found}"
  if grep -qi "ADMU0016I" "$NA_LOG"; then
    pass "Found successful synchronization messages"
  else
    warn "No explicit successful sync message found - review $NA_LOG manually"
  fi
  if grep -qiE "sync.*fail|ADMU05[0-9][0-9]E" "$NA_LOG"; then
    fail "Found sync-related error/failure entries - review $NA_LOG"
  fi
else
  fail "$NA_LOG not found"
fi

echo
echo "=== Manual sync availability (this is an ACTIVE operation, not read-only) ==="
if [ -x "$NODE_PROFILE/bin/syncNode.sh" ]; then
  pass "syncNode.sh present and executable"
  echo "  To force a sync right now (e.g. after an urgent config push):"
  echo "    $NODE_PROFILE/bin/syncNode.sh $DMGR_HOST $DMGR_SOAP_PORT -username <user> -password <pass>"
else
  fail "syncNode.sh not found under $NODE_PROFILE/bin"
fi

echo
echo "=== Config directory freshness vs current time ==="
CONFIG_DIR="$NODE_PROFILE/config/cells"
if [ -d "$CONFIG_DIR" ]; then
  NEWEST=$(find "$CONFIG_DIR" -type f -printf '%T@\n' 2>/dev/null | sort -n | tail -1)
  if [ -n "$NEWEST" ]; then
    NOW=$(date +%s)
    AGE_MIN=$(( (NOW - ${NEWEST%.*}) / 60 ))
    echo "  Newest config file is approximately ${AGE_MIN} minutes old"
    if [ "$AGE_MIN" -gt 60 ]; then
      warn "Newest config file is over an hour old - if you expect recent Dmgr-side changes, this node may be lagging; don't rely on 'Synchronized' status alone"
    else
      pass "Config appears recently updated"
    fi
  fi
else
  fail "$CONFIG_DIR not found"
fi

echo
echo "=== Clock source hygiene (relevant on virtualized hosts) ==="
if systemctl is-active chronyd &>/dev/null; then
  pass "chronyd active"
else
  fail "chronyd not active"
fi
if command -v vmware-toolbox-cmd &>/dev/null; then
  TIMESYNC=$(vmware-toolbox-cmd timesync status 2>/dev/null)
  echo "  VMware Tools time sync status: ${TIMESYNC:-unknown}"
  if [ "$TIMESYNC" = "Enabled" ]; then
    warn "VMware Tools time sync is ALSO enabled alongside chronyd - two competing time sources can cause small clock drift and flapping node sync status; disable one"
  else
    pass "VMware Tools time sync is not competing with chronyd"
  fi
else
  echo "  VMware Tools not detected - if this is a different hypervisor, check its guest time-sync feature isn't fighting chronyd"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before proceeding to Phase 12 (security hardening)."
fi
