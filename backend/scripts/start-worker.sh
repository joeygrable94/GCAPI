#! /usr/bin/env bash
set -e

echo "Prestarting Backend Worker..."

# Check the DB is connected.
python /app/prestart.py

echo "Starting Backend Worker..."

taskiq worker app.broker:broker app.tasks.core_tasks app.tasks.website_tasks
