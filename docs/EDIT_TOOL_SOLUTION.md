# Edit Tool - Solución Definitiva

_Documento de referencia rápida creado tras investigación exhaustiva (2026-02-27)_

**19 pruebas prácticas realizadas.**

---

## ❌ El Error

```
Could not find the exact text in file. The old text must match exactly including all whitespace and newlines.
```

## 🔍 Causa Raíz CONFIRMADA

**El archivo cambió entre el momento en que tienes el contenido y el momento del edit.**

---

## ✅ Solución

### Patrón Correcto

```
read(file) → edit(file, exactText, newText)  // Mismo turno
```

### Múltiples edits secuenciales

```
read → edit → edit → edit  // ✅ FUNCIONA (contexto se actualiza)
```

El contexto se actualiza automáticamente después de cada edit exitoso.

### Si edit falla

```bash
# Releer y reintentar
read(file)
edit(file, exactTextFromRead, newText)

# Alternativa: sed
sed -i 's/oldText/newText/g' file

# Alternativa: echo (append)
echo "text" >> file

# Alternativa: write (sobrescribir todo)
write(file, fullContent)
```

---

## 🚨 Casos Especiales

### Líneas duplicadas

Si el oldText aparece múltiples veces, el edit falla con:
```
Found 3 occurrences of the text. The text must be unique.
```

**Solución:** Incluir más contexto en oldText:
```
# ❌ Falla
oldText: "Repeated: XXX"

# ✅ Funciona
oldText: "Repeated: XXX\nRepeated: XXX"
```

---

## 📋 Checklist Rápido

- [ ] ¿Tengo el contenido ACTUAL del archivo?
- [ ] ¿Copié texto EXACTO del resultado?
- [ ] ¿Archivo modificado por otros? → Releer antes de editar
- [ ] ¿Líneas duplicadas? → Incluir más contexto

---

## 🧪 Pruebas Realizadas (19 tests)

### ✅ Exitosos (15)
- Edit inmediato después de read
- CRLF (Windows line endings)
- Archivo grande (5000 líneas)
- Múltiples líneas en oldText
- Múltiples edits secuenciales
- Caracteres especiales (${variable}, backticks)
- Trailing whitespace
- Contexto de exec (no solo read tool)

### ❌ Fallidos (4 - esperados)
- Archivo modificado externamente
- Contexto compactado/desactualizado
- Líneas duplicadas sin contexto
- Adivinar contenido incorrectamente

---

## 💡 Reglas Definitivas

1. **Ten el contenido actual** - Antes de edit, asegúrate de tener el contenido ACTUAL
2. **Copia exactamente** - oldText = copia EXACTA del contenido en tu contexto
3. **Si falla, releer** - read → copiar → reintentar
4. **Líneas duplicadas** - Incluir más contexto en oldText

---

_Referencia: tasks/lessons.md "2026-02-27 - Edit Tool: Solución Definitiva"_
