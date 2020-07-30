#!/bin/bash

./install.sh

# Variables.
ENV_FILE=$PWD/.env

# Function check if the line is empty by the user.
function checkDefault() {
  while read -r -p "$1" DATA; do
    DATA=${DATA}
    if [[ "$DATA" =~ ^()$ ]]; then
      continue
    else
      echo "$DATA"
      break
    fi
  done
}

# Function check yes or no.
function checkYesOrNo() {
  while read -r -p "$1" DATA; do
    DATA=${DATA}
    if [[ "$DATA" =~ ^(yes|y|no|n)$ ]]; then
      echo "$DATA"
      break
    else
      continue
    fi
  done
}

# Function check service.
function checkService() {
  while read -r -p "$1" DATA; do
    DATA=${DATA}
    if [[ "$DATA" =~ ^(aws|ngrok|serveo)$ ]]; then
      echo "$DATA"
      break
    else
      continue
    fi
  done
}

echo "$(tput setaf 2)Welcome to 80bots$(tput sgr0)"

ANSWER=$(checkDefault "Do you have a .env file? [y/N]: ")

if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
  if [ -f $ENV_FILE ]; then
    ./start.sh
  else
    echo "We didn't find the file. Please import by $PWD path"
  fi
elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then

  SERVICE=$(checkService "The name of the service you want to use to start [aws|ngrok|serveo] $(tput setaf 1)(required)$(tput sgr0): ")

  if [[ "$SERVICE" =~ ^(aws)$ ]]; then
    PUBLIC_URL=$(checkDefault "Specify public DNS (IPv4)
    > for example: $(tput setaf 2)ec2-***.us-east-2.compute.amazonaws.com$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")

  elif [[ "$SERVICE" =~ ^(ngrok)$ ]]; then
    NGROK_AUTH=$(checkDefault "Authentication key for Ngrok account $(tput setaf 1)(required)$(tput sgr0): ")
  fi

  GENERATE_APP_KEY=$(checkYesOrNo "You are want generate APP_KEY? [y/N] $(tput setaf 1)(required)$(tput sgr0): ")
  if [[ "$GENERATE_APP_KEY" =~ ^(yes|y)$ ]]; then
    APP_KEY=`cd backend && sudo php artisan key:generate --show`
    echo "$APP_KEY"
  elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then
    APP_KEY=$(checkDefault "App secret key
      > for example: $(tput setaf 2)base64:***/***/***=$(tput sgr0)
      > $(tput setaf 1)(required)$(tput sgr0): ")
  fi

  AWS_ACCESS_KEY_ID=$(checkDefault "AWS access key ID
    > for example: $(tput setaf 2)fdf***f5$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_SECRET_ACCESS_KEY=$(checkDefault "AWS secret access key
    > for example: $(tput setaf 2)fs+***Jv$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_CLOUDFRONT_INSTANCES_HOST=$(checkDefault "AWS url for the instance configuration
    > for example: $(tput setaf 2)https://***.cloudfront.net$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")

  cd $PWD && rm -rf .env && touch .env

  echo "SERVICE=$SERVICE" >> ./.env
  echo "PUBLIC_URL=$PUBLIC_URL" >> ./.env
  echo "NGROK_AUTH=$NGROK_AUTH" >> ./.env
  echo "APP_KEY=$APP_KEY" >> ./.env
  echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ./.env
  echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ./.env
  echo "AWS_CLOUDFRONT_INSTANCES_HOST=$AWS_CLOUDFRONT_INSTANCES_HOST" >> ./.env

 ./start.sh

else
  exit 0
fi