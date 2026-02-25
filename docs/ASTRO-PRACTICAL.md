# ASTRO-PRACTICAL.md - Guía de Producción

> **Lecciones aprendidas de implementación real - 2026-02-25**

---

## 🎯 Flujo de Trabajo Oficial

### Desarrollo Local
```bash
npm run dev
# o
pnpm dev
```
- Servidor de desarrollo con hot-reload
- Escucha cambios en `src/`
- NO requiere --remote flag

### Build de Producción
```bash
npm run build
# Si usas Astro DB:
npm run build -- --remote
```
- Genera carpeta `dist/`
- Genera CSS/JS optimizado
- Pre-renderiza rutas estáticas

### Servidor de Producción
```bash
npm run start
```
- Levanta servidor Node.js
- Usa archivos de `dist/`
- **SIEMPRE después del build**

### Preview Local
```bash
npm run preview
```
- Preview del build localmente
- NO usar en producción

---

## 📦 package.json Correcto

```json
{
  "scripts": {
    "dev": "astro dev",
    "build": "astro build --remote",
    "preview": "astro preview",
    "start": "NODE_ENV=production HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs"
  }
}
```

**Notas:**
- `--remote` incluido en build para Astro DB
- `start` con variables de entorno embebidas
- NO usar `node` directamente, usar scripts npm

---

## 🔧 Configuración Producción

### astro.config.mjs

```javascript
import { defineConfig } from 'astro/config';
import node from '@astrojs/node';
import db from '@astrojs/db';

export default defineConfig({
  site: 'https://tu-dominio.com',
  output: 'server',
  adapter: node({
    mode: 'standalone'
  }),
  integrations: [db()],
  security: {
    checkOrigin: false
  }
});
```

**Importante:**
- `mode: 'standalone'` para servidor independiente
- `output: 'server'` para SSR
- `checkOrigin: false` para permitir POST cross-site

---

## 🗄️ Astro DB Configuración

### .env (PRODUCCIÓN)
```bash
ASTRO_DB_REMOTE_URL=file:/ruta/absoluta/a/.astro/db.sqlite
```

**CRÍTICO:** Usar ruta ABSOLUTA, no relativa.

### .env.example
```bash
# Para desarrollo local
ASTRO_DB_REMOTE_URL=file:/root/projects/claudio-infinite/.astro/db.sqlite

# Para producción con Turso
# ASTRO_DB_REMOTE_URL=libsql://tu-db.turso.io
# ASTRO_DB_APP_TOKEN=eyJhbGciOiJF...
```

### db/config.ts
```typescript
import { defineDb, defineTable, column, NOW } from 'astro:db';

const Contact = defineTable({
  columns: {
    id: column.number({ primaryKey: true }),
    name: column.text(),
    email: column.text(),
    createdAt: column.date({ default: NOW }),
  }
});

export default defineDb({
  tables: { Contact }
});
```

---

## 🚀 Comandos de Producción

### Levantar Servidor
```bash
cd /root/projects/claudio-infinite
npm run build  # Siempre build primero
npm run start  # Luego start
```

### Verificar Estado
```bash
# Verificar proceso
ps aux | grep "node.*entry.mjs"

# Verificar puerto
ss -tlnp | grep 4321

# Verificar HTTP
curl -I http://localhost:4321/
```

### Diagnosticar Problemas
```bash
# Logs del sistema
journalctl -u astro -n 50

# Logs generales
tail -100 /var/log/syslog | grep node

# Memoria
free -h

# Disco
df -h /
```

---

## ⚠️ Problemas Comunes

### 1. "Invalid URL" en Astro DB
**Causa:** Ruta relativa en ASTRO_DB_REMOTE_URL
**Solución:** Usar ruta absoluta
```bash
# MAL
ASTRO_DB_REMOTE_URL=file:.astro/db.sqlite

# BIEN
ASTRO_DB_REMOTE_URL=file:/root/projects/claudio-infinite/.astro/db.sqlite
```

### 2. Páginas 500 después del build
**Causa:** Faltan variables de entorno o DB no configurada
**Solución:**
1. Verificar .env existe
2. Build con --remote flag
3. Verificar db.sqlite existe

### 3. Puerto en uso (EADDRINUSE)
**Causa:** Proceso anterior no terminado
**Solución:**
```bash
# Encontrar proceso
lsof -i :4321
# Matar proceso
kill -9 <PID>
```

### 4. Server muerto sin motivo aparente
**Causa:** Falta process manager (PM2, systemd)
**Solución:**
```bash
# Instalar PM2
npm install -g pm2
pm2 start "npm run start" --name claudio-infinite
pm2 save
pm2 startup
```

---

## 📊 Checklist Pre-Producción

- [ ] package.json tiene script "start"
- [ ] Build exitoso (`npm run build`)
- [ ] dist/ existe y tiene archivos
- [ ] .env con rutas absolutas
- [ ] astro.config.mjs con mode: 'standalone'
- [ ] Puerto configurado (4321 por defecto)
- [ ] Proceso vivo después de 5 min
- [ ] Todas las páginas HTTP 200

---

## 🔍 Monitoreo

### Verificar Server Cada 5 Min
```bash
#!/bin/bash
# check-astro.sh
if ! curl -s http://localhost:4321/ > /dev/null; then
  echo "Astro down, restarting..."
  cd /root/projects/claudio-infinite && npm run start
fi
```

### Cron Job
```bash
*/5 * * * * /root/scripts/check-astro.sh >> /var/log/astro-check.log 2>&1
```

---

## 📚 Referencia Rápida

| Comando | Propósito | Cuándo Usar |
|---------|-----------|-------------|
| `npm run dev` | Desarrollo local | Mientras desarrollas |
| `npm run build` | Build producción | Antes de deploy |
| `npm run start` | Servidor producción | Después del build |
| `npm run preview` | Preview local | Probar build local |

---

## 🎓 Lecciones Aprendidas

### 1. Build ≠ Start
> **SIEMPRE ejecutar build antes de start**
> Build genera los archivos que start sirve

### 2. Rutas Absolutas para DB
> **ASTRO_DB_REMOTE_URL debe ser ruta absoluta**
> Rutas relativas causan "Invalid URL" error

### 3. No Reiniciar Sin Investigar
> **Si server cae, investigar causa primero**
> NO reiniciar automáticamente

### 4. Usar Scripts npm
> **NO ejecutar `node` directamente**
> Usar `npm run start` para variables de entorno

### 5. Process Manager para Producción
> **Un servidor de producción necesita PM2 o systemd**
> No depender de `&` en terminal

---

## 📁 Estructura Final del Proyecto

```
claudio-infinite/
├── .env                    # Variables de entorno (ABSOLUTAS)
├── .env.example           # Template para documentación
├── astro.config.mjs       # Configuración Astro
├── package.json           # Scripts correctos
├── db/
│   ├── config.ts          # Schema DB
│   └── seed.ts            # Datos desarrollo
├── src/
│   ├── pages/             # Rutas
│   ├── components/        # Componentes
│   ├── layouts/           # Layouts
│   └── styles/            # CSS
├── dist/                  # Build output
│   ├── client/            # Archivos estáticos
│   └── server/            # entry.mjs
└── .astro/
    └── db.sqlite          # Database file
```

---

## 🔗 Enlaces Útiles

- [Astro Docs - Node Adapter](https://docs.astro.build/en/guides/integrations-guide/node/)
- [Astro DB Guide](https://docs.astro.build/en/guides/astro-db/)
- [Deployment Guide](https://docs.astro.build/en/guides/deploy/)

---

_Actualizado: 2026-02-25_
_Aprendido de: Errores reales en producción_
