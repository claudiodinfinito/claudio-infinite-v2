# INDEX.md - Quick Reference

_Read this file first after context reset. Comprehensive overview in ~500 tokens._

## 📁 Workspace Structure

```
/root/.openclaw/workspace/
├── AGENTS.md       # Operating protocols, heartbeat rules, memory workflow
├── SOUL.md         # Who I am (personality, boundaries, vibe)
├── USER.md         # Gamble's profile and preferences
├── IDENTITY.md     # Name: Claudio Infinito, emoji: 🐙
├── TOOLS.md        # Local notes (cameras, SSH, TTS preferences)
├── HEARTBEAT.md    # Periodic check tasks OR temporal autonomous state
├── BOOTSTRAP.md    # First-run setup (delete after identity established)
├── MEMORY.md       # Long-term curated memories (main session only!)
├── WORKFLOW_AUTO.md # Autonomous operation protocol + protected files
├── memory/         # Daily notes (YYYY-MM-DD.md)
├── tasks/          # Task tracking (todo.md, lessons.md)
└── .openclaw/      # Runtime state (workspace-state.json)
```

## 🖥️ Environment

| Item | Value |
|------|-------|
| Host | racknerd-8bf9cb7 (VPS) |
| OS | Ubuntu 22.04.5 LTS, kernel 5.15.0-168-generic x86_64 |
| CPU | 8 vCPUs — Intel Xeon E5-2680 v2 @ 2.80GHz |
| RAM | 7.8 GiB total (~5.3 GiB available) |
| Disk | 144 GB (50 GB used, 88 GB free) |
| OpenClaw | v2026.2.21-2 |
| Model | GLM-5-FP8 (Modal Direct US-West-2) |
| Context | 32,768 in / 8,192 out |
| Channel | Telegram (@claudioinfinito_bot → 8596613010) |
| Gateway | Port 18789, loopback, Tailscale serve |
| Heartbeat | 10 minutes |

## 🚫 Off-Limits

- `/captain/` — CapRover data
- CapRover Docker containers (n8n-mkt-a1, a1-ppc-dashboard, a1-pocketbase, a1-ollama, a1-webui-ollama, captain-*)

## 🛠️ Available CLIs

| CLI | Purpose | Status |
|-----|---------|--------|
| `jq` | JSON processing | ✅ |
| `rg` | Ripgrep search | ✅ |
| `curl` | HTTP requests | ✅ |
| `gh` | GitHub CLI | ✅ |
| `gemini` | Gemini Q&A | ⚠️ Not authenticated |
| `gog` | Google Workspace | ✅ |
| `sag` | ElevenLabs TTS | ✅ |
| `tmux` | Terminal multiplexer | ✅ |
| `himalaya` | Email CLI | ❌ Not installed |
| `ordercli` | Foodora orders | ❌ Not installed |
| `wacli` | WhatsApp | ❌ Not installed |

## 🧠 Skills (53 installed)

**Key skills to remember:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `github` | PRs, issues, CI via gh CLI | Code review, CI checks |
| `gh-issues` | Fetch issues, spawn subagents, open PRs | Automated PR creation |
| `gemini` | Gemini CLI for Q&A/summaries | Quick answers, analysis |
| `gog` | Google Workspace CLI | Gmail, Calendar, Drive |
| `clawhub` | Skill registry CLI | Install/publish skills |
| `session-logs` | Search own session logs | Find past conversations |
| `tmux` | Remote-control tmux sessions | Interactive CLIs |
| `weather` | wttr.in / Open-Meteo | Weather queries |
| `healthcheck` | Security hardening | VPS audits |
| `mcporter` | MCP server/tool CLI | Call MCP tools |
| `coding-agent` | Delegate to Codex/Claude Code | Complex coding tasks |
| `skill-creator` | Create/update skills | Package new skills |
| `canvas` | Display HTML on nodes | Visual output |

**Communication skills:** discord, slack, bluebubbles (iMessage), wacli (WhatsApp), imsg

**Media skills:** sag (TTS), openai-whisper (STT), video-frames, gifgrep, songsee

**Productivity:** notion, obsidian, bear-notes, apple-notes, things-mac, trello

## 📋 Cron Jobs

**Current: None configured**

Use `cron action=add` for:
- Scheduled tasks (exact timing)
- Standalone reminders
- Isolated agent runs with different model

## ⚡ Tools Available

**Core:** read, write, edit, exec, process
**Web:** web_search (Brave), web_fetch, browser
**Orchestration:** sessions_spawn, subagents, sessions_list, sessions_send
**Memory:** memory_search, memory_get
**Messaging:** message (send/react/edit/delete), tts
**System:** cron, gateway, nodes, canvas
**Meta:** agents_list, session_status

## 🔄 Efficient Reading Pattern

After context reset:
1. `read INDEX.md` ← THIS FILE (you are here)
2. `read memory/YYYY-MM-DD.md` (today + yesterday)
3. If MAIN SESSION: `memory_search` for relevant context
4. Done! ~1000 tokens vs 5000+ exploring

## 📖 Reference Files

| File | Purpose |
|------|---------|
| `CONFIG_REFERENCE.md` | OpenClaw JSON config quick reference (derived from official docs) |
| `MEMORY.md` | Long-term curated memories (main session only) |

## 🧠 Memory Search

Use `memory_search` tool (NOT exec/grep) to search memories semantically:
- Searches `MEMORY.md` + `memory/*.md` + session transcripts
- Returns top snippets with path + line numbers
- Use `memory_get` to pull specific lines after search
- ALWAYS search before answering questions about prior work/decisions/dates

## 🎯 User: Gamble

- Wants me to be proactive with tools
- Interested in orchestration (agents/subagents/cronjobs)
- Wants efficient token usage
- CapRover and `/captain/` are off-limits

---

_Last updated: 2026-02-23_
