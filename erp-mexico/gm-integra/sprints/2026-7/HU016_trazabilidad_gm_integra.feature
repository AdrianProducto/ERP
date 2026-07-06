# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 4 – Validaciones, seguridad y trazabilidad
# HU         : HU-016
# NOMBRE     : Registro de trazabilidad en base de datos GM Integra
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Cada operación relevante que pasa por la API de GM Transport
# (GM Integra) debe quedar registrada en la base de datos interna
# de GM Integra con suficiente detalle para:
#   - Auditar cualquier transacción en cualquier punto del flujo
#   - Diagnosticar errores de integración
#   - Correlacionar eventos entre sistemas
#   - Dar soporte a desarrollo, QA y operaciones
#
# ESTRUCTURA MÍNIMA DE UN REGISTRO DE TRAZABILIDAD:
#   - id_registro       (PK autogenerado)
#   - correlation_id    (UUID generado por GM Integra al recibir msg)
#   - load_number       (referencia del viaje / solicitud)
#   - message_id        (ID del mensaje del sistema origen)
#   - origin_system     (WMS-GA / SIAV-GA / BOXSTORE-GA / ERP-GMT / SAP-GA)
#   - evento            (nombre del evento: RECIBIDO, VALIDADO, etc.)
#   - estado            (estado resultante del evento)
#   - timestamp         (fecha y hora exacta del evento, UTC)
#   - detalle           (descripción del evento o mensaje de error)
#   - http_status       (código HTTP de la petición asociada)
#   - usuario_sistema   (client_id del sistema que originó el evento)
#
# ESTADOS DE TRAZABILIDAD DEFINIDOS EN EL PROYECTO:
#   RECIBIDO → VALIDADO → MATERIALES_REGISTRADOS →
#   SOLICITUD_VIAJE_CREADA → SOLICITUD_VERIFICADA_EN_PORTAL →
#   SOLICITUD_ACEPTADA_ERP → MATERIALES_CARGADOS_CARTA_PORTE →
#   CXC_GENERADA_SAP → CFDI_TIMBRADO → PAGO_RECIBIDO_* →
#   COMPLEMENTO_PAGO_TIMBRADO → CFDI_CANCELADO
#   + estados de ERROR por cada etapa
# -----------------------------------------------------------------

Feature: HU-016 – Registro de trazabilidad de operaciones en base de datos GM Integra

  Como sistema API de GM Transport (GM Integra),
  quiero registrar automáticamente cada evento relevante del flujo de integración
  en la base de datos interna de GM Integra,
  para garantizar trazabilidad completa, auditoría y capacidad de diagnóstico
  en todo el ciclo de vida de cada solicitud o viaje.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Registro automático de evento de trazabilidad en cada etapa del flujo

    # Dado que GM Integra procesó una operación en el flujo de integración
    Given que la API GM Integra procesó el evento "<evento>" para el Load Number "<load_number>"
    And el sistema origen del mensaje es "<origin_system>"
    And el resultado del procesamiento es "<estado_resultado>"

    # Cuando GM Integra registra el evento en la base de datos
    When la API persiste el registro de trazabilidad en GM Integra DB

    # Entonces el registro queda correctamente almacenado con todos los campos
    Then se crea un registro en la tabla de trazabilidad con los campos:
        correlation_id generado automáticamente,
        load_number "<load_number>",
        origin_system "<origin_system>",
        evento "<evento>",
        estado "<estado_resultado>",
        timestamp con la fecha y hora exacta en UTC y
        usuario_sistema con el client_id del sistema origen
    And el registro es recuperable por correlation_id, load_number y origin_system
    And el registro es inmutable una vez escrito (no se modifica, se agregan nuevos eventos)

    Examples:
      | load_number     | origin_system | evento                        | estado_resultado               |
      | LN-20260223-001 | WMS-GA        | RECEPCION_XML                 | RECIBIDO                       |
      | LN-20260223-001 | WMS-GA        | VALIDACION_XML                | VALIDADO                       |
      | LN-20260223-001 | WMS-GA        | REGISTRO_MATERIALES           | MATERIALES_REGISTRADOS         |
      | LN-20260223-001 | WMS-GA        | CREACION_SOLICITUD_VIAJE      | SOLICITUD_VIAJE_CREADA         |
      | LN-20260223-001 | ERP-GMT       | CAMBIO_ESTATUS_VIAJE          | SOLICITUD_ACEPTADA_ERP         |
      | LN-20260223-001 | ERP-GMT       | CARGA_MATERIALES_CARTA_PORTE  | MATERIALES_CARGADOS_CARTA_PORTE|
      | LN-20260223-001 | ERP-GMT       | CAMBIO_ESTATUS_VIAJE          | TERMINADO                      |
      | LN-20260223-001 | SAP-GA        | GENERACION_CXC                | CXC_GENERADA_SAP               |
      | LN-20260223-001 | ERP-GMT       | TIMBRADO_CFDI                 | CFDI_TIMBRADO                  |
      | LN-20260223-001 | SAP-GA        | RECEPCION_PAGO                | PAGO_RECIBIDO_CICLO_CERRADO    |

  Scenario Outline: Registro de evento de error con detalle del fallo

    # Dado que GM Integra procesó una operación que resultó en error
    Given que la API GM Integra intentó el evento "<evento>" para el Load Number "<load_number>"
    And el resultado fue un error con código "<error_code>"
    And el detalle del error es "<detalle_error>"

    # Cuando GM Integra registra el evento de error
    When la API persiste el registro de error en GM Integra DB

    # Entonces el registro de error queda almacenado con el detalle completo
    Then se crea un registro en la tabla de trazabilidad con estado "<estado_error>"
    And el campo "detalle" contiene el mensaje de error "<detalle_error>"
    And el campo "http_status" contiene el código HTTP del error
    And el campo "error_code" contiene el valor "<error_code>"
    And el registro permite identificar la causa raíz del fallo

    Examples:
      | load_number     | evento                    | error_code                   | detalle_error                             | estado_error                  |
      | LN-20260223-010 | VALIDACION_XML            | MISSING_FIELD_MANIFEST_NBR   | Campo load_manifest_nbr vacío             | RECHAZADO_VALIDACION          |
      | LN-20260223-011 | REGISTRO_MATERIALES       | MISSING_CLAVE_PRODUCTO_SAT   | ClaveProductoServicios ausente en línea 3 | RECHAZADO_FISCAL              |
      | LN-20260223-012 | CREACION_SOLICITUD_VIAJE  | PORTAL_CONNECTION_TIMEOUT    | Timeout al conectar con Portal Clientes   | ERROR_CREACION_VIAJE          |
      | LN-20260223-013 | GENERACION_CXC            | SAP_INVALID_CUSTOMER         | Cliente GA-SAP-0099 no existe en SAP      | ERROR_CXC_SAP                 |
      | LN-20260223-014 | TIMBRADO_CFDI             | DUPLICATE_CFDI_UUID          | UUID ya registrado para este Load Number  | ERROR_REGISTRO_CFDI           |

  Scenario Outline: Consulta del historial completo de trazabilidad por Load Number

    # Dado que existen múltiples eventos registrados para un Load Number
    Given que el Load Number "<load_number>" tiene "<total_eventos>" eventos en GM Integra DB
    And el sistema "<solicitante>" realiza una petición GET al endpoint de trazabilidad

    # Cuando la API consulta la trazabilidad del Load Number
    When la API busca todos los eventos del Load Number "<load_number>" en GM Integra DB

    # Entonces devuelve el historial completo ordenado cronológicamente
    Then la API responde con código HTTP 200
    And la respuesta contiene una lista de "<total_eventos>" registros
    And cada registro incluye: correlation_id, evento, estado, timestamp y origin_system
    And los registros están ordenados cronológicamente de forma ascendente
    And la respuesta incluye el estado actual del Load Number como resumen

    Examples:
      | load_number     | total_eventos | solicitante |
      | LN-20260223-001 | 10            | ERP-GMT     |
      | LN-20260227-010 | 6             | SIAV-GA     |
      | LN-20260227-020 | 4             | BOXSTORE-GA |

  Scenario Outline: Consulta de trazabilidad filtrada por estado o rango de fechas

    # Dado que se necesita consultar eventos con filtros específicos
    Given que GM Integra DB tiene registros de trazabilidad para múltiples Load Numbers
    And el sistema "<solicitante>" aplica el filtro "<tipo_filtro>" con valor "<valor_filtro>"

    # Cuando la API ejecuta la consulta filtrada
    When la API busca registros en GM Integra DB con el filtro aplicado

    # Entonces devuelve solo los registros que coinciden con el filtro
    Then la API responde con código HTTP 200
    And todos los registros en la respuesta cumplen el criterio "<tipo_filtro>" = "<valor_filtro>"
    And la respuesta incluye el total de registros encontrados

    Examples:
      | solicitante | tipo_filtro   | valor_filtro                   |
      | ERP-GMT     | estado        | ERROR_CREACION_VIAJE           |
      | ERP-GMT     | estado        | RECHAZADO_FISCAL               |
      | ERP-GMT     | origin_system | WMS-GA                         |
      | ERP-GMT     | fecha_desde   | 2026-02-23T00:00:00Z           |
      | ERP-GMT     | load_number   | LN-20260223-001                |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en el registro de trazabilidad — manejo sin afectar el flujo principal

    # Dado que GM Integra intenta persistir un evento pero la BD falla
    Given que la API GM Integra procesó el evento "<evento>" para el Load Number "<load_number>"
    And la base de datos de GM Integra presenta la condición de error "<condicion_error>"

    # Cuando la API intenta escribir el registro de trazabilidad
    When la API intenta persistir el evento en GM Integra DB

    # Entonces el fallo de trazabilidad se gestiona sin detener el flujo principal
    Then la API registra el fallo de trazabilidad en el log de sistema (nivel ERROR)
    And la API continúa procesando el flujo de negocio principal sin interrumpirlo
    And el fallo de trazabilidad genera una alerta al equipo de soporte
    And se reintenta la escritura del registro en la siguiente oportunidad disponible

    Examples:
      | load_number     | evento               | condicion_error                              |
      | LN-20260223-001 | VALIDACION_XML       | Timeout de conexión a GM Integra DB          |
      | LN-20260223-001 | CREACION_SOLICITUD   | BD no disponible (mantenimiento)             |
      | LN-20260223-001 | TIMBRADO_CFDI        | Error de escritura en tabla de trazabilidad  |

  Scenario Outline: Rechazo de consulta de trazabilidad por falta de permisos

    # Dado que un sistema intenta consultar trazabilidad sin los permisos correctos
    Given que el sistema "<sistema>" realiza una petición GET al endpoint de trazabilidad
    And la petición presenta la condición de seguridad "<condicion_error>"

    # Cuando la API evalúa la petición de consulta
    When GM Integra verifica los permisos del sistema para la consulta

    # Entonces la API rechaza la consulta
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo incluye el campo "errorCode" con valor "<error_code>"
    And el intento queda registrado en la bitácora de seguridad

    Examples:
      | sistema     | condicion_error                                       | http_code | error_code               |
      | WMS-GA      | Token inválido o expirado                             | 401       | AUTH_INVALID_TOKEN       |
      | WMS-GA      | Intento de consultar Load Number de otro sistema      | 403       | ACCESS_DENIED            |
      | SIAV-GA     | Scope insuficiente para consultar trazabilidad        | 403       | INSUFFICIENT_SCOPE       |
      | BOXSTORE-GA | Load Number no existe en GM Integra DB                | 404       | LOAD_NUMBER_NOT_FOUND    |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-016-A] ¿Cuál es la política de retención de registros
  #              en GM Integra DB? ¿Por cuánto tiempo se conservan?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de infraestructura.
  #
  # [DUDA-016-B] ¿El equipo de soporte tendrá una interfaz (dashboard)
  #              para consultar y gestionar errores de integración?
  #              → AÚN NO ESTÁ DEFINIDO. Se recomienda contemplarlo
  #              como parte del alcance de la Épica 8.
  #
  # [DUDA-016-C] ¿Se requiere enmascaramiento de datos sensibles
  #              en los registros de trazabilidad (ej. RFC, importes)?
  #              → PENDIENTE DE DEFINICIÓN con el área de seguridad.
  #
  # [DUDA-016-D] ¿Los registros de trazabilidad son accesibles
  #              para todos los sistemas origen o solo para ERP-GMT?
  #              → SUPUESTO TÉCNICO: cada sistema solo puede consultar
  #              los registros de sus propios Load Numbers.
  # ----------------------------------------------------------------
