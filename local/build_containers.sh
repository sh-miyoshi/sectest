#!/bin/bash

tmpfile=$(mktemp)

cat default.conf | while read line; do
  res=`echo $line | tr -d ' '`
  if [ "x$res" = "x" ]; then
    continue
  elif [ ${res:0:1} != '#' ]; then
    echo "export $res" >> $tmpfile
  fi
done

source $tmpfile

if [ -z "$DOCKER_REGISTRY_URL" ]; then
  echo "Please set DOCKER_REGISTRY_URL in default.conf or Environment variable."
  exit 1
fi

[ -z "$APISERVER_CONTAINER_NAME" ] && echo "Please set APISERVER_CONTAINER_NAME in default.conf" && exit 1;
[ -z "$MYSQL_CONTAINER_NAME" ] && echo "Please set MYSQL_CONTAINER_NAME in default.conf" && exit 1;
[ -z "$FRONTEND_CONTAINER_NAME" ] && echo "Please set FRONTEND_CONTAINER_NAME in default.conf" && exit 1;
[ -z "$BUILD_CONTAINER_VERSION" ] && echo "Please set BUILD_CONTAINER_VERSION in default.conf" && exit 1;

rm $tmpfile

DOCKER_REGISTRY_URL=`echo $DOCKER_REGISTRY_URL | sed -e "s/http:\/\///g"`

containers=($APISERVER_CONTAINER_NAME $MYSQL_CONTAINER_NAME $FRONTEND_CONTAINER_NAME)
dockerfile_names=(apiserver mysql front_end)

cd src
for ((i=0; i < ${#containers[@]}; i++)); do
     docker build -t $DOCKER_REGISTRY_URL/${containers[$i]}:$BUILD_CONTAINER_VERSION . -f Dockerfile_${dockerfile_names[$i]} --build-arg http_proxy="$http_proxy" --build-arg https_proxy="$https_proxy"
done

