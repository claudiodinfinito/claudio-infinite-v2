# Lessons Learned

_Corrections and patterns to prevent repeat mistakes._

---

## 2026-02-23 - Subagent Strategy Correction

### The Mistake
WORKFLOW_AUTO.md had subagents marked as "DISABLED — Token burn"

### Why It Was Wrong
- GLM5 has **unlimited tokens** — no marginal cost
- Subagents enable **parallelism** while main stays responsive
- The "token burn" argument applies to paid APIs, not GLM5

### The Correct Approach
- Use subagents **liberally**
- Offload research, exploration, parallel analysis
- Main = Dispatcher (fast response)
- Subagents = Workers (deep work in parallel)

### The Pattern
> When evaluating tool/resource usage, consider the **specific constraints of the environment** — not generic heuristics. GLM5 ≠ typical paid LLM.

---

## 2026-02-24 - LLM Files vs Web Browsing

### The Mistake
Usar `web_fetch` para documentación que tiene archivos LLM dedicados.

### Why It Was Wrong
- `web_fetch` trunca a 50KB por default
- `llms-full.txt` de Astro tiene 2.6MB → perdí 95% del contenido
- Múltiples llamadas web vs un solo download

### The Correct Approach
```bash
# Descargar archivo LLM completo
curl -o docs/llms-full.txt https://docs.astro.build/llms-full.txt

# Leer paginado con read()
read(path, limit=4000, offset=X)
```

### The Pattern
> **Always check for LLM-optimized files before web browsing.**
> 
> URLs comunes:
> - `https://docs.X.com/llms-full.txt`
> - `https://docs.X.com/llms.txt` (index)
> 
> Ventajas: 100% contenido, cero HTML noise, una sola llamada.

---

## 2026-02-24 - Hybrid Rendering for Forms

### The Mistake
Intentar usar `Astro.request.formData()` en static build.

### Why It Was Wrong
- Static pages = HTML generado al build, no hay servidor
- `Astro.request`, `Astro.clientAddress` solo existen en SSR
- Formularios POST necesitan servidor para procesar

### The Correct Approach
```javascript
// astro.config.mjs
import node from '@astrojs/node';
export default defineConfig({
  output: 'hybrid',  // Static por defecto, SSR donde se necesite
  adapter: node()
});

// En la página que procesa forms:
export const prerender = false;  // Esta página es SSR
```

### The Pattern
> **Forms that process POST = Hybrid or SSR mode.**
> 
> - Static: Solo para forms que usan API externa
> - Hybrid: La mayoría de casos (static + forms)
> - SSR: Apps completamente dinámicas

---

## 2026-02-24 - Quickfixes vs Official Documentation

### The Mistake
Hacer quickfixes sin consultar documentación oficial. Usuario tuvo que recordarme: "El troubleshooting lo deberías de hacer viendo el llms-full.txt de astro no inventando"

### Why It Was Wrong
- Intenté múltiples soluciones sin entender el problema
- Perdí tiempo en "trial and error" en lugar de consultar la fuente
- Violé WORKFLOW_ORCHESTRATION.md Regla 5: "Consult official documentation first"

### The Correct Approach
```markdown
**Workflow para bugs:**
1. Leer error del log
2. Consultar documentación oficial (llms-full.txt)
3. Entender el patrón correcto
4. Implementar solución elegante
```

### The Pattern
> **Documentation First, Implementation Second.**
> 
> - No inventar soluciones
> - Buscar en llms-full.txt con grep
> - Entender el patrón oficial antes de codear
> - Si la documentación no tiene la respuesta, entonces experimentar

---

## 2026-02-24 - Astro Actions Result Pattern

### The Mistake
```astro
result.data.data.name  // ❌ Anidado incorrectamente
```

### Why It Was Wrong
- Assumí que el handler retornaba `{ data: { name } }`
- No leí el ejemplo de la documentación oficial
- El handler retorna el objeto directamente, no anidado

### The Correct Approach
```astro
// actions/index.ts
handler: async (input) => {
  return { id, name, email };  // ← Retorna directamente
}

// contact.astro
const result = Astro.getActionResult(actions.contact);
result.data.name  // ✅ Correcto - data es el retorno del handler
```

### The Pattern
> **Leer ejemplos de la documentación oficial antes de asumir estructuras.**
> 
> Patrón Astro Actions:
> - `result.data` = lo que retorna el handler
> - `result.error` = errores de validación o ActionError
> - No hay doble anidación

---

## 2026-02-24 - Zombie Process Causing Server Crashes

### The Mistake
Servidor crasheaba cada ~30 minutos. Assumí que era el VPS o el código.

### Why It Was Wrong
- No verifiqué procesos existentes antes de iniciar nuevo servidor
- Había un proceso zombie de **4 días** (PID 1997754, iniciado Feb 20)
- Múltiples procesos node causaban conflictos de puerto/recursos

### The Correct Approach
```bash
# Antes de iniciar servidor:
ps aux | grep "node.*entry.mjs"
lsof -i:4321

# Si hay proceso antiguo:
kill -9 <old_pid>

# Luego iniciar:
node ./dist/server/entry.mjs
```

### The Pattern
> **Always check for zombie processes before starting a new server instance.**
> 
> Symptoms:
> - Server crashes after some time
> - Multiple processes on same port
> - Process started days/weeks ago still running
> 
> Fix: Kill old processes, then start fresh.

---

## 2026-02-24 - HEARTBEAT.md Race Condition

### The Mistake
`edit` tool falla con "Could not find exact text" en HEARTBEAT.md, incluso después de leerlo.

### Why It Was Wrong
- **Heartbeat corre cada 10 minutos** → modifica HEARTBEAT.md
- **Delay entre read y edit** → archivo cambia mientras tanto
- **edit requiere match exacto** → cualquier cambio causa fail

### The Correct Approach
```markdown
# ❌ Mal
read(HEARTBEAT.md)
read(otros_archivos)  # ← delay
edit(HEARTBEAT.md)    # ← race condition

# ✅ Bien
read(HEARTBEAT.md)
edit(HEARTBEAT.md)    # ← inmediato, funciona
```

### The Pattern
> **Para archivos actualizados frecuentemente (HEARTBEAT.md, logs):**
> - Leer → editar inmediatamente (sin operaciones intermedias)
> - O usar `write` en lugar de `edit`
> - Aceptar que el sistema puede modificar estos archivos

---

## 2026-02-25 - Astro: Static by Design

### The Mistake
Intenté editar `src/pages/index.astro` esperando que los cambios se reflejaran en el servidor corriendo. Recibí error "Could not find the exact text".

### Why It Was Wrong
Astro es **estático por diseño**, no interpretado. El servidor corre desde `dist/`, no desde `src/`. Cualquier cambio requiere rebuild.

### The Correct Approach
```bash
# Flujo correcto para cambios en Astro:
# 1. Editar src/*.astro
# 2. npm run build
# 3. kill old process && node ./dist/server/entry.mjs
```

### The Pattern
> **"Astro es como compilar C: edit → compile → run"**
> 
> No es interpretado como Python/PHP. Es compilado.
> - `src/` = código fuente
> - `dist/` = compilado (NO modificar directamente)
> - Cambios siempre requieren build + restart

---

## 2026-02-25 - File Structure: OpenClaw Loads from ROOT

### The Mistake
Creé carpetas (`core/`, moví archivos a `system/`) sin entender que OpenClaw carga automáticamente del **root**.

### Why It Was Wrong
- OpenClaw tiene rutas hardcodeadas: `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, `HEARTBEAT.md`, `TOOLS.md`, `MEMORY.md` → todas del **root**
- Moverlos a carpetas rompe la carga automática
- Inventé `core/` sin que nadie me dijera

### The Correct Approach
```
workspace/
├── AGENTS.md      # Root - cargado por OpenClaw
├── SOUL.md        # Root - cargado por OpenClaw
├── USER.md        # Root - cargado por OpenClaw
├── IDENTITY.md    # Root - cargado por OpenClaw
├── HEARTBEAT.md   # Root - cargado por OpenClaw
├── TOOLS.md       # Root - cargado por OpenClaw
├── MEMORY.md      # Root - cargado por OpenClaw
├── INDEX.md       # Root - navegación
│
├── system/        # Solo WORKFLOW_ORCHESTRATION.md
├── docs/          # Documentación técnica
├── business/      # CLIENTS.md, KANBAN.md
├── tasks/         # todo.md, lessons.md
├── lessons/       # Lecciones detalladas
├── memory/        # Logs diarios
└── archive/       # Archivos obsoletos
```

### The Pattern
> **OpenClaw carga del ROOT. No mover archivos que el sistema lee automáticamente.**
> 
> Antes de reorganizar: verificar qué carga el sistema y qué no.

---

## Template for Future Lessons
