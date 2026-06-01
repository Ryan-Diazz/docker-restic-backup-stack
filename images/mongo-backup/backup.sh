#!/bin/bash
set -eo pipefail

TIMESTAMP=$(date +%F-%H%M%S)
echo "Mongo backup started at ${TIMESTAMP}"

LOCKFILE="/backup/.lock"
touch "${LOCKFILE}"
trap 'rm -f "${LOCKFILE}"' EXIT

TMPFILE="/backup/.${SERVICE}-${TIMESTAMP}.tmp"
OUTFILE="/backup/${SERVICE}-latest.archive.gz"


mongodump \
  --host="${MONGO_HOST}" \
  --serverSelectionTimeoutMS=5000 \
  --archive="${TMPFILE}" \
  --gzip

if [ ! -s "${TMPFILE}" ]; then
  echo "ERROR: dump file is empty, aborting" >&2
  exit 1
fi

mv "${TMPFILE}" "${OUTFILE}"

TIMESTAMP=$(date +%F-%H%M%S)
echo "Mongo backup completed at ${TIMESTAMP}"