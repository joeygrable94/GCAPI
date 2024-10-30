#! /usr/bin/env sh

# Exit in case of error
set -e

# Import .env vars
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

DOMAIN=${DOMAIN?Variable not set} \
TRAEFIK_PUBLIC_NETWORK_IS_EXTERNAL=false \
INSTALL_DEV=true \
docker compose \
-f docker-compose.yml \
config > docker-stack.yml

docker compose -f docker-stack.yml build
docker compose -f docker-stack.yml down -v --remove-orphans # Remove possibly previous broken stacks left hanging after an error
docker compose -f docker-stack.yml up -d
docker compose -f docker-stack.yml exec -T backend bash /start-tests.sh
docker compose -f docker-stack.yml down -v --remove-orphans
