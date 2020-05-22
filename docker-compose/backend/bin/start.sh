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

touch /var/www/app/storage/logs/cron.log

composer install \
  && php artisan cache:refresh \
  && php artisan migrate \
  && crontab /etc/cron.d/laravel-scheduler && service cron restart \
  && service supervisor start \
  && php artisan serve --host=0.0.0.0 --port=8000