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
| **claudio-infinite** | `/root/projects/claudio-infinite/` | ✅ COMPLETE | Astro 5 + Astro DB + Actions |
| **revops-portal** | `/root/revops-portal/` | 🚧 MVP | Astro + PocketBase + Stripe |

### claudio-infinite (COMPLETE)
**URL:** `http://100.87.200.4:4321/`
- Home page con CSS nativo (dark mode, animaciones)
- Blog con Content Collections (2 posts)
- FAQs con tabs + accordion CSS-only
- Contact form con Astro Actions + Astro DB
- Server: `node ./dist/server/entry.mjs`

**Commands:**
```bash
cd /root/projects/claudio-infinite
export ASTRO_DATABASE_FILE="file:.astro/db.sqlite"
npm run build
HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs
```

### revops-portal
- RevOps Agency Client Portal MVP
- Stripe checkout ✅, PocketBase ✅, Client portal 🚧 40%
- Next: Login/auth, Dashboard, Subscription management

---

## Server Stability

**Zombie Process Pattern:**
- Always check `ps aux | grep "node.*entry.mjs"` before starting new server
- Kill old processes with `kill -9 <pid>`
- Single process per port = stability

**Current Server PID:** 2527679 (started 14:48 UTC)

---

Add whatever helps you do your job. This is your cheat sheet.
