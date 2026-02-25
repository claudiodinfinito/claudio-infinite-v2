# KOMMO.md - Kommo CRM Reference

_Complete reference for Kommo CRM integrations and automation._

---

## Overview

Kommo is a CRM platform with messenger integration, automation tools, and pipeline management.

**Key Capabilities:**
- Multi-channel messaging (WhatsApp, Facebook, Instagram, Telegram)
- Sales automation via Salesbot
- Digital Pipeline for event-based triggers
- REST API for data manipulation
- Widget system for UI extensions

---

## Integration Types

| Type | Use Case | Moderation |
|------|----------|------------|
| **Private** | Single account, custom features | ❌ No |
| **Public** | Marketplace distribution | ✅ Yes |

For Client 001 (Spa), use **Private Integration**.

---

## Private Integration Setup

### Prerequisites
- Administrator account access
- Account registered at Kommo.com

### Steps
1. Go to **Settings → Integrations**
2. Click **Create integration**
3. Select **Private**
4. Fill required fields:
   - Integration name (3-255 chars)
   - Description (5-65,000 chars)
   - Allow access (permissions)
5. Save → Keys generated

### Keys Generated
| Key | Purpose |
|-----|---------|
| **Long-lived token** | Authorization for private integrations |
| **Secret key** | API authentication |
| **Integration ID** | Unique identifier |

---

## REST API

### Base URL
```
https://{subdomain}.kommo.com/api/v4/
```

### Authentication
```http
Authorization: Bearer {long_lived_token}
```

### Rate Limits
- 7 requests per second
- Burst: up to 21 requests

---

## Core Entities

### Leads (Deals)
```json
{
  "id": 12345,
  "name": "Lead name",
  "price": 5000,
  "status_id": 142,
  "pipeline_id": 1234,
  "responsible_user_id": 5678,
  "created_at": 1234567890,
  "updated_at": 1234567890,
  "tags": [{"name": "pagado"}],
  "custom_fields_values": [
    {
      "field_id": 123,
      "values": [{"value": "Custom value"}]
    }
  ]
}
```

### Contacts
```json
{
  "id": 12345,
  "name": "Contact name",
  "first_name": "John",
  "last_name": "Doe",
  "responsible_user_id": 5678,
  "custom_fields_values": [
    {
      "field_code": "PHONE",
      "values": [{"value": "+521234567890", "enum_code": "MOB"}]
    },
    {
      "field_code": "EMAIL",
      "values": [{"value": "email@example.com"}]
    }
  ]
}
```

### Pipelines
```json
{
  "id": 1234,
  "name": "Pipeline name",
  "is_main": true,
  "statuses": [
    {"id": 142, "name": "Nuevo", "sort": 10},
    {"id": 143, "name": "En proceso", "sort": 20},
    {"id": 144, "name": "Cerrado", "sort": 30}
  ]
}
```

---

## Salesbot - Automation Engine

Salesbot uses JSON-based scenarios for automated messaging and actions.

### Structure
```json
[
  {
    "question": [ /* Actions when bot sends message */ ],
    "answer": [ /* Actions when user responds */ ],
    "finish": [ /* Actions when bot completes */ ]
  }
]
```

### Handlers

| Handler | Purpose |
|---------|---------|
| `show` | Send message/buttons to client |
| `action` | Execute action (set_tag, change_status, etc.) |
| `condition` | Conditional logic |
| `wait_answer` | Wait for user response |
| `goto` | Jump to specific step |
| `stop` | End bot |

### Example: Ask for Contact Info
```json
[
  {
    "question": [
      {
        "handler": "show",
        "params": {
          "type": "text",
          "value": "Por favor proporciona tu teléfono y email"
        }
      },
      {
        "handler": "action",
        "params": {
          "name": "set_tag",
          "params": {
            "type": 2,
            "value": "nuevo_lead"
          }
        }
      }
    ],
    "answer": [
      {
        "handler": "preset",
        "params": {
          "name": "contacts.validate_base_info",
          "params": {
            "success": "¡Gracias por tu información!"
          }
        }
      }
    ]
  }
]
```

### Available Actions

| Action | Description |
|--------|-------------|
| `set_tag` | Add tag to lead |
| `change_status` | Move lead to different stage |
| `assign_responsible` | Assign to user |
| `send_message` | Send message via chat |
| `create_task` | Create follow-up task |

### Placeholders

| Placeholder | Value |
|-------------|-------|
| `{{contact.name}}` | Contact name |
| `{{lead.id}}` | Lead ID |
| `{{lead.price}}` | Lead value |
| `{{origin}}` | Source (WhatsApp, FB, etc.) |
| `{{message_text}}` | User's message |
| `{{current_date}}` | Current date |

---

## Digital Pipeline

Automation tool for event-based triggers.

### Trigger Events
- Lead stage change
- Incoming message
- Incoming call
- Email received
- Website visit

### Configuration Paths
1. **Leads → Automate → Select stage → Add Trigger → Salesbot**
2. **Settings → Communication tools → Salesbots**

---

## Webhooks

Subscribe to events without polling.

### Setup
```bash
POST /api/v4/webhooks
{
  "destination": "https://your-server.com/webhook",
  "settings": [
    {"action": "created", "entity": "leads"},
    {"action": "status_changed", "entity": "leads"},
    {"action": "updated", "entity": "contacts"}
  ]
}
```

### Events Available
| Entity | Actions |
|--------|---------|
| leads | created, status_changed, deleted |
| contacts | created, updated, deleted |
| companies | created, updated, deleted |
| tasks | created, updated, deleted |

---

## Client 001 Implementation Plan

### Requirements → Kommo Features

| Requirement | Kommo Feature |
|-------------|---------------|
| Pipeline por tratamientos | Create multiple pipelines via API |
| Tags (pagado, cancelado, parcialidades) | Salesbot `set_tag` action |
| Google Calendar integration | Native Kommo integration |
| Recordatorios automáticos | Salesbot + Digital Pipeline |
| Sistema de recordatorios de pagos | Tasks + Webhooks |

### Pipeline Structure (Spa)
```
Pipeline: Tratamientos
├── Nuevo lead
├── Cita agendada
├── Confirmado
├── En tratamiento
├── Pagado
└── Cancelado
```

### Tags Configuration
```
- pagado → Payment complete
- cancelado → Appointment cancelled
- en_parcialidades → Payment plan active
- recordatorio_2d → 2-day reminder sent
- recordatorio_3h → 3-hour reminder sent
```

### Salesbot Scenarios

#### 1. Appointment Confirmation
```json
[
  {
    "question": [
      {
        "handler": "show",
        "params": {
          "type": "text",
          "value": "¡Hola {{contact.name}}! Tu cita está agendada. ¿Confirmas tu asistencia?"
        }
      },
      {
        "handler": "show",
        "params": {
          "type": "buttons",
          "value": "Selecciona una opción:",
          "buttons": ["Confirmar", "Reagendar", "Cancelar"]
        }
      }
    ],
    "answer": [
      {
        "handler": "condition",
        "params": {
          "logic": "or",
          "conditions": [
            {"value": "{{message_text}}", "operand": "Confirmar", "operator": "="}
          ],
          "result": [
            {
              "handler": "action",
              "params": {"name": "set_tag", "params": {"type": 2, "value": "confirmado"}}
            },
            {
              "handler": "show",
              "params": {"type": "text", "value": "¡Excelente! Te esperamos."}
            }
          ]
        }
      }
    ]
  }
]
```

#### 2. Automatic Reminders (via Digital Pipeline)
- **2 days before**: Trigger on task due date → Salesbot sends message
- **3 hours before**: Trigger on custom field time → Salesbot sends message

---

## API Endpoints Reference

### Leads
```bash
# List leads
GET /api/v4/leads

# Create lead
POST /api/v4/leads
{
  "name": "New lead",
  "pipeline_id": 1234,
  "status_id": 142,
  "responsible_user_id": 5678
}

# Update lead
PATCH /api/v4/leads/{id}
{
  "status_id": 143,
  "tags": [{"name": "pagado"}]
}
```

### Pipelines
```bash
# List pipelines
GET /api/v4/leads/pipelines

# Create pipeline
POST /api/v4/leads/pipelines
{
  "name": "Tratamientos",
  "is_main": false,
  "statuses": [
    {"name": "Nuevo", "sort": 10, "color": "#99ccff"},
    {"name": "Pagado", "sort": 50, "color": "#99ff99"}
  ]
}
```

### Tags
```bash
# Add tag to lead
POST /api/v4/leads/{id}/tags
{
  "name": "pagado"
}
```

---

## Google Calendar Integration

Kommo has native Google Calendar sync:
1. Go to **Settings → Integrations**
2. Find **Google Calendar** in marketplace
3. Install and authorize
4. Configure sync rules

Events sync automatically when:
- Lead created → Calendar event
- Task due date → Calendar event
- Appointment field updated → Calendar event

---

## Best Practices

1. **Use long-lived tokens** for private integrations
2. **Implement webhooks** for real-time updates (avoid polling)
3. **Structure pipelines** by business process (not by team)
4. **Tag systematically** for filtering and automation
5. **Test Salesbot** thoroughly before deployment
6. **Document custom field IDs** for API calls

---

## Troubleshooting

### Common Issues
| Issue | Solution |
|-------|----------|
| 401 Unauthorized | Check token validity |
| 429 Rate limit | Implement request throttling |
| Missing fields | Verify custom field IDs |
| Bot not triggering | Check Digital Pipeline configuration |

---

## Resources

- **Documentation**: https://developers.kommo.com/
- **API Reference**: https://developers.kommo.com/reference/
- **LLMs.txt**: https://developers.kommo.com/llms.txt
- **Discord**: Kommo community

---

_Created: 2026-02-25_
_Context: Client 001 (Spa Kommo CRM Setup)_
