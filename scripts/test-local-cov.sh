#! /usr/bin/env bash

# Exit in case of error
set -e

# Import .env vars
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Remove possibly previous broken stacks left hanging after an error
docker compose down -v --remove-orphans

# Remove pycache files
if [ $(uname -s) = "Linux" ]; then
    echo "Remove __pycache__ files"
    sudo find . -type d -name __pycache__ -exec rm -r {} \+
fi

docker compose build
docker compose up -d
sleep 30
docker compose exec -T backend bash ./scripts/test-cov.sh
