# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 2 – Recepción de solicitudes desde SIAV y Box Store
# HU         : HU-007
# NOMBRE     : Creación de solicitud de viaje de traslado
#              desde SIAV y Box Store vía API SolicitudViaje/Agregar
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 2.0  ← actualizada con documentación real de la API
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# SIAV y Box Store usan el mismo endpoint de la API del ERP que
# el WMS para crear solicitudes de viaje.  La diferencia es el
# origen del mensaje (OriginSystem en el XML) y los campos del
# viaje (traslado entre sucursales vs. carga desde CD).
#
# ENDPOINT CONFIRMADO (mismo que HU-004):
#   POST https://appapitest.gmtransport.co/api/SolicitudViaje/Agregar
#
# AUTENTICACIÓN: Basic Auth (igual que HU-004)
#   Header Authorization : basic {Base64(Usuario:Contraseña)}
#   Header RFC           : RFC del cliente
#   Header Aplicacion    : 4
#   Header Content-Type  : application/json
#
# MAPEO XML SIAV/BOX STORE → BODY JSON API ERP:
#   sucursal_origen    → Origen
#   sucursal_destino   → Destino
#   sucursal_destino   → EntregarEn
#   sucursal_origen    → RecogerEn
#   MessageId / ref    → LoadNumber (generado al dar salida de mercancía)
#   cantidad_estimada  → Peso
#   (campo libre)      → Observaciones con OriginSystem
# -----------------------------------------------------------------

Feature: HU-007 – Creación de solicitud de viaje de traslado en ERP desde SIAV y Box Store

  Como sistema API de GM Transport (GM Integra),
  quiero crear solicitudes de viaje de traslado entre sucursales en GM Transport ERP
  llamando al endpoint POST /api/SolicitudViaje/Agregar con los datos del XML
  de SIAV o Box Store transformados a JSON,
  para que el equipo operativo de GM Transport pueda gestionar el traslado
  de mercancía entre sucursales de Grupo Andrea.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Creación exitosa de solicitud de traslado desde SIAV o Box Store

    # Dado que el XML fue recibido y validado correctamente
    Given que el XML del sistema "<origin_system>" con MessageId "<message_id>" tiene estado "VALIDADO"
    And GM Integra construye el body JSON con los campos:
        LoadNumber "<load_number>",
        Origen "<sucursal_origen>",
        Destino "<sucursal_destino>",
        EntregarEn "<sucursal_destino>",
        RecogerEn "<sucursal_origen>",
        Observaciones "Traslado desde <origin_system>" y
        Peso "<peso>"
    And el header Authorization contiene "basic <token_base64>"
    And el header RFC contiene "<rfc_cliente>"
    And el header Aplicacion contiene "4"

    # Cuando GM Integra envía el POST al endpoint del ERP
    When GM Integra realiza POST a "/api/SolicitudViaje/Agregar"

    # Entonces el ERP crea la solicitud y devuelve el IdSolicitud
    Then el ERP responde con código HTTP 200
    And la respuesta incluye "Success": true
    And la respuesta incluye LoadNumber "<load_number>" e IdSolicitud "<id_solicitud>"
    And GM Integra almacena la correlación:
        MessageId "<message_id>" ↔ LoadNumber "<load_number>" ↔ IdSolicitud "<id_solicitud>"
    And el registro de trazabilidad incluye el origin_system "<origin_system>"
    And el estado en trazabilidad se actualiza a "SOLICITUD_VIAJE_CREADA"

    Examples:
      | origin_system | message_id               | load_number     | sucursal_origen | sucursal_destino | peso   | rfc_cliente  | token_base64     | id_solicitud |
      | SIAV          | MSG-SIAV-20260227-000001 | LN-20260227-010 | SUC-MTY-001     | SUC-CDMX-005     | 500.00 | GGT081209393 | dXNlcjpwYXNz | 30           |
      | SIAV          | MSG-SIAV-20260227-000002 | LN-20260227-011 | SUC-GDL-003     | SUC-MTY-002      | 200.00 | GGT081209393 | dXNlcjpwYXNz | 31           |
      | Box Store     | MSG-BS-20260227-000001   | LN-20260227-020 | SUC-CDMX-010    | SUC-QRO-001      | 100.00 | GGT081209393 | dXNlcjpwYXNz | 32           |
      | Box Store     | MSG-BS-20260227-000002   | LN-20260227-021 | SUC-MTY-004     | SUC-SLP-002      | 350.00 | GGT081209393 | dXNlcjpwYXNz | 33           |

  Scenario Outline: Consulta de estatus de solicitud de traslado recién creada

    # Dado que la solicitud fue creada y tiene IdSolicitud conocido
    Given que la solicitud con IdSolicitud "<id_solicitud>" fue creada para "<origin_system>"

    # Cuando GM Integra consulta el estatus
    When GM Integra realiza GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"

    # Entonces la solicitud aparece como pendiente
    Then la respuesta incluye Motivo "La solicitud de viaje esta pendente"
    And el registro de trazabilidad confirma estado "SOLICITUD_VERIFICADA_PENDIENTE"
    And la correlación LoadNumber ↔ IdSolicitud permanece activa para seguimiento

    Examples:
      | id_solicitud | origin_system |
      | 30           | SIAV          |
      | 32           | Box Store     |

  Scenario Outline: Consulta de solicitud de traslado ya aceptada — obtención de SucursalFolio

    # Dado que GM Transport aceptó la solicitud de traslado
    Given que la solicitud con IdSolicitud "<id_solicitud>" fue aceptada en el ERP

    # Cuando GM Integra consulta el estatus de la solicitud aceptada
    When GM Integra realiza GET a "/api/SolicitudViaje/Consultar/<id_solicitud>"

    # Entonces la respuesta incluye el SucursalFolio necesario para cargar materiales
    Then la respuesta incluye EstatusViaje con valor distinto a "pendente"
    And la respuesta incluye el nodo Aceptacion con Fecha, Hora y Nombre del operador
    And la respuesta incluye el campo SucursalFolio "<sucursal_folio>"
    And GM Integra almacena la correlación LoadNumber ↔ IdSolicitud ↔ SucursalFolio
    And el estado en trazabilidad se actualiza a "SOLICITUD_ACEPTADA_ERP"
    And GM Integra dispara el flujo de carga de materiales usando SucursalFolio (HU-008)

    Examples:
      | id_solicitud | sucursal_folio  | origin_system |
      | 30           | MA-002030       | SIAV          |
      | 32           | MA-002032       | Box Store     |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Detección de solicitud duplicada por LoadNumber

    # Dado que ya existe una solicitud con el mismo LoadNumber en el ERP
    Given que GM Integra intenta crear una solicitud con LoadNumber "<load_number>"
    And el ERP ya tiene registrada una solicitud con ese LoadNumber para el cliente

    # Cuando GM Integra envía el POST al ERP
    When GM Integra realiza POST a "/api/SolicitudViaje/Agregar"

    # Entonces GM Integra detecta la duplicidad por el IdSolicitud ya conocido
    Then GM Integra verifica si el LoadNumber "<load_number>" ya tiene IdSolicitud en trazabilidad
    And si existe correlación previa, GM Integra NO envía el POST al ERP
    And el estado en trazabilidad se actualiza a "SOLICITUD_DUPLICADA"
    And la respuesta incluye el IdSolicitud existente "<id_solicitud_existente>"

    Examples:
      | load_number     | id_solicitud_existente | origin_system |
      | LN-20260227-010 | 30                     | SIAV          |
      | LN-20260227-020 | 32                     | Box Store     |

  Scenario Outline: Fallo en la creación de solicitud de traslado

    # Dado que la petición al ERP presenta algún error
    Given que GM Integra envía POST a "/api/SolicitudViaje/Agregar" para "<origin_system>"
    And la petición presenta la condición de error "<condicion_error>"

    # Cuando el ERP responde con error
    When GM Integra evalúa la respuesta del ERP

    # Entonces el fallo se gestiona correctamente
    Then el ERP responde con código "<http_code>" o faultcode "<fault_code>"
    And GM Integra registra el fallo con estado "ERROR_CREACION_VIAJE"
    And el mensaje queda en cola de errores para revisión manual
    And se genera alerta al equipo de soporte

    Examples:
      | origin_system | condicion_error                             | http_code | fault_code |
      | SIAV          | Nodo LoadNumber ausente en JSON             | 400       | 1          |
      | SIAV          | Campo Origen vacío                          | 400       | 2          |
      | Box Store     | Credenciales Basic Auth inválidas           | 401       | 401        |
      | Box Store     | ERP no disponible (timeout)                 | 500       | -          |

  # ----------------------------------------------------------------
  # RESUELTAS Y PENDIENTES
  # ----------------------------------------------------------------
  # [v2] Mecanismo real: mismo endpoint que HU-004.
  #      El SucursalFolio obtenido al consultar la solicitud aceptada
  #      es la llave para la carga de materiales (HU-008).
  #
  # [DUDA-007-B] ¿El tipo de equipo para traslados se determina
  #              por cantidad/peso o lo define el operador de ERP?
  #              → La API SolicitudViaje/Agregar no tiene campo de
  #              tipo de equipo — lo define el operador al aceptar.
  #              RESUELTO IMPLÍCITAMENTE por la documentación.
  # ----------------------------------------------------------------
