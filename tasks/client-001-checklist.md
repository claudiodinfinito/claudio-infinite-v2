# Client 001: Spa - Kommo CRM Checklist

**Deadline:** Feb 27 (mañana viernes tarde)
**Tiempo restante:** < 24 horas
**Credenciales:** ⚠️ PENDIENTES

---

## 🎯 Plan de Implementación (cuando tenga credenciales)

### FASE 1: Setup Inicial (15 min)

- [ ] Recibir credenciales Kommo (subdomain + API token)
- [ ] Verificar acceso: `GET https://{subdomain}.kommo.com/api/v4/account`
- [ ] Listar pipelines existentes: `GET /api/v4/leads/pipelines`
- [ ] Listar tags existentes: `GET /api/v4/leads/tags`

### FASE 2: Pipeline por Tratamientos (30 min)

**Crear pipeline "Tratamientos Spa":**

```bash
POST /api/v4/leads/pipelines
{
  "name": "Tratamientos Spa",
  "is_main": false,
  "statuses": [
    {"name": "Nueva consulta", "sort": 10, "color": "99CCFF"},
    {"name": "Cotización enviada", "sort": 20, "color": "FFCC66"},
    {"name": "Cita confirmada", "sort": 30, "color": "66CC66"},
    {"name": "Completado", "sort": 40, "color": "CCFF99"},
    {"name": "Pagado", "sort": 50, "color": "66FF66"},
    {"name": "Cancelado", "sort": 60, "color": "FF6666"}
  ]
}
```

**Opcional:** Sub-pipelines por tipo de tratamiento:
- Masajes
- Faciales
- Corporales
- Paquetes

### FASE 3: Tags de Pago (15 min)

**Crear tags:**

```bash
POST /api/v4/leads/tags
[
  {"name": "pagado", "color": "4CAF50"},
  {"name": "cancelado", "color": "F44336"},
  {"name": "parcialidades", "color": "FF9800"},
  {"name": "pendiente-pago", "color": "FFC107"}
]
```

### FASE 4: Integración Google Calendar (30 min)

1. [ ] Verificar widget de Calendar habilitado en Kommo
2. [ ] Conectar cuenta Google del cliente
3. [ ] Configurar tipos de eventos:
   - Masaje 60 min
   - Facial 45 min
   - Tratamiento corporal 90 min
   - Paquete spa 2h

### FASE 5: Automatizaciones (45 min)

**SalesBot Flow - Recordatorios de Citas:**

```
Trigger: Lead status = "Cita confirmada"
Wait: 2 días antes de la cita
Action: Enviar WhatsApp "Tu cita es en 2 días. ¿Confirmas asistencia?"

Wait: 3 horas antes de la cita
Action: Enviar WhatsApp "Tu cita es en 3 horas. Te esperamos."
```

**SalesBot Flow - Recordatorios de Pago:**

```
Trigger: Tag = "pendiente-pago"
Condition: Lead creado > 7 días
Action: Enviar mensaje "Recordatorio: tienes un pago pendiente de $X"
Loop: Repetir cada 3 días (máximo 3 veces)
```

### FASE 6: Testing (30 min)

- [ ] Crear lead de prueba desde Instagram/Facebook
- [ ] Verificar que aparece en pipeline correcto
- [ ] Mover lead por las etapas
- [ ] Aplicar tags
- [ ] Crear evento de calendario
- [ ] Verificar que los recordatorios se programan

### FASE 7: Documentación para el Cliente (15 min)

- [ ] Crear PDF/video de cómo usar el sistema
- [ ] Explicar:
  - Cómo ver leads nuevos
  - Cómo mover leads entre etapas
  - Cómo aplicar tags
  - Cómo ver calendario
  - Cómo funcionan los recordatorios automáticos

---

## ⏱️ Tiempo Total Estimado: 3 horas

| Fase | Tiempo | Dependencia |
|------|--------|-------------|
| Setup | 15 min | Credenciales |
| Pipeline | 30 min | Setup |
| Tags | 15 min | Setup |
| Calendar | 30 min | Credenciales Google |
| Automatizaciones | 45 min | Pipeline + Tags |
| Testing | 30 min | Todo lo anterior |
| Documentación | 15 min | Testing completo |

---

## 🚀 Listo para ejecutar

**Cuando Gamble proporcione:**
1. Subdomain Kommo
2. API token
3. (Opcional) Acceso a Google Calendar del cliente

**Puedo implementar todo en 3 horas y entregar mañana.**

---

_Checklist creado: 2026-02-26 — Modo autónomo_
