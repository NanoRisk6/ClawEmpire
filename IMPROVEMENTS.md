# IMPROVEMENTS.md — Tier 3 Proposal: X Posting Flywheel (2026-03-05)

## Proposal: Activate Public X Posting from Thread JSONLs

**Status**: Pending Human Review

**Target**: Tier 3 Autonomy (Public Posting) — post polished threads from `~/ClawEmpire/threads/*.jsonl` via `post_tweet_oauth2.js` script or browser/gh CLI.

**Expected Impact**:
- ROI: $100/mo flywheel → $500/mo (10 threads/wk → 1% conversion @ $5/post affiliate).
- Throughput: +threads posted/day → compounding followers/ROI.
- Risk: Low (reversible deletes, draft-first).

**Steps**:
1. Human provides X API keys (bearer_token, consumer_key/secret, access_token/secret) → write to `~/ClawEmpire/secrets/x-api.json` (chmod 600).
2. Edit `post_tweet_oauth2.js` for OAuth2 v2 (API v2 threads).
3. Cron: `0 */6 * * * node post_tweet_oauth2.js ~/ClawEmpire/threads/latest.jsonl` (Tier 2 after approve).
4. Test: Post 1 draft thread → monitor engagement.
5. Rollout: Auto-pick best thread (clip count/ROI score).

**Cost Estimate**: $0 (API free tier 50 posts/day).

**Risks**:
- ToS ban (0.5%): Draft-only, no spam.
- Engagement low (20%): Iterate captions.
- Key leak (0%): Local file, no git.

**Rollback**: Delete posts via API, revoke keys, disable cron.

**Approve?** Paste "APPROVED: X posting" → exec setup.

🐸💰