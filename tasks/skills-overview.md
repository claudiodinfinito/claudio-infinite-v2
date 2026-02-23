# Skills Overview - Quick Reference

## Most Relevant Skills

### Communication & Productivity
| Skill | Description | Status |
|-------|-------------|--------|
| **gog** | Google Workspace (Gmail, Calendar, Drive, Contacts, Sheets, Docs) | ✅ Available |
| **github** | GitHub CLI operations (issues, PRs, CI, code review) | ✅ Available |
| **gh-issues** | Fetch GitHub issues, spawn fix agents, open PRs | ✅ Available |
| **gemini** | Gemini CLI for one-shot Q&A, summaries, generation | ⚠️ Needs API key |

### System & Monitoring
| Skill | Description | Status |
|-------|-------------|--------|
| **healthcheck** | Security hardening, firewall, SSH hardening | ✅ Available |
| **session-logs** | Search own session logs using jq | ✅ Available |
| **tmux** | Remote control tmux sessions | ✅ Available |

### Utilities
| Skill | Description | Status |
|-------|-------------|--------|
| **weather** | Current weather and forecasts (wttr.in/Open-Meteo) | ✅ Available |
| **skill-creator** | Create or update AgentSkills | ✅ Available |
| **clawhub** | Skill marketplace (search, install, publish) | ✅ Available |
| **mcporter** | MCP server/tool CLI operations | ✅ Available |

### Voice & Media
| Skill | Description | Status |
|-------|-------------|--------|
| **sag** | ElevenLabs TTS voice storytelling | ❓ Needs API key |
| **nano-pdf** | Edit PDFs with natural language | ✅ Available |

## Skills Requiring Setup

### Gemini (AI Assistant)
- **Needs:** `GEMINI_API_KEY` environment variable
- **Key:** AIza... format (NOT GOCSPX-... which is OAuth)
- **Use case:** One-shot Q&A, summaries, parallel research

### SAG (ElevenLabs Voice)
- **Needs:** ElevenLabs API key
- **Use case:** Voice storytelling, engaging audio output

## How to Use Skills

1. Skills auto-load when task matches description
2. Read SKILL.md for specific instructions:
   ```bash
   read /usr/lib/node_modules/openclaw/skills/<name>/SKILL.md
   ```
3. Follow the workflow in SKILL.md

## Installation of New Skills

Use **clawhub** skill to discover and install new skills:
```
clawhub search <query>
clawhub install <skill-name>
```

---

_Last updated: 2026-02-23_
