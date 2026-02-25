# INDEX.md - Navegación Rápida

_Estructura reorganizada: 2026-02-25_

---

## 📁 Estructura del Workspace

```
/root/.openclaw/workspace/
├── core/                    # Archivos fundamentales del agente
│   ├── AGENTS.md           # Reglas de operación
│   ├── SOUL.md             # Identidad y personalidad
│   ├── USER.md             # Perfil del usuario (Gamble)
│   └── IDENTITY.md         # Datos de identidad
├── docs/                    # Documentación técnica
│   ├── ASTRO.md            # Astro framework (38KB, 26 secciones)
│   ├── ASTRO-SYNTHESIS.md  # Metodología de síntesis
│   ├── STRIPE.md           # Stripe integration (12KB, 20+ secciones)
│   ├── KOMMO.md            # Kommo CRM reference (9KB)
│   ├── CONFIG_REFERENCE.md # OpenClaw config (15KB)
│   └── astro-llms-full.txt # Documentación Astro completa (2.6MB)
├── business/               # Gestión de clientes y proyectos
│   ├── CLIENTS.md          # Clientes activos y pipeline
│   └── KANBAN.md           # Tablero de proyectos
├── system/                  # Sistema y orquestación
│   ├── HEARTBEAT.md        # Estado y modo autónomo
│   ├── WORKFLOW_ORCHESTRATION.md  # Reglas de workflow
│   └── TOOLS.md            # Notas técnicas del servidor
├── memory/                  # Memoria del agente
│   ├── MEMORY.md           # Memoria a largo plazo
│   └── YYYY-MM-DD.md       # Logs diarios
├── tasks/                   # Gestión de tareas
│   ├── todo.md             # Tareas pendientes
│   ├── lessons.md          # Lecciones aprendidas
│   └── skills-overview.md  # Skills disponibles
├── lessons/                 # Lecciones detalladas
│   └── astro-critical-gotcha.md
└── archive/                 # Archivos obsoletos
```

---

## 🔍 Quick Reference

### Archivos más consultados

| Propósito | Archivo | Ubicación |
|-----------|---------|-----------|
| ¿Quién soy? | SOUL.md | core/ |
| ¿Qué hago? | AGENTS.md | core/ |
| ¿Estado actual? | HEARTBEAT.md | system/ |
| ¿Qué aprendí? | MEMORY.md | ./ |
| ¿Clientes? | CLIENTS.md | business/ |
| ¿Tareas? | todo.md | tasks/ |
| ¿Errores? | lessons.md | tasks/ |

---

## 📊 Proyectos Activos

| Proyecto | Path | Status |
|----------|------|--------|
| **claudio-infinite** | `/root/projects/claudio-infinite/` | ✅ Running |
| **revops-portal** | `/root/revops-portal/` | 🚧 MVP |

---

## ⚠️ Archivos Sensibles

| Archivo | Ubicación | Permisos |
|---------|-----------|----------|
| openclaw.json | `/root/.openclaw/openclaw.json` | Config del sistema |
| claudio-docs | `/root/claudio-docs/` | Predecesor - pedir permiso |
| /captain/ | `/captain/` | OFF-LIMITS (CapRover) |

---

## 🔧 Comandos Útiles

```bash
# Ver estado del sistema
cat system/HEARTBEAT.md | head -30

# Buscar en memoria
grep -r "término" memory/

# Ver clientes
cat business/CLIENTS.md

# Ver tareas
cat tasks/todo.md
```

---

_Last updated: 2026-02-25_
