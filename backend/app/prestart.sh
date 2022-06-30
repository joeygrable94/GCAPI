#! /usr/bin/env bash

echo "Prestarting Backend API..."

# Check the DB is connected.
python /app/app/prestart.py
sleep 1;

# Run DB migrations
alembic upgrade head
sleep 1;

python /app/app/initial_data.py
sleep 1;
