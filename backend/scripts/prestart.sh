#! /usr/bin/env bash
set -e

echo "Prestarting Backend API..."

# Check the DB is connected.
python /app/prestart.py
sleep 1;

# Run DB migrations
# alembic upgrade head
# sleep 1;
