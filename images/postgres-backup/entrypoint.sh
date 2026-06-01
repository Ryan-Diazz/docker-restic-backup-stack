#!/bin/sh
set -e

echo "${CRON_SCHEDULE} /app/backup.sh >> /proc/1/fd/1 2>&1" > /crontab

exec supercronic /crontab
