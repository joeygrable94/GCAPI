#! /usr/bin/env bash
set -e

# Check the DB is connected.
python /app/app/prestart.py
sleep 1;

# Load initial app data
python /app/app/initial_data.py
sleep 1;

bash ./scripts/test.sh "$@"
