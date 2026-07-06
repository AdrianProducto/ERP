# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 6 – Facturación, CxC y pagos
# HU         : HU-013
# NOMBRE     : Recepción y registro de pago desde SAP
#              con manejo de complemento de pago
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Una vez que la CxC queda registrada en SAP y el CFDI de ingreso
# está timbrado, Grupo Andrea realiza el pago del servicio.
# SAP S/4HANA gestiona el cobro y la aplicación de pagos (cash
# application) y notifica a la API de GM Transport cuando un
# pago es registrado contra una CxC.
#
# En México, cuando el CFDI de ingreso se emite con método de pago
# PPD (Pago en Parcialidades o Diferido), se requiere emitir un
# Complemento de Pago (REP - Recibo Electrónico de Pago) cuando
# se recibe el pago.  Este complemento también es timbrado por el PAC.
#
# FLUJO DE PAGO:
#   1. SAP registra el pago entrante de Grupo Andrea
#   2. SAP aplica (limpia) la partida abierta de la CxC
#   3. SAP notifica a la API: pago registrado + datos del pago
#   4. API actualiza trazabilidad y correlaciona pago con CxC/CFDI
#   5. Si aplica: GM Transport ERP genera complemento de pago
#      PAC timbra el complemento
#      ERP notifica a la API el UUID del complemento
#   6. API notifica a SAP el UUID del complemento de pago
#
# MÉTODO DE PAGO EN CFDI:
#   PUE (Pago en Una Exhibición): pago inmediato, no requiere REP
#   PPD (Pago en Parcialidades o Diferido): requiere REP al pagar
# -----------------------------------------------------------------

Feature: HU-013 – Recepción y registro de pago desde SAP con manejo de complemento de pago

  Como sistema API de GM Transport,
  quiero recibir la notificación de pago registrado en SAP S/4HANA
  y gestionar la generación del complemento de pago cuando aplique,
  para mantener el ciclo factura-cobro completo y fiscalmente correcto.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Recepción exitosa de notificación de pago desde SAP

    # Dado que SAP registró y aplicó un pago de Grupo Andrea
    Given que la CxC con documento SAP "<doc_sap>" tiene estado "PENDIENTE_PAGO"
    And el CFDI asociado tiene UUID "<uuid_cfdi>" y método de pago "<metodo_pago>"
    And SAP S/4HANA notifica a la API el pago registrado

    # Cuando la API recibe la notificación de pago de SAP
    When la API procesa la notificación con los campos:
        doc_sap "<doc_sap>",
        uuid_cfdi "<uuid_cfdi>",
        monto_pagado "<monto_pagado>",
        fecha_pago "<fecha_pago>",
        forma_pago "<forma_pago>" y
        referencia_pago "<referencia_pago>"

    # Entonces la API registra el pago y actualiza el estado de la CxC
    Then la API actualiza el estado de la CxC "<doc_sap>" a "<estado_cxc>"
    And el registro de trazabilidad se actualiza a estado "<estado_trazabilidad>"
    And la correlación Load Number ↔ UUID ↔ pago queda registrada en la API
    And si el método de pago es "PPD" se dispara el flujo de generación de complemento de pago
    And si el método de pago es "PUE" el ciclo queda cerrado sin complemento

    Examples:
      | doc_sap        | uuid_cfdi                            | metodo_pago | monto_pagado | fecha_pago | forma_pago       | referencia_pago | estado_cxc | estado_trazabilidad      |
      | SAP-DOC-000001 | 550e8400-e29b-41d4-a716-446655440001 | PPD         | 17400.00     | 2026-03-25 | TRANSFERENCIA    | TRF-2026-001    | PAGADA     | PAGO_RECIBIDO_PPD        |
      | SAP-DOC-000002 | 550e8400-e29b-41d4-a716-446655440002 | PUE         | 9860.00      | 2026-02-28 | TRANSFERENCIA    | TRF-2026-002    | PAGADA     | PAGO_RECIBIDO_CICLO_CERRADO |
      | SAP-DOC-000003 | 550e8400-e29b-41d4-a716-446655440003 | PPD         | 13920.00     | 2026-03-30 | CHEQUE           | CHQ-2026-003    | PAGADA     | PAGO_RECIBIDO_PPD        |

  Scenario Outline: Generación y registro del complemento de pago (REP) para método PPD

    # Dado que el pago fue recibido con método PPD y se requiere complemento
    Given que la CxC "<doc_sap>" con método PPD tiene estado "PAGO_RECIBIDO_PPD"
    And GM Transport ERP genera el complemento de pago para el UUID "<uuid_cfdi>"
    And el PAC externo timbra el complemento y devuelve el UUID del complemento "<uuid_rep>"

    # Cuando el ERP notifica a la API el complemento timbrado
    When la API recibe la notificación del complemento con:
        uuid_rep "<uuid_rep>",
        uuid_cfdi_relacionado "<uuid_cfdi>",
        monto_pagado "<monto_pagado>",
        fecha_pago "<fecha_pago>" y
        doc_sap "<doc_sap>"

    # Entonces la API registra el complemento y notifica a SAP
    Then la API almacena la correlación UUID CFDI "<uuid_cfdi>" ↔ UUID REP "<uuid_rep>"
    And el registro de trazabilidad se actualiza a estado "COMPLEMENTO_PAGO_TIMBRADO"
    And la API notifica a SAP el UUID del complemento "<uuid_rep>" para vincular con la CxC "<doc_sap>"
    And SAP actualiza el documento contable con la referencia del complemento de pago
    And el ciclo factura-cobro queda cerrado para el Load Number asociado

    Examples:
      | doc_sap        | uuid_cfdi                            | uuid_rep                             | monto_pagado | fecha_pago |
      | SAP-DOC-000001 | 550e8400-e29b-41d4-a716-446655440001 | 661f9511-f3ac-52e5-b827-557766551001 | 17400.00     | 2026-03-25 |
      | SAP-DOC-000003 | 550e8400-e29b-41d4-a716-446655440003 | 661f9511-f3ac-52e5-b827-557766551003 | 13920.00     | 2026-03-30 |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en la recepción o procesamiento del pago

    # Dado que la notificación de pago presenta algún problema
    Given que SAP notifica a la API un pago para el documento "<doc_sap>"
    And la notificación presenta la condición de error "<condicion_error>"

    # Cuando la API procesa la notificación de pago
    When la API evalúa la notificación de pago de SAP

    # Entonces el procesamiento falla con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el registro de trazabilidad se actualiza a estado "ERROR_PROCESAMIENTO_PAGO"
    And el estado de la CxC no se modifica ante errores de validación
    And se genera alerta al equipo de soporte y al área de administración

    Examples:
      | doc_sap        | condicion_error                                              | http_code | error_code                       |
      | SAP-DOC-000001 | Documento SAP no existe en la capa de integración            | 404       | SAP_DOC_NOT_FOUND                |
      | SAP-DOC-000001 | Monto pagado no coincide con el total de la CxC              | 422       | PAYMENT_AMOUNT_MISMATCH          |
      | SAP-DOC-000001 | CxC ya tiene estado PAGADA (pago duplicado)                  | 409       | DUPLICATE_PAYMENT                |
      | SAP-DOC-000002 | UUID del CFDI en la notificación no coincide con el esperado | 422       | UUID_CFDI_MISMATCH               |
      | SAP-DOC-000002 | Campo fecha_pago ausente o con formato inválido              | 422       | INVALID_PAYMENT_DATE             |
      | SAP-DOC-000003 | Campo monto_pagado ausente o igual a cero                    | 422       | MISSING_OR_ZERO_PAYMENT_AMOUNT   |
      | SAP-DOC-000003 | SAP no disponible al intentar confirmar recepción            | 503       | SAP_CONNECTION_TIMEOUT           |

  Scenario Outline: Fallo en el registro del complemento de pago (REP)

    # Dado que la notificación del complemento de pago presenta un problema
    Given que el complemento de pago para el UUID CFDI "<uuid_cfdi>" fue generado por el ERP
    And la notificación del complemento presenta la condición de error "<condicion_error>"

    # Cuando la API procesa la notificación del complemento
    When la API evalúa la notificación del complemento de pago

    # Entonces el registro del complemento falla
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el registro de trazabilidad se actualiza a estado "ERROR_COMPLEMENTO_PAGO"
    And el UUID del CFDI original permanece en estado "PAGO_RECIBIDO_PPD" para reintento

    Examples:
      | uuid_cfdi                            | condicion_error                                          | http_code | error_code                    |
      | 550e8400-e29b-41d4-a716-446655440001 | UUID del complemento (REP) ausente o vacío               | 422       | MISSING_UUID_REP               |
      | 550e8400-e29b-41d4-a716-446655440001 | UUID del CFDI relacionado no existe en trazabilidad      | 404       | UUID_CFDI_NOT_FOUND            |
      | 550e8400-e29b-41d4-a716-446655440003 | Complemento de pago ya registrado para ese CFDI          | 409       | DUPLICATE_REP                  |
      | 550e8400-e29b-41d4-a716-446655440003 | SAP no disponible para vincular el complemento           | 503       | SAP_CONNECTION_TIMEOUT         |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-013-A] ¿Todos los CFDI de GM Transport se emiten con método
  #              PPD, o pueden emitirse con PUE?
  #              → PENDIENTE DE DEFINICIÓN con el área fiscal.
  #              Impacta si siempre se genera complemento o no.
  #
  # [DUDA-013-B] ¿SAP notifica el pago a la API mediante webhook/push
  #              o la API debe consultar periódicamente partidas
  #              abiertas en SAP? → SUPUESTO TÉCNICO: webhook de SAP.
  #
  # [DUDA-013-C] ¿Pueden existir pagos parciales (abonos) contra una
  #              misma CxC? → PENDIENTE DE DEFINICIÓN.
  #              Si aplica, se requiere HU adicional para abonos.
  #
  # [DUDA-013-D] ¿Qué formas de pago (forma_pago SAT) maneja
  #              Grupo Andrea? (Transferencia, Cheque, etc.)
  #              → PENDIENTE con el área de administración.
  # ----------------------------------------------------------------
