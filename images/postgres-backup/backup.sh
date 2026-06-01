#!/bin/sh
set -e

exec 1>/proc/1/fd/1 2>/proc/1/fd/2

TIMESTAMP=$(date +%F-%H%M%S)
echo "Postgres backup started at ${TIMESTAMP}"

LOCKFILE="/backup/.lock"
touch "${LOCKFILE}"
trap 'rm -f "${LOCKFILE}"' EXIT

export PGPASSWORD="${POSTGRES_PASSWORD}"

TMPFILE="/backup/${SERVICE}-latest.sql.gz.tmp"
OUTFILE="/backup/${SERVICE}-latest.sql.gz"

pg_dump \
  -h "${POSTGRES_HOST}" \
  -U "${POSTGRES_USER}" \
  "${POSTGRES_DB}" \
  | gzip > "${TMPFILE}"

if [ ! -s "${TMPFILE}" ]; then
  echo "ERROR: dump file is empty, aborting" >&2
  exit 1
fi

mv "${TMPFILE}" "${OUTFILE}"

TIMESTAMP=$(date +%F-%H%M%S)
echo "Postgres backup completed at ${TIMESTAMP}"