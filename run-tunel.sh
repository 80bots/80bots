#!/bin/bash

BASE_NAME="$(openssl rand -hex 3)"
SCHEMA="https"
DOMAIN=serveo.net

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

DOCKER_WEB_SERVER_HOST=$(read_var DOCKER_WEB_SERVER_HOST .env)
DOCKER_WEB_SERVER_PORT=$(read_var DOCKER_WEB_SERVER_PORT .env)
DOCKER_API_SERVER_HOST=$(read_var DOCKER_API_SERVER_HOST .env)
DOCKER_API_SERVER_PORT=$(read_var DOCKER_API_SERVER_PORT .env)
DOCKER_SOCKET_SERVER_HOST=$(read_var DOCKER_SOCKET_SERVER_HOST .env)
DOCKER_SOCKET_SERVER_PORT=$(read_var DOCKER_SOCKET_SERVER_PORT .env)

WEB_PREFIX="$BASE_NAME"
API_PREFIX="api-$BASE_NAME"
WS_PREFIX="ws-$BASE_NAME"

WEB_HOST=$WEB_PREFIX.$DOMAIN
API_HOST=$API_PREFIX.$DOMAIN
WS_HOST=$WS_PREFIX.$DOMAIN

# Make it possible to publish the local project https://serveo.net/#manual
# TODO: Deploy our own hosted serveo tool in order to process everything through our domain and servers

ssh \
  -R "$WEB_HOST:80":"$DOCKER_WEB_SERVER_HOST:$DOCKER_WEB_SERVER_PORT" \
  -R "$API_HOST:80":"$DOCKER_API_SERVER_HOST:$DOCKER_API_SERVER_PORT" \
  -R "$WS_HOST:80":"$DOCKER_SOCKET_SERVER_HOST:$DOCKER_SOCKET_SERVER_PORT" \
  $DOMAIN