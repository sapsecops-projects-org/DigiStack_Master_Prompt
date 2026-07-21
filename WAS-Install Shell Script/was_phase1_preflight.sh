#!/usr/bin/env bash
# WebSphere ND 9 - Phase 1 OS pre-flight check
# Run as root (or via sudo) on the target RHEL 8 host BEFORE installing
# IBM Installation Manager / WebSphere ND 9.
#
#   sudo bash was_phase1_preflight.sh

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== OS version ==="
if grep -q "release 8" /etc/redhat-release 2>/dev/null; then
  pass "RHEL 8 detected: $(cat /etc/redhat-release)"
else
  warn "Not RHEL 8, or /etc/redhat-release missing: $(cat /etc/redhat-release 2>/dev/null)"
fi

echo "=== wasadmin user ==="
if id wasadmin &>/dev/null; then
  pass "wasadmin user exists ($(id wasadmin))"
else
  fail "wasadmin user not found - create it before proceeding"
fi

echo "=== Required RPMs ==="
for pkg in glibc glibc.i686 libstdc++ libstdc++.i686 ksh tar unzip; do
  if rpm -q "$pkg" &>/dev/null; then
    pass "$pkg installed"
  else
    fail "$pkg missing - run: dnf install -y $pkg"
  fi
done

echo "=== ulimits for wasadmin ==="
NOFILE=$(su - wasadmin -c 'ulimit -Hn' 2>/dev/null)
NPROC=$(su - wasadmin -c 'ulimit -Hu' 2>/dev/null)
if [ "${NOFILE:-0}" -ge 65536 ] 2>/dev/null; then pass "nofile hard limit: $NOFILE"; else warn "nofile hard limit is ${NOFILE:-unknown}, recommend >=65536"; fi
if [ "${NPROC:-0}" -ge 16384 ] 2>/dev/null; then pass "nproc hard limit: $NPROC"; else warn "nproc hard limit is ${NPROC:-unknown}, recommend >=16384"; fi

echo "=== Filesystem layout ==="
for dir in /opt/IBM /data/websphere/profiles /data/websphere/logs; do
  if [ -d "$dir" ]; then pass "$dir exists"; else warn "$dir missing"; fi
done
ROOT_MOUNT=$(df --output=target /data/websphere 2>/dev/null | tail -1)
if [ "$ROOT_MOUNT" = "/" ]; then
  warn "/data/websphere is on the root filesystem, not a dedicated mount - runaway logs can crash the whole OS"
else
  pass "/data/websphere is on its own mount: $ROOT_MOUNT"
fi

echo "=== /tmp exec permissions ==="
if mount | grep -q " /tmp .*noexec"; then
  warn "/tmp is mounted noexec - point Installation Manager at -DIATempDir=/data/websphere/tmp instead"
else
  pass "/tmp allows exec"
fi

echo "=== SELinux ==="
SELINUX_STATE=$(getenforce 2>/dev/null)
if [ "$SELINUX_STATE" = "Disabled" ]; then
  warn "SELinux is disabled - common audit finding in regulated environments; prefer enforcing with proper context labels"
else
  pass "SELinux state: $SELINUX_STATE"
fi

echo "=== firewalld ==="
if systemctl is-active firewalld &>/dev/null; then
  pass "firewalld is active"
  for port in 8879 9060 9043 9080 9443; do
    if firewall-cmd --list-ports 2>/dev/null | grep -qw "${port}/tcp"; then
      pass "port $port/tcp open"
    else
      warn "port $port/tcp not open yet - confirm with the Network team's ticket"
    fi
  done
else
  warn "firewalld not active - confirm Network has an equivalent control in place"
fi

echo "=== Hostname & DNS ==="
FQDN=$(hostname -f 2>/dev/null)
if getent hosts "$FQDN" &>/dev/null; then
  pass "forward resolution OK for $FQDN"
else
  fail "forward resolution failed for $FQDN - fix /etc/hosts or DNS before profile creation"
fi

echo "=== Time sync ==="
if systemctl is-active chronyd &>/dev/null; then
  pass "chronyd is active"
  if chronyc tracking 2>/dev/null | grep -q "Leap status.*Normal"; then
    pass "chrony tracking normal"
  else
    warn "chrony tracking not confirmed normal - run chronyc tracking manually"
  fi
else
  fail "chronyd not active - clock drift will break node federation later"
fi

echo "=== Swappiness ==="
SWAP=$(cat /proc/sys/vm/swappiness 2>/dev/null)
if [ "${SWAP:-60}" -le 10 ] 2>/dev/null; then
  pass "vm.swappiness = $SWAP"
else
  warn "vm.swappiness = ${SWAP:-unknown} - recommend <=10 to avoid JVM heap paging and GC pause spikes"
fi

echo "=== Transparent Huge Pages ==="
THP=$(cat /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null)
if echo "$THP" | grep -q '\[never\]'; then
  pass "THP disabled"
else
  warn "THP appears enabled: ${THP:-unknown} - known to cause JVM GC latency spikes, recommend disabling"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before moving to Installation Manager setup (Phase 5)."
fi
