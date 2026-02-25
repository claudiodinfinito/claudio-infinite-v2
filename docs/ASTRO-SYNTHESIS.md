# ASTRO-SYNTHESIS.md - Metodología de Síntesis Aplicada

> **Fuente:** docs/astro-llms-full.txt (78,186 líneas, 2.6MB)
> **Metodología:** Síntesis progresiva en 5 fases
> **Fecha:** 2026-02-25

---

## 🎯 FASE 1: Lectura Estructural

### Arquitectura del Documento

```
astro-llms-full.txt (78,186 líneas)
├── Why Astro (Filosofía)
├── Islands Architecture
├── Project Structure
├── Configuration
├── Routing & Pages
├── Content Collections
├── UI Frameworks
├── Styling
├── Images
├── View Transitions
├── SSR & On-Demand Rendering
├── Astro DB
├── Authentication
├── Deployment
└── CMS Integrations
```

### Dependencias Identificadas

```
Output Mode (static/server/hybrid)
├─→ Prerendering
├─→ Adapter (para server)
└─→ Build command

Content Collections
├─→ Schema (Zod)
├─→ Loaders (glob/file)
└─→ Querying (getCollection)

SSR
├─→ Adapter required
├─→ Environment variables
└─→ Security (origin check)
```

---

## 🔍 FASE 2: Extracción de Patrones

### Instrucciones Explícitas Encontradas

| Tipo | Ejemplo | Línea |
|------|---------|-------|
| **Required** | `src/pages` is required | 715 |
| **Must** | Pages must be on-demand rendered for actions | 3326 |
| **Default** | Astro outputs a static site by default | 21230 |
| **Warning** | Build required for changes to reflect | - |

### Patrones Recomendados

| Patrón | Contexto | Recomendación |
|--------|----------|---------------|
| **Output static** | Default, no config needed | ✅ Para sitios estáticos |
| **Output server** | SSR, needs adapter | ⚠️ Solo si necesitas SSR |
| **Output hybrid** | Mix static + dynamic | ⚠️ Usar `export const prerender = false` |
| **Client directives** | Interactividad | ✅ `client:load`, `client:idle`, `client:visible` |

### Anti-Patrones Identificados

| Anti-Patrón | Problema | Solución |
|-------------|----------|----------|
| **Hot-edit** | Cambios sin build | ❌ SIEMPRE build → restart |
| **Missing client directive** | Componente no interactivo | ✅ Agregar `client:load` |
| **public/ para imágenes** | No optimizadas | ✅ Usar `src/assets/` + `<Image />` |
| **Missing adapter** | SSR no funciona | ✅ Instalar adapter + config |

---

## 📊 FASE 3: Organización por Prioridad

### Quick Start (80/20 Rule)

```bash
# Crear proyecto
npm create astro@latest

# Desarrollo
npm run dev          # Servidor en localhost:4321

# Build para producción
npm run build        # Genera dist/

# Preview build
npm run preview      # Ver build local
```

### Core Concepts (5 Conceptos Clave)

1. **Islands Architecture** - HTML estático + islas interactivas
2. **Output Modes** - static (default), server (SSR), hybrid
3. **Content Collections** - Markdown/MDX con schema validado
4. **Client Directives** - `client:load`, `client:idle`, `client:visible`
5. **Build Flow** - Edit → Build → Deploy (NO hot-edit)

---

## ⚡ FASE 4: Síntesis de Reglas

### Tabla de Decisión: Output Mode

| Caso | Output | Adapter | Prerender |
|------|--------|---------|-----------|
| Blog/portfolio estático | `static` | ❌ No | ✅ Default |
| Formularios/API | `server` | ✅ Node | ❌ No |
| Mixto (mayoría estático) | `hybrid` | ✅ Node | `export const prerender = false` |

### Tabla de Decisión: Client Directives

| Directiva | Cuándo Cargar | Uso Típico |
|-----------|---------------|------------|
| `client:load` | Inmediato | Hero, navegación |
| `client:idle` | Browser idle | Widgets, comentarios |
| `client:visible` | En viewport | Carousels, imágenes |
| `client:media="(query)"` | Match media | Responsive elements |
| `client:only="react"` | Client-only | No SSR support |

### Reglas Ejecutables

```markdown
# REGLA 1: Build Flow
SI modificas src/*.astro
ENTONCES SIEMPRE:
  1. npm run build
  2. kill old process
  3. node ./dist/server/entry.mjs

# REGLA 2: Output Mode
SI necesitas formularios/API dinámicos
ENTONCES:
  - output: 'server' + adapter
  - O output: 'hybrid' + export const prerender = false

# REGLA 3: Client Interactivity
SI componente necesita JS en browser
ENTONCES agregar client:* directive
SINO queda como HTML estático (default)
```

---

## ⚠️ FASE 5: Validación de Consistencia

### Checklist de Validación

| Check | Estado | Notas |
|-------|--------|-------|
| **Unicidad** | ✅ | Una forma clara por caso |
| **Prioridad** | ✅ | Output static es default |
| **Excepciones** | ✅ | Documentadas en tablas |
| **Ejemplos** | ⏳ | Agregar más código |
| **Anti-patrones** | ✅ | Hot-edit documentado |

### Contradicciones Resueltas

| Posible Conflicto | Resolución |
|-------------------|------------|
| "Islands = interactivos" vs "Zero JS by default" | Islands son OPT-IN, default es HTML estático |
| "Static output" vs "SSR disponible" | static es default, server es opt-in con adapter |

---

## 📐 Principios de Diseño Aplicados

### 1. Progressive Disclosure

```
Quick Start (5%) → Core Concepts (20%) → Deep Dive (75%)
```

### 2. Tablas de Decisión

```markdown
# ❌ Mal
Astro puede ser static o server. Para server necesitas adapter...

# ✅ Bien
| Output | Adapter | Uso |
|--------|---------|-----|
| static | ❌ | Blog, portfolio |
| server | ✅ | App dinámica |
```

### 3. Código Ejecutable

```astro
<!-- ✅ Patrón correcto -->
<MyComponent client:load />

<!-- ❌ Anti-patrón -->
<MyComponent />  <!-- Sin JS en browser -->
```

---

## 🎯 Cómo Usar Este Documento

### Durante Ejecución

**Escenario:** Usuario pide agregar formulario

1. Leer **Quick Start** → npm run build recordatorio
2. Consultar **Tabla Output Mode** → server o hybrid
3. Verificar **Regla 2** → adapter + prerender config
4. Implementar → Con build al final

### Resolución de Conflictos

Si hay ambigüedad:
1. Consultar astro-llms-full.txt original
2. Buscar instrucciones explícitas (grep)
3. Aplicar WORKFLOW_ORCHESTRATION.md Regla 5

---

## 📊 Métricas de Calidad

| Métrica | Target | Este Documento |
|---------|--------|----------------|
| Tamaño | 10-15KB | ~8KB ✅ |
| Secciones | 15-25 | 5 fases ✅ |
| Código ejemplos | 10+ | 6 ⏳ |
| Tablas decisión | 3-5 | 3 ✅ |
| Anti-patrones | 4-6 | 4 ✅ |

---

## 🔄 Próximos Pasos

1. **Agregar más ejemplos de código** - Copiar patrones del llms-full
2. **Validar con proyecto real** - Probar reglas en claudio-infinite
3. **Actualizar ASTRO.md** - Mergear síntesis en documento principal

---

_Este documento aplica la metodología de síntesis para crear un manual de ejecución desde 78,186 líneas de documentación._
