# Security

## Generate Secrets

`openssl rand -hex 32`

## Testing for Security Leaks

### GitLeaks

    gitleaks detect --verbose --config=./gitleaks.toml

#### References & Issues

- [GitLeaks Repository](https://github.com/zricethezav/gitleaks)
- [GitLeaks Allow List for Inline Cases of False Positive Secrets Leak](https://github.com/zricethezav/gitleaks/issues/579)
- [GitLeaks Custom Config .toml File](https://github.com/zricethezav/gitleaks/issues/787)

---

## Full Stack

- [Stack Template, Tiangolo FastAPI-PostgreSQL](https://github.com/tiangolo/full-stack-fastapi-postgresql/blob/master/%7B%7Bcookiecutter.project_slug%7D%7D/README.md)

docker-compose up -d
docker-compose up --build -d
docker-compose up --build --force-recreate --remove-orphans -d

## Backend

python -m pip install -r requirements.dev.txt

bash ./start.sh

http://localhost:8888/api/v1/redoc
http://localhost:8888/api/v1/docs
http://localhost:8888/api/v1/docs/openapi.json


https://rogulski.it/blog/sqlalchemy-14-async-orm-with-fastapi/
https://rogulski.it/blog/fastapi-async-db/
https://www.azepug.az/posts/fastapi/ecommerce-fastapi-nuxtjs/ecommerce-pytest-user-auth-part1.html

## Frontend

- [Wait-For-It.sh](https://github.com/vishnubob/wait-for-it)
  - to wait until backend running before building frontend
- [FastAPI OpenAPI Frontend Client Generation](https://fastapi.tiangolo.com/advanced/generate-clients/)
  - for frontend tooling generated via FastAPI reponse model naming and OpenDoc api JSON
  - [OpenAPI Frontend Client Generator](https://github.com/ferdikoomen/openapi-typescript-codegen)
