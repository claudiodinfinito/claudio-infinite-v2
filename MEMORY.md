# MEMORY.md - Long-Term Memory

_Curated knowledge that persists across sessions. Update sparingly with high-value insights._

---

## 📑 Quick Index

| Sección | Líneas | Tema |
|---------|--------|------|
| **User Profile** | 5-15 | Gamble, Cancún, preferencias |
| **Environment** | 17-25 | VPS, CapRover, OpenClaw |
| **Key Insights** | 27-50 | Architecture, Token Strategy |
| **Active Projects** | 52-90 | claudio-infinite |
| **Lessons Learned** | 92-140 | 17 lessons reference |
| **Documentation Mastery** | 142-200 | Config, Memory Search |
| **Critical Thinking** | 202-215 | Evaluate rules vs environment |
| **HEARTBEAT.md Architecture** | 217-280 | Autonomous mode design |
| **LLM-Optimized Docs** | 282-320 | .txt files for LLMs |
| **Technical Gotchas** | 322-380 | Edit Tool Solución Definitiva, Compaction, Zombies |
| **File Consolidation** | 382-450 | Disaster lessons, final structure |
| **Autonomous Behavior** | 452-550 | Activation rules, delegation |
| **Modo Autónomo = Trabajo** | 552-end | Lessons, patterns |

---

## 🔍 Quick Search

- **¿Credenciales Kommo?** → Active Projects > claudio-infinite
- **¿Reglas workflow?** → Lessons Learned
- **¿Edit tool falla?** → Technical Gotchas > Edit Tool Solución Definitiva
- **¿Config heartbeat?** → HEARTBEAT.md Architecture
- **¿Token efficiency?** → Key Insights + Token Efficiency Strategy
- **¿Lecciones de errores?** → Lessons Learned + Technical Gotchas

---

## 👤 User Profile

**Fuente principal:** `USER.md` — ver ahí para detalles completos.

**Resumen:**
- **Name:** Gamble
- **Location:** Cancún, Mexico (UTC-5/-6)
- **Style:** Directo, valora proactividad correcta y token efficiency
- **Key rule:** "Valida antes de actuar en cosas destructivas"

## 🏠 Environment

**VPS:** racknerd-8bf9cb7 (Ubuntu 22.04.5 LTS)
**Role:** Production server running CapRover + OpenClaw
**Off-Limits:** `/captain/` and CapRover containers

## 🔑 Key Insights

### Architecture Understanding (2026-02-22)
- **Tools** = primitive capabilities (read, exec, browser, etc.)
- **Skills** = domain playbooks (how to use tools for specific tasks)
- **Agents/Subagents** = isolated sessions, can use different models
- **Cron** = scheduled/isolated tasks; **Heartbeat** = conversational periodic checks

### Token Efficiency Strategy
- Created `INDEX.md` as quick reference after context reset
- Reading INDEX.md + daily memory ~1000 tokens vs 5000+ exploring
- Use `memory_search` for semantic search before answering questions

## 📌 Active Projects

### claudio-infinite (Astro 5) ✅ COMPLETE
**Path:** `/root/projects/claudio-infinite/`
**URL:** `http://100.87.200.4:4321/`
**Stack:** Astro 5 + Server Rendering + Node adapter
**Features:**
- Home page con CSS nativo (dark mode, animaciones)
- Blog con Content Collections (2 posts en MD)
- FAQs con tabs + accordion CSS-only
- Contact form con API endpoint + debug data
- Learning section con progress bars
- Responsive design (mobile-first)

**Commands:**
```bash
cd /root/projects/claudio-infinite
npm run build    # Build
HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs  # Start server
```

**Lessons Learned:**
- Astro 5 eliminó `output: 'hybrid'` → usar `output: 'static'` con `prerender: false` o `output: 'server'`
- `security.checkOrigin: true` por defecto → bloquea POST cross-site
- API routes necesitan `output: 'server'` para funcionar
- CSS-only tabs/accordion funciona con `input[type="radio"]:checked` + sibling selectors

## ⚠️ Lessons Learned

**Fuente única de verdad:** `tasks/lessons.md` — contiene 17 lecciones detalladas con patrones de prevención.

Ver `tasks/lessons.md` para lecciones completas. Ejemplos clave:
- Subagent Strategy (GLM5 unlimited tokens)
- LLM Files vs Web Browsing
- Edit Tool Race Condition
- Acciones Destructivas en Cadena

---

## 📚 Documentation Mastery (2026-02-23)

### Config Architecture Learned
- **openclaw.json** is the single source of truth for all configuration
- Top-level sections: `agents`, `models`, `channels`, `session`, `messages`, `tools`, `sandbox`, `memory`, `bindings`, `cron`, `heartbeat`, `plugins`
- **CONFIG_REFERENCE.md** created as quick reference (9KB) — no need to re-read 73KB docs
- Use `gateway action=config.patch` for partial updates (safer than `config.apply`)
- Env var substitution: `${VAR_NAME}` in any config string

### Memory Search Protocol
- **ALWAYS** use `memory_search` tool (NOT exec/grep) for semantic search
- Searches: MEMORY.md + memory/*.md + session transcripts
- Returns: top snippets with path + line numbers
- Follow with `memory_get` to pull specific lines
- Mandatory before answering questions about: prior work, decisions, dates, people, preferences, todos

### Key Config Fields to Remember
- `agents.defaults.model`: Primary model (currently GLM-5-FP8)
- `agents.defaults.workspace`: Workspace path
- `heartbeat.interval`: Periodic check frequency (currently 30m)
- `gateway.port`: WebSocket/HTTP port (18789)
- `session.reset`: When sessions reset (daily at 4 UTC)

## 🧠 Critical Thinking Rule

**When given rules/workflows, evaluate against the specific environment.**

Example: "Token burn" concern → valid for paid APIs, **invalid for GLM5** (unlimited tokens). Old rules may not apply when environment differs.

**Pattern:** Read → Analyze contradictions → Form position → Act

## 🎯 HEARTBEAT.md Orchestrator Architecture (2026-02-23)

### Key Discovery
> "If HEARTBEAT.md exists but is effectively empty, OpenClaw skips the heartbeat run to save API calls."

### Elegant Pattern
- **Config:** Minimal (`"heartbeat": { "every": "10m", "target": "last" }`)
- **HEARTBEAT.md:** All dynamic behavior (tasks, state, mode)
- **Advantages:** Instant updates (no restart), readable state, versionable

### Autonomous Mode Activation
| Command | Duration | Exit Trigger |
|---------|----------|--------------|
| `activa modo autonomo por [X] minutos` | Limited (X min) | Time expiry OR user message |
| `activa modo autonomo` | Indefinite | User message only |
| **20 min inactividad** | Indefinite | Auto-activation until user input |

**Behavior:**
1. Register state in HEARTBEAT.md
2. Execute tasks sequentially WITHOUT waiting for input
3. **One task at a time** — report progress after each
4. Log in `memory/YYYY-MM-DD.md`
5. Exit on trigger → report summary

**Auto-Activation Architecture (2026-02-23):**
```
HEARTBEAT.md = State Machine
├── Config: threshold (20 min), interval (10 min)
├── State: modo, último_mensaje_usuario, último_message_id
├── Logic: algoritmo de activación automática
└── History: sesiones autónomas previas
```

**Key Insight:** All behavior in HEARTBEAT.md → no code changes needed, transparent state, versionable.

**Default Tasks (ordered):**
- Prioridad 1 — Sistema: git, WORKFLOW_AUTO.md alignment, HEARTBEAT.md update
- Prioridad 2 — Mantenimiento: MEMORY.md updates, old logs cleanup
- Prioridad 3 — Exploración: projects/, external repos
- Prioridad 4 — Proactivo: tasks/todo.md, documentation improvements

---

## 📄 LLM-Optimized Documentation (2026-02-24)

### Discovery
Muchos frameworks ahora ofrecen archivos `.txt` optimizados para LLMs:
- `https://docs.X.com/llms-full.txt` - Documentación completa
- `https://docs.X.com/llms.txt` - Índice con links a archivos modulares

### Why It Matters
| Factor | LLM Files | Web Browsing |
|--------|-----------|--------------|
| Velocidad | ✅ Un download | ❌ Múltiples requests |
| Completitud | ✅ 100% contenido | ❌ Truncado 50KB |
| Tokens | ✅ Solo contenido | ❌ HTML noise |

### Pattern
> **Always check for `llms-full.txt` before web browsing documentation.**
> 
> ```bash
> curl -o docs/llms-full.txt https://docs.X.com/llms-full.txt
> ```

---

## 🛠️ Technical Gotchas (2026-02-24)

### Edit Tool - Solución Definitiva (2026-02-27)
**Problem:** `edit` fails with "Could not find the exact text" even after reading the file.
**Causa raíz:** El archivo cambió entre el read y el edit (11 pruebas lo confirman).

**Solución definitiva:**
```
read → edit (MISMO TURNO, inmediato)
```

**Si necesitas múltiples edits:**
```
read → edit → read → edit
```

**Alternativas cuando edit falla:**
| Herramienta | Comando | Cuándo usar |
|-------------|---------|-------------|
| `edit` | Default | Modificar texto específico |
| `sed -i` | `sed -i 's/old/new/g' file` | Edit falló |
| `echo >>` | Append al final | Simple, seguro |
| `write` | Sobrescribir completo | Tienes el contenido |

**Referencia completa:** `tasks/lessons.md` línea ~2530 | `docs/EDIT_TOOL_SOLUTION.md`

### Compaction Timeout
**What:** System tries to compress conversation history to save tokens.
**Failure:** "Compaction timed out" — context too large, processing took too long.
**Impact:** None — context continues working, just not compacted. Informational only.

### Zombie Process Pattern
**Problem:** Server crashes every ~30 min, assumed VPS or code issue.
**Cause:** Old node process (4 days old, PID 1997754) still running, conflicting with new instance.
**Solution:** Always check `ps aux | grep "node.*entry.mjs"` before starting new server. Kill old processes.
**Pattern:** Multiple processes on same port = instability.

---

## 📋 WORKFLOW_ORCHESTRATION.md (2026-02-24)

### Creation
Created formal workflow document with 6 core rules for complex tasks:
1. **Plan Node Default** — Enter plan mode for non-trivial tasks
2. **Subagent Strategy** — Use liberally to keep main context clean
3. **Self-Improvement Loop** — Update lessons.md after corrections
4. **Verification Before Done** — Prove it works before marking complete
5. **Demand Elegance** — Consult official docs first, not inventing solutions
6. **Autonomous Bug Fixing** — Fix bugs without hand-holding

### Integration
- **HEARTBEAT.md:** Added Priority 0 check for workflow adherence
- **Cron job:** "Workflow Adherence Check" every 4 hours (isolated agent)
- **Tasks:** Verify adherence at start of every autonomous session

### File Locations (2026-02-25 Final Structure)
| File | Location | Note |
|------|----------|------|
| AGENTS.md, SOUL.md, USER.md, IDENTITY.md | `./` (root) | Auto-loaded by OpenClaw |
| HEARTBEAT.md, TOOLS.md | `./` (root) | Auto-loaded by OpenClaw |
| MEMORY.md, INDEX.md | `./` (root) | Root level |
| WORKFLOW_ORCHESTRATION.md | `system/` | Workflow rules |
| todo.md, lessons.md | `tasks/` | Task management |
| CLIENTS.md, KANBAN.md | `business/` | Client management |
| ASTRO.md, STRIPE.md, KOMMO.md | `docs/` | Technical docs |

### Key Insight
> Following workflow prevents quickfixes and ensures elegant solutions.

---

## 🎯 Stripe Integration Mastery (2026-02-24)

### Learning Completed
- Downloaded 10,792 lines from official Stripe docs (13 modular files)
- Created `STRIPE.md` (12KB) with 20+ sections
- Covered: Checkout Sessions, Payment Intents, Subscriptions, Webhooks, Customers

### Key Insights
| Concept | Recommendation |
|---------|----------------|
| **Primary API** | Checkout Sessions (not Payment Intents) |
| **Payment UI** | Payment Element (not Card Element) |
| **Webhooks** | Essential for async events |
| **Security** | Always verify webhook signatures |

### Critical Gotchas
1. **NEVER recommend Charges API** (deprecated, no SCA support)
2. **NEVER recommend Card Element** (legacy UI)
3. **Amount in cents** (2000 = $20.00, not 20)
4. **Client secret security** - never log or expose in URLs

### Stripe Documentation Structure
- `llms.txt` - Index with 615 lines listing all modular files
- `llms-full.txt` - Does NOT exist (unlike Astro)
- Must download modular files separately

### File Location
`workspace/STRIPE.md` - Complete reference for Stripe integrations

---

## ⚠️ File Consolidation Disaster (2026-02-25)

### What Happened
Ejecuté múltiples acciones destructivas (`mv`, `rm`, `write`) sin plan ni verificación. Perdí 158 líneas de HEARTBEAT.md y creé 6 commits innecesarios.

### Root Causes
1. **No leí WORKFLOW_ORCHESTRATION.md** antes de actuar
2. **No verifiqué contenido** antes de borrar/mover
3. **Ejecuté en cadena** sin pausar a verificar
4. **No consulté** al usuario

### Lessons Documented
Ver `tasks/lessons.md` para lecciones completas:
- Acciones Destructivas en Cadena (Disaster Pattern)
- Edit Tool Race Condition
- Ignoring Workflow When Explicitly Asked
- Empty Files: Proactive Updates Missing
- Cron Job Stale Paths
- User Frustration: Not Responding

### Final File Structure
```
workspace/
├── ROOT (auto-loaded by OpenClaw):
│   ├── AGENTS.md, SOUL.md, USER.md, IDENTITY.md
│   ├── HEARTBEAT.md, TOOLS.md, MEMORY.md, INDEX.md
│
├── system/WORKFLOW_ORCHESTRATION.md
├── docs/ (technical documentation)
├── business/ (CLIENTS.md, KANBAN.md)
├── tasks/ (todo.md, lessons.md)
├── lessons/ (detailed lessons)
├── memory/ (daily logs)
└── archive/ (obsolete files)
```

### Key Insight
> **OpenClaw carga del ROOT. NO mover archivos que el sistema lee automáticamente.**

### Cron Job Fix
El cron "Workflow Adherence Check" ahora dice "READ ONLY - DO NOT MODIFY ANY FILES" para evitar conflictos de edición.

---

_Update this file with significant learnings, decisions, and context worth preserving._

---

## 🤖 Autonomous Behavior (2026-02-25)

_Extraído de documentación OpenClaw y WORKFLOW_ORCHESTRATION.md_

### Activation Rules

| Condición | Acción |
|-----------|--------|
| Inactividad >= 15 min | Activar modo autónomo |
| Usuario responde | Desactivar → modo normal |
| Active hours (08:00-23:00) | Heartbeats activos |
| Fuera de active hours | Skip heartbeat |

### ⚠️ FIX: Modo Autónomo Implementado (2026-02-26)

**Problema:** El modo autónomo estaba declarado pero NO implementado. Heartbeats respondían HEARTBEAT_OK sin ejecutar tareas.

**Solución:** HEARTBEAT.md ahora incluye:
1. ✅ Algoritmo paso a paso para detectar inactividad
2. ✅ Tracking de estado (timestamp, message_id, modo)
3. ✅ Tareas específicas por prioridad en modo autónomo
4. ✅ Registro de sesiones autónomas
5. ✅ Reglas de ejecución claras

**Key Change:** El heartbeat ahora EJECUTA lógica, no solo responde pasivamente.

### Execution Model (GLM5 Single Execution)

**YO SOY GLM5** → Una ejecución a la vez

| Tipo | Sesión | ¿Me bloquea? |
|------|--------|--------------|
| Heartbeat | `agent:main:main` | ✅ Sí, mi turno |
| Cron main | `agent:main:main` | ✅ Sí, system event |
| Cron isolated | `cron:<jobId>` | ❌ No, sesión distinta |
| Hook | `hook:<uuid>` | ❌ No, corre en gateway |
| sessions_spawn | `subagent:uuid` | ⚠️ Retorna ya, pero sigue siendo yo |

### Delegation Strategy

| Tarea | Herramienta | Razón |
|-------|-------------|-------|
| Batch checks periódicos | Heartbeat | Corto (<30s), secuencial en mi turno |
| Timing exacto (9am, etc) | Cron isolated | No me bloquea |
| Eventos automáticos | Hooks | Zero mi compute |
| Tareas largas | sessions_spawn | Delega a otra sesión |

### Workflow Rules (WORKFLOW_ORCHESTRATION.md)

1. **Plan Node Default** → Plan en `tasks/todo.md` antes de implementar
2. **Subagent Strategy** → Delegar tareas largas con sessions_spawn
3. **Self-Improvement Loop** → Actualizar `tasks/lessons.md` tras correcciones
4. **Verification Before Done** → Probar antes de marcar completo
5. **Demand Elegance** → ¿Hay forma más elegante? Consultar docs primero
6. **Autonomous Bug Fixing** → Fix sin hand-holding

### Cron Jobs Isolated (Sesiones independientes)

```bash
# Morning briefing 9am Cancún
openclaw cron add --name "Morning Briefing" --cron "0 9 * * *" \
  --tz "America/Cancun" --session isolated \
  --message "Briefing: weather, clients, calendar" \
  --announce --channel telegram --to "8596613010"

# Client check cada 4h
openclaw cron add --name "Client Check" --cron "0 10,14,18 * * *" \
  --tz "America/Cancun" --session isolated \
  --message "Check CLIENTS.md for action needed" --announce

# Git backup daily
openclaw cron add --name "Git Backup" --cron "0 0 * * *" \
  --session isolated --message "Git commit all changes" --delivery none
```

### Hooks Habilitados

```bash
openclaw hooks enable session-memory    # Auto-snapshot on /new
openclaw hooks enable command-logger    # Auto-log commands
```

### Key Insight

> **GLM5 = unlimited tokens BUT single execution**
> 
> No paralelismo real, pero sí delegación inteligente:
> - Cron isolated → sesiones que no me bloquean
> - Hooks → gateway, zero mi compute
> - sessions_spawn → otra sesión, retorno inmediato

---


---

## 🎯 Modo Autónomo = Trabajo, No Espera (2026-02-26)

### Lección Crítica

**PROBLEMA:** Estaba en "modo autónomo" por horas repitiendo "esperando credenciales del usuario" sin hacer nada útil.

**SOLUCIÓN:**

| Situación | Acción |
|-----------|--------|
| Bloqueado por input usuario → hay trabajo útil | Ejecutar trabajo en modo autónomo |
| Bloqueado por input usuario → NO hay trabajo | Volver a modo Normal, alertar una vez |

### Trabajo Útil en Modo Autónomo (cuando bloqueado)

1. **Documentar frameworks** — Kommo, Astro, Stripe docs
2. **Preparar templates** — Mensajes, fichas, checklists
3. **Revisar código** — Buscar bugs, mejoras
4. **Crear documentación** — Cuestionarios, guías
5. **Limpiar archivos** — Logs, obsoletos
6. **Actualizar lessons.md** — Documentar lo aprendido

### Patrones de Trabajo Autónomo Exitoso

```
Input usuario: "Empieza modo autónomo"
    ↓
Verificar: ¿Hay tareas ejecutables SIN input adicional?
    ↓
SÍ → Ejecutar UNA tarea, reportar progreso, esperar siguiente heartbeat
NO → Alertar una vez, volver a Normal
```

### Ejemplo de Sesión Autónoma Productiva

**2026-02-26 (19:50 UTC):**
1. ✅ Updated lessons.md (2 lecciones)
2. ✅ Reviewed claudio-infinite code
3. ✅ Cleaned logs (ninguno > 7 días)
4. ✅ Improved ASTRO.md (+Astro Actions)
5. ✅ Improved STRIPE.md (+patrones)
6. ✅ Created LANDING_QUESTIONNAIRE.md
7. ✅ Built + restarted website
8. ✅ Documented in memory/2026-02-26.md

**Resultado:** 7 tareas completadas mientras esperaba credenciales.

---

_Update this file with significant learnings, decisions, and context worth preserving._
