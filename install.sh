#!/bin/bash

git submodule init
git submodule update

composer install  --working-dir=$PWD/backend --ignore-platform-reqs
yarn --cwd $PWD/frontend