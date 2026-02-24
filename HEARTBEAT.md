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
| **Último Mensaje Usuario** | 2026-02-24 21:33 UTC |
| **Último Message ID** | ~5202 |
| **Inactividad Actual** | 0 min (usuario activo) |
| **Activación** | 2026-02-24 19:11 UTC (confirmado por usuario) |
| **Proyecto activo** | Client 001: Spa Kommo CRM Setup (Feb 24-27) |
| **Server** | ✅ Stable (PID running) |
| **Clients** | ✅ 1 Active, 1 Prospect |
| **Pages** | ✅ 10 pages total (Home, Store, Blog, About, Projects, FAQs, Contact, Tours Demo, Landing Template) |
| **Billing** | Client 001: $4,000 MXN (50% depositado) |
| **Pipeline** | Prospect Tours: $3,000 MXN/mes potential |
| **Up-sale** | Client 001: Google Ads $1,500 MXN/mes |
| **Learning** | ✅ Stripe mastery complete (STRIPE.md created) |
| **Tasks** | ✅ 15/15 completed (all phases done) |
| **Learning** | ✅ Stripe mastery complete (STRIPE.md created) |

---

## 📋 Workflow Adherence Check (20:02 UTC)

**Check 1: Pending tasks in todo.md?**
- ⚠️ **YES** — 12 pending tasks across 4 phases:
  - Phase 1 (Content & SEO): 4 tasks
  - Phase 2 (New Pages): 3 tasks
  - Phase 3 (Performance): 3 tasks
  - Phase 4 (Features): 3 tasks

**Check 2: Recent corrections for lessons.md?**
- ✅ No new corrections — 6 lessons documented, last: Zombie Process

**Check 3: Following the 6 rules?**
| Rule | Status |
|------|--------|
| 1. Plan Node Default | ✅ todo.md has phases defined |
| 2. Subagent Strategy | ✅ Enabled (GLM5 unlimited) |
| 3. Self-Improvement Loop | ✅ lessons.md maintained |
| 4. Verification Before Done | ⏳ Pending tasks to verify |
| 5. Demand Elegance | ✅ Docs consulted first |
| 6. Autonomous Bug Fixing | ✅ Zombies fixed |

**Check 4: HEARTBEAT.md updated?**
- ✅ This update

**Action Required:** Continue autonomous mode work on Phase 1 tasks

---

## 🧠 Lógica de Activación Automática

### Algoritmo (ejecutar en cada heartbeat)

```
0. LEER WORKFLOW_ORCHESTRATION.md (verificar adherencia a las 6 reglas)
1. LEER estado actual (NO MODIFICAR)
2. CALCULAR inactividad = ahora - último_mensaje_usuario (mentalmente)
3. SI inactividad >= 20 min Y modo == Normal:
   → ACTIVAR modo autónomo indefinido
   → ACTUALIZAR HEARTBEAT.md (solo en cambio de estado)
   → EJECUTAR tareas autónomas
4. SI modo == Autónomo Y usuario envió mensaje:
   → DESACTIVAR modo autónomo
   → ACTUALIZAR HEARTBEAT.md (solo en cambio de estado)
   → REPORTAR resumen
5. SI modo == Autónomo:
   → CONTINUAR ejecutando tareas
6. SI modo == Normal:
   → HEARTBEAT_OK (sin modificar archivo)
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

## 🔴 MODO AUTÓNOMO

**Desde:** 2026-02-24 19:11 UTC
**Trigger:** Confirmado por usuario (mensaje 5191)
**Sesión normal previa:** 18:58-19:11 UTC (13 min, terminada por inactividad)

---

## 📋 Historial de Sesiones Autónomas

### 2026-02-24 19:11-... UTC 🔄
**Trigger:** Confirmado por usuario
**Duración:** En progreso...
**Completadas:**
- HEARTBEAT.md actualizado
- Zombie processes eliminados (múltiples)
- Server estabilizado (PID 2552796, 19:33 UTC)
- **Stripe Store implementado** (store page, checkout API, success page)
- **2 blog posts creados** (Stripe integration, Astro DB)
- **SEO agregado** (sitemap.xml, robots.txt)
- **About page creada** (personal info, workflow, learning progress)
- **Projects page creada** (portfolio, skills)
- **Git commits:** b1af7c0, 06e20d8, d7d6e48

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

### 2026-02-24 13:20-15:36 UTC ✅
**Trigger:** Auto-activación (63 min inactividad)
**Duración:** 2h 16min (indefinida, terminada por usuario)
**Exit:** Usuario envió mensaje (message_id 5145)
**Completadas:**
- WORKFLOW_ORCHESTRATION.md creado con 6 reglas
- Cron job para workflow adherence (cada 4h)
- Astro Actions bug fix (result.data.name)
- lessons.md actualizado 3 veces
- Zombie process diagnosticado y eliminado
- Workspace cleanup completo (BOOTSTRAP.md deleted, WORKFLOW_AUTO.md archived)
- Todos los archivos actualizados
- Git commits: a1d33d6, b589788, 4a9223b, 544f7fe, 9fc84f4
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
