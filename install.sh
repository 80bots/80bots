#!/bin/bash

GIT_NAME="$(git config user.name)"
GIT_EMAIL="$(git config user.email)"

# Function check if the line is empty by the user.
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

if [[ -z $GIT_NAME || -z $GIT_EMAIL ]]; then

  NAME=$(checkDefault "Please enter your git name $(tput setaf 1)(required)$(tput sgr0): ")
  git config user.name "$NAME"
  EMAIL=$(checkDefault "Please enter your git email $(tput setaf 1)(required)$(tput sgr0): ")
  git config user.email "$EMAIL"

fi

git submodule init
git submodule update

composer install  --working-dir=$PWD/backend --ignore-platform-reqs
yarn --cwd $PWD/frontend