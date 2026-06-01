#!/bin/bash
set -eo pipefail

export RESTIC_REPOSITORY
export RESTIC_PASSWORD

if ! restic snapshots >/dev/null 2>&1; then
  echo "Initializing restic repository..."
  restic init
fi

printf '%s /app/run-restic.sh >> /proc/1/fd/1 2>&1\n' "${CRON_SCHEDULE}"       > /app/crontab
printf '%s /app/run-check.sh  >> /proc/1/fd/1 2>&1\n' "${CHECK_CRON_SCHEDULE}"  >> /app/crontab

exec supercronic /app/crontab