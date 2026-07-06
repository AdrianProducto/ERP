# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 4 – Validaciones, seguridad y trazabilidad
# HU         : HU-017
# NOMBRE     : Validaciones de integridad, duplicados y correlación
#              entre sistemas
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# La API GM Integra actúa como capa central de integración y debe
# garantizar la integridad de los datos que fluyen entre sistemas.
# Esto incluye:
#
# 1. CONTROL DE DUPLICADOS:
#    - MessageId duplicado: mismo mensaje enviado más de una vez
#    - Load Number duplicado: intento de crear viaje ya existente
#    - UUID CFDI duplicado: mismo documento fiscal registrado dos veces
#    - Pago duplicado: mismo pago aplicado a la misma CxC dos veces
#
# 2. VALIDACIONES DE CORRELACIÓN:
#    - El Load Number del XML debe existir antes de cargar materiales
#    - El Load Number debe tener CxC en SAP antes de registrar CFDI
#    - El UUID CFDI debe existir antes de registrar pago o complemento
#    - El sistema origen del evento debe coincidir con el registrado
#
# 3. VALIDACIONES DE INTEGRIDAD DE DATOS:
#    - Importes consistentes entre CFDI y CxC SAP
#    - RFC emisor consistente con el configurado en GM Transport
#    - Claves SAT válidas en el catálogo del SAT
#    - Fechas dentro de rangos operativos permitidos
# -----------------------------------------------------------------

Feature: HU-017 – Validaciones de integridad, duplicados y correlación entre sistemas en GM Integra

  Como sistema API de GM Transport (GM Integra),
  quiero detectar y rechazar mensajes duplicados, inconsistencias de correlación
  y datos con integridad comprometida,
  para garantizar que cada operación sea única, consistente y rastreable
  a través de todos los sistemas involucrados.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Validación de unicidad de MessageId — mensaje nuevo aceptado

    # Dado que llega un mensaje con un MessageId nunca antes visto
    Given que GM Integra recibe un mensaje del sistema "<origin_system>"
    And el campo MessageId tiene el valor "<message_id>"
    And no existe ningún registro previo en GM Integra DB con ese MessageId

    # Cuando la API valida la unicidad del MessageId
    When GM Integra verifica si el MessageId "<message_id>" ya fue procesado

    # Entonces el mensaje es aceptado para continuar el flujo
    Then el MessageId "<message_id>" es marcado como "NUEVO" en GM Integra DB
    And el flujo de procesamiento continúa normalmente
    And el MessageId queda indexado en GM Integra DB para futuras validaciones

    Examples:
      | origin_system | message_id               |
      | WMS-GA        | MSG-WMS-20260223-000099  |
      | SIAV-GA       | MSG-SIAV-20260227-000099 |
      | BOXSTORE-GA   | MSG-BS-20260227-000099   |

  Scenario Outline: Validación de correlación correcta entre entidades

    # Dado que se intenta realizar una operación que depende de una entidad previa
    Given que la operación "<operacion>" requiere que exista la entidad "<tipo_entidad>"
    And la entidad con identificador "<id_entidad>" SÍ existe en GM Integra DB
    And tiene el estado requerido "<estado_requerido>"

    # Cuando la API valida la correlación
    When GM Integra verifica la existencia y estado de "<tipo_entidad>" con id "<id_entidad>"

    # Entonces la correlación es válida y el flujo continúa
    Then la validación de correlación resulta "VÁLIDA"
    And el flujo continúa hacia la operación "<operacion>"

    Examples:
      | operacion                    | tipo_entidad  | id_entidad      | estado_requerido    |
      | Carga de materiales          | Carta Porte   | LN-20260223-001 | ACEPTADA            |
      | Registro de CFDI             | CxC SAP       | SAP-DOC-000001  | PENDIENTE_PAGO      |
      | Registro de pago             | CFDI          | UUID-001        | VIGENTE             |
      | Registro de complemento pago | CFDI          | UUID-001        | VIGENTE             |
      | Cancelación de CFDI          | CFDI          | UUID-001        | VIGENTE             |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Detección y rechazo de MessageId duplicado

    # Dado que llega un mensaje con un MessageId ya procesado anteriormente
    Given que GM Integra recibe un mensaje del sistema "<origin_system>"
    And el campo MessageId tiene el valor "<message_id>"
    And ya existe en GM Integra DB un registro con ese MessageId en estado "<estado_previo>"

    # Cuando la API valida la unicidad del MessageId
    When GM Integra verifica si el MessageId "<message_id>" ya fue procesado

    # Entonces el mensaje es rechazado como duplicado
    Then la API responde con código HTTP 409
    And el cuerpo incluye el campo "errorCode" con valor "DUPLICATE_MESSAGE_ID"
    And el cuerpo incluye el campo "existingCorrelationId" con el ID de la operación previa
    And NO se procesa ninguna operación de negocio con el mensaje duplicado
    And el intento duplicado queda registrado en GM Integra DB con estado "RECHAZADO_DUPLICADO"

    Examples:
      | origin_system | message_id               | estado_previo               |
      | WMS-GA        | MSG-WMS-20260223-000001  | SOLICITUD_VIAJE_CREADA      |
      | SIAV-GA       | MSG-SIAV-20260227-000001 | VALIDADO                    |
      | BOXSTORE-GA   | MSG-BS-20260227-000001   | MATERIALES_CARGADOS_CARTA_PORTE |

  Scenario Outline: Detección de inconsistencia de correlación entre entidades

    # Dado que se intenta una operación con una entidad en estado incorrecto o inexistente
    Given que la operación "<operacion>" requiere la entidad "<tipo_entidad>" con id "<id_entidad>"
    And la condición de fallo es "<condicion_fallo>"

    # Cuando la API valida la correlación
    When GM Integra verifica la existencia y estado de "<tipo_entidad>"

    # Entonces la validación falla con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo incluye el campo "errorCode" con valor "<error_code>"
    And el intento queda registrado en GM Integra DB como "RECHAZADO_CORRELACION"
    And NO se ejecuta la operación solicitada

    Examples:
      | operacion                 | tipo_entidad  | id_entidad      | condicion_fallo                          | http_code | error_code                       |
      | Carga de materiales       | Carta Porte   | LN-20260299-001 | Load Number no existe en GM Integra      | 404       | LOAD_NUMBER_NOT_FOUND            |
      | Carga de materiales       | Carta Porte   | LN-20260223-001 | Carta Porte en estado PENDIENTE (no ACEPTADA) | 409  | CARTA_PORTE_NOT_ACCEPTED         |
      | Registro de CFDI          | CxC SAP       | SAP-DOC-000099  | Documento SAP no existe en GM Integra    | 404       | SAP_DOC_NOT_FOUND                |
      | Registro de pago          | CFDI          | UUID-999        | UUID CFDI no existe en GM Integra        | 404       | UUID_CFDI_NOT_FOUND              |
      | Cancelación de CFDI       | CFDI          | UUID-001        | CFDI ya está en estado CANCELADO         | 409       | CFDI_ALREADY_CANCELLED           |
      | Registro complemento pago | CFDI          | UUID-001        | CFDI tiene método PUE (no requiere REP)  | 422       | REP_NOT_REQUIRED_FOR_PUE         |

  Scenario Outline: Detección de inconsistencia de integridad en datos

    # Dado que los datos de una operación presentan inconsistencia de integridad
    Given que GM Integra recibe una operación para el Load Number "<load_number>"
    And la operación presenta la inconsistencia "<tipo_inconsistencia>"

    # Cuando la API valida la integridad de los datos
    When GM Integra ejecuta las validaciones de integridad cruzada

    # Entonces la API rechaza la operación con detalle del problema
    Then la API responde con código HTTP 422
    And el cuerpo incluye el campo "errorCode" con valor "<error_code>"
    And el cuerpo incluye el campo "detail" describiendo la inconsistencia detectada
    And el evento queda registrado en GM Integra DB con estado "RECHAZADO_INTEGRIDAD"

    Examples:
      | load_number     | tipo_inconsistencia                                        | error_code                       |
      | LN-20260223-001 | Importe CFDI no coincide con importe CxC en SAP            | AMOUNT_MISMATCH_SAP_CFDI         |
      | LN-20260223-001 | RFC emisor del CFDI no coincide con RFC de GM Transport    | RFC_EMISOR_MISMATCH              |
      | LN-20260227-010 | OriginSystem del evento no coincide con el origen del viaje| ORIGIN_SYSTEM_MISMATCH           |
      | LN-20260227-010 | ClaveProductoServicios no válida en catálogo SAT vigente   | INVALID_CLAVE_PRODUCTO_SAT       |
      | LN-20260227-020 | UUID CFDI en complemento de pago no coincide con CFDI      | UUID_CFDI_MISMATCH               |
      | LN-20260227-020 | Monto del pago mayor al total de la CxC                    | PAYMENT_AMOUNT_EXCEEDS_CXC       |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-017-A] ¿El índice de MessageId en GM Integra DB es por
  #              combinación de MessageId + OriginSystem, o solo
  #              por MessageId globalmente?
  #              → SUPUESTO TÉCNICO: MessageId + OriginSystem como
  #              clave compuesta para evitar colisiones entre sistemas.
  #
  # [DUDA-017-B] ¿GM Integra consulta el catálogo del SAT en tiempo
  #              real para validar ClaveProductoServicios y ClaveUnidad,
  #              o usa una tabla local sincronizada periódicamente?
  #              → PENDIENTE DE DEFINICIÓN con arquitectura.
  #
  # [DUDA-017-C] ¿Cuánto tiempo se conserva el índice de MessageIds
  #              procesados para detección de duplicados?
  #              → PENDIENTE con la política de retención de GM Integra.
  # ----------------------------------------------------------------
