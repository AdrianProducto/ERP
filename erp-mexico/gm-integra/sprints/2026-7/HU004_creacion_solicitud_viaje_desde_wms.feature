# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 1 – Recepción e integración operativa desde WMS
# HU         : HU-004
# NOMBRE     : Creación de solicitud de viaje en GM Transport ERP
#              vía API SolicitudViaje/Agregar
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 3.0  ← actualizada con documentación real de la API
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# GM Integra llama a la API real de GM Transport ERP para crear
# solicitudes de viaje.  El mecanismo NO es el Portal web sino
# un endpoint REST documentado:
#
# ENDPOINT CONFIRMADO:
#   POST https://appapitest.gmtransport.co/api/SolicitudViaje/Agregar
#
# AUTENTICACIÓN (Basic Auth — diferente a OAuth 2.0):
#   Header Authorization : basic {Base64(Usuario:Contraseña)}
#   Header RFC           : RFC del cliente (ej. GGT081209393)
#   Header Aplicacion    : 4  (valor fijo para este endpoint)
#   Header Content-Type  : application/json
#   Nota: el Usuario/Contraseña lo genera GM Transport ERP desde
#         el apartado Clientes/Contactos → opción Portal de Cliente
#
# CAMPOS DEL BODY (JSON) — campos obligatorios marcados con *:
#   LoadNumber*    String  Max 20 — identificador del viaje
#   Origen*        String  Max 70 — origen del viaje
#   Destino*       String  Max 70 — destino del viaje
#   EntregarEn*    String  Max 100 — lugar de entrega de mercancía
#   RecogerEn*     String  Max 100 — lugar de recolección
#   Observaciones  String  Max 512 — notas adicionales
#   Peso           Decimal 15,4 — peso estimado
#
# SOLICITUDES MASIVAS:
#   Se pueden enviar múltiples solicitudes en un solo POST dentro
#   del nodo SolicitudesViaje[].
#
# RESPUESTA EXITOSA (HTTP 200):
#   { "Content": [{ "Success": true,
#       "SolicitudesViaje": [
#         { "LoadNumber": "...", "IdSolicitud": "..." }
#       ]
#   }]}
#   → El ERP devuelve LoadNumber + IdSolicitud por cada solicitud.
#   → IdSolicitud es la llave única para consultas posteriores.
#
# REGLA DE NEGOCIO IMPORTANTE:
#   Las solicitudes creadas desde la API solo pueden ser aceptadas
#   como Carta Porte (no como viaje normal).
#   Al aceptar, el operador de GM Transport define cuántos viajes
#   crear de esa solicitud (1 a 99).
#
# MAPEO XML WMS → BODY JSON API ERP:
#   facility_code / route_nbr  → Origen / Destino
#   facility_code (dirección)  → RecogerEn
#   route_nbr (destino)        → EntregarEn
#   load_manifest_nbr          → LoadNumber
#   total_weight               → Peso
#   (campo libre)              → Observaciones
# -----------------------------------------------------------------

Feature: HU-004 – Creación de solicitud de viaje en GM Transport ERP vía API SolicitudViaje/Agregar

  Como sistema API de GM Transport (GM Integra),
  quiero crear solicitudes de viaje en GM Transport ERP llamando al endpoint
  POST /api/SolicitudViaje/Agregar con los datos del XML del WMS transformados a JSON,
  para que el equipo operativo de GM Transport pueda gestionar y aceptar
  el servicio de transporte solicitado por Grupo Andrea.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Creación exitosa de solicitud de viaje individual vía API ERP

    # Dado que el XML del WMS fue validado y sus datos están listos para enviarse
    Given que el XML del WMS con MessageId "<message_id>" tiene estado "MATERIALES_REGISTRADOS"
    And GM Integra construye el body JSON con los campos:
        LoadNumber "<load_number>",
        Origen "<origen>",
        Destino "<destino>",
        EntregarEn "<entregar_en>",
        RecogerEn "<recoger_en>",
        Observaciones "<observaciones>" y
        Peso "<peso>"
    And el header Authorization contiene "basic <token_base64>"
    And el header RFC contiene "<rfc_cliente>"
    And el header Aplicacion contiene "4"

    # Cuando GM Integra envía el POST al endpoint del ERP
    When GM Integra realiza POST a "/api/SolicitudViaje/Agregar" con el body JSON

    # Entonces el ERP crea la solicitud y devuelve el IdSolicitud
    Then el ERP responde con código HTTP 200
    And la respuesta incluye "Success": true
    And la respuesta incluye el nodo SolicitudesViaje con:
        LoadNumber "<load_number>" e IdSolicitud "<id_solicitud>"
    And GM Integra almacena la correlación:
        MessageId "<message_id>" ↔ LoadNumber "<load_number>" ↔ IdSolicitud "<id_solicitud>"
    And el registro de trazabilidad se actualiza a estado "SOLICITUD_VIAJE_CREADA"

    Examples:
      | message_id              | load_number     | origen            | destino                      | entregar_en  | recoger_en | observaciones      | peso    | rfc_cliente   | token_base64         | id_solicitud |
      | MSG-WMS-20260223-000001 | LN-20260223-001 | Mexicali, BC      | San Luis Rio Colorado, Sonora| GM Transport | Flex       | Solicitud WMS      | 1500.00 | GGT081209393  | dXNlcjpwYXNz     | 26           |
      | MSG-WMS-20260223-000002 | LN-20260223-002 | Guadalajara, Jal  | Tepic, Nayarit               | CD Tepic     | WH-GDL-02  | Solicitud WMS      | 800.00  | GGT081209393  | dXNlcjpwYXNz     | 27           |

  Scenario Outline: Creación masiva de solicitudes de viaje en un solo POST

    # Dado que GM Integra tiene múltiples XML validados pendientes de crear en ERP
    Given que GM Integra tiene "<total_solicitudes>" solicitudes listas para enviar
    And GM Integra construye un body JSON con el nodo SolicitudesViaje[] con "<total_solicitudes>" elementos
    And cada elemento tiene LoadNumber, Origen, Destino, EntregarEn y RecogerEn válidos
    And los headers Authorization, RFC y Aplicacion están correctamente configurados

    # Cuando GM Integra envía el POST masivo al endpoint del ERP
    When GM Integra realiza POST a "/api/SolicitudViaje/Agregar" con el body masivo

    # Entonces el ERP crea todas las solicitudes y devuelve un IdSolicitud por cada una
    Then el ERP responde con código HTTP 200
    And la respuesta incluye "Success": true
    And el nodo SolicitudesViaje[] contiene "<total_solicitudes>" elementos
    And cada elemento incluye su LoadNumber e IdSolicitud correspondiente
    And GM Integra almacena la correlación de cada LoadNumber con su IdSolicitud
    And el registro de trazabilidad registra "<total_solicitudes>" eventos "SOLICITUD_VIAJE_CREADA"

    Examples:
      | total_solicitudes |
      | 2                 |
      | 5                 |
      | 10                |

  Scenario Outline: Verificación de que la solicitud creada aparece en ERP con estatus PENDIENTE

    # Dado que la solicitud fue creada exitosamente con IdSolicitud conocido
    Given que la solicitud con IdSolicitud "<id_solicitud>" fue creada en el ERP
    And GM Integra consulta el endpoint GET /api/SolicitudViaje/Consultar/<id_solicitud>

    # Cuando el ERP responde a la consulta
    When GM Integra evalúa la respuesta de la consulta

    # Entonces la solicitud aparece como pendiente en el ERP
    Then la respuesta incluye Motivo "La solicitud de viaje esta pendente"
    And el registro de trazabilidad confirma estado "SOLICITUD_VERIFICADA_PENDIENTE"

    Examples:
      | id_solicitud |
      | 26           |
      | 27           |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en la creación de solicitud por error en la API del ERP

    # Dado que GM Integra intenta crear la solicitud pero el ERP responde con error
    Given que GM Integra envía el POST a "/api/SolicitudViaje/Agregar"
    And la petición presenta la condición de error "<condicion_error>"

    # Cuando el ERP procesa la petición
    When GM Integra evalúa la respuesta del ERP

    # Entonces el fallo se gestiona y se registra en trazabilidad
    Then el ERP responde con código "<http_code>" o faultcode "<fault_code>"
    And GM Integra registra el fallo con código "<error_code>" en trazabilidad
    And el estado en trazabilidad se actualiza a "ERROR_CREACION_VIAJE"
    And el mensaje queda en cola de errores para revisión manual
    And se genera alerta al equipo de soporte

    Examples:
      | condicion_error                                        | http_code | fault_code | error_code                    |
      | Nodo LoadNumber ausente en el JSON                     | 400       | 1          | ERP_MISSING_LOAD_NUMBER       |
      | Campo obligatorio vacío (Origen, Destino, etc.)        | 400       | 2          | ERP_MISSING_REQUIRED_FIELD    |
      | Credenciales Basic Auth inválidas o expiradas          | 401       | 401        | ERP_AUTH_ERROR                |
      | ERP no disponible (timeout de conexión)                | 500       | -          | ERP_CONNECTION_TIMEOUT        |
      | ERP responde con error interno 500                     | 500       | -          | ERP_INTERNAL_ERROR            |
      | LoadNumber excede 20 caracteres                        | 400       | 2          | ERP_LOAD_NUMBER_TOO_LONG      |
      | Origen excede 70 caracteres                            | 400       | 2          | ERP_FIELD_TOO_LONG            |

  # ----------------------------------------------------------------
  # CAMBIOS RESPECTO A VERSIONES ANTERIORES
  # ----------------------------------------------------------------
  # [v3] Mecanismo real confirmado por documentación API:
  #      - Endpoint: POST /api/SolicitudViaje/Agregar
  #      - Auth: Basic Auth Base64(Usuario:Contraseña), NO OAuth 2.0
  #      - Body: JSON con nodo SolicitudesViaje[]
  #      - Respuesta: LoadNumber + IdSolicitud por cada solicitud
  #      - Permite envío masivo en un solo POST
  #      - Solicitudes API solo aceptables como Carta Porte
  #
  # [DUDA-004-G] ¿El token Basic Auth de GM Integra hacia el ERP
  #              se configura una sola vez o rota periódicamente?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de ERP.
  #
  # [DUDA-004-H] ¿El campo Aplicacion=4 es fijo para todos los
  #              entornos (dev, staging, prod) o varía?
  #              → SUPUESTO TÉCNICO: fijo en 4. Confirmación requerida.
  # ----------------------------------------------------------------
