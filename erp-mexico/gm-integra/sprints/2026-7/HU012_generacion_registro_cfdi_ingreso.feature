# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 6 – Facturación, CxC y pagos
# HU         : HU-012
# NOMBRE     : Generación y registro de CFDI de ingreso
#              timbrado por PAC externo
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# GM Transport genera el CFDI de ingreso dentro de su propio ERP
# y lo timbra mediante un PAC externo cuyo flujo ya está integrado
# en el ERP.  Este proceso es transparente para la API de integración
# en términos de ejecución.
#
# Sin embargo, la API debe:
#   1. Recibir la notificación del ERP cuando el CFDI queda timbrado
#   2. Registrar la correlación: Load Number ↔ UUID del CFDI
#   3. Actualizar la trazabilidad con los datos fiscales del CFDI
#   4. Notificar a SAP el UUID del CFDI para vincular la CxC
#      con el documento fiscal timbrado
#   5. Detectar y gestionar errores de timbrado
#
# DATOS CLAVE DEL CFDI TIMBRADO:
#   - UUID              (folio fiscal, generado por el PAC)
#   - RFC emisor        (GM Transport)
#   - RFC receptor      (Grupo Andrea / entidad correspondiente)
#   - Total             (importe total con IVA)
#   - Subtotal          (importe antes de IVA)
#   - IVA               (impuesto trasladado)
#   - Fecha timbrado    (timestamp del PAC)
#   - Serie/Folio       (identificador interno del ERP)
#   - Load Number       (campo de referencia para correlación)
#   - ClaveProductoServicios / ClaveUnidad por cada concepto
# -----------------------------------------------------------------

Feature: HU-012 – Generación y registro de CFDI de ingreso timbrado por PAC externo

  Como sistema API de GM Transport,
  quiero recibir la notificación del ERP cuando el CFDI de ingreso queda timbrado
  por el PAC externo y registrar los datos fiscales en la trazabilidad,
  para vincular el documento fiscal con la CxC en SAP y mantener
  el control completo del ciclo factura-pago.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Recepción y registro exitoso de CFDI timbrado

    # Dado que el ERP generó y timbró el CFDI con el PAC
    Given que GM Transport ERP generó el CFDI para el Load Number "<load_number>"
    And el PAC externo timbró el CFDI y devolvió el UUID "<uuid_cfdi>"
    And el ERP notifica a la API el CFDI timbrado con los datos fiscales

    # Cuando la API recibe la notificación del CFDI timbrado
    When la API procesa la notificación con los campos:
        load_number "<load_number>",
        uuid_cfdi "<uuid_cfdi>",
        rfc_emisor "<rfc_emisor>",
        rfc_receptor "<rfc_receptor>",
        total "<total>",
        subtotal "<subtotal>",
        iva "<iva>" y
        fecha_timbrado "<fecha_timbrado>"

    # Entonces la API registra el CFDI y notifica a SAP
    Then la API almacena la correlación Load Number "<load_number>" ↔ UUID "<uuid_cfdi>"
    And el registro de trazabilidad se actualiza a estado "CFDI_TIMBRADO"
    And la API notifica a SAP el UUID "<uuid_cfdi>" para vincular con el documento "<doc_sap>"
    And SAP actualiza la CxC con la referencia fiscal del UUID "<uuid_cfdi>"
    And la API responde al ERP con código HTTP 200 y confirmación de registro

    Examples:
      | load_number     | uuid_cfdi                            | rfc_emisor     | rfc_receptor   | total     | subtotal  | iva      | fecha_timbrado      | doc_sap        |
      | LN-20260223-001 | 550e8400-e29b-41d4-a716-446655440001 | GGT081209393   | AND820101ABC   | 17400.00  | 15000.00  | 2400.00  | 2026-02-24T10:00:00 | SAP-DOC-000001 |
      | LN-20260227-010 | 550e8400-e29b-41d4-a716-446655440002 | GGT081209393   | AND820101ABC   | 9860.00   | 8500.00   | 1360.00  | 2026-02-28T11:00:00 | SAP-DOC-000002 |
      | LN-20260227-020 | 550e8400-e29b-41d4-a716-446655440003 | GGT081209393   | AND820101XYZ   | 13920.00  | 12000.00  | 1920.00  | 2026-02-28T12:00:00 | SAP-DOC-000003 |

  Scenario Outline: Consulta de datos fiscales del CFDI por Load Number

    # Dado que el CFDI fue timbrado y registrado en la API
    Given que el Load Number "<load_number>" tiene un CFDI timbrado con UUID "<uuid_cfdi>"

    # Cuando un sistema consulta los datos fiscales del CFDI
    When la API recibe una petición GET para el CFDI del Load Number "<load_number>"

    # Entonces la API devuelve los datos fiscales completos
    Then la API responde con código HTTP 200
    And la respuesta incluye: uuid_cfdi, rfc_emisor, rfc_receptor, total, subtotal, iva y fecha_timbrado
    And la respuesta incluye el estado fiscal "<estado_cfdi>"
    And la respuesta incluye el documento SAP correlacionado "<doc_sap>"

    Examples:
      | load_number     | uuid_cfdi                            | estado_cfdi | doc_sap        |
      | LN-20260223-001 | 550e8400-e29b-41d4-a716-446655440001 | VIGENTE     | SAP-DOC-000001 |
      | LN-20260227-010 | 550e8400-e29b-41d4-a716-446655440002 | VIGENTE     | SAP-DOC-000002 |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en el registro del CFDI timbrado

    # Dado que la notificación del CFDI presenta algún problema
    Given que el ERP notifica a la API un CFDI para el Load Number "<load_number>"
    And la notificación presenta la condición de error "<condicion_error>"

    # Cuando la API intenta procesar la notificación del CFDI
    When la API evalúa la notificación del CFDI timbrado

    # Entonces el registro falla con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el registro de trazabilidad se actualiza a estado "ERROR_REGISTRO_CFDI"
    And NO se actualiza la correlación UUID en la trazabilidad si el UUID es inválido
    And se genera alerta al equipo de soporte

    Examples:
      | load_number     | condicion_error                                          | http_code | error_code                     |
      | LN-20260223-001 | UUID del CFDI ausente o vacío                            | 422       | MISSING_UUID_CFDI              |
      | LN-20260223-001 | UUID del CFDI con formato inválido                       | 422       | INVALID_UUID_FORMAT            |
      | LN-20260223-001 | Load Number no existe en la capa de integración          | 404       | LOAD_NUMBER_NOT_FOUND          |
      | LN-20260223-001 | Load Number no tiene CxC generada en SAP aún             | 409       | CXC_NOT_GENERATED_YET          |
      | LN-20260227-010 | UUID duplicado: ya existe un CFDI registrado para ese LN | 409       | DUPLICATE_CFDI_UUID            |
      | LN-20260227-010 | RFC emisor no coincide con el RFC de GM Transport        | 422       | RFC_EMISOR_MISMATCH            |
      | LN-20260227-020 | Total del CFDI no coincide con el importe de la CxC SAP  | 422       | AMOUNT_MISMATCH_SAP_CFDI       |
      | LN-20260227-020 | SAP no disponible para vincular UUID con documento       | 503       | SAP_CONNECTION_TIMEOUT         |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-012-A] ¿El ERP notifica a la API el CFDI timbrado mediante
  #              webhook/push, o la API debe consultar periódicamente
  #              al ERP el estado del timbrado?
  #              → SUPUESTO TÉCNICO: webhook/push del ERP hacia la API,
  #              consistente con el mecanismo de cambio de estatus.
  #
  # [DUDA-012-B] ¿Qué sucede si el PAC rechaza el timbrado?
  #              ¿El ERP reintenta automáticamente o notifica a la API
  #              el fallo de timbrado? → PENDIENTE DE DEFINICIÓN.
  #
  # [DUDA-012-C] ¿La API debe validar la autenticidad del CFDI
  #              consultando al SAT (servicio de verificación)?
  #              → PENDIENTE DE DEFINICIÓN con el área fiscal.
  #
  # [DUDA-012-D] ¿El RFC receptor siempre es el RFC corporativo de
  #              Grupo Andrea, o varía por entidad/sucursal?
  #              → PENDIENTE DE DEFINICIÓN con el área fiscal.
  # ----------------------------------------------------------------
