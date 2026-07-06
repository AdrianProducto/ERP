# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 4 – Validaciones, seguridad y trazabilidad
# HU         : HU-015
# NOMBRE     : Autenticación y autorización OAuth 2.0 por sistema
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# La API de GM Transport (GM Integra) usa OAuth 2.0 como mecanismo
# de autenticación.  Cada sistema que se conecta a la API tiene
# sus propias credenciales (client_id / client_secret) y obtiene
# un access_token independiente.
#
# Sistemas que se autentican contra la API:
#   - WMS-GA       (Grupo Andrea - Centro de Distribución)
#   - SIAV-GA      (Grupo Andrea - Sucursales SIAV)
#   - BOXSTORE-GA  (Grupo Andrea - Sucursales Box Store)
#   - ERP-GMT      (GM Transport ERP - notificaciones internas)
#   - SAP-GA       (SAP S/4HANA - notificaciones de pagos/CxC)
#
# Flujo OAuth 2.0 (Client Credentials Grant):
#   1. Sistema envía POST /auth/token con client_id y client_secret
#   2. API valida credenciales y devuelve access_token + expiry
#   3. Sistema usa el access_token en el header Authorization
#      de cada petición: "Authorization: Bearer {token}"
#   4. API valida el token en cada petición
#   5. Cuando el token expira, el sistema solicita uno nuevo
#
# Cada token está asociado a un sistema y tiene permisos
# (scopes) específicos según lo que ese sistema puede hacer.
# -----------------------------------------------------------------

Feature: HU-015 – Autenticación y autorización OAuth 2.0 por sistema en la API GM Integra

  Como sistema API de GM Transport (GM Integra),
  quiero autenticar y autorizar cada sistema externo mediante OAuth 2.0
  con credenciales y scopes independientes por sistema,
  para garantizar que solo los sistemas autorizados accedan a los endpoints
  correctos y que ningún sistema pueda ejecutar operaciones fuera de su alcance.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Obtención exitosa de access_token por sistema

    # Dado que el sistema tiene credenciales válidas registradas en GM Integra
    Given que el sistema "<sistema>" tiene un client_id "<client_id>" y client_secret válidos
    And el sistema realiza una petición POST al endpoint "/auth/token"
    And el cuerpo incluye grant_type "client_credentials", client_id y client_secret

    # Cuando GM Integra procesa la solicitud de token
    When la API valida las credenciales del sistema "<sistema>"

    # Entonces la API emite un access_token con los scopes correspondientes
    Then la API responde con código HTTP 200
    And la respuesta incluye el campo "access_token" con un JWT firmado
    And la respuesta incluye el campo "token_type" con valor "Bearer"
    And la respuesta incluye el campo "expires_in" con el tiempo de expiración en segundos
    And la respuesta incluye el campo "scope" con los permisos "<scopes>" del sistema
    And el token queda registrado en GM Integra asociado al sistema "<sistema>"

    Examples:
      | sistema     | client_id        | scopes                                          |
      | WMS-GA      | wms-ga-client    | shipments:write estatus:read trazabilidad:read  |
      | SIAV-GA     | siav-ga-client   | transfers:write estatus:read trazabilidad:read  |
      | BOXSTORE-GA | bs-ga-client     | transfers:write estatus:read trazabilidad:read  |
      | ERP-GMT     | erp-gmt-client   | estatus:write cfdi:write materiales:write       |
      | SAP-GA      | sap-ga-client    | pagos:write cxc:read cfdi:read                  |

  Scenario Outline: Acceso exitoso a endpoint con token válido y scope correcto

    # Dado que el sistema tiene un access_token válido y no expirado
    Given que el sistema "<sistema>" obtuvo un access_token válido con scope "<scope_requerido>"
    And el sistema realiza una petición al endpoint "<endpoint>" con el método "<metodo>"
    And el header "Authorization" contiene "Bearer {token_valido}"

    # Cuando GM Integra valida el token y el scope
    When la API verifica la autenticación y autorización de la petición

    # Entonces la petición es procesada correctamente
    Then la API acepta la petición y la procesa según la lógica del endpoint
    And el acceso queda registrado en la bitácora de GM Integra con el sistema "<sistema>"

    Examples:
      | sistema     | scope_requerido   | endpoint                              | metodo |
      | WMS-GA      | shipments:write   | /api/v1/wms/shipped-loads             | POST   |
      | SIAV-GA     | transfers:write   | /api/v1/transfers/request             | POST   |
      | BOXSTORE-GA | transfers:write   | /api/v1/transfers/request             | POST   |
      | ERP-GMT     | estatus:write     | /api/v1/viajes/estatus                | POST   |
      | ERP-GMT     | cfdi:write        | /api/v1/cfdi/registro                 | POST   |
      | SAP-GA      | pagos:write       | /api/v1/pagos/registro                | POST   |

  Scenario Outline: Renovación exitosa de access_token expirado

    # Dado que el token del sistema expiró
    Given que el sistema "<sistema>" tiene un access_token expirado
    And el sistema detecta la expiración por la respuesta HTTP 401 con errorCode "TOKEN_EXPIRED"

    # Cuando el sistema solicita un nuevo token
    When el sistema realiza una nueva petición POST al endpoint "/auth/token"
    And envía su client_id y client_secret válidos

    # Entonces la API emite un nuevo access_token
    Then la API responde con código HTTP 200 y un nuevo "access_token"
    And el token anterior queda invalidado en GM Integra
    And el nuevo token tiene los mismos scopes que el token anterior

    Examples:
      | sistema     |
      | WMS-GA      |
      | SIAV-GA     |
      | ERP-GMT     |
      | SAP-GA      |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Rechazo de autenticación por credenciales inválidas o problema en token

    # Dado que el sistema envía una petición con algún problema de autenticación
    Given que el sistema "<sistema>" realiza una petición a la API de GM Integra
    And la petición presenta la condición de seguridad "<condicion_error>"

    # Cuando la API evalúa la autenticación de la petición
    When GM Integra verifica las credenciales o el token de la petición

    # Entonces la API rechaza la petición con el código apropiado
    Then la API responde con código HTTP "<http_code>"
    And el cuerpo de la respuesta incluye el campo "errorCode" con valor "<error_code>"
    And el intento de acceso queda registrado en la bitácora de seguridad de GM Integra
    And NO se procesa ninguna operación de negocio

    Examples:
      | sistema     | condicion_error                                              | http_code | error_code                    |
      | WMS-GA      | client_secret incorrecto al solicitar token                  | 401       | AUTH_INVALID_CREDENTIALS      |
      | SIAV-GA     | client_id no registrado en GM Integra                        | 401       | AUTH_UNKNOWN_CLIENT           |
      | BOXSTORE-GA | access_token ausente en el header Authorization              | 401       | AUTH_MISSING_TOKEN            |
      | ERP-GMT     | access_token expirado en petición a endpoint                 | 401       | TOKEN_EXPIRED                 |
      | SAP-GA      | access_token con firma inválida (JWT manipulado)             | 401       | TOKEN_INVALID_SIGNATURE       |
      | WMS-GA      | Token válido pero scope insuficiente para el endpoint        | 403       | INSUFFICIENT_SCOPE            |
      | SIAV-GA     | Token de otro sistema usado en endpoint no autorizado        | 403       | TOKEN_SYSTEM_MISMATCH         |
      | ERP-GMT     | Demasiadas solicitudes de token en corto tiempo (rate limit) | 429       | RATE_LIMIT_EXCEEDED           |

  Scenario Outline: Intento de acceso a endpoint fuera del scope del sistema

    # Dado que un sistema intenta acceder a un endpoint que no le corresponde
    Given que el sistema "<sistema>" tiene un token válido con scope "<scope_sistema>"
    And el sistema intenta una petición al endpoint "<endpoint_no_autorizado>"

    # Cuando la API evalúa el scope del token contra el endpoint solicitado
    When GM Integra verifica los permisos del sistema "<sistema>" para el endpoint

    # Entonces la API rechaza el acceso por scope insuficiente
    Then la API responde con código HTTP 403
    And el cuerpo incluye el campo "errorCode" con valor "INSUFFICIENT_SCOPE"
    And el cuerpo incluye el campo "requiredScope" indicando el scope necesario
    And el intento queda registrado en bitácora como alerta de seguridad

    Examples:
      | sistema     | scope_sistema   | endpoint_no_autorizado     |
      | WMS-GA      | shipments:write | /api/v1/pagos/registro     |
      | SAP-GA      | pagos:write     | /api/v1/wms/shipped-loads  |
      | SIAV-GA     | transfers:write | /api/v1/cfdi/registro      |
      | BOXSTORE-GA | transfers:write | /api/v1/viajes/estatus     |

  # ----------------------------------------------------------------
  # ACLARACIÓN IMPORTANTE — DOS CAPAS DE AUTENTICACIÓN
  # ----------------------------------------------------------------
  # Esta HU cubre OAuth 2.0 para la capa EXTERNA de GM Integra,
  # es decir, los sistemas que se conectan A GM Integra:
  #   WMS-GA, SIAV-GA, BOXSTORE-GA, SAP-GA → GM Integra: OAuth 2.0
  #
  # La capa INTERNA de GM Integra hacia el ERP usa Basic Auth:
  #   GM Integra → API ERP (SolicitudViaje, MaterialesPedimentos):
  #   Header Authorization: basic {Base64(Usuario:Contraseña)}
  #   Header RFC: RFC del cliente
  #   Header Aplicacion: 4 (solicitudes) o 5 (materiales)
  #   El usuario/contraseña es generado por el ERP desde
  #   Clientes/Contactos → opción Portal de Cliente.
  #
  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-015-A] ¿Cuál es el tiempo de expiración del access_token?
  #              → SUPUESTO TÉCNICO: 3600 segundos (1 hora).
  #              Confirmación requerida con arquitectura.
  #
  # [DUDA-015-B] ¿Se implementa refresh_token además del
  #              client_credentials flow, o solo client_credentials?
  #              → SUPUESTO TÉCNICO: solo client_credentials,
  #              ya que son integraciones sistema-a-sistema.
  #
  # [DUDA-015-C] ¿El catálogo completo de scopes por sistema
  #              está definido? Los scopes en la tabla de ejemplos
  #              son SUPUESTOS TÉCNICOS. → PENDIENTE con arquitectura.
  #
  # [DUDA-015-D] ¿Se implementa lista blanca de IPs (whitelist)
  #              adicionalmente a OAuth 2.0?
  #              → PENDIENTE DE DEFINICIÓN con seguridad/infraestructura.
  # ----------------------------------------------------------------
