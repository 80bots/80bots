#!/bin/bash
touch /var/www/storage/logs/cron.log

# Setup env
cd /var/www && rm -rf .env && touch .env && chgrp -R www-data .env
#
cd /var/www/storage/app && rm -rf scripts
# Clear existing logs
cd /var/www && touch storage/logs/cron.log && touch storage/logs/laravel.log && touch storage/logs/supervisor-queue-worker.log
chmod 775 -R /var/www/storage/logs
chown -R 1001:www-data /var/www/storage/logs

echo "APP_KEY=$APP_KEY" >>./.env
echo "APP_NAME=${APP_NAME:-80bots}" >>./.env
echo "APP_ENV=${APP_ENV:-local}" >>./.env
echo "APP_DEBUG=${APP_DEBUG:-true}" >>./.env
echo "LOG_CHANNEL=${LOG_CHANNEL:-stack}" >>./.env

echo "DB_CONNECTION=${DB_CONNECTION:-mysql}" >>./.env
echo "DB_HOST=${DB_HOST:-mysql}" >>./.env
echo "DB_PORT=${DB_PORT:-3306}" >>./.env
echo "DB_DATABASE=${DB_DATABASE:-80bots}" >>./.env
echo "DB_USERNAME=${DB_USERNAME:-user}" >>./.env
echo "DB_PASSWORD=${DB_PASSWORD:-user}" >>./.env

echo "BROADCAST_DRIVER=${BROADCAST_DRIVER:-redis}" >>./.env
echo "CACHE_DRIVER=${CACHE_DRIVER:-file}" >>./.env
echo "QUEUE_CONNECTION=${QUEUE_CONNECTION:-redis}" >>./.env
echo "SESSION_DRIVER=${SESSION_DRIVER:-file}" >>./.env
echo "SESSION_LIFETIME=${SESSION_LIFETIME:-120}" >>./.env

echo "REDIS_HOST=${REDIS_HOST:-redis}" >>./.env
echo "REDIS_PASSWORD=${REDIS_PASSWORD:-root}" >>./.env
echo "REDIS_PORT=${REDIS_PORT:-6379}" >>./.env

echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >>./.env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >>./.env
echo "AWS_REGION=${AWS_REGION:-us-east-2}" >>./.env
echo "AWS_BUCKET=${AWS_BUCKET:-80bots}" >>./.env
echo "AWS_CLOUDFRONT_INSTANCES_HOST=$AWS_CLOUDFRONT_INSTANCES_HOST" >>./.env
echo "AWS_SCREENSHOTS_BUCKET=${AWS_SCREENSHOTS_BUCKET:-80bots-issued-screenshots}" >>./.env
echo "AWS_IMAGE_ID=${AWS_IMAGE_ID:-ami-0eb47b6a97d3f4e58}" >>./.env
echo "AWS_INSTANCE_TYPE=${AWS_INSTANCE_TYPE:-t3.medium}" >>./.env
echo "AWS_VOLUME_SIZE=${AWS_VOLUME_SIZE:-32}" >>./.env
echo "AWS_INSTANCE_METADATA=${AWS_INSTANCE_METADATA:-http://169.254.169.254/latest/meta-data/}" >>./.env

echo "WS_URL=${WS_URL:-http://localhost:80}" >>./.env
echo "APP_URL=${APP_URL:-http://localhost:8080}" >>./.env
echo "WEB_CLIENT_URL=${WEB_CLIENT_URL:-http://localhost:80}" >>./.env

echo "SENTRY_LARAVEL_DSN=$SENTRY_LARAVEL_DSN" >>./.env

chgrp -R www-data storage
chgrp -R www-data bootstrap/cache

php artisan cache:refresh

crontab /etc/cron.d/laravel-scheduler && service cron restart &&
  service supervisor start && supervisorctl update && supervisorctl reload &&
  php-fpm