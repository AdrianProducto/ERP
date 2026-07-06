# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 2 – Recepción de solicitudes (también aplica WMS)
# HU         : HU-008
# NOMBRE     : Carga de materiales y pedimentos sobre viaje aceptado
#              vía API MaterialesPedimentos — con transformación XML→JSON
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 3.0  ← actualizada con documentación real de la API
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Cuando GM Transport acepta una solicitud de viaje y la convierte
# en Carta Porte, GM Integra debe cargar los materiales/pedimentos
# usando el endpoint real del ERP.
#
# FLUJO CONFIRMADO:
#   1. HU-004/007: POST SolicitudViaje/Agregar → obtiene IdSolicitud
#   2. GET SolicitudViaje/Consultar/{IdSolicitud} → obtiene SucursalFolio
#      (solo disponible cuando la solicitud está ACEPTADA)
#   3. Esta HU: POST MaterialesPedimentos/{SucursalFolio}
#
# ENDPOINT CONFIRMADO:
#   POST https://appapitest.gmtransport.co/api/gmterpv8/importacion/
#        MaterialesPedimentos/{SucursalFolio}
#
# AUTENTICACIÓN (Basic Auth — diferente al endpoint de solicitudes):
#   Header Authorization : basic {Base64(Usuario:Contraseña)}
#   Header RFC           : RFC del cliente
#   Header Aplicacion    : 5  ← valor distinto al de SolicitudViaje (4)
#   Header Content-Type  : application/json
#
# TRANSFORMACIÓN XML → JSON (responsabilidad de GM Integra):
#   GM Integra recibe el XML del WMS/SIAV/Box Store y debe
#   transformarlo al formato JSON que requiere este endpoint.
#   No se envía el XML directamente al ERP.
#
# MAPEO XML → JSON (campos obligatorios *):
#   XML WMS/SIAV/BS           → JSON API MaterialesPedimentos
#   ──────────────────────────────────────────────────────────
#   shipped_qty               → Cantidad*         (INT)
#   (catálogo GM Integra)     → IdUnidadEmbalaje*  (INT)
#   item_alternate_code       → DescripcionMaterial* (String max 1024)
#   (calculado de total_weight)→ Peso (implícito en IdUnidadPeso)
#   (catálogo GM Integra)     → IdUnidadPeso*      (21=KG, 26=Lb, 48=Ton)
#   ClaveProductoServicios    → ClaveProductoServicios* (max 10)
#   ClaveUnidad               → ClaveUnidad*        (max 10)
#   (si aplica)               → ClaveFraccionArancelaria (max 10)
#   (si aplica)               → EsMaterialPeligroso (Bit 0/1)
#   (si peligroso)            → ClaveMaterialPeligroso, TipoEmbalaje
#   IdViajeTrayecto           → Trayecto[].IdViajeTrayecto (de consulta)
#   (número aduanal)          → Pedimentos[].Pedimento (máscara SAT)
#
# RESPUESTA EXITOSA (HTTP 200):
#   { "ok": "True" }
#
# VALIDACIONES CRÍTICAS DEL ERP (bloquean la importación):
#   - Viaje timbrado con Carta Porte → no permite modificaciones
#   - Viaje facturado con Carta Porte → no permite modificaciones
#   - Viaje cancelado → no permite modificaciones
#   - Viaje TERMINADO → no permite modificaciones
#   - Trayectos con llegada registrada → no permite modificaciones
#   - Pedimentos duplicados: se agregan solo los no repetidos
# -----------------------------------------------------------------

Feature: HU-008 – Carga de materiales y pedimentos vía API MaterialesPedimentos con transformación XML→JSON

  Como sistema API de GM Transport (GM Integra),
  quiero recibir el XML de materiales de WMS, SIAV o Box Store,
  transformarlo al formato JSON requerido por el endpoint MaterialesPedimentos
  y enviarlo al ERP usando el SucursalFolio como llave de correlación,
  para que la Carta Porte quede completa con la información fiscal
  y operativa de la mercancía a transportar.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Transformación exitosa de XML a JSON y carga de materiales en ERP

    # Dado que la solicitud de viaje fue aceptada y se tiene el SucursalFolio
    Given que la solicitud con LoadNumber "<load_number>" tiene estado "ACEPTADA" en ERP
    And GM Integra obtuvo el SucursalFolio "<sucursal_folio>" de la consulta de la solicitud
    And el sistema "<origin_system>" envió el XML de materiales para el LoadNumber "<load_number>"
    And el XML contiene "<total_lineas>" nodos de material con los campos obligatorios:
        shipped_qty, item_alternate_code, ClaveProductoServicios y ClaveUnidad
    And GM Integra transforma el XML al JSON requerido por el endpoint:
        mapeando ClaveProductoServicios, ClaveUnidad, Cantidad, DescripcionMaterial,
        IdUnidadEmbalaje e IdUnidadPeso según catálogos internos de GM Integra
    And el header Authorization contiene "basic <token_base64>"
    And el header RFC contiene "<rfc_cliente>"
    And el header Aplicacion contiene "5"

    # Cuando GM Integra envía el POST al endpoint del ERP
    When GM Integra realiza POST a "/api/gmterpv8/importacion/MaterialesPedimentos/<sucursal_folio>"

    # Entonces el ERP confirma la carga exitosa
    Then el ERP responde con código HTTP 200
    And la respuesta incluye "ok": "True"
    And los "<total_lineas>" materiales quedan registrados en la Carta Porte "<sucursal_folio>"
    And el registro de trazabilidad se actualiza a estado "MATERIALES_CARGADOS_CARTA_PORTE"
    And el ERP genera una notificación interna indicando el viaje actualizado

    Examples:
      | origin_system | load_number     | sucursal_folio | total_lineas | rfc_cliente  | token_base64     |
      | WMS           | LN-20260223-001 | MA-002001      | 5            | GGT081209393 | dXNlcjpwYXNz |
      | WMS           | LN-20260223-002 | MA-002002      | 1            | GGT081209393 | dXNlcjpwYXNz |
      | SIAV          | LN-20260227-010 | MA-002030      | 3            | GGT081209393 | dXNlcjpwYXNz |
      | Box Store     | LN-20260227-020 | MA-002032      | 8            | GGT081209393 | dXNlcjpwYXNz |

  Scenario Outline: Carga de materiales con pedimentos aduanales

    # Dado que el viaje involucra mercancía con pedimento de importación
    Given que la Carta Porte con SucursalFolio "<sucursal_folio>" está en estado ACEPTADA
    And el XML incluye un nodo de pedimentos con número "<numero_pedimento>"
    And el número de pedimento cumple la máscara SAT: 2 dígitos - 2 dígitos - 4 dígitos - 7 dígitos

    # Cuando GM Integra transforma y envía el JSON con el nodo Pedimentos
    When GM Integra realiza POST a "/api/gmterpv8/importacion/MaterialesPedimentos/<sucursal_folio>"

    # Entonces el pedimento queda registrado correctamente
    Then el ERP responde con "ok": "True"
    And el pedimento "<numero_pedimento>" queda asociado a la Carta Porte "<sucursal_folio>"
    And el registro de trazabilidad confirma estado "MATERIALES_Y_PEDIMENTOS_CARGADOS"

    Examples:
      | sucursal_folio | numero_pedimento        |
      | MA-002001      | 20 12 0000 0123456      |
      | MA-002030      | 21 24 4321 9876543      |

  Scenario Outline: Carga de material peligroso con campos adicionales

    # Dado que el XML incluye un material marcado como peligroso
    Given que la Carta Porte con SucursalFolio "<sucursal_folio>" está ACEPTADA
    And el XML contiene un material con EsMaterialPeligroso = 1
    And el material incluye ClaveMaterialPeligroso "<clave_mp>",
        TipoEmbalaje "<tipo_embalaje>" y DescripcionEmbalaje "<desc_embalaje>"

    # Cuando GM Integra transforma y envía el JSON
    When GM Integra realiza POST a "/api/gmterpv8/importacion/MaterialesPedimentos/<sucursal_folio>"

    # Entonces el ERP registra el material con sus atributos de peligrosidad
    Then el ERP responde con "ok": "True"
    And el material peligroso queda registrado con ClaveMaterialPeligroso, TipoEmbalaje y DescripcionEmbalaje
    And el registro de trazabilidad confirma estado "MATERIALES_CARGADOS_CARTA_PORTE"

    Examples:
      | sucursal_folio | clave_mp | tipo_embalaje | desc_embalaje      |
      | MA-002001      | UN1203   | 4G            | Bidón de plástico  |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en transformación XML→JSON por campo obligatorio faltante

    # Dado que el XML del sistema origen tiene un campo obligatorio faltante
    Given que GM Integra intenta transformar el XML de "<origin_system>" para SucursalFolio "<sucursal_folio>"
    And el XML presenta la condición de error "<condicion_error>"

    # Cuando GM Integra ejecuta la transformación
    When GM Integra valida y transforma el XML al formato JSON

    # Entonces la transformación falla antes de llamar al ERP
    Then GM Integra NO envía la petición al endpoint del ERP
    And el registro de trazabilidad se actualiza a estado "ERROR_TRANSFORMACION_XML_JSON"
    And el cuerpo del error incluye el campo "<campo_faltante>" y la descripción del problema
    And el mensaje queda en cola de errores para corrección manual

    Examples:
      | origin_system | sucursal_folio | condicion_error                              | campo_faltante          |
      | WMS           | MA-002001      | ClaveProductoServicios ausente en XML        | ClaveProductoServicios  |
      | WMS           | MA-002001      | ClaveUnidad ausente en XML                   | ClaveUnidad             |
      | SIAV          | MA-002030      | shipped_qty igual a cero o negativo          | Cantidad                |
      | Box Store     | MA-002032      | item_alternate_code vacío                    | DescripcionMaterial     |
      | WMS           | MA-002001      | IdUnidadEmbalaje sin equivalencia en catálogo| IdUnidadEmbalaje        |
      | SIAV          | MA-002030      | IdUnidadPeso sin equivalencia en catálogo    | IdUnidadPeso            |

  Scenario Outline: Rechazo del ERP por estado del viaje no permitido

    # Dado que el viaje está en un estado que no permite modificaciones
    Given que GM Integra envía POST a "/api/gmterpv8/importacion/MaterialesPedimentos/<sucursal_folio>"
    And el viaje con SucursalFolio "<sucursal_folio>" presenta la condición "<condicion_error>"

    # Cuando el ERP procesa la petición
    When GM Integra evalúa la respuesta del ERP

    # Entonces el ERP rechaza la carga con el código de error correspondiente
    Then el ERP responde con faultcode "<fault_code>"
    And GM Integra registra el fallo con estado "ERROR_CARGA_MATERIALES_ERP"
    And el cuerpo del error incluye la descripción: "<descripcion_error>"
    And el mensaje queda en cola de errores para revisión manual

    Examples:
      | sucursal_folio | condicion_error                                          | fault_code | descripcion_error                                              |
      | MA-002001      | SucursalFolio no existe en el sistema                    | 1          | La sucursal no existe en el sistema, favor de validar          |
      | MA-002001      | No se encontró viaje con ese folio                       | 2          | No se encontró un viaje con el folio sucursal proporcionado    |
      | MA-002002      | Viaje cancelado                                          | 3          | No puede ser modificado este viaje porque está cancelado       |
      | MA-002002      | Trayecto con llegada registrada                          | 4          | No puede ser modificado este viaje porque tiene trayectos con llegada |
      | MA-002030      | Carta Porte ya timbrada                                  | 5          | Esta carta porte ya se encuentra timbrada                      |
      | MA-002030      | Carta Porte ya tiene facturas                            | 6          | Esta carta porte ya cuenta con facturas                        |
      | MA-002032      | Viaje ya terminado                                       | 7          | Este viaje ya ha sido terminado                                |
      | MA-002032      | Error interno al registrar materiales                    | 501        | Sucedió un error al momento de registrar los materiales        |

  Scenario Outline: Rechazo del ERP por error en campos del material (faultcode 8)

    # Dado que algún campo del material en el JSON no cumple las reglas del ERP
    Given que GM Integra envía POST a "/api/gmterpv8/importacion/MaterialesPedimentos/<sucursal_folio>"
    And el JSON contiene un material con la condición de error "<condicion_error>"

    # Cuando el ERP valida el contenido del JSON
    When el ERP procesa la petición de materiales

    # Entonces el ERP rechaza con faultcode 8 y detalle del campo fallido
    Then el ERP responde con faultcode "8"
    And la respuesta incluye faultstring con el mensaje: "<mensaje_error>"
    And GM Integra registra el fallo con estado "ERROR_VALIDACION_MATERIAL_ERP"
    And el mensaje queda en cola de errores para corrección manual

    Examples:
      | sucursal_folio | condicion_error                                       | mensaje_error                                               |
      | MA-002001      | Cantidad del material igual a 0                       | El campo Cantidad del material X no puede ser 0             |
      | MA-002001      | IdUnidadEmbalaje no existe en catálogo ERP            | El campo IdUnidadEmbalaje del material X no existe          |
      | MA-002001      | DescripcionMaterial vacía                             | El campo DescripcionMaterial es obligatorio                 |
      | MA-002001      | Peso del material igual a 0                           | El campo Peso del material X no puede ser 0                 |
      | MA-002001      | IdUnidadPeso no existe en catálogo ERP                | El campo IdUnidadPeso del material X no existe              |
      | MA-002001      | ClaveProductoServicios no existe en catálogo SAT      | El campo ClaveProductoServicios del material X no existe    |
      | MA-002001      | ClaveUnidad no existe en catálogo SAT                 | El campo ClaveUnidad del material X no existe               |
      | MA-002001      | Número de pedimento no cumple máscara SAT             | El número de pedimento X no cumple con la máscara del SAT   |

  Scenario Outline: Fallo por error de autenticación o licenciamiento

    # Dado que la petición tiene un problema de acceso
    Given que GM Integra envía POST a "/api/gmterpv8/importacion/MaterialesPedimentos/<sucursal_folio>"
    And la petición presenta la condición de acceso "<condicion_error>"

    # Cuando el ERP evalúa los headers
    When el ERP procesa los headers de la petición

    # Entonces el ERP rechaza con el código HTTP apropiado
    Then el ERP responde con código HTTP "<http_code>"
    And GM Integra registra el fallo con estado "ERROR_AUTH_MATERIALES_ERP"

    Examples:
      | sucursal_folio | condicion_error                                   | http_code |
      | MA-002001      | RFC en header con formato inválido                | 400       |
      | MA-002001      | Usuario/contraseña incorrectos                    | 404       |
      | MA-002001      | Módulo de tráfico no contratado                   | 402       |
      | MA-002001      | Error en conexión a BD del cliente                | 403       |
      | MA-002001      | Token Basic Auth ausente o mal formado            | 401       |

  # ----------------------------------------------------------------
  # CAMBIOS RESPECTO A VERSIONES ANTERIORES
  # ----------------------------------------------------------------
  # [v3] Cambios confirmados por documentación real de la API:
  #      - Endpoint real: POST MaterialesPedimentos/{SucursalFolio}
  #      - Llave de correlación: SucursalFolio (NO Load Number)
  #      - GM Integra transforma XML → JSON (no envía XML directo)
  #      - Header Aplicacion = 5 (diferente al endpoint de solicitudes)
  #      - Respuesta exitosa: {"ok": "True"}
  #      - 13 códigos de error propios del ERP documentados
  #      - Pedimentos con máscara SAT: 2-2-4-7 dígitos
  #      - Materiales peligrosos con campos adicionales requeridos
  #      - Pedimentos duplicados: el ERP agrega solo los no repetidos
  #
  # [DUDA-008-A] ¿El catálogo de equivalencias
  #              shipped_uom → IdUnidadEmbalaje/IdUnidadPeso
  #              está definido en GM Integra?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de ERP.
  #              Ejemplo documentado: 21=KG, 26=Libras, 48=Toneladas.
  #
  # [DUDA-008-B] ¿Cómo obtiene GM Integra el IdViajeTrayecto para
  #              el nodo Trayecto del JSON?
  #              → Se obtiene de la respuesta del endpoint
  #              GET SolicitudViaje/Consultar/{IdSolicitud} cuando
  #              el viaje está ACEPTADO (campo Trayectos[].IdTrayecto).
  # ----------------------------------------------------------------
