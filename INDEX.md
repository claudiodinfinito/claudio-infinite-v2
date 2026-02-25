# INDEX.md - Navegación Rápida

_Estructura: 2026-02-25_

---

## 📁 Estructura del Workspace

```
/root/.openclaw/workspace/
├── core/                    # Archivos fundamentales del agente
│   ├── AGENTS.md           # Reglas de operación
│   ├── SOUL.md             # Identidad y personalidad
│   ├── USER.md             # Perfil del usuario (Gamble)
│   └── IDENTITY.md         # Datos de identidad
│
├── system/                  # Sistema y orquestación
│   ├── HEARTBEAT.md        # Estado y modo autónomo
│   ├── WORKFLOW_ORCHESTRATION.md  # 6 reglas de workflow
│   └── TOOLS.md            # Notas técnicas del servidor
│
├── docs/                    # Documentación técnica
│   ├── ASTRO.md            # Astro framework (38KB, 26 secciones)
│   ├── ASTRO-SYNTHESIS.md  # Metodología de síntesis
│   ├── STRIPE.md           # Stripe integration (12KB)
│   ├── KOMMO.md            # Kommo CRM reference (9KB)
│   ├── CONFIG_REFERENCE.md # OpenClaw config (15KB)
│   └── astro-llms-full.txt # Docs Astro completas (2.6MB)
│
├── business/               # Gestión de clientes
│   ├── CLIENTS.md          # Clientes activos y pipeline
│   └── KANBAN.md           # Tablero de proyectos
│
├── tasks/                   # Gestión de tareas
│   ├── todo.md             # Tareas pendientes
│   └── lessons.md          # Lecciones aprendidas
│
├── lessons/                 # Lecciones detalladas
│   └── astro-critical-gotcha.md
│
├── memory/                  # Memoria diaria
│   └── YYYY-MM-DD.md       # Logs diarios
│
├── archive/                 # Archivos obsoletos
│
├── MEMORY.md               # Memoria a largo plazo
└── INDEX.md                # Este archivo
```

---

## 🔍 Quick Reference

| Propósito | Archivo | Ubicación |
|-----------|---------|-----------|
| ¿Quién soy? | SOUL.md | `core/` |
| ¿Qué hago? | AGENTS.md | `core/` |
| ¿Estado actual? | HEARTBEAT.md | `system/` |
| ¿Qué aprendí? | MEMORY.md | `./` (root) |
| ¿Clientes? | CLIENTS.md | `business/` |
| ¿Tareas? | todo.md | `tasks/` |
| ¿Errores? | lessons.md | `tasks/` |
| ¿Workflow? | WORKFLOW_ORCHESTRATION.md | `system/` |

---

## 📊 Proyectos Activos

| Proyecto | Path | Status |
|----------|------|--------|
| **claudio-infinite** | `/root/projects/claudio-infinite/` | ✅ Running |
| **revops-portal** | `/root/revops-portal/` | 🚧 MVP |

---

## ⚠️ Archivos Sensibles

| Archivo | Ubicación | Nota |
|---------|-----------|------|
| openclaw.json | `/root/.openclaw/openclaw.json` | Config del sistema |
| claudio-docs | `/root/claudio-docs/` | Predecesor - pedir permiso |
| /captain/ | `/captain/` | OFF-LIMITS (CapRover) |

---

_Last updated: 2026-02-25_
