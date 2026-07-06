# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 3 – Seguimiento y actualización de estatus de viajes
# HU         : HU-010
# NOMBRE     : Propagación de cambio de estatus de viaje
#              a sistemas destino (WMS / SIAV / Box Store / SAP)
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Una vez que la API recibe y valida el cambio de estatus del ERP
# (HU-009), debe propagar ese cambio a los sistemas destino:
#
#   1. Sistema origen del viaje → WMS, SIAV o Box Store
#      (el que generó la solicitud original)
#   2. SAP S/4HANA → para el flujo administrativo y fiscal
#      (especialmente relevante en estatus TERMINADO, que
#       dispara la generación de cuenta por cobrar)
#
# La propagación se realiza de forma asíncrona desde una cola
# de procesamiento que se alimenta al acusar recibo del webhook
# del ERP (HU-009).
#
# REGLAS DE PROPAGACIÓN POR ESTATUS:
#
#   PENDIENTE  → Sin propagación a SAP (solo al sistema origen)
#   ACEPTADA   → Notificar a sistema origen + SAP
#   EN RUTA    → Notificar a sistema origen + SAP
#   TERMINADO  → Notificar a sistema origen + SAP
#                Además: disparar flujo de CxC en SAP (Épica 6)
# -----------------------------------------------------------------

Feature: HU-010 – Propagación de cambio de estatus de viaje a sistemas destino

  Como sistema API de GM Transport,
  quiero propagar los cambios de estatus de cada viaje
  al sistema origen (WMS / SIAV / Box Store) y a SAP,
  para que todos los sistemas involucrados mantengan
  una visión actualizada y consistente del estado del servicio.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Propagación exitosa de cambio de estatus al sistema origen

    # Dado que la API procesó un cambio de estatus válido
    Given que el Load Number "<load_number>" cambió a estatus "<estatus_nuevo>"
    And el viaje fue originado por el sistema "<origin_system>"
    And el sistema "<origin_system>" tiene un endpoint de notificación activo y disponible

    # Cuando la API propaga el cambio al sistema origen
    When la API envía la notificación de estatus al sistema "<origin_system>"

    # Entonces el sistema origen recibe y confirma la notificación
    Then el sistema "<origin_system>" responde con código HTTP 200
    And la notificación incluye: load_number "<load_number>", estatus "<estatus_nuevo>" y timestamp
    And el registro de trazabilidad se actualiza con evento "NOTIFICADO_<origin_system>"
    And el estado de propagación hacia "<origin_system>" queda como "ENTREGADO"

    Examples:
      | load_number     | estatus_nuevo | origin_system |
      | LN-20260223-001 | ACEPTADA      | WMS           |
      | LN-20260223-001 | EN RUTA       | WMS           |
      | LN-20260223-001 | TERMINADO     | WMS           |
      | LN-20260227-010 | ACEPTADA      | SIAV          |
      | LN-20260227-010 | EN RUTA       | SIAV          |
      | LN-20260227-010 | TERMINADO     | SIAV          |
      | LN-20260227-020 | ACEPTADA      | Box Store     |
      | LN-20260227-020 | TERMINADO     | Box Store     |

  Scenario Outline: Propagación exitosa de cambio de estatus a SAP

    # Dado que el cambio de estatus aplica notificación a SAP
    Given que el Load Number "<load_number>" cambió a estatus "<estatus_nuevo>"
    And el estatus "<estatus_nuevo>" está dentro de los que requieren notificación a SAP
    And SAP S/4HANA tiene el endpoint de integración activo y disponible

    # Cuando la API propaga el cambio a SAP
    When la API envía la notificación de estatus a SAP S/4HANA

    # Entonces SAP recibe y confirma la notificación
    Then SAP responde confirmando la recepción del cambio de estatus
    And la notificación a SAP incluye: load_number "<load_number>", estatus "<estatus_nuevo>" y timestamp
    And el registro de trazabilidad se actualiza con evento "NOTIFICADO_SAP"
    And el estado de propagación hacia SAP queda como "ENTREGADO"
    And si el estatus es "TERMINADO" se encola el proceso de generación de CxC en SAP (Épica 6)

    Examples:
      | load_number     | estatus_nuevo |
      | LN-20260223-001 | ACEPTADA      |
      | LN-20260223-001 | EN RUTA       |
      | LN-20260223-001 | TERMINADO     |
      | LN-20260227-010 | ACEPTADA      |
      | LN-20260227-020 | TERMINADO     |

  Scenario Outline: Estatus PENDIENTE solo se propaga al sistema origen, no a SAP

    # Dado que el viaje cambió a estatus PENDIENTE (primera creación)
    Given que el Load Number "<load_number>" tiene estatus "PENDIENTE"
    And el viaje fue originado por "<origin_system>"

    # Cuando la API evalúa a quién propagar
    When la API determina los destinos de propagación para estatus "PENDIENTE"

    # Entonces solo notifica al sistema origen, SAP no recibe notificación
    Then la API envía notificación de estatus "PENDIENTE" al sistema "<origin_system>"
    And la API NO envía ninguna notificación a SAP para estatus "PENDIENTE"
    And el registro de trazabilidad confirma propagación solo hacia "<origin_system>"

    Examples:
      | load_number     | origin_system |
      | LN-20260223-001 | WMS           |
      | LN-20260227-010 | SIAV          |
      | LN-20260227-020 | Box Store     |

  Scenario Outline: Consulta de historial de estatus de un viaje por Load Number

    # Dado que un sistema externo consulta el historial de un viaje
    Given que el Load Number "<load_number>" tiene registrados "<total_cambios>" cambios de estatus
    And el sistema "<solicitante>" realiza una petición GET al endpoint de historial de estatus

    # Cuando la API procesa la consulta
    When la API busca el historial del Load Number "<load_number>"

    # Entonces devuelve el historial completo ordenado cronológicamente
    Then la API responde con código HTTP 200
    And la respuesta incluye una lista de "<total_cambios>" eventos de estatus
    And cada evento incluye: estatus, timestamp, responsable y sistema que fue notificado
    And los eventos están ordenados de forma cronológica ascendente

    Examples:
      | load_number     | total_cambios | solicitante |
      | LN-20260223-001 | 4             | WMS         |
      | LN-20260227-010 | 2             | SIAV        |
      | LN-20260227-020 | 3             | Box Store   |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en la propagación a sistema destino con reintento automático

    # Dado que la API intenta propagar un cambio de estatus pero el destino falla
    Given que el Load Number "<load_number>" cambió a estatus "<estatus_nuevo>"
    And el sistema destino "<sistema_destino>" presenta la condición de error "<condicion_error>"

    # Cuando la API intenta enviar la notificación
    When la API intenta propagar el estatus al sistema "<sistema_destino>"

    # Entonces la API aplica política de reintentos y gestiona el fallo
    Then la API registra el fallo de entrega con código "<error_code>"
    And la API aplica política de reintentos automáticos (máx. 3 intentos, intervalo 30 seg)
    And cada intento fallido queda registrado en bitácora con timestamp
    And si se agotan los reintentos, la notificación queda en cola de errores
    And el estado de propagación hacia "<sistema_destino>" queda como "FALLIDO"
    And se genera una alerta al equipo de soporte con el detalle del fallo
    And el fallo en la propagación a "<sistema_destino>" NO bloquea la propagación a otros destinos

    Examples:
      | load_number     | estatus_nuevo | sistema_destino | condicion_error                        | error_code                   |
      | LN-20260223-001 | ACEPTADA      | WMS             | Endpoint de WMS no disponible (timeout)| DEST_CONNECTION_TIMEOUT      |
      | LN-20260223-001 | EN RUTA       | SAP             | SAP no disponible (timeout)            | DEST_CONNECTION_TIMEOUT      |
      | LN-20260227-010 | TERMINADO     | SIAV            | SIAV responde con error 500            | DEST_INTERNAL_ERROR          |
      | LN-20260227-020 | TERMINADO     | SAP             | SAP responde con error de autenticación| DEST_AUTH_ERROR              |
      | LN-20260223-001 | TERMINADO     | Box Store       | Endpoint de Box Store no encontrado    | DEST_ENDPOINT_NOT_FOUND      |

  Scenario Outline: Consulta de historial con Load Number inexistente o sin permisos

    # Dado que se consulta el historial con algún problema
    Given que el sistema "<solicitante>" realiza una petición GET al endpoint de historial
    And la consulta presenta la condición de error "<condicion_error>"

    # Cuando la API procesa la consulta
    When la API evalúa la petición de historial de estatus

    # Entonces la API rechaza la consulta con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"

    Examples:
      | solicitante | condicion_error                               | http_code | error_code                |
      | WMS         | Load Number no existe en la capa de integrac. | 404       | LOAD_NUMBER_NOT_FOUND     |
      | SIAV        | Token de autenticación inválido o expirado    | 401       | AUTH_INVALID_TOKEN        |
      | Box Store   | Sistema origen no tiene acceso a ese viaje    | 403       | ACCESS_DENIED             |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-010-A] ¿Los sistemas WMS, SIAV y Box Store exponen un
  #              endpoint para recibir notificaciones de estatus,
  #              o la consulta es pull (ellos consultan cuando quieren)?
  #              → SUPUESTO TÉCNICO: exponen endpoint de notificación.
  #              Confirmación requerida con cada sistema.
  #
  # [DUDA-010-B] ¿El formato de la notificación hacia WMS/SIAV/BS
  #              es JSON o XML? → SUPUESTO TÉCNICO: JSON.
  #
  # [DUDA-010-C] ¿Qué información exacta requiere SAP en la
  #              notificación de estatus? ¿Solo el estatus y Load
  #              Number, o también datos de la Carta Porte?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de SAP.
  #
  # [DUDA-010-D] ¿El estatus TERMINADO dispara de forma inmediata
  #              y automática la generación de CxC en SAP, o
  #              requiere una confirmación adicional de operaciones?
  #              → PENDIENTE DE DEFINICIÓN (impacta Épica 6).
  #
  # [DUDA-010-E] ¿Un sistema origen puede consultar el historial
  #              de estatus de viajes de otros clientes/sistemas?
  #              → SUPUESTO TÉCNICO: no, solo de sus propios viajes.
  # ----------------------------------------------------------------
