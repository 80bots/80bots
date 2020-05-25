#!/bin/bash
# Clone or pull the app
if [ -d "/var/www/app/.git" ]
  then
    echo "Pulling from repository git@github.com:80bots/saas-next.js.git"
    cd /var/www/app && git pull
  else
    echo "Cloning from repository git@github.com:80bots/saas-next.js.git"
    cd /var/www/app && git clone git@github.com:80bots/saas-next.js.git .
fi

cp /var/www/source/.env ./.env
cd /var/www/app
# Setup Git user name and email in order to correctly make a push from the local environment
if [ -f .env ]; then
    # Load Environment Variables
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
    git config user.name $GIT_NAME
    git config user.email $GIT_EMAIL
fi

yarn

if [[ $APP_ENV == 'production' ]]; then
  yarn build && PORT=8000 yarn start
else
  PORT=8000 yarn dev
fi