#! /usr/bin/env sh

# Exit in case of error
set -e

# Import .env vars
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

TAG=${TAG?Variable not set} \
APP_ENV=${APP_ENV-production} \
docker compose \
-f docker-compose.yml \
build
