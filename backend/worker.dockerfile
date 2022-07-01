FROM python:3.10

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY ./app/requirements.dev.txt /tmp/requirements.dev.txt
RUN pip install --no-cache-dir -r /tmp/requirements.dev.txt

COPY ./app/start-worker.sh /start-worker.sh
RUN chmod +x /start-worker.sh

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

ENV C_FORCE_ROOT=1

CMD [ "/start-worker.sh" ]
