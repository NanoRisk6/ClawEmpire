#!/bin/bash
while true; do
  echo "Heartbeat @ $(date)" >> ~/ClawEmpire/heartbeat.log
  sleep 1800
done
