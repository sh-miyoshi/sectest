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
[ -z "$MYSQL_ROOT_PASSWORD" ] && echo "Please set MYSQL_ROOT_PASSWORD in default.conf" && exit 1;

rm $tmpfile

DOCKER_REGISTRY_URL=`echo $DOCKER_REGISTRY_URL | sed -e "s/http:\/\///g"`

docker run --name sec_test_mysql -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -d $DOCKER_REGISTRY_URL/$MYSQL_CONTAINER_NAME:$BUILD_CONTAINER_VERSION > /dev/null
mysql_ip=`docker inspect --format "{{.NetworkSettings.IPAddress}}" sec_test_mysql`
docker run --name sec_test_apiserver -d -e MYSQL_ADDR=$mysql_ip $DOCKER_REGISTRY_URL/$APISERVER_CONTAINER_NAME:$BUILD_CONTAINER_VERSION > /dev/null
api_ip=`docker inspect --format "{{.NetworkSettings.IPAddress}}" sec_test_apiserver`
docker run --name sec_test_frontend -d -p 4567:4567 -e API_SERVER_URL=$api_ip $DOCKER_REGISTRY_URL/$FRONTEND_CONTAINER_NAME:$BUILD_CONTAINER_VERSION > /dev/null

echo "Deploy was finished."
echo "Please access to http://<your server address>:4567"
