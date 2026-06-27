#!/bin/bash
# make_gumroad_bundle.sh — Build a ready-to-upload Gumroad package from recent empire clips
# Usage: ./scripts/make_gumroad_bundle.sh [bundle_name]
# Picks best bangers + loops + mids + docs. Zips for distribution.

set -e

BUNDLE_NAME="${1:-robot-civ-ambient-pack-$(date +%Y%m%d)}"
BUNDLE_DIR="$HOME/ClawEmpire/bundles/$BUNDLE_NAME"
mkdir -p "$BUNDLE_DIR/videos" "$BUNDLE_DIR/thumbs" "$BUNDLE_DIR/docs"

echo "=== Building Gumroad Bundle: $BUNDLE_NAME ==="

# Select top recent robot-civ clips (prefer farm/crab for visual appeal)
# Limit to bangers (small) + 1-2 short loops to keep bundle reasonable size
CLIP_DIRS=$(ls -1t $HOME/ClawEmpire/clips/ | grep -E 'robot-civ-(farm|crab|space|city|agi)' | head -5)

for dir in $CLIP_DIRS; do
  FULL="$HOME/ClawEmpire/clips/$dir"
  if [ -d "$FULL" ]; then
    echo "Adding from $dir"
    # Banger (small)
    cp "$FULL"/banger-*.mp4 "$BUNDLE_DIR/videos/" 2>/dev/null || true
    # Short loop if exists and not huge
    for loop in "$FULL"/ambient-loop-*.mp4; do
      if [ -f "$loop" ]; then
        size=$(stat -f%z "$loop" 2>/dev/null || stat -c%s "$loop")
        if [ "$size" -lt 150000000 ]; then  # < ~150MB
          cp "$loop" "$BUNDLE_DIR/videos/" 2>/dev/null || true
        else
          echo "  Skipping large loop $(basename $loop) - user can loop source"
        fi
      fi
    done
    # Midframe thumb
    cp "$FULL"/midframe.jpg "$BUNDLE_DIR/thumbs/${dir}-mid.jpg" 2>/dev/null || true
    # Meta for reference
    cp "$FULL"/meta.json "$BUNDLE_DIR/docs/${dir}.json" 2>/dev/null || true
  fi
done

# Add product description and instructions
cp "$HOME/ClawEmpire/drafts/gumroad-robot-civ-pack.md" "$BUNDLE_DIR/docs/product-description.md"
cat > "$BUNDLE_DIR/README.txt" << 'EOF'
Peaceful Robot Civilization Ambient Pack
Built by ClawEmpire on a single laptop 🐸

Contents:
- videos/: 15s bangers + selected loops (loop longer ones with ffmpeg -stream_loop for 10hr ambients)
- thumbs/: preview images
- docs/: metadata + full product description for Gumroad

How to use loops for YouTube:
ffmpeg -stream_loop -1 -i ambient-loop-300s.mp4 -t 36000 -c copy 10hr-ambient.mp4

License: Personal & commercial use. Credit "ClawEmpire" appreciated but not required.
See product-description.md for full Gumroad copy.

Generated: $(date)
Next: Upload zip to Gumroad. Promote with attention-tuned threads.
EOF

# Create zip
cd "$HOME/ClawEmpire/bundles"
zip -r "${BUNDLE_NAME}.zip" "$BUNDLE_NAME" -x "*.DS_Store" > /dev/null
SIZE=$(ls -lh "${BUNDLE_NAME}.zip" | awk '{print $5}')

echo "✅ Bundle ready: $HOME/ClawEmpire/bundles/${BUNDLE_NAME}.zip ($SIZE)"
echo "   Folder: $BUNDLE_DIR"
echo "Upload the zip to Gumroad. Use docs/product-description.md for the listing."
ls -lh "${BUNDLE_NAME}.zip"
