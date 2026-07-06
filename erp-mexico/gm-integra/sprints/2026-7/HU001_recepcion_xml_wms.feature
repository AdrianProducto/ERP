# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 1 – Recepción e integración operativa desde WMS
# HU         : HU-001
# NOMBRE     : Recepción de XML desde WMS
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 2.0  ← actualizada con impacto de documentación API real
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# El WMS de Grupo Andrea envía información de cargas despachadas
# a GM Integra mediante un endpoint REST en formato XML.
# GM Integra acusa recibo, registra el mensaje y lo encola para
# su posterior validación (HU-002) y transformación a JSON (HU-004).
#
# IMPACTO DE LA DOCUMENTACIÓN REAL DE LA API DEL ERP:
# El campo load_manifest_nbr del XML se mapea al campo LoadNumber
# de la API SolicitudViaje/Agregar, que tiene un máximo de 20
# caracteres.  Por ello, GM Integra debe verificar desde la
# recepción que load_manifest_nbr no excede este límite.
#
# FLUJO POSTERIOR AL ACUSE DE RECIBO:
#   GM Integra recibe XML → acusa recibo al WMS →
#   encola para validación estructural (HU-002) →
#   registra en bitácora con correlationId →
#   prepara para transformación XML→JSON (HU-004)
#
# AUTENTICACIÓN DEL WMS HACIA GM INTEGRA:
#   OAuth 2.0 Client Credentials (HU-015)
#   Header Authorization: Bearer {access_token}
#   OriginSystem: WMS-GA
# -----------------------------------------------------------------

Feature: HU-001 – Recepción del mensaje XML enviado por WMS

  Como sistema API de GM Transport (GM Integra),
  quiero recibir y acusar de recibo el XML enviado por el WMS de Grupo Andrea,
  para garantizar que ningún mensaje se pierda, que el WMS tenga confirmación
  del ingreso y que el mensaje quede encolado para validación y posterior
  transformación al formato JSON requerido por la API del ERP.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Recepción exitosa del XML de WMS

    # Dado que el WMS envía un XML válido con credenciales correctas
    Given que el WMS realiza una petición POST al endpoint "<endpoint>"
    And el header "Content-Type" tiene el valor "application/xml"
    And el header "Authorization" contiene un Bearer token OAuth 2.0 válido
    And el cuerpo contiene un XML con nodo raíz válido, nodo <Header> y nodo <ListOfShippedLoads>
    And el campo "MessageId" del nodo <Header> tiene el valor "<message_id>"
    And el campo "OriginSystem" del nodo <Header> tiene el valor "WMS-GA"
    And el campo "load_manifest_nbr" dentro del nodo <load> tiene el valor "<load_manifest_nbr>"
    And el campo "load_manifest_nbr" tiene como máximo 20 caracteres

    # Cuando la API procesa la petición entrante
    When GM Integra recibe y procesa la petición del WMS

    # Entonces la API confirma la recepción al WMS
    Then la API responde con código HTTP 202
    And la respuesta incluye el campo "status" con valor "RECEIVED"
    And la respuesta incluye el campo "messageId" con valor "<message_id>"
    And la respuesta incluye un campo "correlationId" generado por GM Integra
    And el evento queda registrado en bitácora con estado "RECIBIDO" y origin "WMS-GA"
    And el mensaje queda encolado para validación estructural (HU-002)

    Examples:
      | endpoint                      | message_id              | load_manifest_nbr   |
      | /api/v1/wms/shipped-loads     | MSG-WMS-20260223-000001 | LN-20260223-001     |
      | /api/v1/wms/shipped-loads     | MSG-WMS-20260223-000002 | LN-20260223-002     |
      | /api/v1/wms/shipped-loads     | MSG-WMS-20260223-000003 | MAN-2026-0000003    |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Recepción fallida del XML de WMS por error en la petición

    # Dado que el WMS envía una petición con algún problema
    Given que el WMS realiza una petición POST al endpoint "/api/v1/wms/shipped-loads"
    And la petición presenta la condición de error "<condicion_error>"

    # Cuando la API evalúa la petición entrante
    When GM Integra evalúa la petición del WMS

    # Entonces la API rechaza la petición con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And la respuesta incluye el campo "errorMessage" con descripción legible
    And el evento queda registrado en bitácora con estado "RECHAZADO" y la causa
    And NO se encola ningún mensaje para procesamiento posterior

    Examples:
      | condicion_error                                        | http_code | error_code                    |
      | Token OAuth 2.0 ausente en el header Authorization     | 401       | AUTH_MISSING_TOKEN            |
      | Token OAuth 2.0 inválido o expirado                    | 401       | AUTH_INVALID_TOKEN            |
      | Content-Type diferente de application/xml              | 415       | UNSUPPORTED_MEDIA_TYPE        |
      | Cuerpo de la petición vacío                            | 400       | EMPTY_REQUEST_BODY            |
      | Método HTTP incorrecto (GET en lugar de POST)          | 405       | METHOD_NOT_ALLOWED            |
      | Endpoint incorrecto / no encontrado                    | 404       | ENDPOINT_NOT_FOUND            |
      | load_manifest_nbr excede 20 caracteres                 | 422       | LOAD_NUMBER_EXCEEDS_MAX_LENGTH|

  # ----------------------------------------------------------------
  # CAMBIOS v2 — IMPACTO API REAL
  # ----------------------------------------------------------------
  # [v2] load_manifest_nbr → LoadNumber en API ERP (max 20 chars)
  #      Se agrega validación de longitud desde la recepción.
  #      Si load_manifest_nbr > 20 chars → rechazo con 422.
  #
  # [DUDA-001-A] ¿El mecanismo de autenticación WMS→GM Integra es
  #              OAuth 2.0 client_credentials o mTLS?
  #              → SUPUESTO TÉCNICO: OAuth 2.0. Confirmación pendiente.
  #
  # [DUDA-001-B] ¿Se requiere whitelist de IPs para el WMS?
  #              → PENDIENTE con seguridad/infraestructura.
  # ----------------------------------------------------------------
