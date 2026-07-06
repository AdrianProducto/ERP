# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 1 – Recepción e integración operativa desde WMS
# HU         : HU-002
# NOMBRE     : Validación de estructura del XML de WMS
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 2.0  ← actualizada con longitudes y campos reales de la API
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Una vez que GM Integra acusa recibo del XML (HU-001), valida
# su estructura y campos obligatorios antes de procesarlo.
#
# IMPACTO DE LA DOCUMENTACIÓN REAL DE LA API DEL ERP:
# Ahora que conocemos el mapeo XML→JSON exacto, las validaciones
# de longitud y obligatoriedad reflejan los límites reales de la
# API SolicitudViaje/Agregar y MaterialesPedimentos:
#
# MAPEO XML WMS → CAMPOS API ERP (con límites reales):
#   load_manifest_nbr → LoadNumber*      max 20 chars  (obligatorio)
#   facility_code     → Origen*          max 70 chars  (obligatorio)
#   route_nbr         → Destino*         max 70 chars  (obligatorio)
#   facility_code     → RecogerEn*       max 100 chars (obligatorio)
#   route_nbr         → EntregarEn*      max 100 chars (obligatorio)
#   total_weight      → Peso             Decimal 15,4  (opcional)
#   (campo libre)     → Observaciones    max 512 chars (opcional)
#
# CAMPOS FISCALES (para API MaterialesPedimentos — validados en HU-003):
#   ClaveProductoServicios → max 10 chars (obligatorio en materiales)
#   ClaveUnidad            → max 10 chars (obligatorio en materiales)
#   ClaveFraccionArancelaria → max 10 chars (opcional)
#
# CAMPOS ADICIONALES CONFIRMADOS:
#   pedimento → máscara SAT: 2 dígitos - 2 dígitos - 4 dígitos - 7 dígitos
# -----------------------------------------------------------------

Feature: HU-002 – Validación de estructura y campos del XML de WMS con límites reales de la API

  Como sistema API de GM Transport (GM Integra),
  quiero validar la estructura XML y los campos obligatorios del mensaje del WMS
  aplicando los límites y restricciones exactas que requiere la API del ERP,
  para garantizar que solo se procesan mensajes que pueden completar
  exitosamente el flujo hasta la creación del viaje y carga de materiales.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Validación estructural y de longitudes exitosa del XML

    # Dado que GM Integra recibió un XML del WMS
    Given que GM Integra recibió un XML del WMS con MessageId "<message_id>"
    And el nodo <Header> incluye: DocumentVersion, OriginSystem "WMS-GA",
        ClientEnvCode, ParentCompanyCode, Entity, TimeStamp y MessageId
    And el nodo <ListOfShippedLoads> contiene al menos un nodo <load>
    And el nodo <load> incluye los campos obligatorios con las siguientes restricciones:
        load_manifest_nbr "<load_manifest_nbr>" de máximo 20 caracteres,
        facility_code "<facility_code>" de máximo 70 caracteres,
        route_nbr "<route_nbr>" de máximo 70 caracteres,
        ship_date con formato de fecha válido y
        action_code con valor reconocido "<action_code>"
    And el campo total_weight tiene un valor decimal válido mayor a cero
    And cada nodo de material incluye shipped_qty, shipped_uom e item_alternate_code

    # Cuando GM Integra ejecuta la validación
    When la API procesa la validación estructural y semántica del XML

    # Entonces el XML es aprobado para continuar
    Then la validación concluye con resultado "VÁLIDO"
    And el registro de trazabilidad del MessageId "<message_id>" se actualiza a "VALIDADO"
    And el flujo continúa hacia el registro de materiales (HU-003)

    Examples:
      | message_id              | load_manifest_nbr | facility_code | route_nbr   | action_code |
      | MSG-WMS-20260223-000001 | LN-20260223-001   | WH-MTY-01     | RT-CDMX-005 | SHIP        |
      | MSG-WMS-20260223-000002 | LN-20260223-002   | WH-GDL-02     | RT-MTY-002  | SHIP        |
      | MSG-WMS-20260223-000003 | MAN-2026-0000003  | WH-MTY-01     | RT-SLP-001  | SHIP        |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Validación fallida por estructura, campos o longitudes incorrectas

    # Dado que el XML presenta un problema de estructura o datos
    Given que GM Integra recibió un XML del WMS con MessageId "<message_id>"
    And el XML presenta la condición de error "<condicion_error>"

    # Cuando GM Integra ejecuta la validación
    When la API procesa la validación estructural y semántica del XML

    # Entonces la validación rechaza el mensaje
    Then la validación concluye con resultado "INVÁLIDO"
    And la API responde con código HTTP 422
    And la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And la respuesta incluye el campo "invalidFields" listando los campos con problema
    And el registro de trazabilidad se actualiza a "RECHAZADO_VALIDACION"
    And NO se continúa el flujo hacia creación de solicitud de viaje
    And se notifica al equipo de soporte según el canal configurado

    Examples:
      | message_id              | condicion_error                                              | error_code                       |
      | MSG-WMS-20260223-000010 | Nodo <Header> ausente en el XML                              | MISSING_HEADER_NODE              |
      | MSG-WMS-20260223-000011 | Campo MessageId vacío o nulo                                 | MISSING_FIELD_MESSAGE_ID         |
      | MSG-WMS-20260223-000012 | Campo OriginSystem vacío o nulo                              | MISSING_FIELD_ORIGIN_SYSTEM      |
      | MSG-WMS-20260223-000013 | Nodo <ListOfShippedLoads> ausente                            | MISSING_SHIPPED_LOADS_NODE       |
      | MSG-WMS-20260223-000014 | Campo load_manifest_nbr ausente o vacío                      | MISSING_FIELD_MANIFEST_NBR       |
      | MSG-WMS-20260223-000015 | load_manifest_nbr excede 20 caracteres (límite API ERP)      | LOAD_NUMBER_EXCEEDS_MAX_LENGTH   |
      | MSG-WMS-20260223-000016 | Campo facility_code ausente o vacío                          | MISSING_FIELD_FACILITY_CODE      |
      | MSG-WMS-20260223-000017 | facility_code excede 70 caracteres (límite campo Origen API) | FACILITY_CODE_EXCEEDS_MAX_LENGTH |
      | MSG-WMS-20260223-000018 | Campo route_nbr ausente o vacío                              | MISSING_FIELD_ROUTE_NBR          |
      | MSG-WMS-20260223-000019 | route_nbr excede 70 caracteres (límite campo Destino API)    | ROUTE_NBR_EXCEEDS_MAX_LENGTH     |
      | MSG-WMS-20260223-000020 | Campo ship_date ausente o con formato inválido               | INVALID_DATE_FORMAT              |
      | MSG-WMS-20260223-000021 | Campo action_code con valor no reconocido                    | INVALID_ACTION_CODE              |
      | MSG-WMS-20260223-000022 | Nodo <load> sin ningún material/SKU                          | NO_MATERIALS_IN_LOAD             |
      | MSG-WMS-20260223-000023 | XML malformado (no parseable)                                | XML_PARSE_ERROR                  |
      | MSG-WMS-20260223-000024 | MessageId ya fue procesado anteriormente (duplicado)         | DUPLICATE_MESSAGE_ID             |
      | MSG-WMS-20260223-000025 | total_weight igual a cero o negativo                         | INVALID_TOTAL_WEIGHT             |

  # ----------------------------------------------------------------
  # CAMBIOS v2 — IMPACTO API REAL
  # ----------------------------------------------------------------
  # Los siguientes límites son exactos según la documentación de la API:
  #   load_manifest_nbr → LoadNumber*   max 20 chars
  #   facility_code     → Origen*       max 70 chars
  #   route_nbr         → Destino*      max 70 chars
  #   (dirección)       → RecogerEn*    max 100 chars
  #   (dirección)       → EntregarEn*   max 100 chars
  #   (notas)           → Observaciones max 512 chars
  #
  # [RESUELTA-002-C] ClaveProductoServicios y ClaveUnidad
  #              se validan en HU-003 (campos de materiales),
  #              no en la validación de estructura del viaje.
  #
  # [DUDA-002-A] ¿Existe un XSD formal del XML del WMS?
  #              → SUPUESTO TÉCNICO: validación por reglas de negocio.
  #
  # [DUDA-002-B] ¿Catálogo completo de valores de action_code?
  #              → SUPUESTO TÉCNICO: "SHIP" es el conocido.
  #              → PENDIENTE DE DEFINICIÓN con el equipo del WMS.
  # ----------------------------------------------------------------
