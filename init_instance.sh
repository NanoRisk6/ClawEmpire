#!/bin/bash
INSTANCE_NAME=$1
if [ -z "$INSTANCE_NAME" ]; then 
  echo "Usage: ./init_instance.sh <InstanceName>"
  exit 1
fi
cp -r ~/ClawEmpire/template ~/ClawEmpire/$INSTANCE_NAME
echo "Date,Action,Outcome,Value" > ~/ClawEmpire/$INSTANCE_NAME/ledger.csv
echo "Instance $INSTANCE_NAME initialized at ~/ClawEmpire/$INSTANCE_NAME"
