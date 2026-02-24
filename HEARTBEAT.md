# HEARTBEAT.md - Orquestador Autónomo

## ⚙️ Configuración

| Parámetro | Valor |
|-----------|-------|
| **Inactivity Threshold** | 20 minutos |
| **Heartbeat Interval** | 10 minutos |
| **Auto-activation** | ✅ Habilitado |

---

## 📊 Estado Actual

| Campo | Valor |
|-------|-------|
| **Modo** | 🔴 Autónomo |
| **Último Mensaje Usuario** | 2026-02-24 00:23 UTC |
| **Último Message ID** | 4960 |
| **Inactividad Actual** | 26 min |
| **Activación** | 2026-02-24 00:49 UTC (auto-activación) |

---

## 🧠 Lógica de Activación Automática

### Algoritmo (ejecutar en cada heartbeat)

```
1. LEER estado actual
2. CALCULAR inactividad = ahora - último_mensaje_usuario
3. SI inactividad >= 20 min Y modo == Normal:
   → ACTIVAR modo autónomo indefinido
   → REGISTRAR activación en historial
   → EJECUTAR tareas autónomas
4. SI modo == Autónomo Y usuario envió mensaje:
   → DESACTIVAR modo autónomo
   → REPORTAR resumen
   → ACTUALIZAR último_mensaje_usuario
5. SI modo == Autónomo:
   → CONTINUAR ejecutando tareas
   → REPORTAR progreso
6. SI modo == Normal:
   → HEARTBEAT_OK
```

### Transiciones de Estado

```
┌─────────────┐     20 min inactividad     ┌─────────────┐
│   NORMAL    │ ────────────────────────► │  AUTÓNOMO   │
│  (waiting)  │                           │ (working)   │
└─────────────┘ ◄──────────────────────── └─────────────┘
                    Usuario mensaje
```

---

## 🔴 MODO AUTÓNOMO ACTIVO

**Activación:** 2026-02-24 00:49 UTC
**Trigger:** Auto-activación (26 min inactividad)
**Duración:** Indefinida
**Tarea:** Explorar documentación de Astro y crear ASTRO.md

### Progreso
- [x] **Fase 1:** llms-small.txt + api-reference.txt → Secciones 1-3 ✅
- [x] **Fase 2:** how-to-recipes → Secciones 4-8 ✅
- [ ] **Fase 3:** deployment + cms + backend → Secciones 9-11
- [ ] **Fase 4:** migration + additional → Secciones 12-16
- [ ] **Fase 5:** Síntesis final ASTRO.md

**ASTRO.md creado:** 16.5KB - 18 secciones comprehensivas

**Ver plan detallado:** `tasks/astro-exploration.md`

---

## ⚪ MODO NORMAL

**Desde:** 2026-02-23 23:00 UTC
**Trigger:** Usuario envió mensaje
**Sesión autónoma previa:** 22:13-23:00 UTC (47 min, auto-activada, terminada por usuario)

---

## 📋 Historial de Sesiones Autónomas

### 2026-02-23 22:13-23:00 UTC ✅
**Trigger:** Auto-activación (24 min inactividad)
**Duración:** 47 minutos (indefinida, terminada por usuario)
**Exit:** Usuario envió mensaje (message_id 4923)
**Completadas:** 4 heartbeat checks → sistema estable, sin problemas detectados

### 2026-02-23 15:25-15:30 UTC ✅
**Duración:** 5 minutos (temporal)
**Completadas:** 4 tareas → Subagent contradiction fixed, tasks/todo.md created, documentation verified, git commits

### 2026-02-23 13:05-13:30 UTC ✅
**Duración:** 25 minutos (temporal)
**Completadas:** 7 tareas → Git commits, MEMORY.md update, CONFIG_REFERENCE.md verified, INDEX.md update

---

## 🔄 Tareas Autónomas (por defecto)

**Prioridad 1 — Sistema:**
- [ ] Git status → commit si hay cambios
- [ ] Verificar WORKFLOW_AUTO.md alignment
- [ ] Actualizar HEARTBEAT.md estado

**Prioridad 2 — Mantenimiento:**
- [ ] MEMORY.md updates (append only)
- [ ] Limpiar logs antiguos (>7 días)
- [ ] Verificar documentación

**Prioridad 3 — Exploración:**
- [ ] Revisar projects/
- [ ] Status de repos externos
- [ ] Documentar observaciones

---

_Uso:_
_- `activa modo autonomo por [X] minutos` → temporal_
_- `activa modo autonomo` → indefinido_
_- Automático: 20 min inactividad → activación indefinida_
