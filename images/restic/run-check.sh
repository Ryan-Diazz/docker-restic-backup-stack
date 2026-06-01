#!/bin/bash
set -eo pipefail

TIMESTAMP=$(date +%F-%H%M%S)
echo "Restic check started at ${TIMESTAMP}"

restic check

TIMESTAMP=$(date +%F-%H%M%S)
echo "Restic check completed at ${TIMESTAMP}"