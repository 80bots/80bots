#!/bin/bash

# Validator function that checks whether a variable is empty.
function checkDefault() {
  while read -r -p "$1" DATA; do
    DATA=${DATA,,}
    if [[ "$DATA" =~ ^()$ ]]; then
      continue
    else
      echo "$DATA"
      break
    fi
  done
}

ANSWER=$(checkDefault "This script is for deploying 80bots on a brand new, AWS EC2 running Ubuntu 20.04. You should have ports 80 and 8080 open. Continue? [y/N]: ")
if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
  sudo apt-get update
  sudo apt-get install php7.4-cli -y
  sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y
  git clone https://github.com/80bots/80bots.git
  cd 80bots/
  sudo apt install nodejs -y
  sudo apt install npm -y
  sudo npm install --global yarn
  cd ~
  curl -sS https://getcomposer.org/installer -o composer-setup.php
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  sudo systemctl status docker
  sudo ./configure.sh
  sudo docker exec 80bots-backend php artisan db:refresh
  sudo docker exec 80bots-backend php artisan migrate
  sudo docker exec 80bots-backend php artisan db:seed --force

  ./configure.sh

elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then
  exit 0
fi
