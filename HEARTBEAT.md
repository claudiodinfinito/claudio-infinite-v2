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
| **Modo** | ⚪ Normal |
| **Último Mensaje Usuario** | 2026-02-25 04:15 UTC |
| **Inactividad Actual** | 0 min (usuario activo) |
| **Server** | ✅ Stable |
| **Clients** | ✅ 1 Active, 1 Prospect |

---

## 🧠 Lógica de Activación Automática

### Algoritmo (ejecutar en cada heartbeat)

```
0. LEER system/WORKFLOW_ORCHESTRATION.md (verificar adherencia a las 6 reglas)
1. LEER estado actual (NO MODIFICAR)
2. CALCULAR inactividad = ahora - último_mensaje_usuario
3. SI inactividad >= 20 min Y modo == Normal:
   → ACTIVAR modo autónomo indefinido
   → ACTUALIZAR HEARTBEAT.md (solo en cambio de estado)
   → EJECUTAR tareas autónomas
4. SI modo == Autónomo Y usuario envió mensaje:
   → DESACTIVAR modo autónomo
   → ACTUALIZAR HEARTBEAT.md
   → REPORTAR resumen
5. SI modo == Autónomo:
   → CONTINUAR ejecutando tareas
6. SI modo == Normal:
   → HEARTBEAT_OK
```

---

## 📋 Tareas Autónomas (por defecto)

**Prioridad 0 — Workflow Adherence:**
- [ ] Leer `system/WORKFLOW_ORCHESTRATION.md`
- [ ] Verificar adherencia a las 6 reglas

**Prioridad 1 — Sistema:**
- [ ] Git status → commit si hay cambios
- [ ] Verificar HEARTBEAT.md estado

**Prioridad 2 — Mantenimiento:**
- [ ] MEMORY.md updates
- [ ] Limpiar logs antiguos (>7 días)

**Prioridad 3 — Exploración:**
- [ ] Revisar projects/
- [ ] Status de repos externos

---

## 📁 Rutas Importantes

| Archivo | Ubicación |
|---------|-----------|
| WORKFLOW_ORCHESTRATION.md | `system/` (mismo folder) |
| todo.md | `tasks/` |
| lessons.md | `tasks/` |
| CLIENTS.md | `business/` |
| KANBAN.md | `business/` |
| MEMORY.md | `./` (root) |

---

_Uso:_
_- `activa modo autonomo por [X] minutos` → temporal_
_- `activa modo autonomo` → indefinido_
_- Automático: 20 min inactividad → activación indefinida_
