#! /usr/bin/env bash
set -e

# Run the prestart-scheduler.sh script if the file exists
SCHEDULER_PRE_START_PATH=${SCHEDULER_PRE_START_PATH:-/prestart-scheduler.sh}
echo "Checking for scheduler prestart script in $PRE_START_PATH"
if [ -f $SCHEDULER_PRE_START_PATH ] ; then
    echo "Running scheduler prestart script $SCHEDULER_PRE_START_PATH"
    . "$SCHEDULER_PRE_START_PATH"
else
    echo "There is no scheduler prestart script $SCHEDULER_PRE_START_PATH"
fi

echo "Starting Task Scheduler..."

taskiq scheduler app.worker:task_scheduler app.tasks
