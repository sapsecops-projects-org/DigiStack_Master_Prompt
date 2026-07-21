#!/usr/bin/env bash
# WebSphere ND 9 - Phase 12 security hardening check
# Run on the Dmgr host. Requires the keystore password to inspect certs.
#
#   KEYSTORE_PASS='********' bash was_phase12_security_check.sh

DMGR_PROFILE="/data/websphere/profiles/Dmgr01"
CELL_CONFIG="$DMGR_PROFILE/config/cells"
KEYSTORE_PASS="${KEYSTORE_PASS:-}"

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Admin security enabled ==="
SECURITY_XML=$(find "$CELL_CONFIG" -maxdepth 1 -iname "security.xml" 2>/dev/null | head -1)
if [ -n "$SECURITY_XML" ] && grep -qi 'enabled="true"' "$SECURITY_XML"; then
  pass "Admin security enabled"
else
  fail "Admin security not confirmed enabled - check $SECURITY_XML"
fi

echo
echo "=== LDAP federation present ==="
if [ -n "$SECURITY_XML" ] && grep -qi "ldap" "$SECURITY_XML"; then
  pass "LDAP repository reference found in security.xml"
else
  warn "No LDAP reference found - confirm federated repository configuration completed"
fi

echo
echo "=== Break-glass local account still present alongside LDAP ==="
if [ -n "$SECURITY_XML" ] && grep -qi "ldap" "$SECURITY_XML" && grep -qiE "filebasedrealm|internalFileRepository" "$SECURITY_XML"; then
  pass "Both LDAP and a local/file-based repository appear configured - break-glass path preserved"
else
  warn "Could not confirm a local break-glass account alongside LDAP - if LDAP-only, an LDAP outage could lock every admin out of the console"
fi

echo
echo "=== Personal certificate: still the default self-signed? ==="
KEYSTORE=$(find "$CELL_CONFIG" -iname "key.p12" 2>/dev/null | head -1)
if [ -n "$KEYSTORE" ] && [ -n "$KEYSTORE_PASS" ]; then
  ISSUER=$(keytool -list -v -alias default -keystore "$KEYSTORE" -storetype PKCS12 -storepass "$KEYSTORE_PASS" 2>/dev/null | grep -i "Issuer:")
  echo "  $ISSUER"
  if echo "$ISSUER" | grep -qi "ibm"; then
    fail "Personal cert still looks like the IBM-issued default self-signed cert - replace it with your bank's CA-signed cert"
  else
    pass "Personal cert does not look like the default self-signed cert"
  fi
else
  warn "key.p12 not found or KEYSTORE_PASS not set - set KEYSTORE_PASS and re-run to check the cert"
fi

echo
echo "=== Bank root CA present in trust store ==="
TRUSTSTORE=$(find "$CELL_CONFIG" -iname "trust.p12" 2>/dev/null | head -1)
if [ -n "$TRUSTSTORE" ] && [ -n "$KEYSTORE_PASS" ]; then
  if keytool -list -keystore "$TRUSTSTORE" -storetype PKCS12 -storepass "$KEYSTORE_PASS" 2>/dev/null | grep -qi "bankroot"; then
    pass "Bank root CA alias found in trust store"
  else
    fail "Bank root CA not found in trust store - rotating the personal cert without this breaks trust between Dmgr and nodes"
  fi
else
  warn "trust.p12 not found or KEYSTORE_PASS not set"
fi

echo
echo "=== TLS protocol configuration ==="
if [ -n "$SECURITY_XML" ] && grep -qiE "TLSv1\.3|TLSv1\.2" "$SECURITY_XML"; then
  pass "Modern TLS protocol reference found"
else
  warn "Could not confirm TLSv1.2/1.3 configuration - check SSL configurations > Quality of protection in the console"
fi

echo
echo "=== Security auditing ==="
if [ -n "$SECURITY_XML" ] && grep -qiE "auditService.*enabled=\"true\"|securityAuditing" "$SECURITY_XML"; then
  pass "Security auditing appears enabled"
else
  warn "Security auditing not confirmed - review System administration > Security auditing in the console"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before this cell is considered ready for a security review."
fi
