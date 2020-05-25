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

# Setup env
cd /var/www/app
rm -rf ./.env
touch ./.env

echo "API_URL=$API_URL" >> ./.env
echo "SOCKET_URL=$SOCKET_URL" >> ./.env
echo "SOCKET_AUTH_URL=$SOCKET_AUTH_URL" >> ./.env

# Setup Git user name and email in order to correctly make a push from the local environment
git config user.name $GIT_NAME
git config user.email $GIT_EMAIL

yarn

echo $API_URL

if [[ $APP_ENV == 'production' ]]; then
  yarn build && PORT=8000 yarn start
else
  PORT=8000 yarn dev
fi