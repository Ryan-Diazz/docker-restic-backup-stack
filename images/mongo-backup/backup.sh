#!/bin/sh
set -e

TIMESTAMP=$(date +%F-%H%M-%S)

mkdir -p /backup

mongodump \
  --host="${MONGO_HOST}" \
  --archive="/backup/${SERVICE}-${TIMESTAMP}.archive.gz" \
  --gzip

find /backup -type f -mtime +7 -delete

echo "Mongo backup completed at $(TIMESTAMP)"
