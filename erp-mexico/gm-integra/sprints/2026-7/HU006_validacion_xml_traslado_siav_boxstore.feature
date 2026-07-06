# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 2 – Recepción de solicitudes desde SIAV y Box Store
# HU         : HU-006
# NOMBRE     : Validación de estructura XML de solicitud de traslado
#              desde SIAV y Box Store
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Después de que la API acusa recibo del XML de SIAV o Box Store
# (HU-005), debe validar que la estructura y los campos obligatorios
# sean correctos para poder crear una solicitud de traslado entre
# sucursales en GM Transport ERP.
#
# A diferencia del WMS (que envía cargas de CD con manifest),
# SIAV y Box Store envían solicitudes de traslado entre sucursales,
# por lo que los campos clave del nodo de solicitud son distintos:
# sucursal de origen, sucursal de destino, tipo de mercancía,
# cantidad/peso estimado y fecha requerida de traslado.
#
# El nodo Header comparte la misma estructura que el WMS.
# El nodo de solicitud de traslado es específico de SIAV/Box Store.
# -----------------------------------------------------------------

Feature: HU-006 – Validación de estructura y campos del XML de traslado de SIAV y Box Store

  Como sistema API de GM Transport,
  quiero validar la estructura XML y los campos obligatorios de las solicitudes
  de traslado enviadas por SIAV y Box Store,
  para garantizar que solo se procesan solicitudes correctamente formadas
  y con datos suficientes para crear el viaje en GM Transport ERP.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Validación estructural exitosa del XML de traslado

    # Dado que la API recibió un XML de SIAV o Box Store
    Given que la API recibió un XML del sistema "<origin_system>" con MessageId "<message_id>"
    And el XML contiene el nodo <Header> con los campos:
        DocumentVersion, OriginSystem "<origin_system_code>",
        ClientEnvCode, ParentCompanyCode, Entity, TimeStamp y MessageId
    And el XML contiene el nodo de solicitud de traslado con los campos obligatorios:
        sucursal_origen "<sucursal_origen>",
        sucursal_destino "<sucursal_destino>",
        tipo_mercancia "<tipo_mercancia>",
        cantidad_estimada "<cantidad>" mayor a cero,
        unidad_medida "<unidad>",
        fecha_requerida "<fecha_requerida>"
    And el campo "sucursal_origen" es distinto al campo "sucursal_destino"
    And el campo "fecha_requerida" tiene un formato de fecha válido

    # Cuando la API ejecuta la validación estructural y semántica
    When la API procesa la validación del XML de traslado

    # Entonces el XML es aprobado para continuar el flujo
    Then la validación concluye con resultado "VÁLIDO"
    And el registro de trazabilidad del MessageId "<message_id>" se actualiza a "VALIDADO"
    And el flujo continúa hacia la creación de solicitud de viaje en ERP

    Examples:
      | origin_system | origin_system_code | message_id               | sucursal_origen | sucursal_destino | tipo_mercancia | cantidad | unidad | fecha_requerida     |
      | SIAV          | SIAV-GA            | MSG-SIAV-20260227-000001 | SUC-MTY-001     | SUC-CDMX-005     | ROPA           | 500      | PZA    | 2026-02-27T08:00:00 |
      | SIAV          | SIAV-GA            | MSG-SIAV-20260227-000002 | SUC-GDL-003     | SUC-MTY-002      | CALZADO        | 200      | PZA    | 2026-02-28T10:00:00 |
      | Box Store     | BOXSTORE-GA        | MSG-BS-20260227-000001   | SUC-CDMX-010    | SUC-QRO-001      | ACCESORIOS     | 100      | PZA    | 2026-02-27T12:00:00 |
      | Box Store     | BOXSTORE-GA        | MSG-BS-20260227-000002   | SUC-MTY-004     | SUC-SLP-002      | ROPA           | 350      | PZA    | 2026-03-01T09:00:00 |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Validación fallida por estructura o campos incorrectos en XML de traslado

    # Dado que el XML de SIAV o Box Store presenta un problema
    Given que la API recibió un XML del sistema "<origin_system>" con MessageId "<message_id>"
    And el XML presenta la condición de error "<condicion_error>"

    # Cuando la API ejecuta la validación
    When la API procesa la validación del XML de traslado

    # Entonces la validación rechaza el mensaje
    Then la validación concluye con resultado "INVÁLIDO"
    And la API responde con código HTTP 422
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el cuerpo de la respuesta incluye el campo "invalidFields" listando los campos con problema
    And el registro de trazabilidad del MessageId "<message_id>" se actualiza a "RECHAZADO_VALIDACION"
    And NO se genera ninguna solicitud de viaje en GM Transport ERP
    And se genera una alerta al equipo de soporte según el canal configurado

    Examples:
      | origin_system | message_id               | condicion_error                                              | error_code                       |
      | SIAV          | MSG-SIAV-20260227-000010 | Nodo <Header> ausente                                        | MISSING_HEADER_NODE              |
      | SIAV          | MSG-SIAV-20260227-000011 | Campo MessageId vacío o nulo                                 | MISSING_FIELD_MESSAGE_ID         |
      | SIAV          | MSG-SIAV-20260227-000012 | Campo OriginSystem vacío o nulo                              | MISSING_FIELD_ORIGIN_SYSTEM      |
      | Box Store     | MSG-BS-20260227-000010   | Nodo de solicitud de traslado ausente                        | MISSING_TRANSFER_REQUEST_NODE    |
      | Box Store     | MSG-BS-20260227-000011   | Campo sucursal_origen vacío o nulo                           | MISSING_FIELD_SUCURSAL_ORIGEN    |
      | Box Store     | MSG-BS-20260227-000012   | Campo sucursal_destino vacío o nulo                          | MISSING_FIELD_SUCURSAL_DESTINO   |
      | SIAV          | MSG-SIAV-20260227-000013 | sucursal_origen igual a sucursal_destino                     | SAME_ORIGIN_DESTINATION          |
      | SIAV          | MSG-SIAV-20260227-000014 | Campo cantidad_estimada igual a cero o negativo              | INVALID_QUANTITY                 |
      | Box Store     | MSG-BS-20260227-000013   | Campo fecha_requerida con formato inválido                   | INVALID_DATE_FORMAT              |
      | Box Store     | MSG-BS-20260227-000014   | Campo fecha_requerida en el pasado                           | INVALID_DATE_IN_PAST             |
      | SIAV          | MSG-SIAV-20260227-000015 | Campo tipo_mercancia vacío o nulo                            | MISSING_FIELD_TIPO_MERCANCIA     |
      | SIAV          | MSG-SIAV-20260227-000016 | XML malformado (no parseable)                                | XML_PARSE_ERROR                  |
      | Box Store     | MSG-BS-20260227-000015   | MessageId ya procesado anteriormente (duplicado)             | DUPLICATE_MESSAGE_ID             |
      | SIAV          | MSG-SIAV-20260227-000017 | Campo sucursal_origen no existe en catálogo de sucursales    | INVALID_SUCURSAL_ORIGEN          |
      | Box Store     | MSG-BS-20260227-000016   | Campo sucursal_destino no existe en catálogo de sucursales   | INVALID_SUCURSAL_DESTINO         |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-006-A] ¿El nodo de solicitud de traslado de SIAV y Box Store
  #              tiene un nombre definido? (ej. <TransferRequest>,
  #              <SolicitudTraslado>).  Se usa nombre genérico como
  #              SUPUESTO TÉCNICO hasta que se documente el XML real.
  #
  # [DUDA-006-B] ¿Los campos de la solicitud de traslado son los mismos
  #              para SIAV y Box Store, o cada sistema tiene campos
  #              específicos adicionales?
  #              → PENDIENTE DE DEFINICIÓN.  Se asume estructura común
  #              como SUPUESTO TÉCNICO.
  #
  # [DUDA-006-C] ¿Existe un catálogo de sucursales en la API/ERP para
  #              validar sucursal_origen y sucursal_destino?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de ERP.
  #
  # [RESUELTA-006-D] ClaveProductoServicios y ClaveUnidad SAT NO aplican
  #              en la solicitud de viaje inicial.
  #              Flujo confirmado:
  #              1. Se crea la solicitud de viaje (sin materiales/claves SAT)
  #              2. GM Transport la acepta → se convierte en Carta Porte
  #              3. Con el Load Number como llave de correlación, se carga
  #                 posteriormente el XML de materiales con sus claves SAT
  #                 mediante una segunda API independiente (ver HU-008).
  #
  # [DUDA-006-E] ¿Cuáles son los valores válidos para tipo_mercancia?
  #              ¿Existe un catálogo definido?
  #              → PENDIENTE DE DEFINICIÓN.
  # ----------------------------------------------------------------
