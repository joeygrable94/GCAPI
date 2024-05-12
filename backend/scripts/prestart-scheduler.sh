#! /usr/bin/env bash
set -e

echo "Prestarting Task Scheduler..."

# Check DB connection
python cli.py db check-db-connection

# Check Redis connection
python cli.py db check-redis-connection
