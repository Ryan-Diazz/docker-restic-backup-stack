#!/bin/bash
set -eo pipefail

LOCKFILE="/tmp/restic-health.lock"
TIMEOUT=30

# Prevent concurrent health checks
if [ -f "${LOCKFILE}" ]; then
  echo "Health check already running" >&2
  exit 1
fi

touch "${LOCKFILE}"
trap 'rm -f "${LOCKFILE}"' EXIT

# Check 1: restic binary is available
if ! command -v restic >/dev/null 2>&1; then
  echo "FAIL: restic binary not found" >&2
  exit 1
fi

# Check 2: repository is reachable and readable
if ! timeout "${TIMEOUT}" restic snapshots >/dev/null 2>&1; then
  echo "FAIL: repository is unreachable or unreadable" >&2
  exit 1
fi

# Check 3: repository is not locked
if timeout "${TIMEOUT}" restic list locks 2>/dev/null | grep -q .; then
  echo "FAIL: repository has a stale lock" >&2
  exit 1
fi

# Check 4: NAS mount is alive (read AND write)
if ! touch /repository/.healthcheck 2>/dev/null; then
  echo "FAIL: repository mount is not writable" >&2
  exit 1
fi
rm -f /repository/.healthcheck

echo "OK"
exit 0