#!/bin/bash
# Run worker
cd /var/www/app
php artisan queue:work redis --tries=1