FROM python:3.11

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY ./app/requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install --no-cache-dir -r /tmp/requirements.txt \
    && poetry config virtualenvs.create false

COPY ./scripts/prestart-worker.sh ./scripts/start-worker.sh /
RUN chmod +x /start-worker.sh /prestart-worker.sh

COPY ./app/scripts /scripts
COPY ./app/app /app/app
WORKDIR /app/

# Copy poetry.lock* in case it doesn't exist in the repo
COPY ./app/pyproject.toml ./app/poetry.lock* /app/

# Allow installing dev dependencies to run tests
ARG INSTALL_DEV=false
RUN bash -c "if [ $INSTALL_DEV == true ] ; then poetry install --no-root ; else poetry install --no-root --no-dev ; fi"

ENV PYTHONPATH=/app

ENV C_FORCE_ROOT=1

CMD [ "/start-worker.sh" ]
