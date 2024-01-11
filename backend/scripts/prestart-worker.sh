#! /usr/bin/env bash
set -e

echo "Prestarting Backend Worker..."

# Check DB connection
python cli.py db check-connection
