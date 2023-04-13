#! /usr/bin/env bash

# Exit in case of error
set -e

# Import .env vars
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# docker compose down -v --remove-orphans # Remove possibly previous broken stacks left hanging after an error

if [ $(uname -s) = "Linux" ]; then
    echo "Remove __pycache__ files"
    sudo find . -type d -name __pycache__ -exec rm -r {} \+
fi

# docker compose build
docker compose up -d
docker compose exec -T backend bash ./scripts/test.sh
