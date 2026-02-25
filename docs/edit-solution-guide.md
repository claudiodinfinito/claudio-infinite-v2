# EDIT SOLUTION GUIDE

## ⚠️ El Problema

La herramienta `edit` falla frecuentemente con:
```
Could not find the exact text in file. 
The old text must match exactly including all whitespace and newlines.
```

## 🎯 Causa Raíz

1. **Context compaction** - El archivo leído se pierde durante procesamiento
2. **Whitespace invisible** - Tabs vs spaces, CRLF vs LF
3. **Tiempo de procesamiento** - El archivo puede cambiar entre read y edit

---

## ✅ SOLUCIONES (en orden de preferencia)

### 1. Usar `write` para archivos completos

```typescript
// En lugar de:
read(file)
edit(file, oldText, newText)

// Usar:
const content = read(file)
const newContent = content.replace(pattern, replacement)
write(file, newContent)
```

**Cuándo usar:** Archivos pequeños/medianos (< 500 líneas)

---

### 2. Usar `sed` para reemplazos simples

```bash
# Reemplazar texto exacto
sed -i 's/old_text/new_text/g' /path/to/file.md

# Reemplazar línea completa
sed -i '/pattern/c\new line content' /path/to/file.md

# Insertar después de línea
sed -i '/pattern/a\new line' /path/to/file.md
```

**Cuándo usar:** Reemplazos simples, una línea

---

### 3. Usar `grep` + `sed` con verificación

```bash
# Verificar antes de editar
grep -F "exact_text" file.md && sed -i 's/exact_text/new_text/' file.md
```

**Cuándo usar:** Cuando necesitas confirmar que el texto existe

---

### 4. Usar Python para ediciones complejas

```python
import re

with open('file.md', 'r') as f:
    content = f.read()

# Reemplazo con regex
new_content = re.sub(r'pattern', 'replacement', content)

with open('file.md', 'w') as f:
    f.write(new_content)
```

**Cuándo usar:** Múltiples reemplazos, regex, lógica compleja

---

### 5. Usar `awk` para transformaciones

```bash
# Reemplazar campo específico
awk '{gsub(/old/, "new"); print}' file.md > tmp && mv tmp file.md
```

**Cuándo usar:** Transformaciones de datos estructurados

---

## 🚫 ANTI-PATRONES

| ❌ Mal | ✅ Bien |
|--------|---------|
| `read` → esperar → `edit` | `read` → `write` inmediato |
| `edit` sin verificación | `grep` → `sed` |
| Editar archivos que cambian | Usar `write` completo |
| Asumir contexto correcto | Re-leer antes de editar |

---

## 📊 Decision Matrix

| Escenario | Herramienta | Razón |
|-----------|-------------|-------|
| Archivo completo | `write` | Una operación atómica |
| Una línea | `sed -i` | Simple, confiable |
| Verificar primero | `grep` + `sed` | Seguro |
| Múltiples cambios | Python script | Flexible |
| Estructurado (CSV, logs) | `awk` | Eficiente |

---

## 🔧 Ejemplos Prácticos

### Actualizar HEARTBEAT.md

```bash
# ❌ Mal (puede fallar)
edit(HEARTBEAT.md, oldText, newText)

# ✅ Bien
sed -i 's/Modo.*Autónomo/Modo | ⚪ Normal/' system/HEARTBEAT.md
```

### Agregar línea a ASTRO.md

```bash
# ✅ Bien
echo "" >> docs/ASTRO.md
echo "### Nueva Sección" >> docs/ASTRO.md
echo "Contenido aquí." >> docs/ASTRO.md
```

### Reescribir INDEX.md

```typescript
// ✅ Bien
const newContent = `# INDEX.md
...
`
write('INDEX.md', newContent)
```

---

## 📝 Lecciones

1. **`write` > `edit`** para archivos completos
2. **`sed` > `edit`** para cambios simples
3. **Siempre verificar** con grep antes de editar
4. **Git commit** antes de cambios grandes
5. **No confiar** en el contexto compactado

---

_Last updated: 2026-02-25_
_After 5+ failed edit attempts_
