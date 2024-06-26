#! /usr/bin/env bash
set -e

echo "Prestarting Task Worker..."

# Check DB connection
python cli.py db check-db-connection

# Check Redis connection
python cli.py db check-redis-connection
