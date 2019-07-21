#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: ./loadgen.sh <service-addr>"
  exit 1
fi

SERVICE_ADDR=$1
LOOP_NUM=100000
SLEEP_TIME=2

for i in `seq $LOOP_NUM`; do
  curl -k -X POST $SERVICE_ADDR/data \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "user=root" \
  -d "password=ossj_sectest"

  sleep $SLEEP_TIME
done