#! /usr/bin/env bash
set -e

echo "Prestarting Backend Worker..."

# Check the DB is connected.
python /app/prestart.py
sleep 1;

echo "Starting Backend Worker..."

celery --app app.worker worker -l info -Q tasks,websites,sitemaps,webpages -c 1
