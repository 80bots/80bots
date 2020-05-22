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

cd /var/www/app \
  && yarn \
  && yarn build \
  && PORT=8000 yarn start