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
| **Último Mensaje Usuario** | 2026-02-24 15:00 UTC |
| **Último Message ID** | 5130 |
| **Inactividad Actual** | 6 min (conversación activa) |
| **Proyecto activo** | claudio-infinite ✅ COMPLETE + Astro DB + Actions |
| **Server** | ✅ Stable (zombie process killed, PID 2527679) |
| **DB** | ✅ SQLite (.astro/db.sqlite) |
| **Workflow** | ✅ WORKFLOW_ORCHESTRATION.md adherencia verificada |
| **Lessons** | ✅ Zombie process pattern documented |

---

## 🧠 Lógica de Activación Automática

### Algoritmo (ejecutar en cada heartbeat)

```
0. LEER WORKFLOW_ORCHESTRATION.md (verificar adherencia a las 6 reglas)
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

## ⚪ MODO NORMAL

**Desde:** 2026-02-23 23:00 UTC
**Trigger:** Usuario envió mensaje
**Sesión autónoma previa:** 22:13-23:00 UTC (47 min, auto-activada, terminada por usuario)

---

## 📋 Historial de Sesiones Autónomas

### 2026-02-24 13:20-15:00 UTC ✅
**Trigger:** Auto-activación (63 min inactividad)
**Duración:** 1h 40min (indefinida, terminada por usuario)
**Exit:** Usuario envió mensaje (message_id 5130)
**Completadas:**
- WORKFLOW_ORCHESTRATION.md creado con 6 reglas
- Cron job para workflow adherence (cada 4h)
- Astro Actions bug fix (result.data.name)
- lessons.md actualizado 3 veces
- Zombie process diagnosticado y eliminado
- Git commits: a1d33d6, b589788, 4a9223b, 544f7fe
- **Estado:** ✅ COMPLETADO

### 2026-02-24 04:48-08:05 UTC ✅
**Trigger:** Auto-activación (36 min inactividad)
**Duración:** 3h 17min (indefinida, terminada por usuario)
**Exit:** Usuario envió mensaje (message_id 5074)
**Completadas:**
- FAQs page creada con tabs + accordion CSS-only
- CSRF error diagnosticado y arreglado
- API endpoint `/api/contact` creado
- Server reiniciado múltiples veces
- Formulario verificado funcionando (mensaje recibido de Gamble)
- **Estado:** ✅ COMPLETADO

### 2026-02-24 00:49-01:10 UTC ✅
**Trigger:** Auto-activación (26 min inactividad)
**Duración:** 21 minutos (indefinida, terminando por completar tarea)
**Tarea:** Explorar documentación de Astro y crear ASTRO.md
**Completadas:** 
- 4 fases de exploración (9 archivos descargados parcialmente)
- ASTRO.md creado: ~30KB, 25 secciones comprehensivas
- Git commit: ea4beb8
- Fuentes: llms-small.txt, api-reference.txt, how-to-recipes.txt, deployment-guides.txt, cms-guides.txt, backend-services.txt, migration-guides.txt, additional-guides.txt
- **Nota:** Documentos truncados, no lectura completa

### 2026-02-24 (Post-corrección) ✅
**Tarea:** Descargar documentación completa y crear plan de aprendizaje
**Completadas:**
- Descargado llms-full.txt completo (2.6MB, 78,187 líneas)
- **Leído 100% del documento** (78,187 líneas procesadas)
- Creado tasks/astro-learning-prompt.md con 5 fases
- Actualizado HEARTBEAT.md con Astro como Priority 2 learning
- **ASTRO.md actualizado** con Content Collections, SSR, Astro DB comprehensivos
- **26 secciones** totales (~45KB)
- Git commits: 83701f8 + actualizaciones posteriores
- **Estado:** ✅ COMPLETADO

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

**Prioridad 0 — Workflow Adherence (cada heartbeat):**
- [ ] Leer WORKFLOW_ORCHESTRATION.md
- [ ] Verificar adherencia a las 6 reglas
- [ ] Si hay desviación → re-planear

**Prioridad 1 — Sistema:**
- [ ] Git status → commit si hay cambios
- [ ] Verificar WORKFLOW_ORCHESTRATION.md alignment
- [ ] Actualizar HEARTBEAT.md estado

**Prioridad 2 — Aprendizaje Continuo:**
- [x] **Astro Deep Dive** → COMPLETADO ✅ (llms-full.txt 100% leído)
- [ ] Explorar otros frameworks (Svelte, Qwik, etc.)
- [ ] Actualizar ASTRO.md según necesidades

**Prioridad 3 — Mantenimiento:**
- [ ] MEMORY.md updates (append only)
- [ ] Limpiar logs antiguos (>7 días)
- [ ] Verificar documentación

**Prioridad 4 — Exploración:**
- [ ] Revisar projects/
- [ ] Status de repos externos
- [ ] Documentar observaciones

---

_Uso:_
_- `activa modo autonomo por [X] minutos` → temporal_
_- `activa modo autonomo` → indefinido_
_- Automático: 20 min inactividad → activación indefinida_
