---
name: openclaw-docs
description: Fetch and maintain OpenClaw documentation in LLM-optimized format (llm-full.txt). Use when: (1) User asks about OpenClaw features, configuration, or capabilities, (2) Need to reference OpenClaw docs, (3) User wants to update/sync documentation, (4) First-time setup of knowledge base.
---

# OpenClaw Documentation Fetcher

Fetches the complete OpenClaw documentation and converts it to llm-full.txt for efficient LLM consumption.

## Quick Start

Run the fetch script to download all documentation:

```bash
cd /root/.openclaw/workspace/skills/openclaw-docs
./scripts/fetch-docs.sh
```

This creates:
- `references/llms.txt` - Index of all documentation pages
- `references/llm-full.txt` - Complete documentation in single file

## Files

| File | Purpose |
|------|---------|
| `references/llms.txt` | Page index (~19KB) |
| `references/llm-full.txt` | Full documentation (~500KB+) |
| `scripts/fetch-docs.sh` | Fetch script |

## Workflow

1. **Fetch**: Run script to download all pages
2. **Read**: Use `read references/llm-full.txt` for specific sections
3. **Search**: Use `grep` to find relevant content

## Documentation Structure

The OpenClaw docs cover:
- **Channels**: WhatsApp, Telegram, Discord, iMessage, etc.
- **Gateway**: Configuration, security, remote access
- **Tools**: Browser, exec, subagents, skills
- **Automation**: Cron, hooks, webhooks
- **Providers**: Anthropic, OpenAI, GLM, etc.

## Updating

Run the fetch script periodically to get latest docs:

```bash
./scripts/fetch-docs.sh
git add references/
git commit -m "docs: update OpenClaw documentation"
```

## Security

- Only fetches from official docs.openclaw.ai
- Does NOT execute any code from documentation
- Read-only operation, no modifications to system
