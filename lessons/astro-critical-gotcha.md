# ASTRO CRITICAL GOTCHA - Learned 2026-02-25

## ⚠️ NO Hot-Edit in Production

**El error:**
```
⚠️ 📝 Edit: in ~/projects/claudio-infinite/src/pages/index.astro failed: 
Could not find the exact text...
```

**La causa:**
Intenté editar archivos `.astro` esperando que se reflejaran en el servidor corriendo.

**La verdad:**
Astro es **estático por diseño**. El flujo es:

```
src/*.astro  →  BUILD  →  dist/  →  SERVIDOR
   ↓              ↓         ↓          ↓
 editado      compiled  generado   corre desde aquí
```

---

## ✅ Flujo Correcto

```bash
# 1. Editar archivos fuente
vim src/pages/index.astro

# 2. Build
cd /root/projects/claudio-infinite
npm run build

# 3. Reiniciar servidor
lsof -ti:4321 | xargs kill -9
HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs
```

---

## 🚫 Lo que NO funciona

| ❌ Mal | ✅ Bien |
|--------|---------|
| Edit + esperar cambio | Edit → Build → Restart |
| Modificar `dist/` directo | Modificar `src/` solo |
| Skip build | Siempre build después de cambios |
| Asumir contexto actualizado | Re-leer archivo antes de editar |

---

## 🧠 Regla Mnemónica

> **"Astro es como compilar C: edit → compile → run"**

No es interpretado como Python. Es compilado como C/Rust/Go.

---

## 📚 Referencia

- ASTRO.md Gotcha #7 (agregar esta lección)
- WORKFLOW_ORCHESTRATION.md Regla 5: "Consult official docs first"
- lessons.md: "No inventar soluciones"

---

_Guardar esta lección para evitar repetir el error._
