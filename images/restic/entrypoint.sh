#!/bin/sh
set -e

export RESTIC_REPOSITORY
export RESTIC_PASSWORD

if ! restic snapshots >/dev/null 2>&1; then
  echo "Initializing restic repository..."
  restic init
fi

echo "${CRON_SCHEDULE} /run-restic.sh >> /proc/1/fd/1 2>&1" > /crontab

exec supercronic /crontab
