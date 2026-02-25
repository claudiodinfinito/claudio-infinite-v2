# KOMMO.md - Kommo CRM Reference

_Guía de referencia para integraciones y automatizaciones con Kommo CRM._

---

## 📋 Overview

**Kommo** es un CRM diseñado para ventas multicanal (messenger-first). Combina mensajería, pipelines y automatización en una sola plataforma.

**Sitio:** https://www.kommo.com
**Docs:** https://developers.kommo.com
**API Base:** `https://{subdomain}.kommo.com/api/v4/`

---

## 🔑 Autenticación

### Private Integration (Recomendado para Client 001)

Para integraciones dentro de una sola cuenta:

1. **Long-lived Token** — Token permanente para acceso API
2. No requiere moderación
3. Solo funciona en la cuenta donde fue creado

### OAuth2 (Para integraciones públicas)

- `client_id`
- `client_secret`
- `authorization_code`

---

## 🏗️ Arquitectura de Kommo

### Componentes Principales

| Componente | Descripción |
|------------|-------------|
| **Leads** | Oportunidades de venta en pipelines |
| **Contacts** | Personas/empresas relacionadas |
| **Companies** | Empresas |
| **Tasks** | Tareas asociadas a leads |
| **Notes** | Notas en leads/contactos |
| **Tags** | Etiquetas para segmentación |

### Pipelines

Los pipelines son el core de Kommo. Cada pipeline tiene **etapas (statuses)**:

```
Pipeline: Ventas Spa
├── Nueva consulta (status_id: 1)
├── En seguimiento (status_id: 2)
├── Cotizado (status_id: 3)
├── Pagado (status_id: 4) ← Tag: "pagado"
├── Cancelado (status_id: 5) ← Tag: "cancelado"
└── Parcialidades (status_id: 6) ← Tag: "en parcialidades"
```

---

## 🤖 Automatización

### SalesBot

Lenguaje visual para crear escenarios automatizados:
- Respuestas automáticas en chats
- NLP para detectar intención
- Acciones con leads/contactos

### Digital Pipeline

Constructor de automatizaciones basado en eventos:
- Cambio de etapa en pipeline
- Visitas al sitio web
- Creación de tareas
- Envío de emails

**Ejemplo para Client 001:**
```
Trigger: Lead creado desde WhatsApp
↓
Action: Asignar a vendedor
↓
Action: Enviar mensaje de bienvenida
↓
Action: Crear tarea "Seguimiento 24h"
```

---

## 📱 Canales Multicanal

### Mensajería Soportada

| Canal | Status | Notas |
|-------|--------|-------|
| WhatsApp | ✅ | Via API oficial o integradores |
| Facebook Messenger | ✅ | Directo |
| Instagram DM | ✅ | Directo |
| Telegram | ✅ | Directo |
| Email | ✅ | IMAP/SMTP |

### Configuración para Client 001

1. **WhatsApp Business API** — Requiere proveedor externo
2. **Facebook Page** — Conectar página de Facebook
3. **Instagram Business** — Conectar cuenta de Instagram

---

## 🔔 Webhooks

Kommo puede enviar webhooks a tu servidor cuando ocurren eventos:

### Eventos Disponibles

- `lead_added` — Nuevo lead
- `lead_status_changed` — Cambio de etapa
- `contact_added` — Nuevo contacto
- `task_added` — Nueva tarea
- `message_received` — Nuevo mensaje

### Configuración

```bash
# Registrar webhook
POST /api/v4/webhooks
{
  "destination": "https://tu-servidor.com/webhook",
  "settings": ["lead_added", "lead_status_changed"]
}
```

---

## 📅 Integración con Google Calendar

Para agendamiento de citas:

### Opción 1: Widget de Kommo
Kommo tiene widget nativo para Google Calendar.

### Opción 2: API + Webhook
1. Crear lead con fecha/hora deseada
2. Webhook detecta `lead_added`
3. Tu servidor crea evento en Google Calendar API
4. Actualizar lead con link al evento

---

## 🏷️ Sistema de Tags

Los tags permiten segmentar y filtrar leads:

### API de Tags

```bash
# Agregar tags a un lead
PUT /api/v4/leads/{lead_id}
{
  "tags": [
    {"name": "pagado"},
    {"name": "VIP"}
  ]
}
```

### Tags para Client 001

| Tag | Uso |
|-----|-----|
| `pagado` | Lead con pago completo |
| `cancelado` | Lead cancelado |
| `en_parcialidades` | Lead con pagos parciales |
| `VIP` | Cliente recurrente |
| `nuevo` | Primera consulta |

---

## 📊 API Reference

### Endpoints Principales

```bash
# Listar leads
GET /api/v4/leads

# Crear lead
POST /api/v4/leads
{
  "name": "Tratamiento facial",
  "pipeline_id": 123,
  "status_id": 1,
  "price": 1500,
  "contacts": [{"id": 456}]
}

# Obtener pipelines
GET /api/v4/leads/pipelines

# Listar contactos
GET /api/v4/contacts

# Crear contacto
POST /api/v4/contacts
{
  "name": "Juan Pérez",
  "custom_fields_values": [
    {"field_id": 123, "values": [{"value": "+525512345678"}]}
  ]
}
```

---

## 💡 Recetas para Client 001

### 1. Pipeline por Tratamientos

Crear pipeline con etapas:
1. Nueva consulta
2. En seguimiento
3. Cotizado
4. Confirmado
5. Pagado
6. Cancelado

### 2. Recordatorios Automáticos

Usar Digital Pipeline:
```
Trigger: Lead en etapa "Confirmado"
↓
Wait: 2 días antes de cita
↓
Action: Enviar WhatsApp recordatorio
↓
Wait: 3 horas antes
↓
Action: Enviar WhatsApp recordatorio final
```

### 3. Sistema de Pagos

```
Trigger: Lead movido a "Pagado"
↓
Action: Agregar tag "pagado"
↓
Action: Crear factura (integración externa)
↓
Action: Notificar al vendedor
```

---

## 🔧 Herramientas Disponibles

| Herramienta | Uso |
|-------------|-----|
| **REST API** | CRUD de leads, contacts, etc. |
| **Webhooks** | Eventos en tiempo real |
| **SalesBot** | Chatbots automatizados |
| **Digital Pipeline** | Automatizaciones visuales |
| **Widgets** | Extensiones de UI |
| **Chats API** | Integrar nuevos canales |

---

## 📚 Recursos

- [Developer Portal](https://developers.kommo.com)
- [API Reference](https://developers.kommo.com/reference)
- [Recipes](https://developers.kommo.com/docs/recipes)
- [Discord Community](https://discord.gg/kommo)

---

## ⚠️ Notas Importantes

1. **Rate Limits** — Kommo tiene límites de requests por minuto
2. **Private vs Public** — Private es más simple para un solo cliente
3. **WhatsApp** — Requiere proveedor externo (no es directo)
4. **Timezone** — Configurar timezone de la cuenta para citas

---

_Documentación creada: 2026-02-25_
_Próxima actualización: Según necesidades del proyecto_
