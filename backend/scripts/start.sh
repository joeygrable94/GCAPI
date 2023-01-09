#! /usr/bin/env bash
set -e

if [ -f /app/app/main.py ]; then
    DEFAULT_MODULE_NAME=app.main
elif [ -f /app/main.py ]; then
    DEFAULT_MODULE_NAME=main
else
    DEFAULT_MODULE_NAME=app.main
fi
MODULE_NAME=${MODULE_NAME:-$DEFAULT_MODULE_NAME}
VARIABLE_NAME=${VARIABLE_NAME:-app}
export APP_MODULE=${APP_MODULE:-"$MODULE_NAME:$VARIABLE_NAME"}

HOST=${BACKEND_HOST:-0.0.0.0}
PORT=${BACKEND_PORT:-8888}
LOG_LEVEL=${BACKEND_LOG_LEVEL:-info}

# Run the prestart.sh script if the file exists
PRE_START_PATH=${PRE_START_PATH:-/prestart.sh}
echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    . "$PRE_START_PATH"
else
    echo "There is no script $PRE_START_PATH"
fi

# Start ASGI Server with live reload
exec uvicorn $APP_MODULE --host $HOST --port $PORT --log-level $LOG_LEVEL
