#!/bin/bash
# empire-clip.sh — Core of ClawEmpire content pipeline
# Drop a raw sim video → produce banger clips, loops, midframes, metadata
# Usage: ./scripts/empire-clip.sh /path/to/video.mp4 [theme]
# Output to ../clips/<slug>/

set -e

RAW="$1"
THEME="${2:-robot-civ}"
if [ -z "$RAW" ] || [ ! -f "$RAW" ]; then
  echo "Usage: $0 <raw-video.mp4> [theme]"
  echo "Example: $0 ../../farm_v3.mp4 farm-civ"
  exit 1
fi

BASENAME=$(basename "$RAW" .mp4)
SLUG="${THEME}-${BASENAME}-$(date +%s)"
OUTDIR="$HOME/ClawEmpire/clips/${SLUG}"
mkdir -p "$OUTDIR"

echo "=== ClawEmpire Clip Factory ==="
echo "Source: $RAW"
echo "Theme:  $THEME"
echo "Out:    $OUTDIR"

# 1. Probe
DUR=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$RAW")
echo "Duration: ${DUR}s"

# 2. Banger clip (first 12-18s high energy or representative)
BANGER_LEN=15
ffmpeg -y -i "$RAW" -ss 0 -t $BANGER_LEN \
  -c:v libx264 -crf 20 -preset fast -movflags +faststart \
  -c:a aac -b:a 128k \
  "${OUTDIR}/banger-${BANGER_LEN}s.mp4" 2>/dev/null

# 3. Midframe thumbnail (for threads / YT)
ffmpeg -y -i "$RAW" -ss $(echo "$DUR/2" | bc -l) -vframes 1 -q:v 2 \
  "${OUTDIR}/midframe.jpg" 2>/dev/null

# 4. Loopable ambient (repeat source to target length e.g. 5min demo)
LOOP_TARGET=300  # 5 min example
ffmpeg -y -stream_loop -1 -i "$RAW" -t $LOOP_TARGET -c copy \
  "${OUTDIR}/ambient-loop-${LOOP_TARGET}s.mp4" 2>/dev/null || true

# 5. Metadata json
cat > "${OUTDIR}/meta.json" <<EOF
{
  "source": "$(basename "$RAW")",
  "theme": "$THEME",
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "duration_src": $DUR,
  "clips": {
    "banger": "banger-${BANGER_LEN}s.mp4",
    "loop": "ambient-loop-${LOOP_TARGET}s.mp4"
  },
  "thumbnail": "midframe.jpg",
  "notes": "Ready for thread gen + Gumroad/YouTube packaging. Tune loop for real 10hr later."
}
EOF

echo "✅ Clips ready in $OUTDIR"
ls -lh "$OUTDIR"
echo "Next: feed meta + clips to thread gen or publish scripts."
