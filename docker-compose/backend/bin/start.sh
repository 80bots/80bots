#!/bin/bash
touch /var/www/storage/logs/cron.log

# Setup env
cd /var/www && rm -rf ./.env && touch ./.env

echo "APP_NAME=$APP_NAME" >> ./.env
echo "APP_ENV=$APP_ENV" >> ./.env
echo "APP_KEY=$APP_KEY" >> ./.env
echo "APP_DEBUG=$APP_DEBUG" >> ./.env
echo "APP_URL=$APP_URL" >> ./.env

echo "LOG_CHANNEL=$LOG_CHANNEL" >> ./.env

echo "DB_CONNECTION=$DB_CONNECTION" >> ./.env
echo "DB_HOST=$DB_HOST" >> ./.env
echo "DB_PORT=$DB_PORT" >> ./.env
echo "DB_DATABASE=$DB_DATABASE" >> ./.env
echo "DB_USERNAME=$DB_USERNAME" >> ./.env
echo "DB_PASSWORD=$DB_PASSWORD" >> ./.env

echo "BROADCAST_DRIVER=$BROADCAST_DRIVER" >> ./.env
echo "CACHE_DRIVER=$CACHE_DRIVER" >> ./.env
echo "QUEUE_CONNECTION=$QUEUE_CONNECTION" >> ./.env
echo "SESSION_DRIVER=$SESSION_DRIVER" >> ./.env
echo "SESSION_LIFETIME=$SESSION_LIFETIME" >> ./.env

echo "REDIS_HOST=$REDIS_HOST" >> ./.env
echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> ./.env
echo "REDIS_PORT=$REDIS_PORT" >> ./.env
echo "REDIS_PREFIX=$REDIS_PREFIX" >> ./.env

echo "MAIL_MAILER=$MAIL_MAILER" >> ./.env
echo "MAIL_HOST=$MAIL_HOST" >> ./.env
echo "MAIL_USERNAME=$MAIL_USERNAME" >> ./.env
echo "MAIL_PASSWORD=$MAIL_PASSWORD" >> ./.env
echo "MAIL_ENCRYPTION=$MAIL_ENCRYPTION" >> ./.env
echo "MAIL_FROM_ADDRESS=$MAIL_FROM_ADDRESS" >> ./.env
echo "MAIL_FROM_NAME=$APP_NAME" >> ./.env

echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ./.env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ./.env
echo "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" >> ./.env
echo "AWS_BUCKET=$AWS_BUCKET" >> ./.env
echo "AWS_IMAGEID=$AWS_IMAGEID" >> ./.env
echo "AWS_INSTANCE_TYPE=$AWS_INSTANCE_TYPE" >> ./.env
echo "AWS_REGION=$AWS_REGION" >> ./.env
echo "AWS_URL=$AWS_URL" >> ./.env
echo "AWS_CLOUDFRONT_INSTANCES_HOST=$AWS_CLOUDFRONT_INSTANCES_HOST" >> ./.env

echo "PUSHER_APP_ID=$PUSHER_APP_ID" >> ./.env
echo "PUSHER_APP_KEY=$PUSHER_APP_KEY" >> ./.env
echo "PUSHER_APP_SECRET=$PUSHER_APP_SECRET" >> ./.env
echo "PUSHER_APP_CLUSTER=$PUSHER_APP_CLUSTER" >> ./.env

echo "MIX_PUSHER_APP_KEY=$PUSHER_APP_KEY" >> ./.env
echo "MIX_PUSHER_APP_CLUSTER=$PUSHER_APP_CLUSTER" >> ./.env

echo "REACT_URL=$REACT_URL" >> ./.env
echo "UP_TIME_MINUTES=$UP_TIME_MINUTES" >> ./.env
echo "CREDIT_UP_TIME=$CREDIT_UP_TIME" >> ./.env
echo "REGISTER_CREDITS=$REGISTER_CREDITS" >> ./.env

echo "STRIPE_KEY=$STRIPE_KEY" >> ./.env
echo "STRIPE_SECRET=$STRIPE_SECRET" >> ./.env

echo "SENTRY_LARAVEL_DSN=$SENTRY_LARAVEL_DSN" >> ./.env

# Setup Git user name and email in order to correctly make a push from the local environment
git config user.name $GIT_NAME
git config user.email $GIT_EMAIL

crontab /etc/cron.d/laravel-scheduler && service cron restart \
  && service supervisor start \
  && php-fpm -R