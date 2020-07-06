#!/bin/bash

./install.sh

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

SCHEMA="https"
SUBDOMAIN="80bots"
RANDOM_HASH="$(openssl rand -hex 3)"

FRONTEND_SUBDOMAIN="frontend-$SUBDOMAIN-$RANDOM_HASH"
BACKEND_SUBDOMAIN="backend-$SUBDOMAIN-$RANDOM_HASH"
WS_SUBDOMAIN="ws-$SUBDOMAIN-$RANDOM_HASH"

START="# AUTOGENERATED - START"
END="# AUTOGENERATED - END"

SERVICE=$(read_var TUNNEL_SERVICE .env)
SERVICE=${SERVICE:-ngrok}

if [ "$SERVICE" == "serveo" ]; then
  DOMAIN="serveo.net"
elif [ "$SERVICE" == "ngrok" ]; then
  DOMAIN="ngrok.io"
fi

setup_env() {
  echo \ >> .env

  echo $START >> .env

  echo "APP_URL=${SCHEMA}://${BACKEND_SUBDOMAIN}.${DOMAIN}" >> .env
  echo "WEB_CLIENT_URL=${SCHEMA}://${FRONTEND_SUBDOMAIN}.${DOMAIN}" >> .env
  echo "WS_URL=${SCHEMA}://${WS_SUBDOMAIN}.${DOMAIN}" >> .env

  if [ "$SERVICE" == "ngrok" ]; then
    echo "FRONTEND_SUBDOMAIN=${FRONTEND_SUBDOMAIN}" >> .env
    echo "BACKEND_SUBDOMAIN=${BACKEND_SUBDOMAIN}" >> .env
    echo "WS_SUBDOMAIN=${WS_SUBDOMAIN}" >> .env
  fi

  echo $END >> .env
}

if [ "$(uname)" == "Darwin" ]; then
    sed -i .back "/$START/,/$END:/d" .env
    sed -i .back '${/^[[:space:]]*$/d;}' .env
    setup_env
    rm -rf .env.back
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sed -i "/$START/,/$END:/d" .env
    sed -i '${/^[[:space:]]*$/d;}' .env
    setup_env
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
    echo "Unsupported platform" && exitt -1
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
    echo "Unsupported platform" && exitt -1
fi

if [ "$SERVICE" == "serveo" ]; then
  DOCKER_FRONTEND_SERVER_HOST=$(read_var DOCKER_FRONTEND_SERVER_HOST .env)
  DOCKER_FRONTEND_SERVER_HOST=${DOCKER_FRONTEND_SERVER_HOST:-localhost}

  DOCKER_FRONTEND_SERVER_PORT=$(read_var DOCKER_FRONTEND_SERVER_PORT .env)
  DOCKER_FRONTEND_SERVER_PORT=${DOCKER_FRONTEND_SERVER_PORT:-80}

  DOCKER_BACKEND_SERVER_HOST=$(read_var DOCKER_BACKEND_SERVER_HOST .env)
  DOCKER_BACKEND_SERVER_HOST=${DOCKER_BACKEND_SERVER_HOST:-localhost}

  DOCKER_BACKEND_SERVER_PORT=$(read_var DOCKER_BACKEND_SERVER_PORT .env)
  DOCKER_BACKEND_SERVER_PORT=${DOCKER_BACKEND_SERVER_PORT:-8080}

  DOCKER_SOCKET_SERVER_HOST=$(read_var DOCKER_SOCKET_SERVER_HOST .env)
  DOCKER_SOCKET_SERVER_HOST=${DOCKER_SOCKET_SERVER_HOST:-localhost}

  DOCKER_SOCKET_SERVER_PORT=$(read_var DOCKER_SOCKET_SERVER_PORT .env)
  DOCKER_SOCKET_SERVER_PORT=${DOCKER_SOCKET_SERVER_PORT:-6001}

  docker-compose up --build -d proxy

  # Make it possible to publish the local project https://serveo.net/#manual
  # TODO: Deploy our own hosted serveo tool in order to process everything through our domain and servers

  ssh \
    -R "$FRONTEND_SUBDOMAIN.$DOMAIN:80":"$DOCKER_FRONTEND_SERVER_HOST:$DOCKER_FRONTEND_SERVER_PORT" \
    -R "$BACKEND_SUBDOMAIN.$DOMAIN:80":"$DOCKER_BACKEND_SERVER_HOST:$DOCKER_BACKEND_SERVER_PORT" \
    -R "$WS_SUBDOMAIN.$DOMAIN:80":"$DOCKER_SOCKET_SERVER_HOST:$DOCKER_SOCKET_SERVER_PORT" \
    $DOMAIN
elif [ "$SERVICE" == "ngrok" ]; then
  docker-compose up --build -d

  if [ "$(uname)" == "Darwin" ]; then
    open http://localhost:4040/inspect/http
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    xdg-open http://localhost:4040/inspect/http
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    start http://localhost:4040/inspect/http
  fi
else
  echo "environment TUNNEL_SERVICE is not valid"
fi

