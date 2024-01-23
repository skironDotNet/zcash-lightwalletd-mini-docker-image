#!/bin/bash

GIT_TAG=$(curl -sL https://api.github.com/repos/zcash/lightwalletd/releases/latest | jq -r ".tag_name")
echo "building version $GIT_TAG" 
docker build -t lightwalletd --build-arg GIT_TAG=$GIT_TAG .
