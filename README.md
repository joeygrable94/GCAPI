

python -m pip install -r requirements.txt
python -m main


docker-compose up -d
docker-compose up --build -d
docker-compose up --build --force-recreate --remove-orphans -d


http://localhost:8888/api/v1/redoc
http://localhost:8888/api/v1/docs
http://localhost:8888/api/v1/docs/openapi.json


## Frontend

- [Wait-For-It.sh](https://github.com/vishnubob/wait-for-it)
  - to wait until backend running before building frontend
- [FastAPI OpenAPI Frontend Client Generation](https://fastapi.tiangolo.com/advanced/generate-clients/)
  - for frontend tooling generated via FastAPI reponse model naming and OpenDoc api JSON
  - [OpenAPI Frontend Client Generator](https://github.com/ferdikoomen/openapi-typescript-codegen)
