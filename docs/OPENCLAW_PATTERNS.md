# OpenClaw Patterns - Casos de Uso por Archivo

_Estudio de patrones extraídos de la documentación oficial de OpenClaw._

---

## 📊 Resumen del Workspace

| Categoría | Archivos | Tamaño Total |
|-----------|----------|--------------|
| **Core System** | AGENTS.md, SOUL.md, USER.md, IDENTITY.md, HEARTBEAT.md, TOOLS.md, MEMORY.md, INDEX.md | ~92KB |
| **Business** | CLIENTS.md, KANBAN.md | 12KB |
| **Tasks** | todo.md, lessons.md | 64KB |
| **Docs** | ASTRO.md, STRIPE.md, KOMMO.md, CONFIG_REFERENCE.md | 84KB |
| **Memory** | 4 daily logs | 72KB |
| **Skills** | openclaw-docs | 1.9MB |

---

## 🎯 Casos de Uso por Archivo

### 1. HEARTBEAT.md - Orquestador Autónomo

**Patrón OpenClaw:** Heartbeat + Cron combinados

**Mejoras aplicables:**

```markdown
# HEARTBEAT.md actualizado con patrones OpenClaw

## 🔄 Batch Checks (Patrón: Heartbeat batching)
En CADA heartbeat, ejecutar:
1. memory_search + memory_get para recuperar contexto
2. git status + commit si hay cambios
3. Server health check
4. Client status review

## ⏰ Exact Timing (Patrón: Cron para timing exacto)
Usar CRON para:
- Recordatorios de clientes (2 días antes, 3 horas antes)
- Daily briefings a 9am Cancún
- Weekly reviews lunes 9am

## 🎯 Delivery Modes (Patrón: announce/webhook/none)
- Heartbeat → `HEARTBEAT_OK` (none, internal)
- Cron jobs críticos → announce (canal: telegram)
- Webhooks externos → webhook mode
```

**Caso de uso concreto:**
```bash
# Crear cron job para Client 001 reminders
openclaw cron add \
  --name "Client001 - Recordatorio 2 días" \
  --cron "0 9 * * *" \
  --tz "America/Cancun" \
  --session isolated \
  --message "Verificar citas Client 001 Spa para pasado mañana. Revisar KANBAN.md y CLIENTS.md" \
  --announce \
  --channel telegram \
  --to "8596613010"
```

---

### 2. tasks/todo.md - Task Tracker

**Patrón OpenClaw:** Sessions isolation para tasks largas

**Mejoras aplicables:**

```markdown
# Todo.md con subagentes por tarea

## Fase 1: Análisis
- [ ] Lanzar subagent para cada sección de docs
  - [ ] Subagent A: Tools section
  - [ ] Subagent B: Channels section
  - [ ] Subagent C: Gateway section
```

**Caso de uso concreto:**
```
# En lugar de leer yo mismo, usar sessions_spawn:
sessions_spawn(
  task: "Read OpenClaw docs section 'automation/cron-jobs' from llm-full.txt and extract 5 key lessons",
  agentId: "main",
  model: "GLM5-FP8"
)
```

**Ventaja:** GLM5 tiene tokens ilimitados → paralelismo sin costo

---

### 3. business/CLIENTS.md - Client Management

**Patrón OpenClaw:** Memory search + delivery

**Mejoras aplicables:**

```json5
// Cron job para follow-up automático
{
  name: "Client Follow-up",
  schedule: { kind: "every", everyMs: 86400000 }, // Daily
  payload: {
    kind: "agentTurn",
    message: "Check CLIENTS.md for pending actions. If 'Action Needed' exists, remind user via telegram."
  },
  delivery: { mode: "announce", channel: "telegram", to: "8596613010" }
}
```

**Caso de uso concreto:**
- Client 002 tiene "Enviar ficha de pago HOY" → cron job daily check
- Si status == "Action Needed" → mensaje automático

---

### 4. tasks/lessons.md - Lessons Learned

**Patrón OpenClaw:** Hooks para auto-capture

**Mejoras aplicables:**

```typescript
// Hook: auto-append to lessons.md on user correction
// ~/.openclaw/hooks/lesson-capture/handler.ts

const handler = async (event) => {
  if (event.type === "message" && event.action === "received") {
    // Detect correction patterns
    if (event.content?.match(/no|hiciste mal|error|mal/)) {
      // Log for later review
      event.messages.push("📝 Noted for lessons.md");
    }
  }
};
export default handler;
```

**Caso de uso concreto:**
- Crear hook que detecte correcciones del usuario
- Auto-sugerir agregar a lessons.md

---

### 5. MEMORY.md - Long-Term Memory

**Patrón OpenClaw:** memory_search tool

**Uso actual:** Manual reads
**Mejora:** Usar `memory_search` tool

**Caso de uso concreto:**
```
# ANTES (lento):
read(MEMORY.md) → scan → find relevant section

# DESPUÉS (semántico):
memory_search(query: "Client 001 Kommo credentials") 
→ Returns: "Client 001 needs Kommo credentials (subdomain + token)"
```

---

### 6. AGENTS.md - Rules of Operation

**Patrón OpenClaw:** Bootstrap files

**Ya implementado:** OpenClaw auto-loads AGENTS.md, SOUL.md, USER.md

**Mejora posible:**
```json5
// En openclaw.json
{
  agents: {
    defaults: {
      bootstrapFiles: [
        "AGENTS.md",
        "SOUL.md",
        "USER.md",
        "HEARTBEAT.md",  // Agregar
        "tasks/lessons.md"  // Agregar lessons
      ]
    }
  }
}
```

---

### 7. IDENTITY.md - Who Am I

**Patrón OpenClaw:** Avatar + Status

**Mejoras aplicables:**
```json5
// Integrar con Discord/Telegram status
{
  action: "status",
  channel: "telegram",
  status: "online",
  activityType: "working",
  activityName: "Client 001 - Kommo CRM"
}
```

---

### 8. system/WORKFLOW_ORCHESTRATION.md

**Patrón OpenClaw:** 6 Rules → Cron verification

**Mejora:**
```bash
# Cron job cada 4h para verificar adherencia
openclaw cron add \
  --name "Workflow Check" \
  --cron "0 */4 * * *" \
  --session isolated \
  --message "READ ONLY: Check WORKFLOW_ORCHESTRATION.md adherence. Report any violations." \
  --announce
```

**Ya implementado:** ✅ (el cron existe)

---

## 🔧 Config Optimizations

### Sandbox Mode

**Patrón:** Usar sandbox para pruebas

```json5
// openclaw.json
{
  sandbox: {
    mode: "off",  // Actual: disabled
    // Cambiar a "on" para experimentación segura
  }
}
```

**Caso de uso:**
- Probar comandos destructivos en sandbox
- `exec` con `security: "allowlist"` para operaciones sensibles

---

### Memory Configuration

**Patrón:** memory_search obligatorio

```json5
{
  memory: {
    enabled: true,
    paths: ["MEMORY.md", "memory/*.md"],
    searchRequired: true  // Obligar uso de memory_search
  }
}
```

---

## 📋 Resumen de Patrones Clave

| Patrón | Herramienta | Cuándo Usar |
|--------|-------------|-------------|
| **Heartbeat batching** | HEARTBEAT.md | Múltiples checks periódicos |
| **Cron exact timing** | `openclaw cron` | Timing preciso (9am, etc) |
| **Sessions isolation** | `sessions_spawn` | Tareas largas en paralelo |
| **Memory search** | `memory_search` | Recuperar contexto |
| **Hooks** | `~/.openclaw/hooks/` | Eventos automáticos |
| **Sandbox** | `sandbox.mode` | Pruebas seguras |

---

_Generado a partir de OpenClaw docs (1.9MB, 54,895 líneas)_
