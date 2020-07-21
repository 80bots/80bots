#!/bin/bash

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

echo "$(tput setaf 2)Welcome to 80bots$(tput sgr0)"

ANSWER=$(checkDefault "Do you have a .env file? [y/N]: ")

if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
  if [ -f $ENV_FILE ]; then
    exit 0
  else
    echo "We didn't find the file. Please import by $PWD path"
  fi
  echo "true"
elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then

  SERVICE=$(checkDefault "The name of the service you want to use to start [aws | ngrok | serveo] $(tput setaf 1)(required)$(tput sgr0): ")

  if [[ "$SERVICE" =~ ^(aws)$ ]]; then
    PUBLIC_URL=$(checkDefault "Specify public DNS (IPv4)
    > for example: $(tput setaf 2)ec2-*-**-**-***.us-east-2.compute.amazonaws.com$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")

  elif [[ "$SERVICE" =~ ^(ngrok)$ ]]; then
    NGROK_AUTH=$(checkDefault "Authentication key for Ngrok account $(tput setaf 1)(required)$(tput sgr0): ")
  fi

  APP_KEY=$(checkDefault "App secret key
    > for example: $(tput setaf 2)base64:c******o/h************3Y/J*********Mo=$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_ACCESS_KEY_ID=$(checkDefault "AWS access key ID
    > for example: $(tput setaf 2)1dD************************************JHKH6d$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_SECRET_ACCESS_KEY=$(checkDefault "AWS secret access key
    > for example: $(tput setaf 2)+g4g************************************Jghfd6$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_BUCKET=$(checkDefault "AWS S3 bucket
    > for example: $(tput setaf 2)80bots$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_IMAGE_ID=$(checkDefault "Default AWS Image id
    > for example: $(tput setaf 2)ami-0f**********h35$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_INSTANCE_TYPE=$(checkDefault "Default AWS Bot instance type
    > for example: $(tput setaf 2)t3.medium$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_REGION=$(checkDefault "AWS Region
    > for example: $(tput setaf 2)us-east-2$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_URL=$(checkDefault "AWS url for the generating the urls
    > for example: $(tput setaf 2)https://d2**********9r.cloudfront.net$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_CLOUDFRONT_INSTANCES_HOST=$(checkDefault "AWS url for the instance configuration
    > for example: $(tput setaf 2)https://d2**********9r.cloudfront.net$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")

  cd $PWD && rm -rf .env && touch .env

 echo "$SERVICE"

  echo "SERVICE=$SERVICE" >> ./.env
  echo "PUBLIC_URL=$PUBLIC_URL" >> ./.env
  echo "NGROK_AUTH=$NGROK_AUTH" >> ./.env
  echo "APP_KEY=$APP_KEY" >> ./.env
  echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ./.env
  echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ./.env
  echo "AWS_BUCKET=$AWS_BUCKET" >> ./.env
  echo "AWS_IMAGE_ID=$AWS_IMAGE_ID" >> ./.env
  echo "AWS_INSTANCE_TYPE=$AWS_INSTANCE_TYPE" >> ./.env
  echo "AWS_REGION=$AWS_REGION" >> ./.env
  echo "AWS_URL=$AWS_URL" >> ./.env
  echo "AWS_CLOUDFRONT_INSTANCES_HOST=$AWS_CLOUDFRONT_INSTANCES_HOST" >> ./.env

 ./start.sh

else
  exit -1
fi