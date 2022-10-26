#!/usr/bin/env bash

FILE=/tmp/debug

while true
do
  if test -f "$FILE"; then
    echo "Found, exiting"
    exit 0 
  fi
  echo "Waiting..."
  sleep 600
done

