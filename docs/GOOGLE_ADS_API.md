# Google Ads API - Reporte de Investigación

_Investigación sobre cómo conectar APIs, específicamente Google Ads API. Fuentes: Documentación oficial de Google._

---

## 📊 Resumen Ejecutivo

| Aspecto | Estado |
|---------|--------|
| **Skill OpenClaw específico** | ❌ NO existe |
| **MCP Server disponible** | ❌ No encontrado (404) |
| **Librería NodeJS community** | ✅ Existe (no oficial) |
| **API REST directo** | ✅ Posible |
| **Client library oficial** | ✅ Python, Java, PHP, .NET, Ruby, Perl |

---

## 🔧 Opciones de Conexión

### Opción 1: API REST Directo (Recomendado para OpenClaw)

**Requisitos:**
- Developer Token (solicitar a Google)
- OAuth 2.0 credentials (Client ID + Client Secret)
- Refresh Token
- Customer ID (cuenta de Google Ads)

**Endpoint:**
```
https://googleads.googleapis.com/v23/customers/{customer_id}/googleAds:searchStream
```

**Headers:**
```
Authorization: Bearer {access_token}
developer-token: {developer_token}
login-customer-id: {login_customer_id}
```

**Ejemplo curl:**
```bash
curl -X POST \
  'https://googleads.googleapis.com/v23/customers/1234567890/googleAds:searchStream' \
  -H 'Authorization: Bearer ya29.a0...' \
  -H 'developer-token: INSERT_DEVELOPER_TOKEN_HERE' \
  -H 'login-customer-id: 1234567890' \
  -H 'Content-Type: application/json' \
  -d '{
    "query": "SELECT campaign.id, campaign.name FROM campaign ORDER BY campaign.id"
  }'
```

---

### Opción 2: NodeJS Library (Community-maintained)

**Paquete:** `google-ads-api` (npm)

**Instalación:**
```bash
npm install google-ads-api
```

**Uso:**
```javascript
const { GoogleAdsApi } = require('google-ads-api')

const client = new GoogleAdsApi({
  client_id: '...',
  client_secret: '...',
  developer_token: '...',
})

const customer = client.Customer({
  customer_id: '...',
  refresh_token: '...',
})

// Fetch campaigns
const campaigns = await customer.report({
  entity: 'campaign',
  attributes: ['campaign.id', 'campaign.name'],
  limit: 10,
})
```

**⚠️ Nota:** Librería community-maintained, no oficial de Google.

---

### Opción 3: Python Client Library (Oficial)

**Instalación:**
```bash
pip install google-ads
```

**Configuración:**
```yaml
# google-ads.yaml
developer_token: INSERT_DEVELOPER_TOKEN_HERE
client_id: INSERT_CLIENT_ID_HERE
client_secret: INSERT_CLIENT_SECRET_HERE
refresh_token: INSERT_REFRESH_TOKEN_HERE
login_customer_id: INSERT_LOGIN_CUSTOMER_ID_HERE
```

**Uso:**
```python
from google.ads.googleads.client import GoogleAdsClient

client = GoogleAdsClient.load_from_storage('google-ads.yaml')
ga_service = client.get_service('GoogleAdsService')

query = """
    SELECT campaign.id, campaign.name
    FROM campaign
    ORDER BY campaign.id"""

stream = ga_service.search_stream(
    customer_id='1234567890',
    query=query
)

for batch in stream:
    for row in batch.results:
        print(f"Campaign: {row.campaign.id}, {row.campaign.name}")
```

---

## 🔐 Autenticación OAuth 2.0

### Escenarios soportados

| Escenario | Método recomendado |
|-----------|-------------------|
| **App que gestiona cuentas propias** | Service Account |
| **App que gestiona cuentas de otros usuarios** | Multi-user authentication |
| **App que ya usa otras APIs de Google** | Reusar OAuth existente |

### Flujo Service Account

1. Crear Service Account en Google Cloud Console
2. Descargar JSON key file
3. Dar acceso a la cuenta de Google Ads
4. Configurar:
   ```
   GOOGLE_ADS_JSON_KEY_FILE_PATH=/path/to/key.json
   GOOGLE_ADS_DEVELOPER_TOKEN=xxx
   ```

### Flujo Multi-user

1. Crear OAuth credentials en Google Cloud Console
2. Redirigir usuario a URL de autorización
3. Intercambiar código por refresh token
4. Almacenar refresh token por usuario

---

## 📋 Prerequisitos para Client 002 (Tours)

### Lo que necesito del cliente:

| Requisito | Cómo obtenerlo |
|-----------|----------------|
| **Developer Token** | Solicitar en Google Ads API Center |
| **OAuth Client ID** | Crear en Google Cloud Console |
| **OAuth Client Secret** | Crear en Google Cloud Console |
| **Refresh Token** | Flujo OAuth inicial |
| **Customer ID** | Desde Google Ads UI (XXX-XXX-XXXX) |

### Pasos de setup:

1. **Developer Token:**
   - Ir a: https://ads.google.com/aw/apicenter
   - Solicitar acceso a la API
   - Aprobación puede tomar días

2. **OAuth Credentials:**
   - Ir a: https://console.cloud.google.com/apis/credentials
   - Crear OAuth 2.0 Client ID
   - Tipo: Web application o Desktop app
   - Añadir redirect URI

3. **Refresh Token:**
   - Usar OAuth playground o script propio
   - Scope: `https://www.googleapis.com/auth/adwords`

---

## 🛠️ Herramientas OpenClaw Disponibles

### Skills relacionados con Google:

| Skill | Función | Incluye Google Ads |
|-------|---------|-------------------|
| **gog** | Google Workspace | ❌ No (Gmail, Calendar, Drive, Sheets) |
| **mcporter** | MCP servers | ⚠️ Depende de encontrar MCP server |

### Posibles soluciones:

1. **Crear skill personalizado** usando `skill-creator`
2. **Usar exec + curl** para API REST directo
3. **Instalar librería NodeJS** y crear wrapper

---

## 💡 Recomendación

### Para Client 002 (Tours):

**Opción más rápida:**
```
1. Usar exec + curl para API REST directo
2. Almacenar tokens en variables de entorno
3. Crear funciones helper en TOOLS.md
```

**Opción más robusta:**
```
1. Crear skill personalizado google-ads
2. Usar NodeJS library google-ads-api
3. Implementar flujo OAuth
```

---

## 📚 Fuentes Consultadas

1. **Google Ads API Overview** - https://developers.google.com/google-ads/api/docs/get-started/introduction
2. **OAuth 2.0 for Google Ads API** - https://developers.google.com/google-ads/api/docs/oauth/overview
3. **Client Libraries** - https://developers.google.com/google-ads/api/docs/client-libs
4. **OpenClaw Skills Directory** - /usr/lib/node_modules/openclaw/skills/

---

_Creado: 2026-02-27 | Investigación: API connection methods_
