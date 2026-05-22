#!/bin/sh
set -e

restic backup \
  /staging \
  /data

restic forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 6 \
  --prune

echo "Restic backup completed at $(date)"
