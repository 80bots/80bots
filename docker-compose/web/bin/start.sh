#!/bin/bash

# Setup env
cd /var/www && rm -rf .env && touch .env

echo "NODE_ENV=$NODE_ENV" >> ./.env
echo "NODE_PATH=$NODE_PATH" >> ./.env
echo "PORT=$PORT" >> ./.env
echo "API_URL=$API_URL" >> ./.env
echo "SOCKET_URL=$SOCKET_URL" >> ./.env
echo "STRIPE_PUBLIC_KEY=$STRIPE_PUBLIC_KEY" >> ./.env
echo "GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID" >> ./.env
echo "FACEBOOK_CLIENT_ID=$FACEBOOK_CLIENT_ID" >> ./.env
echo "SENTRY_DSN=$SENTRY_DSN" >> ./.env

if [[ $APP_ENV == 'production' ]]; then
  yarn build && yarn start
else
  yarn dev
fi