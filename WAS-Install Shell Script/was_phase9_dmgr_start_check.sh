#!/usr/bin/env bash
# WebSphere ND 9 - Phase 9 Dmgr start & console verification
#
#   bash was_phase9_dmgr_start_check.sh

PROFILE_PATH="/data/websphere/profiles/Dmgr01"
DMGR_HOST="dmgr01.bank.internal"
ADMIN_HTTPS_PORT=9043

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Dmgr process ==="
if [ -x "$PROFILE_PATH/bin/serverStatus.sh" ]; then
  "$PROFILE_PATH/bin/serverStatus.sh" dmgr 2>/dev/null
else
  warn "serverStatus.sh not found - check PROFILE_PATH"
fi

DMGR_PID=$(pgrep -f "dmgr" | head -1)
if [ -n "$DMGR_PID" ]; then
  pass "Dmgr JVM process running, PID $DMGR_PID"
else
  fail "No Dmgr JVM process found - it may not have started"
fi

echo
echo "=== SystemOut.log startup confirmation ==="
LOG="$PROFILE_PATH/logs/dmgr/SystemOut.log"
if [ -f "$LOG" ]; then
  if grep -q "open for e-business" "$LOG"; then
    pass "Found the 'open for e-business' ready message"
  else
    fail "Ready message not found - Dmgr may still be starting, or failed; check $LOG"
  fi
else
  fail "$LOG not found"
fi

echo
echo "=== FFDC (First Failure Data Capture) check ==="
FFDC_DIR="$PROFILE_PATH/logs/ffdc"
if [ -d "$FFDC_DIR" ]; then
  RECENT_FFDC=$(find "$FFDC_DIR" -name "*.txt" -newermt "-10 minutes" 2>/dev/null | wc -l)
  if [ "$RECENT_FFDC" -gt 0 ]; then
    warn "$RECENT_FFDC recent FFDC file(s) written during this startup - review $FFDC_DIR"
  else
    pass "No recent FFDC entries"
  fi
else
  pass "No FFDC directory yet - clean so far"
fi

echo
echo "=== Actual JVM ulimits vs what Phase 1 configured ==="
if [ -n "$DMGR_PID" ] && [ -r "/proc/$DMGR_PID/limits" ]; then
  ACTUAL_NOFILE=$(awk '/Max open files/ {print $4}' /proc/$DMGR_PID/limits 2>/dev/null)
  ACTUAL_NPROC=$(awk '/Max processes/ {print $3}' /proc/$DMGR_PID/limits 2>/dev/null)
  echo "  Running process: nofile=$ACTUAL_NOFILE, nproc=$ACTUAL_NPROC"
  if [ "${ACTUAL_NOFILE:-0}" -ge 65536 ] 2>/dev/null; then
    pass "Running JVM actually has the intended nofile limit"
  else
    fail "Running JVM's actual nofile limit ($ACTUAL_NOFILE) is lower than Phase 1 configured - it likely started via a session that bypassed /etc/security/limits.d; check how it was launched (cron, systemd, non-interactive SSH)"
  fi
else
  warn "Could not read /proc/<pid>/limits - run this as the same user that started the Dmgr, or as root"
fi

echo
echo "=== Listening ports ==="
if command -v ss &>/dev/null; then
  ss -tlnp 2>/dev/null | grep -E ":($ADMIN_HTTPS_PORT|8879|2809)\b" && pass "Expected Dmgr ports found listening" || warn "Expected Dmgr ports not found listening - confirm actual values against AboutThisProfile.txt"
else
  warn "ss not available to check listening ports"
fi

echo
echo "=== Console reachability (self-signed cert warnings expected pre-Phase 12) ==="
if command -v curl &>/dev/null; then
  HTTP_CODE=$(curl -sk -o /dev/null -w "%{http_code}" --max-time 5 "https://$DMGR_HOST:$ADMIN_HTTPS_PORT/ibm/console" 2>/dev/null)
  if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
    pass "Console responded with HTTP $HTTP_CODE"
  else
    warn "Console returned HTTP ${HTTP_CODE:-no response} - if this is run from outside the bastion, that may be expected by design"
  fi
else
  warn "curl not available to test console reachability"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before federating nodes (Phase 10)."
fi
