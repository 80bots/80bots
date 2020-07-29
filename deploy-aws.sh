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

docker run --rm -it amazon/aws-cli --version
alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
shopt -s expand_aliases

ANSWER=$(checkYesOrNo "You have AWS CLI configurations configured? [y/N]: ")

if [[ "$ANSWER" =~ ^(yes|y)$ ]]; then
 aws cloudformation create-stack --stack-name test-80bots --template-body file://80bots-template.yaml --parameters ParameterKey=KeyName,ParameterValue=keyCloudFormation
elif [[ "$ANSWER" =~ ^(no|n)$ ]]; then
 aws configure
 aws cloudformation create-stack --template-body ./80bots-template.yaml --stack-name test-80bots --parameters ParameterKey=KeyName, ParameterValue=keyCloudFormation ParameterKey=InstanceType
fi