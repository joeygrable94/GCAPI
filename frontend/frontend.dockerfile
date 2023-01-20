FROM node:alpine

WORKDIR /usr/src/app

COPY ./app/package*.json ./

RUN npm install

# copy build files
COPY ./app/package.json ./app/package-lock.json \
    ./app/vite-env.d.ts ./app/vite.config.ts ./app/tsconfig.json \
    ./app/.prettierrc ./app/.prettierignore \
    ./

# copy code src
COPY ./app/src ./src

# copy public dir
COPY ./app/public ./public

RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start"]
