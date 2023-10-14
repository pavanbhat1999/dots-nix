#!/bin/bash

while true; do
  for f in /home/root99/Downloads/Wall/*; do
    feh -z --bg-scale --no-fehbg "$f"
    sleep 30
  done
done
