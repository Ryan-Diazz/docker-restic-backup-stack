#!/bin/bash
set -eo pipefail

exec 1>/proc/1/fd/1 2>/proc/1/fd/2

trigger_all_dumps() {
  local fifos
  fifos=$(find /triggers -name "*.trigger" -type p)

  if [ -z "${fifos}" ]; then
    echo "ERROR: no trigger pipes found in /triggers" >&2
    exit 1
  fi

  for fifo in ${fifos}; do
    local service
    service=$(basename "${fifo}" .trigger)
    echo "Triggering dump for ${service}..."
    if ! timeout 10 bash -c "echo backup > ${fifo}"; then
      echo "ERROR: timeout sending trigger to ${service}, is the container running?" >&2
      exit 1
    fi
  done
}

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

TIMESTAMP=$(date +%F-%H%M%S)
echo "Restic backup started at ${TIMESTAMP}"

trigger_all_dumps
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
