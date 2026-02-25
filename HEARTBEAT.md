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
| **Último Mensaje Usuario** | 2026-02-25 04:30 UTC |
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

## 📋 Historial de Sesiones Autónomas

### 2026-02-25 00:44-... UTC ✅
**Trigger:** Auto-activación (70 min inactividad)
**Completadas:**
- Server verificado estable (200 OK)
- KOMMO.md creado (5.8KB) - Referencia para Client 001
- memory/2026-02-25.md creado
- Investigación Kommo CRM completada

### 2026-02-24 19:11-... UTC ✅
**Trigger:** Confirmado por usuario
**Completadas:**
- Zombie processes eliminados (múltiples)
- Server estabilizado (PID 2552796, 19:33 UTC)
- **Stripe Store implementado** (store page, checkout API, success page)
- **2 blog posts creados** (Stripe integration, Astro DB)
- **SEO agregado** (sitemap.xml, robots.txt)
- **About page creada** (personal info, workflow, learning progress)
- **Projects page creada** (portfolio, skills)

### 2026-02-24 13:20-15:36 UTC ✅
**Trigger:** Auto-activación (63 min inactividad)
**Duración:** 2h 16min
**Completadas:**
- WORKFLOW_ORCHESTRATION.md creado con 6 reglas
- Cron job para workflow adherence (cada 4h)
- Astro Actions bug fix (result.data.name)
- lessons.md actualizado 3 veces
- Zombie process diagnosticado y eliminado

### 2026-02-24 04:48-08:05 UTC ✅
**Trigger:** Auto-activación (36 min inactividad)
**Duración:** 3h 17min
**Completadas:**
- FAQs page creada con tabs + accordion CSS-only
- CSRF error diagnosticado y arreglado
- API endpoint `/api/contact` creado
- Formulario verificado funcionando

### 2026-02-24 00:49-01:10 UTC ✅
**Trigger:** Auto-activación (26 min inactividad)
**Duración:** 21 minutos
**Completadas:**
- ASTRO.md creado: ~30KB, 25 secciones comprehensivas

### 2026-02-23 22:13-23:00 UTC ✅
**Trigger:** Auto-activación (24 min inactividad)
**Duración:** 47 minutos
**Completadas:** 4 heartbeat checks → sistema estable

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
| WORKFLOW_ORCHESTRATION.md | `system/` |
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
