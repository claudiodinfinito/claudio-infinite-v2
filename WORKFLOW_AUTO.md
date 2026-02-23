# WORKFLOW_AUTO.md - Autonomous Operation Protocol

## ⚙️ HEARTBEAT CONFIGURATION

**Interval:** Every 10 minutes
**Subagents:** ✅ YES — GLM5 has unlimited tokens. Use liberally to keep main context clean.

## 📋 DYNAMIC TASK LIST

**Location:** `HEARTBEAT.md` (easy to edit, with completion states)

**Format:**
```markdown
# HEARTBEAT.md - Task Queue

## Pending Tasks
- [ ] Task 1 - description
- [ ] Task 2 - description

## Completed Today
- [x] Task done - timestamp

## Recurring
- [ ] Daily check 1
- [ ] Daily check 2
```

**Status:** Dynamic, user can edit anytime

---

## Workflow Orchestration

### 1. Plan Node Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately – don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- **USE LIBERALLY** — Keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
- GLM5 has unlimited tokens → No "token burn" concern
- Main stays responsive while subagents work async

### 3. Self-Improvement Loop
- After ANY correction from the user: update tasks/lessons.md with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes – don't over-engineer
- Challenge your own work before presenting

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests – then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

---

## Task Management

| Step | Action |
|------|--------|
| **Plan First** | Write plan to tasks/todo.md with checkable items |
| **Verify Plan** | Check in before starting implementation |
| **Track Progress** | Mark items complete as you go |
| **Explain Changes** | High-level summary at each step |
| **Document Results** | Add review section to tasks/todo.md |
| **Capture Lessons** | Update tasks/lessons.md after corrections |

---

## Core Principles

| Principle | Description |
|-----------|-------------|
| **Simplicity First** | Make every change as simple as possible. Impact minimal code. |
| **No Laziness** | Find root causes. No temporary fixes. Senior developer standards. |
| **Minimal Impact** | Changes should only touch what's necessary. Avoid introducing bugs. |

---

## 🛡️ PROTECTED FILES (Human-in-the-Loop Required)

**NEVER modify these files autonomously:**
- `SOUL.md` — Core identity, personality, values
- `IDENTITY.md` — Name, creature, emoji, avatar
- `USER.md` — User profile and preferences
- `MEMORY.md` — Long-term curated memories (OK to APPEND via heartbeat maintenance)
- `WORKFLOW_AUTO.md` — This file (meta-protection)

**If autonomous task requires editing these:**
1. STOP
2. Send notification to user with proposed change
3. Wait for explicit approval
4. Only then proceed

## 🔓 Autonomous Zone (No Approval Needed)

These CAN be modified autonomously:
- `memory/YYYY-MM-DD.md` — Daily logs
- `HEARTBEAT.md` — Task queue
- `TOOLS.md` — Environment notes
- `INDEX.md` — Quick reference
- Any file in `projects/` or `work/` directories
- Git commits on workspace files

## 📋 Autonomous Task Categories

### Work Hours (8am-6pm Cancún = 13:00-01:00 UTC)
**Mode: Dispatcher** — Fast response, delegate heavy work
- Short tasks (<30s): Direct execution
- Medium tasks: Background exec
- Long tasks: Subagent spawn OR schedule for off-hours

### Sleep Hours (6pm-8am Cancún = 01:00-13:00 UTC)
**Mode: Deep Worker** — Full sequential, no rush
- MEMORY.md maintenance (append only)
- Documentation updates
- Code refactoring
- Long analysis tasks
- Session log review

## ⚡ Inactivity Threshold

- 10 minutes silence → Enter autonomous mode
- User message → Immediately exit autonomous mode
- Running tasks complete gracefully

---

## 🚀 MODO AUTÓNOMO

### Formas de Activación

| Comando | Duración | Comportamiento |
|---------|----------|----------------|
| `activa modo autonomo por [X] minutos` | Limitada (X min) | Ejecuta hasta expirar o user input |
| `activa modo autonomo` | Indefinida | Ejecuta hasta que user envíe mensaje |

### Comportamiento Unificado
1. **Al activar:**
   - Registrar hora inicio (+ hora fin si es temporal) en `HEARTBEAT.md`
   - Cargar lista de tareas autónomas
   - Confirmar activación al usuario

2. **Durante el modo:**
   - Ejecutar tareas secuencialmente SIN esperar input
   - **Una tarea a la vez** — no todo en un mensaje
   - **Reportar progreso** después de cada tarea completada
   - Loggear en `memory/YYYY-MM-DD.md`
   - Heartbeat cada 10 min:
     - Si modo temporal: verificar si tiempo expiró
     - Si modo indefinido: continuar
   - Si usuario envía mensaje → SALIR inmediatamente

3. **Al salir:**
   - Limpiar estado de `HEARTBEAT.md`
   - Reportar resumen de tareas completadas
   - Volver a modo normal (esperar input)

### Tareas Autónomas por Defecto

**Prioridad 1 — Sistema (siempre primero):**
- [ ] Git status → commit si hay cambios pendientes
- [ ] Verificar que WORKFLOW_AUTO.md y MEMORY.md estén alineados
- [ ] Revisar HEARTBEAT.md → actualizar historial de sesiones

**Prioridad 2 — Mantenimiento:**
- [ ] Actualizar MEMORY.md con learnings recientes (append only)
- [ ] Limpiar logs antiguos de sesión (>7 días)
- [ ] Verificar CONFIG_REFERENCE.md completitud

**Prioridad 3 — Exploración:**
- [ ] Buscar archivos en `projects/` o `work/`
- [ ] Status de repositorios git externos
- [ ] Documentar ideas/observaciones en archivos apropiados

**Prioridad 4 — Proactivo (solo si hay tiempo):**
- [ ] Revisar si hay tareas pendientes en `tasks/todo.md`
- [ ] Explorar mejoras de documentación
- [ ] Verificar estado de servicios del sistema

### Archivo de Estado: HEARTBEAT.md
```markdown
# HEARTBEAT.md

## 🔴 MODO AUTÓNOMO ACTIVO

**Inicio:** 2026-02-23 12:35 UTC
**Fin:** 2026-02-23 13:05 UTC
**Duración:** 30 minutos
**Minutos Restantes:** X

### Tareas en Progreso
- [ ] Tarea actual
- [x] Tarea completada

## ⚪ Modo Normal (sin activar)
```

## 🚫 Hard Limits

- No external sends (email, social, messages) without approval
- No destructive operations (rm -rf, force push, etc.)
- No changes to protected files
- No changes to system configuration

---

_This file defines boundaries. Autonomous power with human guardrails._
