# CLAUDIO-INFINITE.md - Proyecto Astro

> **Documentación específica del proyecto - 2026-02-25**

---

## 🎯 Información del Proyecto

| Campo | Valor |
|-------|-------|
| **Nombre** | claudio-infinite |
| **Tipo** | Sitio web corporativo + landings |
| **Stack** | Astro 5 + Node adapter + Astro DB |
| **Estado** | ✅ En producción |

---

## 🔧 Comandos Oficiales

### Desarrollo
```bash
cd /root/projects/claudio-infinite
npm run dev
```
- Servidor: http://localhost:4321
- Hot-reload activado
- NO requiere --remote

### Producción
```bash
# Build
npm run build

# Start
npm run start
```
- Servidor: http://192.227.249.251:4321
- Siempre build → start

---

## 📦 Estructura

```
claudio-infinite/
├── src/pages/
│   ├── index.astro           # Home
│   ├── kanban.astro          # Dashboard proyectos
│   ├── store.astro           # Tienda
│   ├── contact.astro         # Contacto (con Actions)
│   ├── faq.astro             # FAQs
│   ├── clients/              # Landings clientes
│   │   ├── spa.astro         # Client 001
│   │   └── tours.astro       # Client 002
│   └── landing-template.astro # Template genérico
├── db/
│   ├── config.ts             # Schema DB
│   └── seed.ts               # Datos seed
└── astro.config.mjs          # Configuración
```

---

## 🗄️ Base de Datos

### Tablas
- **Contact**: Formulario de contacto

### Configuración
```bash
# .env
ASTRO_DB_REMOTE_URL=file:/root/projects/claudio-infinite/.astro/db.sqlite
```

**IMPORTANTE:** Ruta absoluta obligatoria.

---

## 🌐 URLs

| Ambiente | URL |
|----------|-----|
| **Desarrollo** | http://localhost:4321 |
| **Producción** | http://192.227.249.251:4321 |
| **IP Interna** | http://100.87.200.4:4321 |

---

## ⚙️ Configuración

### astro.config.mjs
```javascript
{
  site: 'https://claudioinfinito.com',
  output: 'server',
  adapter: node({ mode: 'standalone' }),
  integrations: [db(), sitemap()],
  security: { checkOrigin: false }
}
```

### package.json Scripts
```json
{
  "dev": "astro dev",
  "build": "astro build --remote",
  "start": "NODE_ENV=production HOST=0.0.0.0 PORT=4321 node ./dist/server/entry.mjs"
}
```

---

## 🐛 Troubleshooting

### Server no levanta
```bash
# 1. Verificar proceso existente
ps aux | grep "node.*entry.mjs"

# 2. Matar si existe
kill -9 <PID>

# 3. Build
npm run build

# 4. Start
npm run start
```

### Páginas 500
```bash
# Verificar DB
ls -la .astro/db.sqlite

# Verificar .env
cat .env

# Rebuild
npm run build
```

### Puerto en uso
```bash
lsof -i :4321
kill -9 <PID>
```

---

## 📊 Monitoreo

### Verificar Estado
```bash
curl -I http://localhost:4321/
ps aux | grep "node.*entry.mjs"
ss -tlnp | grep 4321
```

### Logs
```bash
journalctl --since "1 hour ago" | grep astro
```

---

## 🎓 Lecciones del Proyecto

1. **Build antes de Start** - Siempre
2. **Rutas absolutas DB** - NO relativas
3. **Scripts npm** - NO `node` directo
4. **Process manager** - PM2 recomendado
5. **No reiniciar sin investigar** - Diagnosticar primero

---

## 📝 Pendientes

- [ ] Configurar PM2 para auto-restart
- [ ] Configurar dominio real (claudioinfinito.com)
- [ ] SSL/HTTPS
- [ ] GitHub repository
- [ ] CI/CD pipeline

---

_Actualizado: 2026-02-25_
