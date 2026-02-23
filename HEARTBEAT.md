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
| **Modo** | Normal |
| **Último Mensaje Usuario** | 2026-02-23 21:49 UTC |
| **Último Message ID** | 4916 |
| **Inactividad Actual** | 0 min |

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

## ⚪ Estado Normal (desactivado)

_Actualmente en espera. La activación automática ocurrirá tras 20 min de inactividad._

---

## 📋 Historial de Sesiones Autónomas

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
