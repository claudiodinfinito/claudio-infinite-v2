# DIAGNÓSTICO: Error de Edit Tool en Archivos Estáticos

## 🔍 ANÁLISIS DEL PROBLEMA

**Error recurrente:**
```
⚠️ 📝 Edit: in ~/.openclaw/workspace/ASTRO.md failed: 
Could not find the exact text in /root/.openclaw/workspace/ASTRO.md. 
The old text must match exactly including all whitespace and newlines.
```

---

## 👨‍⚕️ ÁNGULO 1: DIAGNÓSTICO MÉDICO (Doctor)

### Síntomas
- Error repetitivo al usar herramienta `edit`
- El patrón se repite en múltiples archivos
- Archivos son estáticos (no cambian dinámicamente)

### Diagnóstico Clínico
**Enfermedad:** "Edit Tool Mismatch Syndrome" (ETMS)

**Causa raíz:** El agente lee un archivo, pasa tiempo procesando, y cuando intenta editar, el contexto en memoria ya no coincide con la realidad del archivo.

**Factores de riesgo:**
1. Context window compaction (el archivo se modifica durante el procesamiento)
2. Lectura incompleta (limit/offset mal usados)
3. Whitespace invisible (tabs vs spaces, CRLF vs LF)
4. Archivos modificados entre read y edit

### Tratamiento Recomendado
```markdown
1. Siempre leer el archivo COMPLETO antes de editar (sin limit/offset)
2. Copiar EXACTAMENTE el texto del archivo (no inventar)
3. Usar `write` en lugar de `edit` para archivos completos
4. Verificar con `cat` o `grep` antes de editar
```

---

## 💻 ÁNGULO 2: EXPERTO EN INFORMÁTICA (25+ años)

### Análisis Técnico

**Problema:** Race condition entre read y edit en un sistema single-threaded aparente.

**Causas identificadas:**

1. **Context Compaction**: El sistema compacta el contexto durante operaciones largas, perdiendo información del archivo leído.

2. **Whitespace Normalization**: El LLM puede normalizar whitespace (multiple spaces → single space, tabs → spaces) al mostrar el contenido.

3. **Line Ending Issues**: El archivo puede tener CRLF (`\r\n`) pero el contexto muestra solo LF (`\n`).

4. **Encoding Issues**: Caracteres invisibles o encoding diferente.

### Soluciones Técnicas

```bash
# Verificar encoding y line endings
file /root/.openclaw/workspace/ASTRO.md
dos2unix -i /root/.openclaw/workspace/ASTRO.md

# Verificar whitespace exacto
cat -A /root/.openclaw/workspace/ASTRO.md | head -20

# Usar hexdump para ver caracteres invisibles
hexdump -C /root/.openclaw/workspace/ASTRO.md | head -20
```

---

## 🧑‍💻 ÁNGULO 3: EXPERTO EN PROGRAMACIÓN (25+ años)

### Análisis de Código

**El problema:** La herramienta `edit` requiere coincidencia EXACTA, incluyendo:
- Espacios en blanco
- Tabs vs spaces
- Saltos de línea (\n vs \r\n)
- Líneas vacías

**Patrón de error común:**

```python
# Lo que el agente VE en contexto (después de compaction):
"""
## Section

Content here.
"""

# Lo que el archivo REALMENTE tiene:
"""
## Section

Content here.

"""
# ↑ Nota: línea vacía al final que se perdió
```

### Debugging Approach

```bash
# 1. Verificar contenido exacto
cat -n /path/to/file.md | grep -A5 -B5 "search_term"

# 2. Contar líneas exactas
wc -l /path/to/file.md

# 3. Verificar si hay trailing whitespace
sed -n 'l' /path/to/file.md | tail -5

# 4. Usar write en lugar de edit para archivos críticos
```

### Solución de Código

```typescript
// En lugar de:
edit(path, oldText, newText)

// Usar:
const content = read(path)
const newContent = content.replace(oldPattern, newPattern)
write(path, newContent)
```

---

## 🤖 ÁNGULO 4: EXPERTO EN IA/AGENTES (25+ años)

### Análisis del Agente

**Problema fundamental:** El agente opera en un ciclo de "read → think → act" donde el paso "think" puede ser largo y el contexto puede cambiar.

**Factores del modelo:**

1. **Token Limit**: El contexto se compacta, perdiendo detalles del archivo leído.

2. **Hallucination**: El modelo puede "recordar" el archivo de manera incorrecta.

3. **Pattern Matching**: El modelo busca patrones, no texto exacto.

**Diferencia entre LLM y herramienta:**
- LLM: "Encuentra algo como esto"
- Tool `edit`: "Encuentra EXACTAMENTE esto, byte por byte"

### Soluciones de Agente

1. **Read-Edit Pattern Inmediato**:
```
read(file) → edit(file) inmediatamente
```

2. **Write Pattern para archivos críticos**:
```
read(file) → write(file, newContent)
```

3. **Verification Loop**:
```
read(file) → grep/verify → edit(file)
```

4. **Context Preservation**:
```
Guardar en variable el contenido exacto
Usar esa variable para el edit
```

---

## 🏗️ ÁNGULO 5: ARQUITECTO DE SISTEMAS (25+ años)

### Análisis de Sistema

**Problema de arquitectura:** El sistema tiene un desajuste entre las expectativas del agente (inteligente, flexible) y las herramientas (determinísticas, estrictas).

**Capas del problema:**

```
┌─────────────────────────────────────┐
│  Agent (LLM)                        │  ← Flexible, approximate
│  "Find something like this"         │
├─────────────────────────────────────┤
│  Context Window                     │  ← Limited, compacted
│  [compacted context]                │
├─────────────────────────────────────┤
│  Edit Tool                          │  ← Strict, exact match
│  "Find EXACTLY this byte-by-byte"   │
└─────────────────────────────────────┘
```

### Soluciones Arquitectónicas

1. **Abstracción de Edición**:
```typescript
// Crear wrapper que tolera variaciones
async function smartEdit(path, approximateOld, newContent) {
  const content = await read(path)
  // Fuzzy matching con tolerancia a whitespace
  const match = fuzzyFind(content, approximateOld)
  if (match) {
    return edit(path, match.exact, newContent)
  }
  throw new Error("No fuzzy match found")
}
```

2. **Verificación Previa**:
```bash
# Antes de editar, verificar que el texto existe
grep -F "exact text" file.md && edit file.md
```

3. **Uso de Shell Scripts**:
```bash
# Más confiable que edit tool
sed -i 's/old/new/g' file.md
```

---

## 📊 RESUMEN DE SOLUCIONES

| Ángulo | Diagnóstico | Solución Principal |
|--------|-------------|-------------------|
| Médico | ETMS - Edit Tool Mismatch Syndrome | Read → Write pattern |
| Informático | Race condition + whitespace normalization | Verificar con `cat -A` |
| Programación | Exact match requirement | Usar `sed` o `write` |
| IA/Agentes | Context compaction + hallucination | Read → Edit inmediato |
| Arquitectura | Agent-tool mismatch | Crear abstracción |

---

## ✅ RECOMENDACIÓN FINAL

**Para archivos estáticos grandes (>1000 líneas):**

```bash
# Opción 1: Usar sed (más confiable)
sed -i 's/old_text/new_text/g' file.md

# Opción 2: Usar write (reescribir completo)
read(file) → modificar en memoria → write(file, newContent)

# Opción 3: Usar grep + sed
grep -q "exact_text" file.md && sed -i 's/exact_text/new_text/' file.md
```

**Para archivos pequeños (<100 líneas):**

```typescript
// Read → Edit inmediato (sin pasos intermedios)
read(path)
edit(path, oldText, newText) // en el MISMO turno
```

---

## 🔧 HERRAMIENTAS ALTERNATIVAS

1. **Shell `sed`**: Para reemplazos simples
2. **Shell `awk`**: Para transformaciones complejas
3. **Python script**: Para ediciones multi-paso
4. **`write` tool**: Para reescritura completa
5. **Git operations**: `git apply` para patches

---

_Diagnóstico realizado: 2026-02-25_
_Archivos afectados: ASTRO.md, HEARTBEAT.md, otros archivos estáticos_
