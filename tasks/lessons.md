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

## Template for Future Lessons

```markdown
## YYYY-MM-DD - [Lesson Title]

### The Mistake
[What went wrong]

### Why It Was Wrong
[Root cause analysis]

### The Correct Approach
[What should have been done]

### The Pattern
[Generalizable rule to prevent recurrence]
```
