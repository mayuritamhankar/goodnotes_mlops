#!/bin/bash

set -e

HOSTS=("foo.localhost" "bar.localhost")
RESULTS="load_test_results.txt"

echo "" > $RESULTS

for HOST in "${HOSTS[@]}"; do
  echo "Testing $HOST" | tee -a $RESULTS
  oha -z 10s -c 10 --host "$HOST" "http://$HOST/" | tee -a $RESULTS
  echo "" >> $RESULTS
done
