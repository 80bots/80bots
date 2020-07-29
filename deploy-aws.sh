#!/bin/bash

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

docker run --rm -it amazon/aws-cli --version
alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
shopt -s expand_aliases

ANSWER=$(checkYesOrNo "You have AWS CLI configurations configured? [y/N]: ")

if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
  KEY_CLOUD_FORMATION=$(checkDefault "KeyPair name
  > for example: $(tput setaf 2)keyCloudFormation$(tput sgr0)
  > $(tput setaf 1)(required)$(tput sgr0): ")
 aws cloudformation create-stack --stack-name stack-80bots --template-body file://80bots-template.yaml --parameters ParameterKey=KeyName,ParameterValue=${KEY_CLOUD_FORMATION}
elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then
 aws configure
  KEY_CLOUD_FORMATION=$(checkDefault "KeyPair name
  > for example: $(tput setaf 2)keyCloudFormation$(tput sgr0)
  > $(tput setaf 1)(required)$(tput sgr0): ")
 aws cloudformation create-stack --stack-name stack-80bots --template-body file://80bots-template.yaml --parameters ParameterKey=KeyName,ParameterValue=${KEY_CLOUD_FORMATION}
fi