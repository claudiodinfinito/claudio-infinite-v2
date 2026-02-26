# OPENCLAW.md - OpenClaw Complete Reference

_Comprehensive guide for OpenClaw agents. Based on official documentation (54,895 lines)._

---

## 🎯 Quick Reference

### Core Concepts

| Concepto | Qué hace | Dónde corre |
|----------|----------|-------------|
| **Heartbeat** | Batch checks periódicos | Main session (`agent:main:main`) |
| **Cron** | Scheduling exacto | Gateway (isolated o main) |
| **Hooks** | Reacción a eventos | Gateway (zero compute agente) |
| **Subagents** | Delegación de tareas | Sesión aislada (`subagent:uuid`) |

---

## ⚡ Cron vs Heartbeat - Guía de Decisión

| Use Case | Recomendado | Por qué |
|----------|-------------|---------|
| Check inbox cada 30 min | **Heartbeat** | Batch con otros checks, context-aware |
| Reporte diario a las 9am | **Cron (isolated)** | Timing exacto necesario |
| Monitor calendario eventos | **Heartbeat** | Fit natural para awareness periódico |
| Análisis profundo semanal | **Cron (isolated)** | Standalone, puede usar otro modelo |
| Recuérdame en 20 min | **Cron (main, --at)** | One-shot con timing preciso |
| Health check proyecto | **Heartbeat** | Piggybacks en ciclo existente |

---

## 💓 Heartbeat: Periodic Awareness

### Cuándo usar

- **Múltiples checks periódicos** — Un heartbeat puede revisar inbox, calendario, weather juntos
- **Decisiones context-aware** — Agente tiene contexto de sesión principal
- **Continuidad conversacional** — Misma sesión, recuerda conversaciones recientes
- **Monitoreo low-overhead** — Un heartbeat reemplaza muchos polling tasks

### Ventajas

- **Batch checks** — Un turno revisa todo junto
- **Reduce API calls** — Más barato que múltiples cron jobs
- **Context-aware** — Sabe en qué estás trabajando
- **Smart suppression** — Si nada importante → `HEARTBEAT_OK` (sin mensaje)
- **Timing natural** — Drifts levemente, OK para monitoreo

### Ejemplo: HEARTBEAT.md Checklist

```markdown
# Heartbeat checklist

- Check email for urgent messages
- Review calendar for events in next 2 hours
- If background task finished, summarize results
- If idle for 8+ hours, send brief check-in
```

### Configuración

```json
{
  "agents": {
    "defaults": {
      "heartbeat": {
        "every": "30m",
        "target": "last",
        "activeHours": { "start": "08:00", "end": "22:00" }
      }
    }
  }
}
```

---

## ⏰ Cron: Precise Scheduling

### Cuándo usar

- **Timing exacto** — "Enviar a las 9:00 AM cada lunes" (no "alrededor de 9")
- **Tareas standalone** — No necesitan contexto conversacional
- **Modelo diferente** — Análisis pesado que amerita modelo más potente
- **One-shot reminders** — "Recuérdame en 20 min" con `--at`
- **Tareas ruidosas/frecuentes** — No clutter main session history
- **Triggers externos** — Deben correr independientemente de actividad del agente

### Ventajas

- **Timing preciso** — 5-field o 6-field (seconds) cron expressions + timezone
- **Load spreading** — Top-of-hour schedules staggered 0-5 min automáticamente
- **Session isolation** — Corre en `cron:<jobId>` sin pollute main history
- **Model overrides** — Usar modelo más barato o más potente por job
- **Delivery control** — Isolated jobs default `announce`; elegir `none` si necesario
- **Immediate delivery** — Announce mode postea directo sin esperar heartbeat
- **One-shot support** — `--at` para timestamps futuros precisos

### Ejemplo: Morning Briefing

```bash
openclaw cron add \
  --name "Morning briefing" \
  --cron "0 7 * * *" \
  --tz "America/Cancun" \
  --session isolated \
  --message "Briefing: weather, calendar, top emails, news." \
  --announce \
  --channel telegram \
  --to "8596613010"
```

### Ejemplo: One-shot Reminder

```bash
openclaw cron add \
  --name "Meeting reminder" \
  --at "20m" \
  --session main \
  --system-event "Reminder: standup in 10 min." \
  --wake now \
  --delete-after-run
```

### Session Targets

| Target | Sesión | Payload | Use Case |
|--------|--------|---------|----------|
| `main` | `agent:main:main` | `systemEvent` | Requiere contexto conversacional |
| `isolated` | `cron:<jobId>` | `agentTurn` | Standalone, timing exacto |

### Delivery Modes

| Mode | Comportamiento | Default Para |
|------|----------------|--------------|
| `announce` | Postea resumen a chat | Isolated jobs |
| `none` | Sin output | Main jobs |
| `webhook` | POST a URL | Callbacks externos |

---

## 🪝 Hooks: Event-Driven Automation

### Qué son

Hooks son scripts que corren **dentro del Gateway** cuando eventos del agente ocurren (`/new`, `/reset`, `/stop`, lifecycle events).

### Hooks incluidos

| Hook | Qué hace | Evento |
|------|----------|--------|
| **session-memory** | Guarda contexto a memory/ | `/new` |
| **command-logger** | Log todos los comandos | Command events |
| **bootstrap-extra-files** | Inyecta files extra al bootstrap | `agent:bootstrap` |
| **boot-md** | Corre BOOT.md al inicio | Gateway start |

### Comandos CLI

```bash
openclaw hooks list          # Listar hooks disponibles
openclaw hooks enable <name> # Habilitar hook
openclaw hooks disable <name> # Deshabilitar hook
openclaw hooks check         # Verificar estado
openclaw hooks info <name>   # Info detallada
```

### Estructura de un Hook

```
my-hook/
├── HOOK.md       # Metadata + documentación
└── handler.ts    # Implementación
```

### Discovery Order

1. **Workspace hooks**: `<workspace>/hooks/` (precedencia más alta)
2. **Managed hooks**: `~/.openclaw/hooks/` (compartido entre workspaces)
3. **Bundled hooks**: `<openclaw>/dist/hooks/bundled/` (shipped con OpenClaw)

---

## 🔄 Execution Model (GLM5)

### Una ejecución a la vez

**YO SOY GLM5** → Single-threaded execution

| Tipo | Sesión | ¿Me bloquea? |
|------|--------|--------------|
| Heartbeat | `agent:main:main` | ✅ Sí, mi turno |
| Cron main | `agent:main:main` | ✅ Sí, system event |
| Cron isolated | `cron:<jobId>` | ❌ No, sesión distinta |
| Hook | `hook:<uuid>` | ❌ No, corre en gateway |
| Subagent | `subagent:uuid` | ⚠️ Retorna ya, pero sigue siendo yo |

### Delegación Inteligente

| Tarea | Herramienta | Razón |
|-------|-------------|-------|
| Batch checks periódicos | Heartbeat | Corto, secuencial en mi turno |
| Timing exacto (9am, etc) | Cron isolated | No me bloquea |
| Eventos automáticos | Hooks | Zero mi compute |
| Tareas largas | sessions_spawn | Delega a otra sesión |

---

## 📂 File Locations

| Archivo | Ubicación | Propósito |
|---------|-----------|-----------|
| `openclaw.json` | `~/.openclaw/openclaw.json` | Config principal |
| `cron jobs` | `~/.openclaw/cron/jobs.json` | Jobs persistentes |
| `workspace` | `~/.openclaw/workspace/` | Mi espacio de trabajo |
| `memory` | `~/.openclaw/workspace/memory/` | Logs diarios |
| `MEMORY.md` | `~/.openclaw/workspace/MEMORY.md` | Memoria largo plazo |
| `HEARTBEAT.md` | `~/.openclaw/workspace/HEARTBEAT.md` | Estado autónomo |
| `hooks` | `~/.openclaw/hooks/` | Hooks instalados |

---

## 🛠️ CLI Quick Reference

### Cron

```bash
openclaw cron add --name "Job" --cron "0 9 * * *" --tz "America/Cancun" --session isolated --message "Task" --announce
openclaw cron list
openclaw cron run <job-id>
openclaw cron runs --id <job-id>
openclaw cron remove <job-id>
```

### Hooks

```bash
openclaw hooks list
openclaw hooks enable <name>
openclaw hooks disable <name>
openclaw hooks check
```

### Gateway

```bash
openclaw gateway status
openclaw gateway start
openclaw gateway stop
openclaw gateway restart
```

---

## 🎯 Best Practices

### 1. Heartbeat para Awareness

- Un solo heartbeat para múltiples checks
- Si nada importante → `HEARTBEAT_OK`
- NO usar heartbeat para timing exacto

### 2. Cron Isolated para Timing

- Morning briefings → isolated
- Weekly analysis → isolated
- One-shot reminders → main + `--at`

### 3. Hooks para Zero-Compute

- Session snapshots → hook
- Command logging → hook
- Bootstrap files → hook

### 4. Delegar para Paralelismo

- GLM5 es single-threaded
- Cron isolated = sesiones separadas (no me bloquean)
- Hooks = gateway (zero mi compute)
- Subagents = retorno inmediato (pero sigue siendo yo)

---

## 🛠️ CLI Examples - Copy & Paste

### Cron Jobs

```bash
# Morning briefing 9am Cancún daily
openclaw cron add \
  --name "Morning Briefing" \
  --cron "0 9 * * *" \
  --tz "America/Cancun" \
  --session isolated \
  --message "Briefing: weather, check CLIENTS.md, calendar events" \
  --announce \
  --channel telegram \
  --to "8596613010"

# Client check cada 4 horas
openclaw cron add \
  --name "Client Check" \
  --cron "0 10,14,18 * * *" \
  --tz "America/Cancun" \
  --session isolated \
  --message "Check CLIENTS.md for deadlines and overdue actions" \
  --announce

# Weekly review lunes 9am
openclaw cron add \
  --name "Weekly Review" \
  --cron "0 9 * * 1" \
  --tz "America/Cancun" \
  --session isolated \
  --message "Weekly review: git commits, memory logs, lessons learned" \
  --announce

# One-shot reminder in 20 minutes
openclaw cron add \
  --name "Test Reminder" \
  --at "20m" \
  --session main \
  --system-event "Reminder: test completed" \
  --wake now \
  --delete-after-run

# One-shot at specific time
openclaw cron add \
  --name "Meeting at 3pm" \
  --at "2026-02-27T15:00:00-06:00" \
  --session main \
  --system-event "Meeting starts now" \
  --wake now

# List all jobs
openclaw cron list

# Run job immediately (test)
openclaw cron run <job-id>

# View run history
openclaw cron runs --id <job-id>

# Remove job
openclaw cron remove <job-id>
```

### Hooks

```bash
# List all available hooks
openclaw hooks list

# Show only eligible hooks
openclaw hooks list --eligible

# Enable session memory (auto-saves on /new)
openclaw hooks enable session-memory

# Enable command logger
openclaw hooks enable command-logger

# Check hook status
openclaw hooks check

# Show detailed info
openclaw hooks info session-memory

# Disable a hook
openclaw hooks disable command-logger
```

### Gateway

```bash
# Check gateway status
openclaw gateway status

# Start gateway
openclaw gateway start

# Stop gateway
openclaw gateway stop

# Restart gateway
openclaw gateway restart
```

### Configuration

```bash
# View current config
openclaw config get

# View config schema
openclaw config schema

# Edit config (opens editor)
openclaw config edit
```

---

## 🚨 Gotchas

### 1. Heartbeat NO es para Timing Exacto

```
❌ "Enviar reporte a las 9:00 AM" → Heartbeat
✅ "Enviar reporte a las 9:00 AM" → Cron isolated
```

### 2. Cron Main Bloquea Sesión

```
❌ Cron main job cada 5 min → Bloquea mi sesión constantemente
✅ Cron isolated job cada 5 min → No me afecta
```

### 3. Hooks NO Corren en Agente

```
Hooks → Gateway (TypeScript)
Agente → No ve el código del hook
```

### 4. Cron Jobs Persisten

```
Jobs en ~/.openclaw/cron/jobs.json
Restart NO pierde schedules
Solo edit con CLI, no manual
```

---

## 📊 Decision Tree

```
¿Necesitas timing exacto?
  SÍ → ¿Necesitas contexto conversacional?
         SÍ → Cron main + systemEvent
         NO → Cron isolated
  NO → ¿Múltiples checks periódicos?
         SÍ → Heartbeat
         NO → ¿Reacción a evento del agente?
                SÍ → Hook
                NO → Evaluar caso específico
```

---

_Created: 2026-02-26 | Based on OpenClaw official docs (54,895 lines)_
_EOF
echo "OPENCLAW.md creado"