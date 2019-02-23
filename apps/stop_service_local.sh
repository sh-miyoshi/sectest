#!/bin/bash

containers=(sec_test_frontend sec_test_apiserver sec_test_mysql)
for container in ${containers[@]}; do
  res=`docker ps | grep $container`
  if [ "x$res" != "x" ]; then
    docker stop $container
  fi
  res=`docker ps -a | grep $container`
  if [ "x$res" != "x" ]; then
    docker rm $container
  fi
done
