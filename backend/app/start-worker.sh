#! /usr/bin/env sh
set -e

MODULE_NAME=${MODULE_NAME:-app}
WORKER_NAME=${WORKER_NAME:-worker}
export APP_WORKER=${APP_WORKER:-"$MODULE_NAME.$WORKER_NAME"}

HOST=${BACKEND_HOST:-0.0.0.0}
PORT=${BACKEND_PORT:-8888}

LOG_LEVEL=${BACKEND_LOG_LEVEL:-info}
TASK_QUEUE=${BACKEND_TASK_QUEUE:-main-queue}

# If there's a prestart.sh script in the /app directory
# or other path specified, run it before starting.
PRE_START_PATH=${PRE_START_PATH:-/app/prestart-worker.sh}
echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    . "$PRE_START_PATH"
else
    echo "There is no script $PRE_START_PATH"
fi

# exec celery --app app.worker worker -l info -Q main-queue -c 1
exec celery --app $APP_WORKER $WORKER_NAME -l $LOG_LEVEL -Q $TASK_QUEUE -c 1
