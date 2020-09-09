#!/bin/bash

./install.sh
# Variables.
ENV_FILE=$PWD/.env
# Validator function that checks whether a variable is empty.
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
# Validator function that checks yes or no.
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
# Validator function that checks [aws|ngrok|serveo] value.
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

echo "$(tput setaf 2)Welcome to 80bots!!!$(tput sgr0)"

ANSWER=$(checkDefault "Do you have .env file configured? [y/N]: ")
if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
  if [ -f $ENV_FILE ]; then
    ./start.sh
  else
    echo "We haven't found your .env file. Please, ,import .env file by the following pass $PWD or restart a script."
  fi
elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then

  SERVICE=$(checkService "Install a service basing on which you'd like to run an application [aws|ngrok|serveo] $(tput setaf 1)(required)$(tput sgr0): ")
  if [[ "$SERVICE" =~ ^(aws)$ ]]; then
    APP_ENV="production"
    PUBLIC_URL=$(checkDefault "Enter your public DNS (IPv4)
    > for example: $(tput setaf 2)ec2-***.us-east-2.compute.amazonaws.com$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  elif [[ "$SERVICE" =~ ^(ngrok)$ ]]; then
    NGROK_AUTH=$(checkDefault "Authentication key for Ngrok account $(tput setaf 1)(required)$(tput sgr0): ")
  fi

  GENERATE_APP_KEY=$(checkYesOrNo "You are want generate APP_KEY? [y/N] $(tput setaf 1)(required)$(tput sgr0): ")
  if [[ "$GENERATE_APP_KEY" =~ ^(yes|y)$ ]]; then
    APP_KEY=`cd backend && sudo php artisan key:generate --show`
    echo "$APP_KEY"
  elif [[ "$GENERATE_APP_KEY" =~ ^(no|n)$ ]]; then
    APP_KEY=$(checkDefault "Enter app secret key
      > for example: $(tput setaf 2)base64:***/***/***=$(tput sgr0)
      > $(tput setaf 1)(required)$(tput sgr0): ")
  fi

  AWS_ACCESS_KEY_ID=$(checkDefault "Enter aws access key ID
    > for example: $(tput setaf 2)fdf***f5$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_SECRET_ACCESS_KEY=$(checkDefault "Enter aws secret access key
    > for example: $(tput setaf 2)fs+***Jv$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_CLOUDFRONT_INSTANCES_HOST=$(checkDefault "Enter aws url for the instance configuration
    > for example: $(tput setaf 2)https://***.cloudfront.net$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_BUCKET=$(checkDefault "Enter s3 bucket
    > for example: $(tput setaf 2)my80bots$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")

  cd $PWD && rm -rf .env && touch .env

  if [[ $APP_ENV == 'production' ]]; then
    echo "APP_ENV=$APP_ENV" >> ./.env
  fi
  echo "SERVICE=$SERVICE" >> ./.env
  echo "PUBLIC_URL=$PUBLIC_URL" >> ./.env
  echo "NGROK_AUTH=$NGROK_AUTH" >> ./.env
  echo "APP_KEY=$APP_KEY" >> ./.env
  echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ./.env
  echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ./.env
  echo "AWS_CLOUDFRONT_INSTANCES_HOST=$AWS_CLOUDFRONT_INSTANCES_HOST" >> ./.env
  echo "AWS_BUCKET=$AWS_BUCKET" >> ./.env

 ./start.sh

else
  exit 0
fi