#! /usr/bin/env bash
set -e

echo "Prestarting Backend API..."

# Check the DB is connected.
python /app/prestart.py

# Build DB — ONLY RUN ONCE
# echo "Building Backend Database Tables..."
# python /app/build.py

# Upgrade DB
echo "Running Backend Database Table Migrations..."
alembic upgrade head

# Create initial data in DB
python /app/initial_data.py
