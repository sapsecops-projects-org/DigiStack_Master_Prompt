#!/usr/bin/env bash
# WebSphere ND 9 - Phase 14 DR & handover readiness check
#
#   bash was_phase14_dr_check.sh

BACKUP_DIR="/data/websphere/backup"
RUNBOOK="/data/websphere/docs/bankCell01_runbook.md"
RESTORE_DRILL_MARKER="/data/websphere/backup/.last_restore_drill"

PASS=0; WARN=0; FAIL=0
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
warn() { echo "  [WARN] $1"; WARN=$((WARN+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "=== Config backup recency ==="
LATEST_BACKUP=$(find "$BACKUP_DIR" -iname "*.zip" -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1)
if [ -n "$LATEST_BACKUP" ]; then
  BTIME=$(echo "$LATEST_BACKUP" | awk '{print $1}')
  BFILE=$(echo "$LATEST_BACKUP" | awk '{print $2}')
  AGE_DAYS=$(( ($(date +%s) - ${BTIME%.*}) / 86400 ))
  SIZE=$(du -h "$BFILE" 2>/dev/null | cut -f1)
  echo "  Latest backup: $BFILE (${AGE_DAYS} days old, size $SIZE)"
  if [ "$AGE_DAYS" -le 7 ]; then
    pass "Backup is recent"
  else
    warn "Backup is more than 7 days old - confirm your backup schedule"
  fi
else
  fail "No backup file found in $BACKUP_DIR - run backupConfig.sh"
fi

echo
echo "=== Restore drill recency ==="
if [ -f "$RESTORE_DRILL_MARKER" ]; then
  DRILL_AGE_DAYS=$(( ($(date +%s) - $(stat -c %Y "$RESTORE_DRILL_MARKER" 2>/dev/null)) / 86400 ))
  echo "  Last recorded restore drill: ${DRILL_AGE_DAYS} days ago"
  if [ "$DRILL_AGE_DAYS" -le 90 ]; then
    pass "Restore drill performed within the last quarter"
  else
    warn "No restore drill recorded in over 90 days - an untested backup is not a validated DR plan; schedule one"
  fi
else
  fail "No restore drill marker found - has restoreConfig.sh ever actually been tested against this backup?"
fi

echo
echo "=== Tranlog replication reminder (cannot be verified from this host alone) ==="
echo "  Reminder: backupConfig.sh does NOT capture /data/websphere/tranlogs."
echo "  Confirm separately with Storage that the tranlog volume has its own"
echo "  synchronous (or RPO-zero) replication policy, per the Phase 3 design decision."

echo
echo "=== Runbook presence and completeness ==="
if [ -f "$RUNBOOK" ]; then
  pass "Runbook found at $RUNBOOK"
  RUNBOOK_AGE_DAYS=$(( ($(date +%s) - $(stat -c %Y "$RUNBOOK" 2>/dev/null)) / 86400 ))
  echo "  Last updated ${RUNBOOK_AGE_DAYS} days ago"
  if grep -qiE "TODO|TBD|____|<name>|placeholder|______________" "$RUNBOOK" 2>/dev/null; then
    fail "Runbook contains unfilled placeholders - it isn't handover-ready yet"
  else
    pass "No obvious placeholder text found in the runbook"
  fi
else
  fail "Runbook not found at $RUNBOOK - Production Support cannot take ownership without this"
fi

echo
echo "=== Summary: $PASS pass, $WARN warnings, $FAIL failures ==="
if [ "$FAIL" -gt 0 ]; then
  echo "Resolve FAIL items before the formal handover to Production Support."
fi
