#!/bin/zsh
WATCH_DIR="$HOME/ClawEmpire/incoming"
LOG_FILE="$HOME/ClawEmpire/logs/watch.log"
SCAN_LOG="$HOME/ClawEmpire/logs/scan.log"
CLIPS_BASE="$HOME/ClawEmpire/clips"
FSWATCH="/opt/homebrew/bin/fswatch"
TERMINAL_NOTIFIER="/opt/homebrew/bin/terminal-notifier"
FFMPEG="/opt/homebrew/bin/ffmpeg"
SAY="/usr/bin/say"
# Ensure dirs exist
mkdir -p "$(dirname "$LOG_FILE")" "$CLIPS_BASE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Watcher starting on $WATCH_DIR (full paths)" >> "$LOG_FILE"
"$FSWATCH" -0 -r --event Created --event Updated "$WATCH_DIR" | while read -d '' -r file; do
  if [[ "$file" =~ \.(mp4|mov|MP4|MOV)$ ]]; then
  # Auto-clip logic...
elif [[ "$file" =~ \.url$ ]]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] .url detected: $file — yt-dlp downloading..." >> "$LOG_FILE"
  DL_FILE="$CLIPS_BASE/dl-$(basename "$file" .url).%(ext)s"
  yt-dlp "$file" -f 'best[height<=720]' -o "$DL_FILE" 2>> "$LOG_FILE"
  DL_OUTPUT=$(ls "$CLIPS_BASE/dl-$(basename "$file" .url)".* 2>/dev/null | head -1)
  if [[ -f "$DL_OUTPUT" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] yt-dlp complete: $DL_OUTPUT → trigger clip chain" >> "$LOG_FILE"
    # Re-trigger watcher on new dl file (simulate drop)
    touch "$DL_OUTPUT"
  fi
fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] New video detected: $file" >> "$LOG_FILE"
    # Append to scan log
    ls -l "$file" >> "$SCAN_LOG" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Scan triggered by watcher - new vid: $(basename "$file")" >> "$SCAN_LOG"
    # Notify
    "$TERMINAL_NOTIFIER" -message "New video dropped: $(basename "$file")" -title "ClawEmpire Vid Intake" -sound default 2>/dev/null || echo "Notifier fallback" >> "$LOG_FILE"
    # Auto-clip: scene detect
    CLIPS_DIR="$CLIPS_BASE/$(basename "$file" .mp4 .mov .MP4 .MOV)"
    mkdir -p "$CLIPS_DIR"
    "$FFMPEG" -y -i "$file" \
      -filter:v "select='gt(scene,0.25),duration>=2,showinfo'" \
      -vsync vfr -frame_pts true \
      -c:v libx264 -crf 23 -preset fast \
      "$CLIPS_DIR/clip-%03d.mp4" 2>> "$LOG_FILE"
    CLIP_COUNT=$(ls "$CLIPS_DIR"/*.mp4 2>/dev/null | wc -l)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Auto-clip complete: $CLIP_COUNT clips to $CLIPS_DIR" >> "$LOG_FILE"
    "$TERMINAL_NOTIFIER" -title "ClawEmpire Clips Ready" -message "$(basename "$file"): $CLIP_COUNT scenes clipped" -sound glass 2>/dev/null
    "$SAY" "Clips extracted from new video" 2>/dev/null &
    echo "→ Ready for threads from $CLIPS_DIR" >> "$LOG_FILE"
  fi
done