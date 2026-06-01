#!/bin/bash
set -eo pipefail

exec 1>/proc/1/fd/1 2>/proc/1/fd/2

TIMESTAMP=$(date +%F-%H%M%S)
echo "Restic check started at ${TIMESTAMP}"

restic check

TIMESTAMP=$(date +%F-%H%M%S)
echo "Restic check completed at ${TIMESTAMP}"