#! /usr/bin/env bash
set -e

echo "Prestarting Backend Worker..."

# Check the DB is connected.
python /app/prestart_worker.py
