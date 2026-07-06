# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 3 – Seguimiento y actualización de estatus de viajes
# HU         : HU-009
# NOMBRE     : Consulta de estatus de solicitud de viaje
#              vía API SolicitudViaje/Consultar
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 2.0  ← actualizada con documentación real de la API
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# GM Integra consulta periódicamente el estatus de las solicitudes
# de viaje usando el endpoint real de consulta del ERP.
# Este endpoint es la fuente de verdad sobre el estado de cada
# solicitud y es también la manera de obtener el SucursalFolio
# necesario para la carga de materiales (HU-008).
#
# ENDPOINT CONFIRMADO:
#   GET https://appapitest.gmtransport.co/api/SolicitudViaje/Consultar/{IdSolicitud}
#
# AUTENTICACIÓN (Basic Auth):
#   Header Authorization : basic {Base64(Usuario:Contraseña)}
#   Header RFC           : RFC del cliente
#   Header Aplicacion    : 4
#   Header Content-Type  : application/json
#
# PARÁMETRO DE URL:
#   IdSolicitud (INT) — llave única devuelta al crear la solicitud
#
# RESPUESTAS SEGÚN ESTADO:
#
#   PENDIENTE (no aceptada ni cancelada):
#   { "Content": [{ "Success": true,
#       "Motivo": "La solicitud de viaje esta pendente" }]}
#
#   NO ENCONTRADA:
#   { "Content": [{ "Success": true,
#       "Motivo": "No se encontro la IdSolicitud" }]}
#
#   ACEPTADA:
#   { "Content": [{ "Success": true, "Viajes": [{
#       "EstatusViaje": "DOCUMENTADO",
#       "Aceptacion": [{ "Fecha": "...", "Hora": "...", "Nombre": "..." }],
#       "LoadNumber": "...",
#       "SucursalFolio": "...",          ← LLAVE PARA MATERIALES
#       "NumeroEconomicoUnidad": "...",
#       "NumeroEconomicoRemolques": "...",
#       "NombreOperador": "...",
#       "Complemento": { "XML": "base64", "PDF": "base64" },  ← si timbrado
#       "TipoCobro": "...",
#       "RepartoRecolecta": boolean,
#       "TipoViaje": "NACIONAL",
#       "Trayectos": [{ "IdTrayecto": N, "Origen": "...",
#                       "Destino": "...", "Secuencia": "N" }]
#   }]}
#
#   CANCELADA:
#   { "Cancelacion": { "Fecha": "...", "Hora": "...",
#       "Nombre": "...", "Motivo": "..." }}
#
# CICLO DE CONSULTA DE GM INTEGRA:
#   GM Integra consulta periódicamente las solicitudes en estado
#   PENDIENTE hasta detectar ACEPTADA o CANCELADA.
#   Al detectar ACEPTADA extrae el SucursalFolio y dispara HU-008.
# -----------------------------------------------------------------

Feature: HU-009 – Consulta de estatus de solicitud de viaje vía API SolicitudViaje/Consultar

  Como sistema API de GM Transport (GM Integra),
  quiero consultar periódicamente el estatus de cada solicitud de viaje
  usando el endpoint GET /api/SolicitudViaje/Consultar/{IdSolicitud},
  para detectar cuando una solicitud es aceptada u obtener el SucursalFolio
  necesario para la carga de materiales, o detectar cancelaciones.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Consulta exitosa — solicitud en estado PENDIENTE

    # Dado que la solicitud fue creada pero aún no fue procesada por GM Transport
    Given que GM Integra tiene registrada la correlación IdSolicitud "<id_solicitud>"
    And la solicitud aún no ha sido aceptada ni cancelada en el ERP

    # Cuando GM Integra consulta el estatus de la solicitud
    When GM Integra realiza GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"

    # Entonces el ERP responde indicando que la solicitud está pendiente
    Then el ERP responde con código HTTP 200
    And la respuesta incluye Success: true
    And la respuesta incluye Motivo "La solicitud de viaje esta pendente"
    And el registro de trazabilidad se actualiza a estado "SOLICITUD_EN_ESPERA_AUTORIZACION"
    And GM Integra programa la próxima consulta según el intervalo configurado

    Examples:
      | id_solicitud |
      | 26           |
      | 30           |
      | 32           |

  Scenario Outline: Consulta exitosa — solicitud ACEPTADA, obtención de SucursalFolio y Trayectos

    # Dado que GM Transport aceptó la solicitud de viaje
    Given que la solicitud con IdSolicitud "<id_solicitud>" fue aceptada en el ERP

    # Cuando GM Integra consulta el estatus
    When GM Integra realiza GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"

    # Entonces el ERP devuelve la información completa del viaje aceptado
    Then el ERP responde con código HTTP 200 y Success: true
    And la respuesta incluye el nodo Viajes con EstatusViaje "<estatus_viaje>"
    And la respuesta incluye el nodo Aceptacion con Fecha, Hora y Nombre del operador
    And la respuesta incluye LoadNumber "<load_number>"
    And la respuesta incluye SucursalFolio "<sucursal_folio>"
    And la respuesta incluye NumeroEconomicoUnidad, NumeroEconomicoRemolques y NombreOperador
    And la respuesta incluye TipoCobro "<tipo_cobro>" y TipoViaje "<tipo_viaje>"
    And la respuesta incluye el nodo Trayectos con IdTrayecto, Origen, Destino y Secuencia
    And GM Integra almacena la correlación LoadNumber ↔ IdSolicitud ↔ SucursalFolio "<sucursal_folio>"
    And el registro de trazabilidad se actualiza a "SOLICITUD_ACEPTADA_ERP"
    And GM Integra dispara el flujo de carga de materiales con SucursalFolio "<sucursal_folio>" (HU-008)

    Examples:
      | id_solicitud | load_number     | sucursal_folio | estatus_viaje | tipo_cobro    | tipo_viaje |
      | 26           | LN-20260223-001 | MA-002001      | DOCUMENTADO   | Por Concepto  | NACIONAL   |
      | 30           | LN-20260227-010 | MA-002030      | DOCUMENTADO   | Por Concepto  | NACIONAL   |
      | 32           | LN-20260227-020 | MA-002032      | DOCUMENTADO   | Materiales    | NACIONAL   |

  Scenario Outline: Consulta exitosa — viaje ACEPTADO con Complemento Carta Porte ya timbrado

    # Dado que el viaje ya fue timbrado por el PAC
    Given que la solicitud con IdSolicitud "<id_solicitud>" tiene estatus "<estatus_viaje>"
    And el viaje ya fue timbrado con Carta Porte

    # Cuando GM Integra consulta el estatus
    When GM Integra realiza GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"

    # Entonces la respuesta incluye el nodo Complemento con el XML y PDF en base64
    Then la respuesta incluye el nodo Complemento con:
        XML en base64 del CFDI timbrado y
        PDF en base64 de la representación impresa
    And GM Integra extrae y registra el UUID del XML del Complemento en trazabilidad
    And el estado de trazabilidad se actualiza a "CFDI_TIMBRADO"

    Examples:
      | id_solicitud | estatus_viaje |
      | 26           | DOCUMENTADO   |
      | 30           | TERMINADO     |

  Scenario Outline: Consulta exitosa — solicitud CANCELADA

    # Dado que GM Transport canceló la solicitud de viaje
    Given que la solicitud con IdSolicitud "<id_solicitud>" fue cancelada en el ERP

    # Cuando GM Integra consulta el estatus
    When GM Integra realiza GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"

    # Entonces la respuesta incluye la información de la cancelación
    Then el ERP responde con código HTTP 200
    And la respuesta incluye el nodo Cancelacion con:
        Fecha "<fecha_cancelacion>",
        Hora "<hora_cancelacion>",
        Nombre del operador que canceló y
        Motivo "<motivo_cancelacion>"
    And el registro de trazabilidad se actualiza a estado "SOLICITUD_CANCELADA_ERP"
    And GM Integra notifica la cancelación al sistema origen (WMS / SIAV / Box Store)
    And GM Integra notifica la cancelación a SAP si la CxC ya fue generada

    Examples:
      | id_solicitud | fecha_cancelacion | hora_cancelacion | motivo_cancelacion              |
      | 27           | 17/09/2026        | 11:33:00         | Capacidad no disponible         |
      | 31           | 18/09/2026        | 09:15:00         | Solicitud duplicada por cliente |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en la consulta por parámetro o autenticación incorrecta

    # Dado que la consulta presenta algún problema
    Given que GM Integra intenta GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"
    And la petición presenta la condición de error "<condicion_error>"

    # Cuando el ERP procesa la petición
    When GM Integra evalúa la respuesta del ERP

    # Entonces el ERP rechaza la consulta con el código apropiado
    Then el ERP responde con código "<http_code>" o faultcode "<fault_code>"
    And GM Integra registra el error en trazabilidad con estado "ERROR_CONSULTA_ESTATUS"
    And si el error es recuperable, GM Integra reintenta en el siguiente ciclo de consulta

    Examples:
      | id_solicitud | condicion_error                               | http_code | fault_code |
      | (ausente)    | IdSolicitud no enviado en la URL              | 400       | 400        |
      | 99999        | IdSolicitud no existe en el ERP               | 200       | -          |
      | 26           | Credenciales Basic Auth inválidas             | 401       | 401        |
      | 26           | ERP no disponible (timeout)                   | 500       | -          |

  # ----------------------------------------------------------------
  # CAMBIOS RESPECTO A VERSIONES ANTERIORES
  # ----------------------------------------------------------------
  # [v2] Cambios confirmados por documentación real de la API:
  #      - Endpoint real: GET /api/SolicitudViaje/Consultar/{IdSolicitud}
  #      - Parámetro: IdSolicitud (INT), no Load Number
  #      - Respuestas diferenciadas: PENDIENTE, ACEPTADA, CANCELADA, NO ENCONTRADA
  #      - SucursalFolio se obtiene en la respuesta ACEPTADA
  #      - Trayectos[].IdTrayecto necesario para HU-008 (nodo Trayecto)
  #      - Complemento con XML+PDF en base64 cuando está timbrado
  #      - El mecanismo NO es webhook del ERP → GM Integra consulta activamente
  #
  # [DUDA-009-A] ¿Con qué frecuencia GM Integra consulta el estatus
  #              de las solicitudes PENDIENTES?
  #              → SUPUESTO TÉCNICO: cada 5 minutos.
  #              → PENDIENTE DE DEFINICIÓN con operaciones.
  #
  # [DUDA-009-B] ¿Cuánto tiempo máximo puede estar una solicitud
  #              en estado PENDIENTE antes de generar una alerta?
  #              → PENDIENTE DE DEFINICIÓN con operaciones.
  # ----------------------------------------------------------------
