FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY ./app/requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install --no-cache-dir -r /tmp/requirements.txt \
    && poetry config virtualenvs.create false

COPY ./scripts/prestart.sh ./scripts/start.sh ./scripts/start-reload.sh ./scripts/start-tests.sh /
RUN chmod +x /prestart.sh /start.sh /start-reload.sh /start-tests.sh

COPY ./app/app /app/app
COPY ./app/alembic /app/alembic
COPY ./app/alembic.ini ./app/start.py ./app/prestart.py /app/
WORKDIR /app/

# Copy poetry.lock* in case it doesn't exist in the repo
COPY ./app/pyproject.toml ./app/poetry.lock* /app/

# Allow installing dev dependencies to run tests
ARG INSTALL_DEV=false
RUN bash -c "if [ $INSTALL_DEV == 'true' ] ; then poetry install --no-root ; else poetry install --no-root --no-dev ; fi"

ENV PYTHONPATH=/app

EXPOSE 8888

CMD [ "/start.sh" ]
