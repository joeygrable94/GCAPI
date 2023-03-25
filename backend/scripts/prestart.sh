#! /usr/bin/env bash
set -e

echo "Prestarting Backend API..."

# Check the DB is connected.
python /app/prestart.py

# Upgrade DB
# echo "Running Backend DB Migrations..."
# alembic upgrade head

# Create initial data in DB
python /app/initial_data.py
