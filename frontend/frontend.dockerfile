# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:17.8 as build-frontend

WORKDIR /app

COPY ./app/nginx.conf /app/nginx.conf
COPY ./app/nginx-backend-not-found.conf /app/nginx-backend-not-found.conf

COPY ./app/package*.json /app/

COPY ./app/ /app/

RUN npm install

ARG FRONTEND_ENV=${FRONTEND_ENV}

# TODO: write tests
# Comment out the next line to disable tests
# RUN npm run test:unit

RUN npm run build

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.15

COPY --from=build-frontend /app/dist/ /usr/share/nginx/html
COPY --from=build-frontend /app/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./app/nginx-backend-not-found.conf /etc/nginx/extra-conf.d/backend-not-found.conf
