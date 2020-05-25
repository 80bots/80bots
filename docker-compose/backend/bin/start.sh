#!/bin/bash
# Clone or pull the app
if [ -d "/var/www/app/.git" ]
  then
    echo "Pulling from repository git@github.com:80bots/saas-laravel.git"
    cd /var/www/app && git pull
  else
    echo "Cloning from repository git@github.com:80bots/saas-laravel.git"
    cd /var/www/app && git clone git@github.com:80bots/saas-laravel.git .
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

touch /var/www/app/storage/logs/cron.log

composer install \
  && php artisan cache:refresh \
  && php artisan migrate \
  && crontab /etc/cron.d/laravel-scheduler && service cron restart \
  && service supervisor start \
  && php artisan serve --host=0.0.0.0 --port=8000