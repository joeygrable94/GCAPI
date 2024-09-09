FROM node:21-bullseye as builder

WORKDIR /build

COPY ./app/package*.json ./

RUN npm ci

COPY ./app ./

RUN npm run build

FROM node:alpine as runner

WORKDIR /app

COPY --from=builder build/package*.json .
COPY --from=builder build/.output .
COPY --from=builder build/.env .

RUN npm ci

EXPOSE 3000

CMD ["node", "/app/.output/server/index.mjs"]
