#! /usr/bin/env bash
set -e

# Run the prestart-worker.sh script if the file exists
WORKER_PRE_START_PATH=${WORKER_PRE_START_PATH:-/prestart-worker.sh}
echo "Checking for worker prestart script in $WORKER_PRE_START_PATH"
if [ -f $WORKER_PRE_START_PATH ] ; then
    echo "Running worker prestart script $WORKER_PRE_START_PATH"
    . "$WORKER_PRE_START_PATH"
else
    echo "There is no worker prestart script $WORKER_PRE_START_PATH"
fi

echo "Starting Task Worker..."

taskiq worker app.worker:task_broker app.tasks
