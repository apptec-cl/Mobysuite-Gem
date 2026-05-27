# Gema `mobysuite` — Guía para IA

Documento de referencia destinado a un agente/IA que necesita consumir esta gema. Describe arquitectura, autenticación, convenciones de llamada y el contrato de cada método público.

- **Nombre:** `mobysuite`
- **Versión actual:** `0.3.10` ([version.rb](lib/mobysuite/version.rb))
- **Lenguaje:** Ruby (`.ruby-version` fija la versión del proyecto)
- **Dependencias runtime:** `httparty`, `dotenv`
- **Propósito:** cliente HTTP para la API GC2 de Mobysuite (`https://<domain>-api.mobysuite.com/v1/api/...`).

---

## 1. Arquitectura

```
Mobysuite (módulo raíz)
└── GC2 (espacio de la API GC2)
    ├── Quote        — cotizaciones
    ├── Prospect     — leads / chatbot / badge
    ├── Asset        — bienes (departamentos, estacionamientos, bodegas)
    ├── Project      — proyectos inmobiliarios
    ├── Parameter    — tablas de parámetros
    ├── Booking      — reservas
    ├── Opportunity  — oportunidades / cálculo de pie
    ├── Amc          — Asistente Mobysuite Cliente (documentos / sidebar / content)
    ├── Contract     — contratos (listar / reversar)
    ├── Meet         — Mobymeet (videollamadas)
    ├── Payment      — pagos
    ├── Client       — clientes (búsqueda por RUT)
    ├── Firm         — confirmación de firma digital
    └── Deed         — escrituras (fecha de entrega)
```

Todas las clases heredan de `AuthorizationGc2` ([auth.rb](lib/mobysuite/auth.rb)), que centraliza:

- Lectura de credenciales (`.env` o argumentos del constructor).
- Obtención del bearer token vía OAuth2 `client_credentials`.
- Construcción del request HTTP con `HTTParty` (GET/POST/PUT).
- Normalización de la respuesta a `{ response: <bool>, body: <parsed>, response_code: <int?> }`.

Constante de namespace: `NAMESPACE = "v1/api"`.
URL final: `https://<domain>-api.mobysuite.com/v1/api/<path>`.

---

## 2. Autenticación

### 2.1 Credenciales

Se leen en este orden:

1. Variables de entorno (vía `dotenv`, archivo `.env`):
   - `MOBYSUITE_GC2_CLIENT_ID`
   - `MOBYSUITE_GC2_CLIENT_SECRET`
2. Si no están definidas, se usan los argumentos pasados al constructor.

Ejemplo `.env`:

```bash
MOBYSUITE_GC2_CLIENT_ID=tu_client_id
MOBYSUITE_GC2_CLIENT_SECRET=tu_client_secret
```

### 2.2 Constructor común

Todas las clases comparten la misma firma:

```ruby
ClassName.new(domain, client_id = nil, client_secret = nil)
```

- `domain` (**obligatorio**): subdominio del cliente (ej. `"try"`, `"demo"`, `"midomain"`). Se inyecta en la URL: `https://try-api.mobysuite.com/...`.
- `client_id`, `client_secret`: opcionales si están en `.env`.

El constructor de cada clase llama a `auth` y guarda el token internamente, así que **no es necesario autenticar manualmente** antes de invocar métodos.

```ruby
require 'mobysuite'

quote = Mobysuite::GC2::Quote.new("try")
# token ya disponible vía @token
```

### 2.3 Formato de respuesta universal

`set_sender` siempre devuelve:

```ruby
{ response: true,  body: <parsed_response> }                       # 200, 201
{ response: false, body: <parsed_response>, response_code: 401 }   # reintenta auth
{ response: false, body: <parsed_response>, response_code: 4xx/5xx }
```

Para verificar éxito: `result[:response] == true`. Datos en `result[:body]`.

---

## 3. Convenciones de los métodos

- Los métodos reciben un `Hash` (con `symbol` keys) llamado normalmente `payload` o `data`.
- Las claves del hash de entrada usan **snake_case** (`project_id`, `client_rut`).
- Internamente se mapean a las claves **camelCase** que espera la API (`projectId`, `cName`).
- Los campos opcionales se incluyen sólo si no son `nil` (patrón `payload.merge!(key: data[:x]) unless data[:x].nil?`).
- Los métodos `list` aceptan `page` y `size` para paginación; por defecto `0/0`.

---

## 4. Referencia por clase

> Nota: los nombres de claves de entrada se documentan tal como aparecen en el código fuente. Algunos endpoints aceptan claves mixtas (snake_case y camelCase) — usar exactamente las indicadas.

### 4.1 `Mobysuite::GC2::Quote` — [quote.rb](lib/mobysuite/gc2/quote.rb)

#### `create(payload)`
`POST integrations/quotes`

Crea una cotización.

**Claves obligatorias:** `rut` (o `dni`), `fName`, `lName`, `email`, `phone`, `source`, `contact`, `project_id`, `assets`.

**Claves opcionales:** `dni`, `userId`, `profesion`, `comuna`, `ageRange`, `destinationPurchase`, `receiveNews`, `observation`, `rentRange`, `sex`, `discountId`, `utm_campaign`, `utm_content`, `utm_medium`, `utm_source`, `utm_term`.

```ruby
quote.create(
  rut: "14603229-k",
  fName: "Pepe", lName: "Cuenca",
  email: "pepe@cuenca.com", phone: "+56986565633",
  source: "COTIZADOR WEB", contact: "COTIZADOR WEB",
  project_id: 5,
  assets: [{ id: 1234 }]
)
```

---

### 4.2 `Mobysuite::GC2::Prospect` — [prospect.rb](lib/mobysuite/gc2/prospect.rb)

#### `create(data)`
`POST integrations/customers`

Crea un prospecto/lead.

**Claves principales:** `rut`, `fName`, `lName`, `bussines_name_type`, `email`, `phone`, `rango_renta`, `information_medium`, `observation`, `source` (default `"CENTRALIZADOR"`), `cip`, utm_*, `isSync` (default `false`), `dni` (default `false`).
**Identificación de proyecto:** `project_name` **o** `project_id` (excluyente).
**Opcionales:** `tipo_comprador`, `user_id`.

```ruby
prospect.create(
  rut: "17.810.699-6",
  fName: "Soporte", lName: "Mobysuite",
  bussines_name_type: "PERSONA_NATURAL",
  email: "soporte@mobysuite.com", phone: "+56972154899",
  project_id: 1,
  information_medium: "INSTAGRAM"
)
```

#### `badge(data)`
`POST integrations/badge`

Crea un badge (notificación de canal — WhatsApp, etc).

**Claves:** `module`, `value`, `message`, `chatbot`, `phone_id`. Opcionales: `project_id`, `chatb_id`, `asset_id`.

#### `chatbot(data)`
`POST integrations/chatbot`

Registra interacción de chatbot. **Claves:** `phone`, `chatbot`. Opcional: `project_id`.

---

### 4.3 `Mobysuite::GC2::Asset` — [asset.rb](lib/mobysuite/gc2/asset.rb)

#### `list(payload)`
`GET integrations/assets?...`

Lista bienes disponibles filtrando por query string.
**Filtros:** `project_id`, `department_typology`, `asset_number`, `asset_type`, `project_stage`, `page` (def. 0), `size` (def. 0). Los `nil` se descartan.

```ruby
asset.list(project_id: 5)
```

#### `list_all(payload)`
`GET integrations/assets/all-assets?...` — mismos filtros que `list`, incluye no disponibles.

#### `types(payload)`
`GET integrations/asset-types/project/<project_id>?page=&size=`

Tipos de bien por proyecto. `project_id` es **obligatorio**.

#### `client_assets_project(payload)`
`GET integrations/assets/list-client-assets-by-project?project=<project_id>`

Bienes de cliente por proyecto. Clave: `project_id`.

#### `edit(payload)`
`POST integrations/assets` (envía `[payload]`)

Edita un bien. Opcionales: `asset_status`, `id`, `id_erp`.

---

### 4.4 `Mobysuite::GC2::Project` — [project.rb](lib/mobysuite/gc2/project.rb)

#### `list(payload = nil)`
`GET integrations/projects`

Lista proyectos. Paginación: `page`, `size`.

---

### 4.5 `Mobysuite::GC2::Parameter` — [parameter.rb](lib/mobysuite/gc2/parameter.rb)

#### `table(payload)`
`GET integrations/parameters/table/<payload>`

`payload` es el identificador de la tabla (string/symbol) — se concatena a la URL.

---

### 4.6 `Mobysuite::GC2::Booking` — [booking.rb](lib/mobysuite/gc2/booking.rb)

#### `create(payload)`
`POST integrations/booking`

**Claves:** `quote_code`, `auth_code`, `card_number`, `total_payments`, `interest_free_payments`, `rut`, `first_name`, `last_name`, `email`, `phone`, `address`, `number`, `commune`, `city`, `tipe_pay`.

---

### 4.7 `Mobysuite::GC2::Opportunity` — [opportunity.rb](lib/mobysuite/gc2/opportunity.rb)

#### `list(payload = nil)`
`GET integrations/assets/available-opportunities[?project=<id>]`

Opcionales: `project`, `page`, `size`.

#### `calculate_payment_plan(payload)`
`POST integrations/assets/calculate-payment-plan`

**Claves:** `discountId`, `assets`, `customer`.

---

### 4.8 `Mobysuite::GC2::Amc` — [amc.rb](lib/mobysuite/gc2/amc.rb)

| Método | Endpoint | Clave |
|--------|----------|-------|
| `documents(payload)` | `GET integrations/amc/documents/<contract_id>` | `contract_id` |
| `sidebar(payload)` | `GET integrations/amc/sidebar-content/<project_id>` | `project_id` |
| `content(payload)` | `GET integrations/amc/content/<project_id>` | `project_id` |

---

### 4.9 `Mobysuite::GC2::Contract` — [contract.rb](lib/mobysuite/gc2/contract.rb)

#### `list(payload = {})`
`GET integrations/contracts?...`

**Filtros opcionales (al menos uno recomendado):**
- `contract_format` → `cFormat`
- `client_id` → `cId`
- `client_rut` → `cName`
- `e_contract` → `eContract`
- `contract_id` → `contract`

```ruby
contract.list(client_rut: "19464782-4")
contract.list(client_id: 96759)
contract.list(e_contract: 3)
```

#### `reverse(data = {})`
`POST integrations/contracts/reverse`

Reversa/desistimiento de contrato. **Identificación (excluyente):** `contract_id` **o** la pareja `numero_bien` + `tipo_bien`.

**Datos opcionales del desistimiento:** `tipo`, `monto`, `multa`, `multa_moneda_local`, `devolucion`, `retencion`, `observacion`.

```ruby
contract.reverse(
  numero_bien: "E-15",
  tipo_bien: "ESTACIONAMIENTO",
  tipo: "DESISTIMIENTO",
  monto: 1500.0,
  devolucion: 1500.0,
  observacion: "Desistimiento dentro del plazo legal"
)
```

---

### 4.10 `Mobysuite::GC2::Meet` — [meet.rb](lib/mobysuite/gc2/meet.rb)

#### `create(data)`
`POST integrations/mobymeet`

Agenda Mobymeet. **Claves:** `dni`, `rut`, `fName`, `lName`, `email`, `phone`, `informationMedium`, `observation`, `token`, `users`, `project_id`, `fechaProgramada`. `contactType` se fija a `"MOBYMEET"`.

#### `accept_reject(data)`
`POST integrations/mobymeet/accept-reject`

**Claves:** `id` (→ `contactEventId`), `accept` (→ `status`). Opcionales: `observation`, `urlVideoConf`.

---

### 4.11 `Mobysuite::GC2::Payment` — [payment.rb](lib/mobysuite/gc2/payment.rb)

#### `find(payment_code)`
`GET integrations/payments?paymentCode=<payment_code>` — recibe el código directo, no un hash.

#### `pay(data)`
`POST integrations/payments`

**Claves:** `pay_code`, `auth_code`, `card_number`, `amount`, `total_payments`, `interest_free_payments`. Opcional: `tipePay`.

#### `active_payment_info(data)`
`GET integrations/payments/add-automated-payments-info?...`

Recibe `asset_id` **o** `contract_id`, más `type`.

---

### 4.12 `Mobysuite::GC2::Client` — [client.rb](lib/mobysuite/gc2/client.rb)

#### `list(payload = nil)`
`GET integrations/customers/rut/<rut>`

**Clave:** `rut` (obligatoria). Opcionales `page`, `size`.

---

### 4.13 `Mobysuite::GC2::Firm` — [firm.rb](lib/mobysuite/gc2/firm.rb)

#### `accept(data)`
`POST integrations/digitalSignatureConfirmation`

**Clave principal:** `portfolio_id`. Opcionales: `members`, `is_autorized`, `is_promise`, `url_signed_document`.

---

### 4.14 `Mobysuite::GC2::Deed` — [deed.rb](lib/mobysuite/gc2/deed.rb)

#### `delivery_date(payload)`
`POST integrations/deed/process/delivery-date`

**Claves:** `id_erp` (→ `idsErp`), `date` (→ `fecha`).

---

## 5. Patrón de uso típico

```ruby
require 'mobysuite'

# 1) instanciar (auth automática)
asset = Mobysuite::GC2::Asset.new("try")
quote = Mobysuite::GC2::Quote.new("try")

# 2) llamar al endpoint
assets_resp = asset.list(project_id: 5)
return unless assets_resp[:response]

available = assets_resp[:body].select do |a|
  a["assetType"]["isPrimary"] && a["status"] == "DISPONIBLE"
end
sample = available.sample

# 3) crear cotización
quote_resp = quote.create(
  rut: "14603229-k", fName: "Pepe", lName: "Cuenca",
  email: "pepe@cuenca.com", phone: "+56986565633",
  source: "COTIZADOR WEB", contact: "COTIZADOR WEB",
  project_id: 5, assets: [{ id: sample["id"] }]
)

if quote_resp[:response]
  puts "OK: #{quote_resp[:body]}"
else
  puts "Error #{quote_resp[:response_code]}: #{quote_resp[:body]}"
end
```

---

## 6. Manejo de errores

- `set_sender` nunca lanza excepciones HTTP — siempre devuelve un hash. Validar `result[:response]` antes de usar `result[:body]`.
- En `401` la gema intenta reautenticarse (`auth(1)`) automáticamente; igual devuelve `response: false` para esa llamada — el caller decide si reintentar.
- `auth` reintenta hasta 3 veces y luego hace `raise "[Autorization] Problem obtain token"`.
- Errores de red u otros se devuelven como `{ token: nil, response: false, msg: <exception> }` cuando ocurren durante la autenticación.

---

## 7. Cómo agregar un nuevo endpoint (para mantenimiento)

1. Crear `lib/mobysuite/gc2/<nombre>.rb` con clase que herede de `AuthorizationGc2`.
2. Definir constructor estándar (3 líneas — ver cualquier clase existente).
3. Implementar el método usando:
   - Hash de payload con claves camelCase para la API.
   - `payload.merge!(api_key: data[:snake_key]) unless data[:snake_key].nil?` para opcionales.
   - `set_sender("GET"|"POST"|"PUT", "integrations/<ruta>", payload)`.
4. Añadir `require "mobysuite/gc2/<nombre>"` en [lib/mobysuite.rb](lib/mobysuite.rb).
5. Crear `spec/<nombre>_spec.rb` siguiendo el patrón de los specs existentes (`Mobysuite::GC2::<Clase>.new("try")`).

---

## 8. Tests

```bash
# todos
rspec spec

# uno
rspec spec/client_spec.rb
```

Los specs apuntan al dominio `try` (entorno de pruebas público de Mobysuite). Requieren `MOBYSUITE_GC2_CLIENT_ID` / `MOBYSUITE_GC2_CLIENT_SECRET` válidos en `.env`.

---

## 9. Build & release

```bash
gem build mobysuite.gemspec    # genera mobysuite-<version>.gem
```

Bump de versión en [lib/mobysuite/version.rb](lib/mobysuite/version.rb).
