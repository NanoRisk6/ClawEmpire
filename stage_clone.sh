#!/bin/bash
NEW_CLONE=$1
if [ -z "$NEW_CLONE" ]; then 
  echo "Usage: ./stage_clone.sh <CloneName>"
  exit 1
fi

~/ClawEmpire/evaluate_gate.sh
if [ $? -eq 0 ]; then
  echo "Staging $NEW_CLONE to cold storage..."
  cp -r ~/ClawEmpire/template ~/ClawEmpire/staged_$NEW_CLONE
  echo "[ACTION REQUIRED] Human bio-gate approval needed to deploy."
  echo "Run: mv ~/ClawEmpire/staged_$NEW_CLONE ~/ClawEmpire/$NEW_CLONE"
else
  echo "Clone aborted by replication gate."
fi
