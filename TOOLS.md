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
```bash
cd /root/projects/claudio-infinite
npm run build
HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs
```

## Cron Jobs

| Nombre | Schedule | Propósito |
|--------|----------|-----------|
| Workflow Adherence Check | Cada 4h | Verificar adherencia a 6 reglas |

## Key Files

| Archivo | Ubicación |
|---------|-----------|
| openclaw.json | `/root/.openclaw/openclaw.json` |
| Workspace | `/root/.openclaw/workspace/` |

## Notes

- Siempre verificar procesos zombie antes de iniciar servidor: `ps aux | grep "node.*entry.mjs"`
- GLM5 tiene tokens ilimitados - usar subagents libremente

---

_Update as needed._
