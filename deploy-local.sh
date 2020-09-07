#!/bin/bash

git pull
./configure.sh
echo "$(tput setaf 2)database refresh...$(tput sgr0)"
sleep 5
docker exec 80bots-backend php artisan db:refresh
echo "$(tput setaf 2)database refresh done.$(tput sgr0)"
