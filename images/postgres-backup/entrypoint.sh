#!/bin/bash
set -eo pipefail

exec 1>/proc/1/fd/1 2>/proc/1/fd/2

FIFO="/triggers/${SERVICE}.trigger"

# Create the named pipe if it doesn't exist
[ -p "${FIFO}" ] || mkfifo "${FIFO}"

echo "${SERVICE} dump container ready, listening for triggers..."

cleanup() {
  echo "${SERVICE} dump container shutting down..."
  rm -f "${FIFO}"
  exit 0
}

trap cleanup SIGTERM SIGINT

exec 3<>"${FIFO}"

while true; do
  # Blocks here until restic writes to the pipe
  read -r signal <&3

  case "${signal}" in
    backup)
      echo "${SERVICE} Trigger received, starting backup..."
      /app/backup.sh
      echo "${SERVICE} Backup finished, listening for next trigger..."
      ;;
    stop)
      echo "${SERVICE} Stop signal received via trigger pipe..."
      cleanup
      ;;
    *)
      echo "${SERVICE} Unknown signal: ${signal}" >&2
      ;;
  esac
done