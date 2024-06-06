FROM node:21-bullseye

WORKDIR /app

COPY ./app2/package*.json ./

RUN npm ci

COPY ./app ./

RUN npm run build

EXPOSE 3000

CMD ["node", "/app/.output/server/index.mjs"]
