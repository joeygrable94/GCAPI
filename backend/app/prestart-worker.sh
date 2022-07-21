#! /usr/bin/env bash
set -e

echo "Prestarting Backend Worker..."

# Check the DB is connected.
python /app/app/prestart.py
sleep 1;

# Check Celery Connection
echo "Check celery status or db connection?"
sleep 1;
