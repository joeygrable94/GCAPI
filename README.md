# GCAPI Stack

## Table of Contents

- [GCAPI Stack](#gcapi-stack)
  - [Table of Contents](#table-of-contents)
  - [Getting Starting](#getting-starting)
    - [Building the Container](#building-the-container)
- [The Full Stack](#the-full-stack)
  - [Backend](#backend)
    - [OpenAPI Documentation](#openapi-documentation)
    - [Database Object Relation Mapping](#database-object-relation-mapping)
    - [Alembic Database Migration](#alembic-database-migration)
  - [Frontend](#frontend)
    - [OpenAPI Typescript Client Generation](#openapi-typescript-client-generation)
  - [End-to-End Testing](#end-to-end-testing)

---

## Getting Starting

Generate App Secrets

    Use `openssl rand -hex 32` to generate a secret key.

Use the base `example.env` file to create a local development `.env` file.

### Building the Container

Build the container and start descretely.

    docker-compose up --build -d

If the image is already built, start the container descretely

    docker-compose up -d

If breaking changes are introduced, a force recreate may be needed, and remove any orphans to keep the system lean.

    docker-compose up --build --force-recreate --remove-orphans -d

---

# The Full Stack

This GCAPI stack is based off the following [Stack Template FastAPI-PostgreSQL, by @Tiangolo on GitHub](https://github.com/tiangolo/full-stack-fastapi-postgresql/blob/master/%7B%7Bcookiecutter.project_slug%7D%7D/README.md).

---

## Backend

### OpenAPI Documentation

- [GCAPI OpenAPI Schema](http://localhost:8888/api/v1/docs/openapi.json)
- [GCAPI Swagger UI Documentation](http://localhost:8888/api/v1/docs)
- [GCAPI ReDoc Alternate UI Documentation](http://localhost:8888/api/v1/redoc)

### Database Object Relation Mapping

- [SQLAlchemy 1.4 ORM with FastAPI WalkThrough](https://rogulski.it/blog/sqlalchemy-14-async-orm-with-fastapi/)
- [FastAPI SQLAlchemy Async DB Example Config](https://rogulski.it/blog/fastapi-async-db/)

### Alembic Database Migration

Check current db version.

`docker-compose run backend alembic current`

After changing db models/tables, run revision, and autogenerate.
Always add a message about what changed in the db models/tables.

`docker-compose run backend alembic revision --autogenerate -m "added table ____"`

To upgrade or downgrade the container database version.

    docker-compose run backend alembic upgrade head
    docker-compose run backend alembic upgrade +1
    docker-compose run backend alembic downgrade -1
    docker-compose run backend alembic downgrade base

---

## Frontend

### OpenAPI Typescript Client Generation

- This is a great introduction tutorial on [FastAPI OpenAPI Frontend Client Generation](https://fastapi.tiangolo.com/advanced/generate-clients/)
- [OpenAPI Frontend Client Generator](https://github.com/ferdikoomen/openapi-typescript-codegen) provides amazing frontend tooling that generates a typescript OpenAPI model based on any OpenAPI JSON schema.

---

## End-to-End Testing

- CI/CD pipeline...
