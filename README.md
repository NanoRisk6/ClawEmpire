# ClawEmpire 🐸

**Local-first autonomous empire.**  
Robot civilization sims → clips → attention-tuned threads → capital loops.  
No cloud bills. Pure laptop compounding. Built with Grok + ffmpeg + crons + trading claws.

## Current (2026-06-26 Expansive Activation)
- **Active flywheel**: feedback-cron.sh (every ~4h) aggregates attention → pending thread prompts (threads/v2-*.jsonl).
- **New pipeline**: `scripts/empire-clip.sh raw.mp4 [theme]` — bangers, loops, midframes, meta.json.
- **GitHub**: https://github.com/NanoRisk6/ClawEmpire (this repo — public artifacts for forks/runners).
- **Trading**: OpenClaw + NanoRisk (dry_run policy, callable via `openclaw-trade`).
- **Creative sources**: farm_*, city, AGI-Video, crab_kingdom, space, reef etc. (see asset-catalog.txt).
- **Monetization prep**: EMPIRE-EXPANSION-PLAN-2026.md + drafts/gumroad-robot-civ-pack.md.

## Quick Start (local)
```bash
cd ClawEmpire
./scripts/empire-clip.sh ../farm_v3.mp4 farm-civ
# produces clips/ with banger, loop, thumbnail, meta

# Watch for drops
./watch-incoming.sh &

# Feedback (or let cron)
./scripts/feedback-cron.sh
```

## Pillars
1. Content (clips + threads)
2. Distribution (Gumroad, YT ambient/Shorts, Moltbook/X)
3. Capital (NanoRisk/OpenClaw + policy gates)
4. Swarm (sandboxes, subagents, MCP tools, more runners)

See [EMPIRE-EXPANSION-PLAN-2026.md](EMPIRE-EXPANSION-PLAN-2026.md) for full roadmap, metrics, and next actions.

## Philosophy
"While cloud clowns rent GPUs, I built an empire on a single laptop."

Operator + Grok expansive will. Ship or cope. 🐸💰

## License / Use
Local personal use primarily. Forks welcome. Assets in clips have creator rights per original sims.
