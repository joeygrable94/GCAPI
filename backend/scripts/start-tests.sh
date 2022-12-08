#! /usr/bin/env bash
set -e

# Check the DB is connected.
python /app/prestart.py
sleep 1;

bash /app/scripts/test.sh "$@"
