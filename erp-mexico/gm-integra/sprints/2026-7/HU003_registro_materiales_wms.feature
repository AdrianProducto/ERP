# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 1 – Recepción e integración operativa desde WMS
# HU         : HU-003
# NOMBRE     : Registro y mapeo de materiales/SKU desde WMS
#              para transformación a formato JSON de la API ERP
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 2.0  ← actualizada con mapeo real API MaterialesPedimentos
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Después de validar la estructura del XML (HU-002), GM Integra
# extrae y registra los materiales/SKUs del nodo <load>.
# El objetivo de este registro no es solo almacenar los datos,
# sino preparar el mapeo completo XML→JSON que será enviado
# posteriormente a la API MaterialesPedimentos del ERP (HU-008).
#
# MAPEO EXACTO XML WMS → JSON API MaterialesPedimentos:
#   XML WMS                    → JSON API ERP               Tipo/Límite
#   ──────────────────────────────────────────────────────────────────
#   shipped_qty                → Cantidad*                  INT, no 0
#   shipped_uom                → IdUnidadEmbalaje*          INT (catálogo)
#   item_alternate_code        → DescripcionMaterial*       String max 1024
#   (de total_weight/XML)      → Peso*                      via IdUnidadPeso
#   shipped_uom                → IdUnidadPeso*              INT:
#                                                           21=Kilogramos
#                                                           26=Libras
#                                                           48=Toneladas
#   ClaveProductoServicios     → ClaveProductoServicios*    String max 10
#   ClaveUnidad                → ClaveUnidad*               String max 10
#   ClaveFraccionArancelaria   → ClaveFraccionArancelaria   String max 10
#   pedimento (si aplica)      → Pedimentos[].Pedimento     Máscara SAT:
#                                                           2-2-4-7 dígitos
#   (trayecto)                 → Trayecto[].IdViajeTrayecto INT (de consulta)
#
# REGLAS CONFIRMADAS:
#   - Materiales peligrosos: NO aplican para Grupo Andrea
#   - Pedimentos aduanales: SÍ pueden incluirse en el XML
#   - ClaveProductoServicios y ClaveUnidad: max 10 chars, obligatorios
#   - Ausencia de claves SAT = ERROR bloqueante
#   - El operador puede capturar claves faltantes en el integrador
#   - IdUnidadEmbalaje e IdUnidadPeso requieren catálogo de equivalencias
#     entre shipped_uom del WMS y los enteros del ERP
# -----------------------------------------------------------------

Feature: HU-003 – Registro y mapeo de materiales/SKU del XML de WMS para transformación a JSON

  Como sistema API de GM Transport (GM Integra),
  quiero extraer, validar y registrar los materiales/SKUs del XML del WMS
  aplicando el mapeo exacto al formato JSON requerido por la API MaterialesPedimentos,
  para que la carga de materiales sobre la Carta Porte (HU-008) pueda
  ejecutarse sin errores de validación en el ERP.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Registro y mapeo exitoso de materiales desde el XML

    # Dado que el XML del WMS fue validado correctamente (HU-002)
    Given que el XML del WMS con MessageId "<message_id>" superó la validación estructural
    And el XML contiene "<total_skus>" nodos de material con los campos:
        item_alternate_code "<item_code>",
        shipped_qty "<qty>" mayor a cero,
        shipped_uom "<uom>",
        ClaveProductoServicios "<clave_producto>" de máximo 10 caracteres y
        ClaveUnidad "<clave_unidad>" de máximo 10 caracteres

    # Cuando GM Integra procesa el mapeo de materiales
    When GM Integra extrae y mapea los materiales del XML al modelo interno

    # Entonces los materiales quedan registrados con el mapeo completo
    Then se registran "<total_skus>" líneas de material para el MessageId "<message_id>"
    And cada línea incluye:
        Cantidad (de shipped_qty),
        DescripcionMaterial (de item_alternate_code),
        IdUnidadEmbalaje (mapeado desde shipped_uom vía catálogo),
        IdUnidadPeso (mapeado desde shipped_uom vía catálogo),
        ClaveProductoServicios y
        ClaveUnidad
    And todos los materiales tienen estado "FISCALMENTE_COMPLETO"
    And el registro de trazabilidad se actualiza a "MATERIALES_REGISTRADOS"
    And el flujo continúa hacia la creación de solicitud de viaje (HU-004)

    Examples:
      | message_id              | total_skus | item_code   | qty | uom | clave_producto | clave_unidad |
      | MSG-WMS-20260223-000001 | 3          | ALT-SKU-001 | 10  | EA  | 78101800       | H87          |
      | MSG-WMS-20260223-000002 | 1          | ALT-SKU-002 | 5   | CS  | 78101800       | KGM          |
      | MSG-WMS-20260223-000003 | 8          | ALT-SKU-003 | 100 | EA  | 62161500       | H87          |

  Scenario Outline: Mapeo exitoso de shipped_uom a IdUnidadEmbalaje e IdUnidadPeso

    # Dado que el XML incluye materiales con diferentes unidades de medida
    Given que el XML contiene un material con shipped_uom "<uom_xml>"
    And existe una equivalencia en el catálogo de GM Integra para ese UOM

    # Cuando GM Integra ejecuta el mapeo de unidades
    When GM Integra convierte shipped_uom "<uom_xml>" usando el catálogo interno

    # Entonces los identificadores enteros quedan mapeados correctamente
    Then IdUnidadEmbalaje queda con valor "<id_embalaje>"
    And IdUnidadPeso queda con valor "<id_peso>" según el catálogo ERP:
        21 = Kilogramos, 26 = Libras, 48 = Toneladas

    Examples:
      | uom_xml | id_embalaje | id_peso |
      | KG      | 21          | 21      |
      | EA      | 1           | 21      |
      | CS      | 4           | 21      |
      | LB      | 26          | 26      |
      | TON     | 48          | 48      |

  Scenario Outline: Registro exitoso de pedimento aduanal en material

    # Dado que el XML incluye un nodo de pedimento aduanal
    Given que el XML del WMS con MessageId "<message_id>" superó la validación estructural
    And el nodo de material contiene un campo de pedimento con valor "<numero_pedimento>"
    And el número de pedimento cumple la máscara SAT: 2-2-4-7 dígitos

    # Cuando GM Integra procesa el material con pedimento
    When GM Integra extrae y mapea el material al modelo interno

    # Entonces el pedimento queda registrado para su envío al ERP
    Then el pedimento "<numero_pedimento>" queda asociado al material
    And el material queda en estado "COMPLETO_CON_PEDIMENTO"
    And el pedimento será incluido en el nodo Pedimentos[] del JSON para HU-008

    Examples:
      | message_id              | numero_pedimento    |
      | MSG-WMS-20260223-000001 | 20 12 0000 0123456  |
      | MSG-WMS-20260223-000002 | 21 24 4321 9876543  |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Registro fallido por campo obligatorio faltante o inválido

    # Dado que el XML tiene un problema en los datos de materiales
    Given que el XML del WMS con MessageId "<message_id>" superó la validación estructural
    And el nodo de material presenta la condición de error "<condicion_error>"

    # Cuando GM Integra intenta procesar el mapeo
    When GM Integra extrae y mapea los materiales del XML al modelo interno

    # Entonces el registro falla o queda bloqueado
    Then la API genera resultado "<resultado>"
    And el estado en trazabilidad se actualiza a "<estado_trazabilidad>"
    And la respuesta incluye "errorCode" con valor "<error_code>"
    And si el resultado es "ERROR" NO se continúa el flujo hacia creación del viaje

    Examples:
      | message_id              | condicion_error                                              | resultado | estado_trazabilidad     | error_code                       |
      | MSG-WMS-20260223-000030 | shipped_qty igual a cero o negativo                          | ERROR     | RECHAZADO_MATERIALES    | INVALID_SHIPPED_QTY              |
      | MSG-WMS-20260223-000031 | item_alternate_code vacío o nulo                             | ERROR     | RECHAZADO_MATERIALES    | MISSING_ITEM_CODE                |
      | MSG-WMS-20260223-000032 | shipped_uom sin equivalencia en catálogo de GM Integra       | ERROR     | RECHAZADO_MATERIALES    | INVALID_UOM_NO_MAPPING           |
      | MSG-WMS-20260223-000033 | ClaveProductoServicios ausente o vacío (campo adicional XML) | ERROR     | RECHAZADO_FISCAL        | MISSING_CLAVE_PRODUCTO_SAT       |
      | MSG-WMS-20260223-000034 | ClaveUnidad ausente o vacía (campo adicional XML)            | ERROR     | RECHAZADO_FISCAL        | MISSING_CLAVE_UNIDAD_SAT         |
      | MSG-WMS-20260223-000035 | ClaveProductoServicios excede 10 caracteres                  | ERROR     | RECHAZADO_FISCAL        | CLAVE_PRODUCTO_EXCEEDS_MAX_LENGTH|
      | MSG-WMS-20260223-000036 | ClaveUnidad excede 10 caracteres                             | ERROR     | RECHAZADO_FISCAL        | CLAVE_UNIDAD_EXCEEDS_MAX_LENGTH  |
      | MSG-WMS-20260223-000037 | ClaveProductoServicios con valor no válido en catálogo SAT   | ERROR     | RECHAZADO_FISCAL        | INVALID_CLAVE_PRODUCTO_SAT       |
      | MSG-WMS-20260223-000038 | ClaveFraccionArancelaria excede 10 caracteres                | ERROR     | RECHAZADO_MATERIALES    | FRACCION_EXCEEDS_MAX_LENGTH      |
      | MSG-WMS-20260223-000039 | Pedimento con formato inválido (no cumple máscara SAT 2-2-4-7)| ERROR    | RECHAZADO_MATERIALES    | INVALID_PEDIMENTO_FORMAT         |
      | MSG-WMS-20260223-000040 | item_alternate_code excede 1024 caracteres                   | ERROR     | RECHAZADO_MATERIALES    | DESCRIPCION_EXCEEDS_MAX_LENGTH   |
      | MSG-WMS-20260223-000041 | Nodo <load> sin ningún material/SKU                          | ERROR     | RECHAZADO_MATERIALES    | NO_MATERIALS_IN_LOAD             |

  # ----------------------------------------------------------------
  # CAMBIOS v2 — IMPACTO API REAL
  # ----------------------------------------------------------------
  # [v2] Mapeo exacto XML→JSON confirmado por documentación de la API:
  #      - shipped_qty   → Cantidad (INT, no puede ser 0)
  #      - shipped_uom   → IdUnidadEmbalaje + IdUnidadPeso (catálogo)
  #      - item_alt_code → DescripcionMaterial (max 1024 chars)
  #      - ClaveProdServ → ClaveProductoServicios (max 10 chars, obligatorio)
  #      - ClaveUnidad   → ClaveUnidad (max 10 chars, obligatorio)
  #      - pedimento     → Pedimentos[].Pedimento (máscara 2-2-4-7)
  #
  # [v2] Materiales peligrosos: NO aplican para Grupo Andrea.
  #      Campos EsMaterialPeligroso, ClaveMaterialPeligroso,
  #      TipoEmbalaje y DescripcionEmbalaje quedan excluidos del mapeo.
  #
  # [RESUELTA-003-A/B] ClaveProductoServicios y ClaveUnidad llegan
  #              en campos adicionales del XML. Límite: max 10 chars.
  #
  # [RESUELTA-003-C] Ausencia de claves SAT = ERROR bloqueante.
  #              El operador puede capturarlas en el integrador.
  #
  # [DUDA-003-D] ¿Catálogo completo de equivalencias
  #              shipped_uom → IdUnidadEmbalaje / IdUnidadPeso?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de ERP.
  #              Los valores confirmados: 21=KG, 26=Libras, 48=Toneladas.
  #              La tabla de la Épica 1 usa: EA, CS, LB, TON, KG.
  #              → Requiere mapeo completo antes del desarrollo de HU-008.
  # ----------------------------------------------------------------
