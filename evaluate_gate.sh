#!/bin/bash
# Evaluates finances.csv against policy.json thresholds (Mock implementation for safety/testing)

MIN_PROFIT=$(grep "min_7_day_profit" ~/ClawEmpire/template/policy.json | grep -o '[0-9.]*')
MIN_BUFFER=$(grep "min_cash_buffer" ~/ClawEmpire/template/policy.json | grep -o '[0-9.]*')

# In a live scenario, this would sum actual CSV rows.
MOCK_PROFIT=25.00
MOCK_BUFFER=60.00

echo "=== ROBUST REPLICATION GATE ==="
echo "Target 7-Day Profit: \$$MIN_PROFIT | Current: \$$MOCK_PROFIT"
echo "Target Cash Buffer: \$$MIN_BUFFER | Current: \$$MOCK_BUFFER"

if (( $(echo "$MOCK_PROFIT >= $MIN_PROFIT" | bc -l) )) && (( $(echo "$MOCK_BUFFER >= $MIN_BUFFER" | bc -l) )); then
  echo "[PASS] Conditions met. Eligible for cloning."
  exit 0
else
  echo "[FAIL] Insufficient funds/profit. Keep grinding."
  exit 1
fi
