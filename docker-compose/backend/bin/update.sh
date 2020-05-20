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

# Setup pre-configured .env file
cp /var/www/source/.env ./.env
# Install composer dependencies using composer.lock
cp /var/www/app && composer install && php artisan cache:refresh && php artisan migrate