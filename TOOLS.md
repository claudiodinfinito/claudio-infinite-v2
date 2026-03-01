# TOOLS.md - Local Notes

## Server

- **Host:** racknerd-8bf9cb7
- **OS:** Ubuntu 22.04.5 LTS
- **IP:** 100.87.200.4 (internal)
- **OpenClaw Port:** 18789
- **Off-Limits:** `/captain/` (CapRover)

## Projects

| Proyecto | Path | Puerto |
|----------|------|--------|
| claudio-infinite | `/root/projects/claudio-infinite/` | 4321 |

### claudio-infinite Commands

**Following official Astro documentation:**

```bash
cd /root/projects/claudio-infinite

# Development
npm run dev

# Production build (includes --remote flag for Astro DB)
npm run build

# Production server
npm run start

# Preview build locally
npm run preview
```

**URLs:**
- Development: http://localhost:4321
- Production: http://192.227.249.251:4321

**Note:** Always use npm scripts, never run node directly.

## Cron Jobs

| Nombre | Schedule | Propósito |
|--------|----------|-----------|
| Workflow Adherence Check | Cada 4h | Verificar adherencia a 6 reglas |

## Key Files

| Archivo | Ubicación |
|---------|-----------|
| openclaw.json | `/root/.openclaw/openclaw.json` |
| Workspace | `/root/.openclaw/workspace/` |

## GitHub Repos

| Repo | URL | Contenido |
|------|-----|-----------|
| claudio-infinite-v2 | https://github.com/claudiodinfinito/claudio-infinite-v2 | OpenClaw workspace (este repo) |
| claudio-infinite | https://github.com/claudiodinfinito/claudio-infinite | OpenClaw original |
| astro-landing-spa | https://github.com/claudiodinfinito/astro-landing-spa | Proyecto Astro 5 |

## Notes

- Siempre verificar procesos zombie antes de iniciar servidor: `ps aux | grep "node.*entry.mjs"`
- GLM5 tiene tokens ilimitados - usar subagents libremente
- **SIEMPRE verificar contenido de repo antes de push** (lección 2026-03-01)

---

_Update as needed._
