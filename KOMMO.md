# KOMMO.md - Kommo CRM Reference

_Complete guide for Kommo CRM setup and automation._

---

## 📚 Overview

Kommo (formerly AmoCRM) is a messaging-centric CRM designed for sales teams. Key features:
- **Multi-channel messaging**: WhatsApp, Facebook, Instagram, Telegram
- **Pipelines**: Visual sales pipelines with stages
- **SalesBot**: Automated conversation flows
- **Digital Pipeline**: Event-based automation
- **API**: REST API for custom integrations
- **Widgets**: Custom JS extensions in the interface

---

## 🔑 Authentication

### Private Integration (Single Account)

```bash
# Long-lived token (simplest for single account)
# Get from: Settings > Integrations > Create Integration

# API calls with Bearer token
curl -X GET "https://YOUR_SUBDOMAIN.kommo.com/api/v4/leads" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### OAuth2 (Public Integration)

For public marketplace integrations:
1. Create integration in Kommo
2. Get `client_id` and `client_secret`
3. Exchange authorization code for tokens
4. Refresh tokens automatically

---

## 📊 Core Entities

| Entity | Description | API Endpoint |
|--------|-------------|--------------|
| **Leads** | Opportunities/deals | `/api/v4/leads` |
| **Contacts** | People/organizations | `/api/v4/contacts` |
| **Companies** | Business entities | `/api/v4/companies` |
| **Pipelines** | Sales process stages | `/api/v4/leads/pipelines` |
| **Tags** | Labels for categorization | `/api/v4/leads/tags` |
| **Tasks** | Follow-ups/actions | `/api/v4/tasks` |
| **Notes** | Comments on entities | `/api/v4/{entity}/notes` |
| **Webhooks** | Event subscriptions | `/api/v4/webhooks` |

---

## 🔄 Pipelines & Stages

### Pipeline Structure

```json
{
  "id": 12345,
  "name": "Spa Treatments",
  "sort": 1,
  "is_main": true,
  "_embedded": {
    "statuses": [
      {"id": 1, "name": "New Lead", "sort": 1},
      {"id": 2, "name": "Consultation", "sort": 2},
      {"id": 3, "name": "Booking Confirmed", "sort": 3},
      {"id": 4, "name": "Completed", "sort": 4},
      {"id": 5, "name": "Payment Received", "sort": 5}
    ]
  }
}
```

### API: Create Pipeline

```bash
POST /api/v4/leads/pipelines
Content-Type: application/json

{
  "name": "Spa Treatments Pipeline",
  "is_main": false,
  "statuses": [
    {"name": "New Inquiry", "sort": 10},
    {"name": "Quote Sent", "sort": 20},
    {"name": "Confirmed", "sort": 30},
    {"name": "In Progress", "sort": 40},
    {"name": "Completed", "sort": 50},
    {"name": "Paid", "sort": 60}
  ]
}
```

---

## 🏷️ Tags

Tags categorize leads for filtering and reporting.

### API: Create Tags

```bash
POST /api/v4/leads/tags
Content-Type: application/json

[
  {"name": "pagado", "color": "4CAF50"},
  {"name": "cancelado", "color": "F44336"},
  {"name": "parcialidades", "color": "FF9800"},
  {"name": "pendiente-pago", "color": "FFC107"}
]
```

### Apply Tag to Lead

```bash
PATCH /api/v4/leads/{lead_id}
Content-Type: application/json

{
  "_embedded": {
    "tags": [
      {"name": "pagado"}
    ]
  }
}
```

---

## 📅 Calendar Integration

### Google Calendar Integration Steps

1. **Enable Calendar Widget** in Kommo (Settings > Integrations)
2. **Connect Google Account** via OAuth
3. **Configure Sync**:
   - Bidirectional sync
   - Default calendar selection
   - Event type mapping

### Appointment Booking Flow

```
Lead Created → SalesBot asks preferred date/time
     ↓
SalesBot creates Google Calendar event
     ↓
Google sends invitation to contact
     ↓
Webhook receives calendar response
     ↓
Update lead stage to "Confirmed"
```

---

## 🤖 SalesBot Automation

SalesBot is Kommo's visual automation builder for conversations.

### Common Automation Patterns

#### 1. Appointment Reminders

```
Trigger: Lead stage = "Confirmed"
Wait: 2 days before appointment
Action: Send WhatsApp message "Your appointment is in 2 days"

Trigger: Lead stage = "Confirmed"
Wait: 3 hours before appointment
Action: Send WhatsApp message "Your appointment is in 3 hours"
```

#### 2. Payment Reminders

```
Trigger: Tag = "pendiente-pago"
Condition: Lead created > 7 days ago
Action: Send message "Reminder: pending payment of $X"
Wait: 3 days
Loop: Send again (max 3 times)
```

#### 3. Lead Qualification

```
Trigger: New lead from Instagram/Facebook
Action: Ask "What service are you interested in?"
Wait: User response
Branch: Based on response, assign to treatment pipeline
Action: Ask "Preferred date?"
Wait: User response
Action: Create calendar event
Action: Update lead stage to "Confirmed"
```

---

## 🔔 Webhooks

Subscribe to events for external automation.

### Available Events

| Event | Description |
|-------|-------------|
| `leads:add` | New lead created |
| `leads:update` | Lead modified |
| `leads:status` | Stage changed |
| `leads:deleted` | Lead deleted |
| `contacts:add` | New contact |
| `tasks:add` | Task created |
| `tasks:complete` | Task completed |

### Register Webhook

```bash
POST /api/v4/webhooks
Content-Type: application/json

{
  "destination": "https://your-server.com/webhook",
  "settings": [
    {"action": "leads:add"},
    {"action": "leads:status"},
    {"action": "tasks:complete"}
  ]
}
```

---

## 📱 Multi-Channel Messaging

### Supported Channels

| Channel | Setup Method | Notes |
|---------|--------------|-------|
| **WhatsApp** | WhatsApp Business API or Kommo's official integration | Requires verified business |
| **Facebook Messenger** | Connect FB Page | Instant setup |
| **Instagram DM** | Connect Instagram Business account | Requires linked FB Page |
| **Telegram** | Create bot via @BotFather | Requires bot token |

### Channel Configuration

1. Go to **Settings > Messaging Channels**
2. Click **+ Add Channel**
3. Select channel type
4. Follow OAuth flow for social channels
5. Test by sending message from that platform

---

## 🎯 Client 001: Spa Kommo Setup Plan

### Project: Spa - Kommo CRM Setup
**Timeline:** Feb 24-27 (4 days)
**Deliverables:**

#### Phase 1: Channels ✅ (Completed)
- [x] Facebook Messenger connected
- [x] WhatsApp Business connected
- [x] Instagram DM connected

#### Phase 2: Pipeline Setup
- [ ] Create pipeline for treatments:
  - Masajes
  - Faciales
  - Corporales
  - Paquetes
- [ ] Define stages for each:
  - Nueva consulta → Cotización enviada → Confirmada → Completada → Pagada

#### Phase 3: Tags
- [ ] Create payment tags:
  - `pagado` (green) - Full payment received
  - `cancelado` (red) - Appointment cancelled
  - `parcialidades` (orange) - Payment plan active
  - `pendiente-pago` (yellow) - Awaiting payment

#### Phase 4: Calendar Integration
- [ ] Connect Google Calendar
- [ ] Configure appointment types
- [ ] Set up booking flow in SalesBot

#### Phase 5: Automations
- [ ] Appointment reminders:
  - 2 days before: "Tu cita es en 2 días"
  - 3 hours before: "Tu cita es en 3 horas"
- [ ] Payment reminders:
  - Weekly reminder for pending payments
  - Max 3 attempts before marking "no response"

#### Phase 6: Testing
- [ ] Test complete flow:
  - Lead from Instagram → Pipeline → Booking → Reminder → Payment → Tag
- [ ] Document procedures for client

---

## 🔧 API Quick Reference

### Base URL
```
https://{subdomain}.kommo.com/api/v4/
```

### Headers
```
Authorization: Bearer {token}
Content-Type: application/json
```

### Rate Limits
- 7 requests per second
- Batch operations available for bulk actions

### Common Endpoints

```bash
# Get all leads
GET /leads

# Get leads in pipeline stage
GET /leads?filter[pipeline_id]={pipeline_id}&filter[status_id]={status_id}

# Create lead
POST /leads
{
  "name": "Juan Pérez - Masaje Relajante",
  "pipeline_id": 12345,
  "status_id": 1,
  "_embedded": {
    "contacts": [{"id": 67890}],
    "tags": [{"name": "pendiente-pago"}]
  }
}

# Update lead stage
PATCH /leads/{lead_id}
{
  "pipeline_id": 12345,
  "status_id": 3  # "Confirmed" stage
}

# Add note
POST /leads/{lead_id}/notes
{
  "note_type": "common",
  "params": {
    "text": "Cliente confirmó cita para el viernes 28 Feb a las 3pm"
  }
}

# Create task
POST /tasks
{
  "entity_type": "leads",
  "entity_id": {lead_id},
  "task_type_id": 1,  # Follow-up
  "complete_till": 1708876800,  # Unix timestamp
  "text": "Send payment reminder"
}
```

---

## 📖 Resources

- **Official Docs**: https://developers.kommo.com/
- **API Reference**: https://developers.kommo.com/reference/
- **YouTube Tutorials**: Search "Kommo CRM tutorial" for video guides
- **Community**: Discord server for developers

---

## ⚠️ Gotchas

1. **Rate Limits**: 7 req/sec - use batch endpoints for bulk operations
2. **Status IDs**: Specific to each pipeline, not global
3. **Webhooks**: Must respond with 200 OK within 3 seconds
4. **Token Expiry**: Long-lived tokens can expire, implement refresh logic
5. **Entity Links**: Use `_embedded` for linking contacts/tags to leads

---

_Update this file as you learn more about Kommo CRM._
