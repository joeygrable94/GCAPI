#! /usr/bin/env bash
set -e

# Check the DB is connected.
python /app/app/prestart.py
sleep 1;

bash ./scripts/test.sh "$@"
