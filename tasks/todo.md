# Todo.md - Task Tracker

## Active Tasks

### 2026-02-25 - Limpiar archivos duplicados y predecesor
**Contexto:** Según WORKFLOW_ORCHESTRATION.md, debo mantener el entorno limpio. Hay archivos duplicados y un proyecto predecesor.

#### Plan (WORKFLOW ORCHESTRATION - Regla 1)

**Fase 1: Análisis completado**
- [x] Identificar archivos duplicados en workspace
- [x] Identificar archivos del predecesor
- [x] Identificar archivos huérfanos

**Fase 2: Confirmación requerida (NO ejecutar sin aprobación)**

| # | Ubicación | Tipo | Tamaño | Acción propuesta |
|---|-----------|------|--------|------------------|
| 1 | `docs/stripe-*.md` (13 archivos) | Duplicados | ~600KB | Eliminar (ya existe STRIPE.md consolidado) |
| 2 | `/root/claudio-docs/` | Predecesor | ~10MB | ¿Eliminar proyecto completo? |
| 3 | `docs/llms-full.txt` | ? | 2.6MB | ¿Mantener o eliminar? |
| 4 | `docs/stripe-index.txt` | ? | 89KB | ¿Mantener o eliminar? |

**Fase 3: Ejecución (después de confirmación)**
- [ ] Eliminar archivos aprobados
- [ ] Commit con mensaje descriptivo
- [ ] Verificar que nada se rompió

---

## Pendiente de Confirmación

**⚠️ NO EJECUTAR HASTA QUE EL USUARIO CONFIRME CADA ELEMENTO**

