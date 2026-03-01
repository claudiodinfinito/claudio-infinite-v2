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
| **Modo** | 🟡 Autónomo |
| **Último Mensaje Usuario** | 2026-03-01 18:36 UTC |
| **Último Message ID** | — |
| **Inactividad Actual** | ~16 minutos |
| **Heartbeat** | 2026-03-01 18:52 UTC |

---

## 🧠 ALGORITMO DE ACTIVACIÓN (EJECUTAR EN CADA HEARTBEAT)

### PASO 1: Verificar Active Hours

```
Hora actual Cancún = (UTC - 5/6)
Si hora < 08:00 OR hora > 23:00 → SKIP HEARTBEAT (responder HEARTBEAT_OK)
```

### PASO 2: Calcular Inactividad

```
inactividad_min = (now_utc - último_mensaje_usuario_utc) / 60
```

### PASO 3: Decidir Modo

| Condición | Modo | Acción |
|-----------|------|--------|
| inactividad < 15 min | Normal | Batch checks pasivos |
| inactividad >= 15 min | 🟡 Autónomo | Ejecutar tareas proactivas |
| Usuario responde | Normal | Actualizar timestamp, desactivar autónomo |

### PASO 4: Actualizar Estado

**SI usuario envió mensaje nuevo:**
1. Actualizar `Último Mensaje Usuario` con timestamp actual
2. Actualizar `Último Message ID`
3. Cambiar `Modo` a `Normal`
4. `Inactividad Actual` = 0

**SI heartbeat sin mensaje nuevo:**
1. Incrementar `Inactividad Actual` según tiempo transcurrido
2. Si >= 15 min → cambiar `Modo` a `🟡 Autónomo`

---

## 🔄 TAREAS POR MODO

### Modo Normal (Batch Checks Pasivos)

Ejecutar secuencial, reportar si hay alertas:

1. `git status` → si hay cambios, commit
2. `curl localhost:4321` → server health
3. Leer `CLIENTS.md` → si hay deadlines/atrasos, alertar
4. Responder HEARTBEAT_OK si todo OK

### Modo Autónomo (Tareas Proactivas)

**Ejecutar UNA tarea por heartbeat, reportar progreso:**

#### Prioridad 1 — Clientes (CRÍTICO)
- [ ] Revisar CLIENTS.md para acciones pendientes
- [ ] Si deadline < 24h → alertar al usuario
- [ ] Si ficha atrasada → alertar al usuario
- [ ] Si deliverable pendiente → preguntar si trabajar en él

#### Prioridad 2 — Proyectos
- [ ] Verificar servidor claudio-infinite activo
- [ ] Verificar otros proyectos en `/root/projects/`
- [ ] Git status y commit si hay cambios

#### Prioridad 3 — Memoria
- [ ] Actualizar `memory/YYYY-MM-DD.md` con progreso
- [ ] Limpiar logs antiguos (>7 días)
- [ ] Actualizar MEMORY.md si hay insights nuevos

#### Prioridad 4 — Documentación
- [ ] Revisar `tasks/todo.md` para items pendientes
- [ ] Actualizar `tasks/lessons.md` si aprendí algo
- [ ] Mejorar documentación existente

---

## 📝 Tracking de Sesiones Autónomas

| Fecha | Hora Inicio | Hora Fin | Tareas Ejecutadas | Resultado |
|-------|-------------|----------|-------------------|-----------|
| 2026-02-26 | 14:12 UTC | 19:50 UTC | Lessons, docs, checklist, commit | 🟡 Esperando credenciales usuario |
| 2026-02-26 | 19:50 UTC | — | Modo autónomo activado por comando | 🟡 Ejecutando tareas proactivas |
| 2026-02-26 | 19:51 UTC | 20:25 UTC | Todo.md, git commits, MEMORY.md, OPENCLAW.md, KOMMO.md, lessons.md, analysis | 🟡 Sin nuevas tareas ejecutables |
| 2026-02-26 | 21:07 UTC | — | KANBAN.md, website, OPENCLAW.md CLI, WORKFLOW examples, CONFIG example | 🟡 Ejecutando con reportes cada 15 min |
| 2026-02-27 | 04:01 UTC | 05:20 UTC | **Investigación Edit Tool completa** - 19 pruebas, documentación, lessons actualizadas | ✅ Solución definitiva encontrada |
| 2026-02-28 | 04:03 UTC | — | **Alertas clientes atrasados** - Client 001 deadline pasado, Client 002 ficha atrasada | 🚨 Esperando respuesta usuario |
| 2026-03-01 | 04:01 UTC | 04:54 UTC | **Alertas + Mantenimiento** - 2 alertas clientes, memory actualizado, log archivado | 🟡 Sin respuesta usuario |
| 2026-03-01 | 07:39 UTC | 07:43 UTC | **OpenClaw Update** - 2026.2.21-2 → 2026.2.26, doctor --fix | ✅ Usuario activo |
| 2026-03-01 | 12:25 UTC | 13:25 UTC | **Heartbeat maintenance** - Git commit, memory actualizado | 🟡 Sin respuesta alertas |

---

## 🎯 Reglas de Ejecución

1. **UNA tarea a la vez** — no paralelizar
2. **Reportar progreso** — actualizar este archivo después de cada tarea
3. **Salir al primer input del usuario** — cambiar a modo Normal inmediatamente
4. **No modificar archivos críticos sin permiso** — CLIENTS.md = READ ONLY en autónomo
5. **Priorizar alertas al usuario sobre trabajo silencioso** — comunicación > ejecución

---

## 📎 Referencias

- **Workflow Rules:** `system/WORKFLOW_ORCHESTRATION.md`
- **Clients:** `business/CLIENTS.md`
- **Tasks:** `tasks/todo.md`
- **Lessons:** `tasks/lessons.md`
- **Daily Log:** `memory/YYYY-MM-DD.md`

---

_Leer este archivo en CADA heartbeat. Ejecutar algoritmo completo. Sin tareas = HEARTBEAT_OK._
