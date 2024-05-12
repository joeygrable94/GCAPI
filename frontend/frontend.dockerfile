FROM node:21 as build-stage

WORKDIR /app

COPY ./app/package*.json ./

RUN npm install

# copy build files
COPY ./app/package.json ./app/package-lock.json \
    ./app/app.config.ts ./app/tsconfig.json \
    ./

# copy code src
COPY ./app/src ./src

# copy public dir
COPY ./app/public ./public

EXPOSE 3000

CMD ["npm", "run", "dev"]
