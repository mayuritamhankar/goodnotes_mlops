#!/bin/bash

set -e

HOSTS=("foo.localhost" "bar.localhost")
RESULTS="load_test_results.txt"

echo "" > $RESULTS

for HOST in "${HOSTS[@]}"; do
  echo "Testing $HOST" | tee -a $RESULTS
  hey -z 10s -c 10 -host "$HOST" http://localhost/ | tee -a $RESULTS
  echo "" >> $RESULTS
done