#!/bin/sh
set -e

TIMESTAMP=$(date +%F-%H%M-%S)

mkdir -p /backup

export PGPASSWORD="${POSTGRES_PASSWORD}"

pg_dump \
  -h "${POSTGRES_HOST}" \
  -U "${POSTGRES_USER}" \
  "${POSTGRES_DB}" \
  | gzip \
  > "/backup/${SERVICE}-${TIMESTAMP}.sql.gz"

find /backup -type f -mtime +7 -delete

echo "Postgres backup completed at $(date)"
