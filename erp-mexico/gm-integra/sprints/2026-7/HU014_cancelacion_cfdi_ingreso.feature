# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 7 – Cancelación de CFDI y reglas fiscales
# HU         : HU-014
# NOMBRE     : Cancelación de CFDI de ingreso y manejo
#              de reglas fiscales SAT
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Existen escenarios en los que un CFDI de ingreso ya timbrado
# debe cancelarse.  En México, la cancelación de CFDIs está regulada
# por el SAT y tiene reglas específicas según la versión CFDI 4.0:
#
# MOTIVOS DE CANCELACIÓN SAT (catálogo):
#   01 - Comprobante emitido con errores con relación
#   02 - Comprobante emitido con errores sin relación
#   03 - No se llevó a cabo la operación
#   04 - Operación nominativa relacionada en una factura global
#
# REGLAS CLAVE DE CANCELACIÓN CFDI 4.0:
#   - Si el receptor ya pagó (CxC liquidada), la cancelación
#     requiere aceptación del receptor (Grupo Andrea en SAP/portal SAT)
#   - Si el motivo es "01", se debe emitir un CFDI sustituto
#     con el UUID del CFDI cancelado en el campo CFDIRelacionado
#   - El plazo para cancelar sin aceptación del receptor es de
#     24 horas desde la emisión (política SAT vigente)
#   - Las cancelaciones se procesan vía PAC externo (mismo que timbra)
#     y el flujo ya está integrado en el ERP de GM Transport
#
# FLUJO DE CANCELACIÓN:
#   1. Se identifica la necesidad de cancelar (operaciones / admin)
#   2. GM Transport ERP solicita cancelación al PAC
#   3. PAC procesa cancelación ante el SAT
#   4. ERP notifica a la API: CFDI cancelado + motivo
#   5. API actualiza trazabilidad y estado del CFDI
#   6. API notifica a SAP para revertir o ajustar la CxC
#   7. Si motivo 01: se emite CFDI sustituto y se registra relación
# -----------------------------------------------------------------

Feature: HU-014 – Cancelación de CFDI de ingreso y manejo de reglas fiscales SAT

  Como sistema API de GM Transport,
  quiero recibir la notificación del ERP cuando un CFDI de ingreso es cancelado
  y gestionar el impacto en SAP y en la trazabilidad,
  para mantener la consistencia fiscal y contable entre GM Transport ERP,
  la capa de integración y SAP S/4HANA.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Cancelación exitosa de CFDI sin relación (motivo 02 o 03)

    # Dado que el ERP procesó la cancelación del CFDI ante el PAC y SAT
    Given que el CFDI con UUID "<uuid_cfdi>" está en estado "VIGENTE"
    And el Load Number asociado es "<load_number>"
    And la CxC en SAP tiene documento "<doc_sap>" y estado "<estado_cxc>"
    And el ERP notifica a la API la cancelación con motivo "<motivo_cancelacion>"
    And el motivo "<motivo_cancelacion>" no requiere CFDI sustituto

    # Cuando la API procesa la notificación de cancelación
    When la API recibe la notificación de cancelación del CFDI "<uuid_cfdi>"

    # Entonces la API actualiza el estado y notifica a SAP
    Then el estado del CFDI "<uuid_cfdi>" se actualiza a "CANCELADO" en trazabilidad
    And el registro de trazabilidad se actualiza a estado "CFDI_CANCELADO"
    And la API notifica a SAP la cancelación del CFDI para ajustar la CxC "<doc_sap>"
    And SAP revierte o ajusta el documento contable "<doc_sap>" según el estado del pago
    And la API responde al ERP con código HTTP 200 y confirmación de cancelación registrada

    Examples:
      | load_number     | uuid_cfdi                            | doc_sap        | estado_cxc      | motivo_cancelacion                        |
      | LN-20260223-001 | 550e8400-e29b-41d4-a716-446655440001 | SAP-DOC-000001 | PENDIENTE_PAGO  | 02 - Comprobante con errores sin relación |
      | LN-20260227-010 | 550e8400-e29b-41d4-a716-446655440002 | SAP-DOC-000002 | PENDIENTE_PAGO  | 03 - No se llevó a cabo la operación      |

  Scenario Outline: Cancelación de CFDI con sustitución (motivo 01)

    # Dado que el CFDI original tiene errores y se requiere uno sustituto
    Given que el CFDI con UUID "<uuid_cfdi_original>" está en estado "VIGENTE"
    And el motivo de cancelación es "01 - Comprobante emitido con errores con relación"
    And el ERP generó y timbró un CFDI sustituto con UUID "<uuid_cfdi_sustituto>"
    And el CFDI sustituto referencia al original en el campo CFDIRelacionado

    # Cuando la API procesa la cancelación con sustitución
    When la API recibe la notificación de cancelación con sustitución

    # Entonces la API registra ambos CFDIs y actualiza SAP
    Then el CFDI "<uuid_cfdi_original>" queda en estado "CANCELADO_CON_SUSTITUCION"
    And el CFDI "<uuid_cfdi_sustituto>" queda en estado "VIGENTE" en trazabilidad
    And la correlación Load Number "<load_number>" se actualiza al UUID sustituto "<uuid_cfdi_sustituto>"
    And la API notifica a SAP para actualizar la referencia fiscal de la CxC "<doc_sap>"
    And SAP vincula la CxC con el nuevo UUID "<uuid_cfdi_sustituto>"
    And el registro de trazabilidad incluye la relación: original → sustituto

    Examples:
      | load_number     | uuid_cfdi_original                   | uuid_cfdi_sustituto                  | doc_sap        |
      | LN-20260223-001 | 550e8400-e29b-41d4-a716-446655440001 | 772a9622-g4bd-63f6-c938-668877662001 | SAP-DOC-000001 |
      | LN-20260227-020 | 550e8400-e29b-41d4-a716-446655440003 | 772a9622-g4bd-63f6-c938-668877662003 | SAP-DOC-000003 |

  Scenario Outline: Cancelación de CFDI con CxC ya pagada — requiere aceptación del receptor

    # Dado que el CFDI a cancelar corresponde a una CxC ya liquidada
    Given que el CFDI con UUID "<uuid_cfdi>" está en estado "VIGENTE"
    And la CxC "<doc_sap>" tiene estado "PAGADA"
    And el complemento de pago (REP) con UUID "<uuid_rep>" está timbrado

    # Cuando el ERP notifica la solicitud de cancelación
    When la API recibe la notificación de cancelación del CFDI "<uuid_cfdi>"

    # Entonces la API registra que se requiere aceptación del receptor
    Then la API actualiza el estado del CFDI a "CANCELACION_PENDIENTE_ACEPTACION"
    And el registro de trazabilidad refleja estado "CANCELACION_REQUIERE_ACEPTACION_RECEPTOR"
    And la API notifica a SAP que la cancelación está pendiente de aceptación de Grupo Andrea
    And la API genera una alerta al área administrativa para seguimiento con el receptor
    And el complemento de pago "<uuid_rep>" también queda en estado "CANCELACION_PENDIENTE"

    Examples:
      | uuid_cfdi                            | doc_sap        | uuid_rep                             |
      | 550e8400-e29b-41d4-a716-446655440001 | SAP-DOC-000001 | 661f9511-f3ac-52e5-b827-557766551001 |
      | 550e8400-e29b-41d4-a716-446655440003 | SAP-DOC-000003 | 661f9511-f3ac-52e5-b827-557766551003 |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo o rechazo en el proceso de cancelación de CFDI

    # Dado que la notificación de cancelación presenta algún problema
    Given que el ERP notifica a la API la cancelación del CFDI "<uuid_cfdi>"
    And la notificación presenta la condición de error "<condicion_error>"

    # Cuando la API procesa la notificación de cancelación
    When la API evalúa la notificación de cancelación

    # Entonces el proceso falla con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el estado del CFDI "<uuid_cfdi>" NO se modifica ante errores de validación
    And el registro de trazabilidad se actualiza a estado "ERROR_CANCELACION_CFDI"
    And se genera alerta al equipo de soporte y al área fiscal

    Examples:
      | uuid_cfdi                            | condicion_error                                              | http_code | error_code                        |
      | 550e8400-e29b-41d4-a716-446655440001 | UUID del CFDI no existe en trazabilidad                      | 404       | UUID_CFDI_NOT_FOUND               |
      | 550e8400-e29b-41d4-a716-446655440001 | CFDI ya está en estado CANCELADO (cancelación duplicada)     | 409       | CFDI_ALREADY_CANCELLED            |
      | 550e8400-e29b-41d4-a716-446655440002 | Motivo de cancelación ausente o no válido en catálogo SAT    | 422       | INVALID_CANCELLATION_REASON       |
      | 550e8400-e29b-41d4-a716-446655440002 | Motivo 01 sin UUID de CFDI sustituto                         | 422       | MISSING_SUBSTITUTE_CFDI_UUID      |
      | 550e8400-e29b-41d4-a716-446655440003 | SAP no disponible para ajustar la CxC                        | 503       | SAP_CONNECTION_TIMEOUT            |
      | 550e8400-e29b-41d4-a716-446655440003 | Credenciales de integración inválidas                        | 401       | AUTH_INVALID_TOKEN                |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-014-A] ¿Cómo se registra en SAP la aceptación/rechazo de
  #              cancelación por parte de Grupo Andrea?
  #              ¿SAP notifica a la API cuando Grupo Andrea acepta?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de SAP.
  #
  # [DUDA-014-B] ¿Qué sucede en SAP con la CxC cuando se cancela
  #              el CFDI pero el servicio sí se prestó?
  #              ¿Se genera nota de crédito o se espera el sustituto?
  #              → PENDIENTE DE DEFINICIÓN con el área contable.
  #
  # [DUDA-014-C] ¿La cancelación del complemento de pago (REP)
  #              también pasa por la API, o es un proceso interno
  #              del ERP transparente para la integración?
  #              → PENDIENTE DE DEFINICIÓN.
  #
  # [DUDA-014-D] ¿El ERP tiene configurado el plazo de 24 horas SAT
  #              para cancelación sin aceptación del receptor?
  #              → Se asume que sí, dado que el flujo de timbrado
  #              ya está integrado en el ERP. Confirmación requerida.
  # ----------------------------------------------------------------
