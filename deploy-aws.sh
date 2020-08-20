#!/bin/bash
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
# AWS launch based on Docker.
docker run --rm -it amazon/aws-cli --version
alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
shopt -s expand_aliases
# Configuring parameters for stack cloudformation launch via console.
ANSWER=$(checkYesOrNo "Do you want to configure aws? [y/N]: ")
if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
   aws configure
  KEY_CLOUD_FORMATION=$(checkDefault "Enter your aws KeyPair name (should be created separately)
  > for example: $(tput setaf 2)keyCloudFormation$(tput sgr0)
  > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_BUCKET=$(checkDefault "Enter your s3 bucket name (the name should be unique)
  > for example: $(tput setaf 2)80bots$(tput sgr0)
  > $(tput setaf 1)(required)$(tput sgr0): ")
  aws cloudformation create-stack --stack-name stack-80bots --template-body file://80bots-template.yaml --parameters ParameterKey=KeyName,ParameterValue=${KEY_CLOUD_FORMATION} ParameterKey=BucketName,ParameterValue=${AWS_BUCKET}
elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then
  KEY_CLOUD_FORMATION=$(checkDefault "Enter your aws KeyPair name (should be created separately)
  > for example: $(tput setaf 2)keyCloudFormation$(tput sgr0)
  > $(tput setaf 1)(required)$(tput sgr0): ")
  AWS_BUCKET=$(checkDefault "Enter your s3 bucket name (the name should be unique)
  > for example: $(tput setaf 2)80bots$(tput sgr0)
  > $(tput setaf 1)(required)$(tput sgr0): ")
  aws cloudformation create-stack --stack-name stack-80bots --template-body file://80bots-template.yaml --parameters ParameterKey=KeyName,ParameterValue=${KEY_CLOUD_FORMATION} ParameterKey=BucketName,ParameterValue=${AWS_BUCKET}
fi