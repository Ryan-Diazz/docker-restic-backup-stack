#!/bin/bash
set -eo pipefail

TIMESTAMP=$(date +%F-%H%M%S)

echo "Restic backup started at ${TIMESTAMP}"

wait_for_all_locks() {
  local timeout=900 # 15 minutes for dumps to finish
  local elapsed=0

  while find /staging -name ".lock" | grep -q .; do
    if [ "${elapsed}" -ge "${timeout}" ]; then
      echo "ERROR: lockfiles still present after ${timeout}s, aborting" >&2
      find /staging -name ".lock" >&2
      exit 1
    fi
    echo "Waiting for dumps to finish..."
    sleep 5
    elapsed=$((elapsed + 5))
  done
}

wait_for_all_locks

restic backup \
  /staging \
  /data

restic forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 6 \
  --prune

TIMESTAMP=$(date +%F-%H%M%S)

echo "Restic backup completed at ${TIMESTAMP}"
