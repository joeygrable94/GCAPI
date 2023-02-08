#! /usr/bin/env bash
set -e

echo "SAMPLE RUN: python /app/app/worker_pre_start.py"

celery --app app.worker worker -l info -Q main-queue -c 1
