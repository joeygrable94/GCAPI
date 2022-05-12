FROM python:3.10

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY ./app/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY ./app/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

COPY ./app/start-worker.sh /start-worker.sh
RUN chmod +x /start-worker.sh

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

ENV C_FORCE_ROOT=1

CMD [ "/start-worker.sh" ]
