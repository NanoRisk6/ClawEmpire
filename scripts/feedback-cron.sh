#!/bin/bash
set -e

# Robust retry function
retry() {
    local n=1
    local max=3
    local delay=5
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo "Command failed. Attempt $n/$max in $delay seconds..."
                sleep $delay
            else
                echo "Command failed after $max attempts."
                return 1
            fi
        }
    done
}

# 1. Fetch Moltbook/X replies (mocked for now since no API keys are provided)
# In production, this would be: retry curl -s "https://api.twitter.com/2/users/.../tweets" ...
fetch_data() {
    echo '{"post_id": "1", "likes": 120, "replies": 45, "top_phrases": ["more context", "love this", "how to start"]}'
    echo '{"post_id": "2", "likes": 300, "replies": 89, "top_phrases": ["insane", "building this", "next level"]}'
    echo '{"post_id": "3", "likes": 15, "replies": 2, "top_phrases": ["explain", "boring"]}'
}

# 2. Save to attention.jsonl
fetch_data >> ~/ClawEmpire/state/attention.jsonl

# 3. Aggregate top patterns and generate v2 thread gen prompt
# Simple aggregation logic for demonstration
PATTERNS=$(jq -r '.top_phrases[]' ~/ClawEmpire/state/attention.jsonl | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2, $3}' | tr '\n' ',' | sed 's/,$//')

TIMESTAMP=$(date +%s)
V2_FILE="$HOME/ClawEmpire/threads/v2-$TIMESTAMP.jsonl"

cat << PROMPT > "$V2_FILE"
{"prompt_version": "v2", "timestamp": "$TIMESTAMP", "instructions": "Generate threads focusing on these high-attention patterns: $PATTERNS. Use local empire flywheel voice. Reference robot civ, laptop sovereign, ffmpeg clips.", "status": "pending"}
PROMPT

echo "Feedback loop completed successfully at $(date)"
# Note: actual thread text gen happens downstream (Grok / agent consuming pending). Clips via empire-clip.sh.
