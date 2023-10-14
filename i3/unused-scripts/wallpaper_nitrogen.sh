#!/bin/bash

while true; do
  for f in /home/root99/Downloads/Wall/*; do
    nitrogen --set-auto  "$f"
    sleep 30
  done
done
