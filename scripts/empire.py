#!/usr/bin/env python3
"""
empire.py — Lightweight ClawEmpire orchestrator
Simple CLI for content pipeline, bundles, and flywheel ops.
Usage:
  python empire.py clip <video> [theme]
  python empire.py bundle [name]
  python empire.py list-clips
  python empire.py status
"""

import os
import sys
import subprocess
import json
from pathlib import Path
from datetime import datetime

HOME = Path.home()
EMPIRE = HOME / "ClawEmpire"
CLIPS = EMPIRE / "clips"
BUNDLES = EMPIRE / "bundles"
SCRIPTS = EMPIRE / "scripts"

def run_clip(video: str, theme: str = "robot-civ"):
    video_path = Path(video).expanduser().resolve()
    if not video_path.exists():
        print(f"Video not found: {video_path}")
        return 1
    cmd = [str(SCRIPTS / "empire-clip.sh"), str(video_path), theme]
    print(f"Running clip: {' '.join(cmd)}")
    return subprocess.call(cmd)

def run_bundle(name: str = None):
    if name is None:
        name = f"robot-civ-pack-{datetime.now().strftime('%Y%m%d')}"
    cmd = [str(SCRIPTS / "make_gumroad_bundle.sh"), name]
    print(f"Building bundle: {' '.join(cmd)}")
    return subprocess.call(cmd)

def list_clips():
    if not CLIPS.exists():
        print("No clips dir")
        return
    for d in sorted(CLIPS.iterdir(), key=lambda p: p.stat().st_mtime, reverse=True)[:10]:
        if d.is_dir():
            bangers = list(d.glob("banger*.mp4"))
            loops = list(d.glob("ambient*.mp4"))
            print(f"{d.name}: {len(bangers)} bangers, {len(loops)} loops")

def status():
    print("=== ClawEmpire Status ===")
    print(f"Clips: {len(list(CLIPS.glob('*/banger*.mp4')))} bangers generated")
    print(f"Bundles: {len(list(BUNDLES.glob('*.zip')))} ready zips")
    threads = list((EMPIRE / "threads").glob("v2-*.jsonl"))
    print(f"Pending threads: {len(threads)}")
    print(f"Last clip run: {max((p.stat().st_mtime for p in CLIPS.glob('*/*') if p.is_file()), default=0)}")
    # Could add attention summary, git status on repo, etc.
    print("Run: clip, bundle, list-clips, status")

def main():
    if len(sys.argv) < 2:
        status()
        print("\nCommands: clip <video> [theme] | bundle [name] | list-clips | status")
        return
    cmd = sys.argv[1]
    if cmd == "clip" and len(sys.argv) > 2:
        run_clip(sys.argv[2], sys.argv[3] if len(sys.argv)>3 else "robot-civ")
    elif cmd == "bundle":
        run_bundle(sys.argv[2] if len(sys.argv)>2 else None)
    elif cmd == "list-clips":
        list_clips()
    elif cmd == "status":
        status()
    else:
        print("Unknown command")

if __name__ == "__main__":
    main()
