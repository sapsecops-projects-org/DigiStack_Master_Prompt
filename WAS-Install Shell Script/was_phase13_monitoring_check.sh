#!/usr/bin/env bash
# WebSphere ND 9 - Phase 13 monitoring & observability check
# Run on the DMGR host - scans across ALL servers in the cell config.
#
#   AGENT_FLAG="-javaagent:/opt/dynatrace/agent.jar" bash was_phase13_monitoring_check.sh

CELL_CONFIG="/data/websphere/profiles/Dmgr01/config/cells"
AGENT_FLAG="${AGENT_FLAG:--javaagent}"   # substring to search for in genericJvmArguments

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== APM agent coverage across all servers (the 'blind node' check) ==="
COVERED=0; MISSING=0
while IFS= read -r -d '' srv_xml; do
  SRV_NAME=$(dirname "$srv_xml" | xargs basename)
  if grep -q "$AGENT_FLAG" "$srv_xml" 2>/dev/null; then
    echo "  [COVERED] $SRV_NAME"
    COVERED=$((COVERED+1))
  else
    echo "  [MISSING] $SRV_NAME - no '$AGENT_FLAG' found in genericJvmArguments"
    MISSING=$((MISSING+1))
  fi
done < <(find "$CELL_CONFIG" -path "*/servers/*/server.xml" -print0 2>/dev/null)

if [ "$MISSING" -eq 0 ] && [ "$COVERED" -gt 0 ]; then
  pass "All $COVERED discovered servers have the APM agent flag present"
elif [ "$MISSING" -gt 0 ]; then
  fail "$MISSING server(s) missing the APM agent flag out of $((COVERED+MISSING)) total - these are your blind nodes"
else
  warn "No server.xml files found under $CELL_CONFIG - check the path"
fi

echo
echo "=== PMI monitoring level ==="
PMI_HITS=$(grep -rli "PMIService\|instrumentationLevel" "$CELL_CONFIG" 2>/dev/null | wc -l)
if [ "$PMI_HITS" -gt 0 ]; then
  pass "PMI configuration found in $PMI_HITS file(s) - manually confirm the level is Custom/Basic, not 'All' cell-wide"
  grep -rhoi 'instrumentationLevel="[^"]*"' "$CELL_CONFIG" 2>/dev/null | sort -u
else
  warn "No PMI configuration found - confirm monitoring was actually configured, not left at defaults"
fi

echo
echo "=== HPEL text log compatibility ==="
HPEL_HITS=$(grep -rli "hpel" "$CELL_CONFIG" 2>/dev/null | wc -l)
if [ "$HPEL_HITS" -gt 0 ]; then
  if grep -rli "outLogContentType.*TEXT\|textLog" "$CELL_CONFIG" 2>/dev/null | grep -q .; then
    pass "HPEL text log compatibility appears enabled - generic log forwarders (Splunk UF, Filebeat) can tail this"
  else
    warn "HPEL is in use but text log compatibility not confirmed - a generic log forwarder pointed at SystemOut.log may show zero volume; enable HPEL's text log, or use a WAS-aware log shipper"
  fi
else
  echo "  HPEL config not found - profile may be using classic text logging by default, which generic forwarders handle natively"
fi

echo
echo "=== Log freshness ==="
LOG_DIR="/data/websphere/profiles/Dmgr01/logs"
if [ -d "$LOG_DIR" ]; then
  NEWEST=$(find "$LOG_DIR" -type f \( -iname "SystemOut*" -o -iname "*.log" \) -printf '%T@\n' 2>/dev/null | sort -n | tail -1)
  if [ -n "$NEWEST" ]; then
    AGE_MIN=$(( ($(date +%s) - ${NEWEST%.*}) / 60 ))
    echo "  Newest log activity: ${AGE_MIN} minutes ago"
    if [ "$AGE_MIN" -gt 30 ]; then
      warn "No log activity in the last 30 minutes - confirm the server is actually receiving traffic or heartbeat activity"
    else
      pass "Recent log activity found"
    fi
  fi
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items - especially blind nodes - before handing this environment to Production Support."
fi
