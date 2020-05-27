#!/bin/bash

cd /var/www

# Setup Git user name and email in order to correctly make a push from the local environment
git config user.name $GIT_NAME
git config user.email $GIT_EMAIL

if [[ $APP_ENV == 'production' ]]; then
  yarn build && yarn start
else
  yarn dev
fi