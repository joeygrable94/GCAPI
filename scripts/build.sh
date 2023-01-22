#! /usr/bin/env sh

# Exit in case of error
set -e

TAG=${TAG?Variable not set} \
VITE_APP_ENV=${VITE_APP_ENV-production} \
docker-compose \
-f docker-compose.yml \
build
