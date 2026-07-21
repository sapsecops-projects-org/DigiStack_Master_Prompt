#!/usr/bin/env bash
# WebSphere ND 9 - Phase 3 storage readiness check
# Run as root (or wasadmin with read access) before Installation Manager setup.
#
#   bash was_phase3_storage_check.sh

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

DIRS=(
  "/opt/IBM/WebSphere/AppServer:binaries"
  "/data/websphere/profiles:profile registry"
  "/data/websphere/logs:logs"
  "/data/websphere/tranlogs:transaction logs"
)

echo "=== Directory existence and mount separation ==="
declare -A MOUNTS_SEEN
for entry in "${DIRS[@]}"; do
  dir="${entry%%:*}"; label="${entry##*:}"
  if [ ! -d "$dir" ]; then
    warn "$dir ($label) does not exist yet"
    continue
  fi
  mnt=$(df --output=target "$dir" 2>/dev/null | tail -1)
  fstype=$(df --output=fstype "$dir" 2>/dev/null | tail -1)
  echo "  $dir ($label) -> mount: $mnt, fstype: $fstype"

  if [ -n "${MOUNTS_SEEN[$mnt]:-}" ] && [ "${MOUNTS_SEEN[$mnt]}" != "$label" ]; then
    warn "$dir shares a mount ($mnt) with '${MOUNTS_SEEN[$mnt]}' - a runaway writer in one can starve the other"
  else
    pass "$dir is on a distinguishable mount ($mnt)"
  fi
  MOUNTS_SEEN[$mnt]="$label"

  case "$fstype" in
    nfs|nfs4)
      if [ "$label" = "profile registry" ] || [ "$label" = "transaction logs" ]; then
        fail "$dir ($label) is on NFS ($fstype) - this needs reliable POSIX locking / low latency; keep it on local or certified clustered storage"
      else
        warn "$dir ($label) is on NFS - acceptable for logs, confirm with Storage this is intentional"
      fi
      ;;
  esac
done

echo
echo "=== Disk space vs inode usage (both matter, check both) ==="
for entry in "${DIRS[@]}"; do
  dir="${entry%%:*}"; label="${entry##*:}"
  [ -d "$dir" ] || continue
  SPACE_PCT=$(df --output=pcent "$dir" 2>/dev/null | tail -1 | tr -dc '0-9')
  INODE_PCT=$(df -i --output=ipcent "$dir" 2>/dev/null | tail -1 | tr -dc '0-9')
  echo "  $dir ($label): space used ${SPACE_PCT:-?}%, inodes used ${INODE_PCT:-?}%"
  if [ "${SPACE_PCT:-0}" -ge 80 ] 2>/dev/null; then warn "$dir space usage above 80%"; fi
  if [ "${INODE_PCT:-0}" -ge 80 ] 2>/dev/null; then warn "$dir inode usage above 80% - df -h alone can miss this ceiling"; fi
done

echo
echo "=== Write latency sanity check (transaction log volume) ==="
if [ -d /data/websphere/tranlogs ] && [ -w /data/websphere/tranlogs ]; then
  START=$(date +%s%N)
  dd if=/dev/zero of=/data/websphere/tranlogs/.iotest bs=4k count=1000 conv=fsync 2>/dev/null
  END=$(date +%s%N)
  rm -f /data/websphere/tranlogs/.iotest
  MS=$(( (END-START)/1000000 ))
  echo "  4000KB fsync'd write took ${MS}ms"
  if [ "$MS" -gt 500 ]; then
    warn "That's slow for a tranlog volume - high write latency here directly throttles transaction throughput"
  else
    pass "Write latency looks reasonable for a tranlog volume"
  fi
else
  warn "/data/websphere/tranlogs missing or not writable - could not run the latency test"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items with the Storage team before Installation Manager setup (Phase 5)."
fi
