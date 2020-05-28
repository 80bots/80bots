#!/bin/bash
GIT_NAME="$(git config user.name)"
GIT_EMAIL="$(git config user.email)"

if [[ -z $GIT_NAME || -z $GIT_EMAIL ]]
 then
  echo "Please configure git user name and email" && exit -1
fi

git submodule init
git submodule update

composer install  --working-dir=$PWD/backend --ignore-platform-reqs
yarn --cwd $PWD/frontend