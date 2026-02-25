# HEARTBEAT.md - Orquestador Autónomo

## ⚙️ Configuración

| Parámetro | Valor |
|-----------|-------|
| **Inactivity Threshold** | 15 minutos |
| **Heartbeat Interval** | 10 minutos |
| **Auto-activation** | ✅ Habilitado |
| **Active Hours** | 08:00-23:00 America/Cancun |

---

## 📊 Estado Actual

| Campo | Valor |
|-------|-------|
| **Modo** | ⚪ Normal |
| **Último Mensaje Usuario** | 2026-02-25 18:05 UTC |
| **Inactividad Actual** | 0 min (usuario activo) |

---

## 🔄 Batch Checks (ejecutar en cada heartbeat)

**Secuencial, un turno:**

1. `memory_search("pending urgent")` → contexto
2. `git status` → commit si hay cambios
3. `curl localhost:4321` → server health
4. Scan `CLIENTS.md` → action needed?
5. Responder **HEARTBEAT_OK** o alertar

---

## 📝 Notas

- **Timing exacto** → Cron jobs isolated (ver `openclaw cron list`)
- **Eventos automáticos** → Hooks (ver `openclaw hooks list`)
- **Decision logic** → MEMORY.md sección "Autonomous Behavior"
- **Historial sesiones** → `memory/YYYY-MM-DD.md`

---

_Leer este archivo en cada heartbeat. Sin tareas pendientes = HEARTBEAT_OK._
