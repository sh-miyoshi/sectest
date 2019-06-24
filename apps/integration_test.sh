#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: ./integration_test.sh <service-addr>"
  exit 1
fi

SERVICE_ADDR=$1

curl -k -X POST $SERVICE_ADDR/data \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "user=root" \
-d "password=ossj_sectest"
