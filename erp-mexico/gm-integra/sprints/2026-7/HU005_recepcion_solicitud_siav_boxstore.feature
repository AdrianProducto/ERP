# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 2 – Recepción de solicitudes desde SIAV y Box Store
# HU         : HU-005
# NOMBRE     : Recepción de solicitud XML desde SIAV / Box Store
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# SIAV y Box Store son los sistemas de gestión de sucursales de
# Grupo Andrea.  Cuando una sucursal necesita recibir mercancía
# desde otra sucursal o desde un punto de origen, genera una
# solicitud de traslado que se envía a la API de GM Transport
# en formato XML vía REST, al mismo endpoint que usa el WMS.
#
# La diferenciación entre sistemas origen se hace mediante el
# campo OriginSystem del nodo Header del XML:
#   - WMS       → "WMS-GA"
#   - SIAV      → "SIAV-GA"
#   - Box Store → "BOXSTORE-GA"
#
# Al ser el mismo endpoint y el mismo formato base que el WMS,
# esta HU reutiliza la misma lógica de recepción (HU-001), pero
# cubre las particularidades del origen y tipo de solicitud:
# traslado de mercancía entre sucursales.
# -----------------------------------------------------------------

Feature: HU-005 – Recepción de solicitud XML de traslado desde SIAV y Box Store

  Como sistema API de GM Transport,
  quiero recibir y acusar de recibo las solicitudes XML enviadas por SIAV y Box Store,
  diferenciándolas del WMS mediante el campo OriginSystem,
  para garantizar que cada solicitud de traslado entre sucursales
  quede registrada, trazada y procesada según su sistema de origen.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Recepción exitosa de solicitud XML desde SIAV o Box Store

    # Dado que SIAV o Box Store envían una solicitud XML válida
    Given que el sistema "<origin_system>" realiza una petición POST al endpoint "/api/v1/transfers/request"
    And el header "Content-Type" tiene el valor "application/xml"
    And el header de autenticación "<auth_header>" contiene un token o API Key válido
    And el XML contiene el nodo <Header> con los campos obligatorios
    And el campo "OriginSystem" del nodo <Header> tiene el valor "<origin_system_code>"
    And el campo "MessageId" tiene el valor "<message_id>"
    And el campo "ParentCompanyCode" identifica a Grupo Andrea
    And el XML contiene el nodo de solicitud de traslado con datos de origen y destino de sucursal

    # Cuando la API procesa la petición entrante
    When la API de GM Transport recibe y procesa la petición de "<origin_system>"

    # Entonces la API acusa recibo y registra el origen correctamente
    Then la API responde con código HTTP 202
    And el cuerpo de la respuesta incluye el campo "status" con valor "RECEIVED"
    And el cuerpo de la respuesta incluye el campo "messageId" con valor "<message_id>"
    And el cuerpo de la respuesta incluye el campo "originSystem" con valor "<origin_system_code>"
    And el cuerpo de la respuesta incluye un campo "correlationId" generado por la API
    And el evento queda registrado en bitácora con estado "RECIBIDO" y origen "<origin_system_code>"

    Examples:
      | origin_system | origin_system_code | auth_header | message_id               |
      | SIAV          | SIAV-GA            | X-API-Key   | MSG-SIAV-20260227-000001 |
      | SIAV          | SIAV-GA            | X-API-Key   | MSG-SIAV-20260227-000002 |
      | Box Store     | BOXSTORE-GA        | X-API-Key   | MSG-BS-20260227-000001   |
      | Box Store     | BOXSTORE-GA        | X-API-Key   | MSG-BS-20260227-000002   |

  Scenario Outline: Identificación correcta del sistema origen en el mismo endpoint

    # Dado que dos sistemas distintos envían al mismo endpoint
    Given que la API recibió dos peticiones POST al endpoint "/api/v1/transfers/request"
    And la primera petición tiene OriginSystem "<origin_a>" con MessageId "<msg_a>"
    And la segunda petición tiene OriginSystem "<origin_b>" con MessageId "<msg_b>"

    # Cuando la API procesa ambas peticiones
    When la API evalúa el campo OriginSystem de cada petición

    # Entonces cada solicitud es clasificada y trazada de forma independiente
    Then la solicitud "<msg_a>" queda registrada con origen "<origin_a>"
    And la solicitud "<msg_b>" queda registrada con origen "<origin_b>"
    And ambas solicitudes tienen correlationId distintos
    And el enrutamiento interno de cada solicitud corresponde a su sistema origen

    Examples:
      | origin_a | msg_a                    | origin_b    | msg_b                  |
      | SIAV-GA  | MSG-SIAV-20260227-000001 | BOXSTORE-GA | MSG-BS-20260227-000001 |
      | SIAV-GA  | MSG-SIAV-20260227-000003 | WMS-GA      | MSG-WMS-20260223-00004 |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Recepción fallida por error en la petición de SIAV o Box Store

    # Dado que SIAV o Box Store envían una petición con algún problema
    Given que el sistema "<origin_system>" realiza una petición POST al endpoint "/api/v1/transfers/request"
    And la petición presenta la condición de error "<condicion_error>"

    # Cuando la API evalúa la petición entrante
    When la API de GM Transport procesa la petición de "<origin_system>"

    # Entonces la API rechaza la petición con el código y mensaje apropiados
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el cuerpo de la respuesta incluye el campo "errorMessage" con descripción legible
    And el evento queda registrado en bitácora con estado "RECHAZADO" y causa "<condicion_error>"
    And NO se genera ninguna solicitud de viaje en GM Transport ERP

    Examples:
      | origin_system | condicion_error                                    | http_code | error_code              |
      | SIAV          | Token/API Key ausente en el header                 | 401       | AUTH_MISSING_TOKEN      |
      | SIAV          | Token/API Key inválido o expirado                  | 401       | AUTH_INVALID_TOKEN      |
      | Box Store     | Content-Type diferente de application/xml          | 415       | UNSUPPORTED_MEDIA_TYPE  |
      | Box Store     | Cuerpo de la petición vacío                        | 400       | EMPTY_REQUEST_BODY      |
      | SIAV          | XML malformado (no parseable)                      | 400       | XML_PARSE_ERROR         |
      | Box Store     | Método HTTP incorrecto (GET en lugar de POST)      | 405       | METHOD_NOT_ALLOWED      |

  Scenario Outline: Rechazo por OriginSystem desconocido o no autorizado

    # Dado que el XML llega con un valor de OriginSystem no reconocido
    Given que una petición POST llega al endpoint "/api/v1/transfers/request"
    And el campo OriginSystem del nodo Header tiene el valor "<origin_desconocido>"
    And el resto de la petición es estructuralmente válida

    # Cuando la API evalúa el origen del mensaje
    When la API de GM Transport valida el campo OriginSystem

    # Entonces la API rechaza la solicitud por origen no autorizado
    Then la API responde con código HTTP 403
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "UNAUTHORIZED_ORIGIN_SYSTEM"
    And el cuerpo de la respuesta incluye el campo "receivedOriginSystem" con valor "<origin_desconocido>"
    And el evento queda registrado en bitácora con estado "RECHAZADO_ORIGEN_NO_AUTORIZADO"
    And NO se genera ninguna solicitud de viaje en GM Transport ERP

    Examples:
      | origin_desconocido  |
      | UNKNOWN-SYS         |
      | WMS-GA-TEST         |
      | SIAV                |
      | boxstore            |
      | (campo vacío)       |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-005-A] ¿Los valores exactos de OriginSystem están confirmados?
  #              Se asume: "SIAV-GA" y "BOXSTORE-GA" como
  #              SUPUESTO TÉCNICO hasta confirmación con el equipo.
  #
  # [RESUELTA-005-B] SIAV y Box Store tienen credenciales de autenticación
  #              INDEPENDIENTES del WMS.  Sin embargo, los tres sistemas
  #              generan el mismo formato de XML para enviar información
  #              de materiales.  Cada sistema se autentica por separado.
  #
  # [DUDA-005-C] ¿El endpoint es el mismo "/api/v1/transfers/request"
  #              para los tres sistemas, o se crean rutas separadas
  #              con un prefijo? Se usa endpoint compartido como
  #              SUPUESTO TÉCNICO.
  #
  # [DUDA-005-D] ¿Existe alguna diferencia en la lógica de enrutamiento
  #              interno entre una solicitud de SIAV y una de Box Store,
  #              más allá del OriginSystem? → PENDIENTE DE DEFINICIÓN.
  # ----------------------------------------------------------------
