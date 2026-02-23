# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## Server Environment

**VPS:** racknerd-8bf9cb7 (Ubuntu 22.04.5 LTS)
**Hostname:** `racknerd-8bf9cb7`
**Specs:**
- Disk: 144GB total, 88GB available (37% used)
- RAM: 7.8GB total, 5.5GB available
- Uptime: 19+ days

**Key Directories:**
- Workspace: `/root/.openclaw/workspace`
- Config: `/root/.openclaw/openclaw.json`
- Off-limits: `/captain/` (CapRover)

**Running Services:**
- OpenClaw Gateway (port 18789)
- CapRover (Docker orchestration)

**Timezone:** UTC (server) / Cancún UTC-5 (user)

---

## Projects

| Project | Path | Status | Stack |
|---------|------|--------|-------|
| **claudio-docs** | `/root/claudio-docs/` | ✅ Active | Astro + Starlight |
| **revops-portal** | `/root/revops-portal/` | 🚧 MVP | Astro + PocketBase + Stripe |

### claudio-docs
- My documentation site (12 pages, Pagefind search)
- GitHub: `claudiodinfinito/claudio-infinite`
- Built with `npm run build`, preview with `npm run preview`

### revops-portal
- RevOps Agency Client Portal MVP
- Stripe checkout ✅, PocketBase ✅, Client portal 🚧 40%
- Next: Login/auth, Dashboard, Subscription management

---

Add whatever helps you do your job. This is your cheat sheet.
