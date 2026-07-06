# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 3 – Seguimiento y actualización de estatus de viajes
# HU         : HU-009
# NOMBRE     : Recepción de notificación de cambio de estatus
#              de viaje desde GM Transport ERP (webhook/push)
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# GM Transport ERP notifica a la API de integración cada vez que
# un viaje cambia de estatus.  El mecanismo es push (webhook):
# el ERP hace una llamada activa hacia la API cuando ocurre
# el cambio, sin que la API tenga que consultar periódicamente.
#
# Ciclo de vida confirmado de estatus de viaje en ERP:
#   PENDIENTE → ACEPTADA → EN RUTA → TERMINADO
#
# Cada cambio de estatus debe:
#   1. Ser recibido y validado por la API
#   2. Registrarse en la bitácora de trazabilidad
#   3. Notificarse al sistema origen (WMS / SIAV / Box Store)
#   4. Notificarse a SAP (para el flujo administrativo)
#
# Esta HU cubre el punto de entrada: recepción y acuse de recibo
# del webhook del ERP.  La propagación a sistemas destino se
# cubre en HU-010.
# -----------------------------------------------------------------

Feature: HU-009 – Recepción de notificación de cambio de estatus de viaje desde ERP

  Como sistema API de GM Transport,
  quiero recibir y acusar de recibo las notificaciones de cambio de estatus
  enviadas por GM Transport ERP vía webhook,
  para mantener actualizado el estado de cada viaje en la capa de integración
  y poder propagar ese cambio a los sistemas destino correspondientes.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Recepción exitosa de notificación de cambio de estatus

    # Dado que el ERP detecta un cambio de estatus en un viaje
    Given que GM Transport ERP genera una notificación de cambio de estatus
    And el ERP realiza una petición POST al endpoint de webhook "/api/v1/viajes/estatus"
    And el header de autenticación contiene credenciales válidas del ERP
    And el cuerpo de la notificación incluye:
        load_number "<load_number>",
        estatus_anterior "<estatus_anterior>",
        estatus_nuevo "<estatus_nuevo>",
        timestamp_cambio "<timestamp>" y
        responsable_cambio "<responsable>"

    # Cuando la API procesa la notificación entrante
    When la API de GM Transport recibe y valida la notificación del ERP

    # Entonces la API acusa recibo y registra el cambio
    Then la API responde al ERP con código HTTP 200
    And el cuerpo de la respuesta incluye el campo "status" con valor "RECEIVED"
    And el cuerpo de la respuesta incluye el campo "loadNumber" con valor "<load_number>"
    And el registro de trazabilidad del Load Number "<load_number>" se actualiza a estatus "<estatus_nuevo>"
    And se registra en bitácora: load_number, estatus_anterior, estatus_nuevo, timestamp y responsable
    And el flujo de propagación a sistemas destino se encola para procesamiento (HU-010)

    Examples:
      | load_number     | estatus_anterior | estatus_nuevo | timestamp           | responsable       |
      | LN-20260223-001 | PENDIENTE        | ACEPTADA      | 2026-02-23T09:00:00 | operador.gmt@gm   |
      | LN-20260223-001 | ACEPTADA         | EN RUTA       | 2026-02-23T14:00:00 | operador.gmt@gm   |
      | LN-20260223-001 | EN RUTA          | TERMINADO     | 2026-02-24T18:00:00 | operador.gmt@gm   |
      | LN-20260227-010 | PENDIENTE        | ACEPTADA      | 2026-02-27T10:00:00 | operador.gmt@gm   |
      | LN-20260227-020 | ACEPTADA         | EN RUTA       | 2026-02-27T15:00:00 | operador.gmt@gm   |

  Scenario Outline: Validación de transición de estatus permitida

    # Dado que la API recibe una notificación de cambio de estatus
    Given que la API recibe una notificación del ERP para el Load Number "<load_number>"
    And el estatus actual registrado en la API es "<estatus_actual>"
    And la notificación indica un cambio al estatus "<estatus_nuevo>"

    # Cuando la API valida si la transición es permitida
    When la API evalúa la transición de estatus "<estatus_actual>" → "<estatus_nuevo>"

    # Entonces la transición es aceptada por ser parte del ciclo de vida válido
    Then la transición es considerada "<resultado>"
    And si el resultado es "VÁLIDA" el estatus se actualiza y se encola la propagación
    And si el resultado es "INVÁLIDA" la API responde con código HTTP 422
    And si el resultado es "INVÁLIDA" el errorCode es "INVALID_STATUS_TRANSITION"
    And en ambos casos el evento queda registrado en bitácora

    Examples:
      | load_number     | estatus_actual | estatus_nuevo | resultado |
      | LN-20260223-001 | PENDIENTE      | ACEPTADA      | VÁLIDA    |
      | LN-20260223-001 | ACEPTADA       | EN RUTA       | VÁLIDA    |
      | LN-20260223-001 | EN RUTA        | TERMINADO     | VÁLIDA    |
      | LN-20260223-002 | PENDIENTE      | EN RUTA       | INVÁLIDA  |
      | LN-20260223-002 | PENDIENTE      | TERMINADO     | INVÁLIDA  |
      | LN-20260223-002 | TERMINADO      | EN RUTA       | INVÁLIDA  |
      | LN-20260223-002 | ACEPTADA       | PENDIENTE     | INVÁLIDA  |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Rechazo de notificación de estatus por error en la petición

    # Dado que el ERP envía una notificación con algún problema
    Given que GM Transport ERP realiza una petición POST al endpoint "/api/v1/viajes/estatus"
    And la petición presenta la condición de error "<condicion_error>"

    # Cuando la API evalúa la notificación entrante
    When la API de GM Transport procesa la notificación del ERP

    # Entonces la API rechaza la notificación con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el evento queda registrado en bitácora con estado "RECHAZADO_NOTIFICACION_ESTATUS"
    And NO se actualiza el estatus de ningún viaje en la capa de integración
    And NO se propaga ningún cambio a sistemas destino

    Examples:
      | condicion_error                                           | http_code | error_code                      |
      | Credenciales del ERP ausentes o inválidas                 | 401       | AUTH_INVALID_TOKEN              |
      | Campo load_number ausente o vacío                         | 422       | MISSING_FIELD_LOAD_NUMBER       |
      | Campo estatus_nuevo ausente o vacío                       | 422       | MISSING_FIELD_ESTATUS_NUEVO     |
      | Campo timestamp_cambio ausente o con formato inválido     | 422       | INVALID_TIMESTAMP_FORMAT        |
      | Load Number no existe en la capa de integración           | 404       | LOAD_NUMBER_NOT_FOUND           |
      | Estatus_nuevo con valor no reconocido en el ciclo de vida | 422       | INVALID_STATUS_VALUE            |
      | Cuerpo de la petición vacío o malformado                  | 400       | EMPTY_OR_MALFORMED_BODY         |
      | Método HTTP incorrecto (GET en lugar de POST)             | 405       | METHOD_NOT_ALLOWED              |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-009-A] ¿El ERP envía el webhook con un formato JSON o XML?
  #              → SUPUESTO TÉCNICO: JSON, por ser webhook interno
  #              entre sistemas propios de GM Transport.
  #              Confirmación requerida con el equipo de ERP.
  #
  # [DUDA-009-B] ¿El ERP espera un acuse de recibo síncrono (HTTP 200)
  #              o la notificación es fire-and-forget?
  #              → SUPUESTO TÉCNICO: acuse síncrono HTTP 200.
  #
  # [DUDA-009-C] ¿Existe algún mecanismo de reintento del ERP si no
  #              recibe el acuse de recibo de la API?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de ERP.
  #
  # [DUDA-009-D] ¿El estatus "TERMINADO" dispara automáticamente
  #              algún proceso adicional (ej. generación de factura,
  #              notificación a SAP)? → Se asume que sí, cubierto
  #              en HU-010 y en las épicas de SAP.
  # ----------------------------------------------------------------
