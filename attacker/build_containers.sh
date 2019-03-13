#!/bin/bash

# configuration of build container
if [ "x$DOCKER_REGISTRY_URL" = "x" ]; then
  DOCKER_REGISTRY_URL="docker.io"
else
  DOCKER_REGISTRY_URL=`echo $DOCKER_REGISTRY_URL | sed -e "s/http:\/\///g"`
fi
ATTACKER_CONTAINER_NAME=sectest-attacker
BUILD_CONTAINER_VERSION=latest

# run docker build
docker build -t $DOCKER_REGISTRY_URL/$ATTACKER_CONTAINER_NAME:$BUILD_CONTAINER_VERSION . --build-arg http_proxy="$http_proxy" --build-arg https_proxy="$https_proxy"
