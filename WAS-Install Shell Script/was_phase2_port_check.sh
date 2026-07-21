#!/usr/bin/env bash
# WebSphere ND 9 - Phase 2 network connectivity check
#
# Run this FROM the node/app host TOWARD the Dmgr, LDAP, and DB hosts
# (and from the Dmgr host toward each node) to confirm every port the
# Network team's firewall ticket promised is ACTUALLY open, before you
# attempt profile federation with addNode.sh.
#
# Edit the host variables below for your environment, then run:
#   bash was_phase2_port_check.sh

DMGR_HOST="dmgr01.bank.internal"
NODE_HOST="appnode01.bank.internal"
LDAP_HOST="ldap.bank.internal"
DB_HOST="db01.bank.internal"

check() {
  local host="$1" port="$2" label="$3"
  if timeout 3 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
    echo "  [OPEN]     $host:$port  ($label)"
  else
    echo "  [BLOCKED]  $host:$port  ($label)"
  fi
}

echo "=== Deployment Manager ports (test from node/app hosts) ==="
check "$DMGR_HOST" 8879 "SOAP connector - federation, admin scripting"
check "$DMGR_HOST" 9060 "Admin console HTTP"
check "$DMGR_HOST" 9043 "Admin console HTTPS"
check "$DMGR_HOST" 2809 "Bootstrap/RMI - naming lookups"

echo "=== Application node ports (test from Dmgr/load balancer) ==="
check "$NODE_HOST" 9080 "HTTP transport - app traffic"
check "$NODE_HOST" 9443 "HTTPS transport - app traffic"

echo "=== LDAP (needed later for admin security, Phase 12) ==="
check "$LDAP_HOST" 389 "LDAP - plaintext, do not rely on alone"
check "$LDAP_HOST" 636 "LDAPS - required in regulated environments"

echo "=== Database (needed post-install for session/JMS persistence) ==="
check "$DB_HOST" 1521 "Oracle listener - adjust port/label if DB2 or other"

echo
echo "Any [BLOCKED] result above means the firewall ticket is not actually"
echo "closed yet, even if it shows 'resolved' in ServiceNow. Confirm before"
echo "running addNode.sh, or you'll spend an hour debugging the wrong layer."
