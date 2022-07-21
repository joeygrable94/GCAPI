FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY ./app/requirements.dev.txt /tmp/requirements.dev.txt
RUN pip install --upgrade pip && pip install --no-cache-dir -r /tmp/requirements.dev.txt

COPY ./app/start.sh /start.sh
RUN chmod +x /start.sh

COPY ./app/start-reload.sh /start-reload.sh
RUN chmod +x /start-reload.sh

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

EXPOSE 8888

CMD [ "/start.sh" ]
