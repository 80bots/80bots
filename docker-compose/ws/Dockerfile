FROM node:10.21.0

# Setup starup script
WORKDIR /var/www/

ARG AUTH_HOST
ARG AUTH_ENDPOINT
ARG REDIS_HOST
ARG REDIS_PORT
ARG REDIS_PASSWORD
ARG REDIS_PREFIX
ARG APP_DEBUG

RUN npm install -g laravel-echo-server envsub

COPY laravel-echo-server.template.json laravel-echo-server.template.json

RUN touch laravel-echo-server.json

RUN envsub \
    --env AUTH_HOST=${AUTH_HOST} \
    --env AUTH_ENDPOINT=${AUTH_ENDPOINT} \
    --env REDIS_HOST=${REDIS_HOST} \
    --env REDIS_PORT=${REDIS_PORT} \
    --env REDIS_PASSWORD=${REDIS_PASSWORD} \
    --env REDIS_PREFIX=${REDIS_PREFIX} \
    --env APP_DEBUG=${APP_DEBUG} \
    --system ./laravel-echo-server.template.json ./laravel-echo-server.json
RUN cat ./laravel-echo-server.json
CMD laravel-echo-server start --force