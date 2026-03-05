#!/bin/bash
cd ~/ClawEmpire || exit 1
DATE=$(date +%Y-%m-%d)
web_search(query="GOLDCLAW crypto signals rare events $DATE") > signals-$DATE.json
jq -r '.results[] | "\(.title): \(.snippet)"' signals-$DATE.json >> state/signals.jsonl || echo "No signals" >> state/signals.jsonl
# Kelly sim (bankroll 1.0, conf avg)
CONF=$(jq 'map(.confidence // 0) | add / length' state/signals.jsonl 2>/dev/null || echo 0)
STAKE=$(echo "scale=4; 0.25 * $CONF" | bc -l)
echo "{\"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\", \"signal\": \"GOLDCLAW $DATE\", \"stake\": \"$STAKE\", \"confidence\": \"$CONF\", \"pnl\": 0}" >> state/nano_risk_log.csv
echo "NanoRisk scan done: conf $CONF stake $STAKE log updated"
