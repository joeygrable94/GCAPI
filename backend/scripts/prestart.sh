#! /usr/bin/env bash
set -e

echo "Prestarting Backend API..."

# Load keys
python cli.py secure load-keys

# Check DB connection
python cli.py db check-connection

# DO NOT USE UNLESS DEBUGGING
# python cli.py db create-db

# Upgrade DB
echo "Running Backend Database Table Migrations..."
alembic upgrade head

# Create initial data
python cli.py db add-initial-data
