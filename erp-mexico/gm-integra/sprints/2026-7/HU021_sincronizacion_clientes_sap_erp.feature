# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 5 – Integración administrativa con SAP S/4HANA
# HU         : HU-021
# NOMBRE     : Sincronización de clientes desde SAP S/4HANA
#              hacia GM Transport ERP vía polling OData
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# GM Integra consulta periódicamente SAP S/4HANA mediante la API
# OData estándar API_BUSINESS_PARTNER para detectar clientes nuevos
# o modificados y sincronizarlos hacia GM Transport ERP a través
# del Portal de Clientes o el endpoint interno del ERP.
#
# API SAP UTILIZADA:
#   Servicio : API_BUSINESS_PARTNER (OData V2)
#   Endpoint : GET /sap/opu/odata/sap/API_BUSINESS_PARTNER/A_Customer
#   Escenario: SAP_COM_0008 (Business Partner, Customer and Supplier)
#   Auth     : Basic Auth con Communication User de SAP
#              (OAuth 2.0 en el lado de GM Integra → SAP)
#
# CAMPOS CLAVE QUE SE SINCRONIZAN AL ERP:
#   Desde SAP API_BUSINESS_PARTNER   → GM Transport ERP (Portal)
#   ─────────────────────────────────────────────────────────────
#   BusinessPartner (ID SAP)         → Num. Cliente / ID externo
#   BusinessPartnerName / Name1Org   → Nombre del Cliente
#   TaxNumber1 (RFC México)          → RFC
#   to_BusinessPartnerAddress        → Dirección fiscal
#     StreetName, CityName,          → Calle, Ciudad,
#     Region, Country, PostalCode    → Estado, País, CP
#   to_CustomerCompany               → Datos de empresa
#     PaymentTerms                   → Condiciones de pago
#     ReconciliationAccount          → Cuenta de mayor
#   BusinessPartnerCategory          → Tipo (1=Persona, 2=Org)
#   LastChangeDateTime               → Timestamp último cambio
#                                      (usado para detección de updates)
#
# MECANISMO DE POLLING CONFIRMADO:
#   - GM Integra ejecuta el polling con una frecuencia configurable
#     (PENDIENTE DE DEFINICIÓN, SUPUESTO TÉCNICO: cada 30 minutos) o un boton que accine el polling
#   - En cada ciclo, consulta clientes modificados desde el último
#     polling usando filtro OData: LastChangeDateTime gt {timestamp}
#   - Todos los clientes de SAP se sincronizan al ERP
#   - Si el cliente ya existe en ERP → se actualiza (UPSERT) 
#   - Si el cliente no existe en ERP → se da de alta
#
# FLUJO COMPLETO:
#   1. GM Integra ejecuta GET a SAP OData con filtro de fecha
#   2. SAP devuelve lista de clientes nuevos o modificados
#   3. GM Integra valida y mapea los datos de cada cliente
#   4. GM Integra hace UPSERT en GM Transport ERP:
#      - Alta nueva si BusinessPartner no existe en ERP
#      - Actualización si BusinessPartner ya existe en ERP
#   5. GM Integra registra resultado en trazabilidad
#   6. GM Integra actualiza el timestamp del último polling exitoso
# -----------------------------------------------------------------

Feature: HU-021 – Sincronización de clientes SAP S/4HANA hacia GM Transport ERP vía polling OData

  Como sistema API de GM Transport (GM Integra),
  quiero consultar periódicamente la API OData API_BUSINESS_PARTNER de SAP S/4HANA
  para detectar clientes nuevos o modificados y sincronizarlos en GM Transport ERP,
  para que el equipo operativo de GM Transport disponga siempre de un catálogo
  de clientes actualizado y consistente con SAP.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Ciclo de polling exitoso — detección y alta de clientes nuevos en ERP

    # Dado que GM Integra ejecuta un ciclo de polling hacia SAP
    Given que GM Integra ejecuta una consulta GET a la API SAP_BUSINESS_PARTNER
    And el filtro OData aplicado es "LastChangeDateTime gt <timestamp_ultimo_polling>"
    And SAP responde con "<total_clientes_nuevos>" clientes creados desde el último polling
    And ninguno de esos clientes existe aún en GM Transport ERP

    # Cuando GM Integra procesa la respuesta de SAP y sincroniza al ERP
    When GM Integra mapea y envía cada cliente nuevo al endpoint de alta del ERP

    # Entonces todos los clientes quedan dados de alta en ERP
    Then se crean "<total_clientes_nuevos>" clientes nuevos en GM Transport ERP
    And cada cliente en ERP incluye los campos mapeados:
        BusinessPartner "<id_sap>" como identificador externo SAP,
        nombre "<nombre>",
        RFC "<rfc>",
        dirección fiscal y
        condiciones de pago
    And el registro de trazabilidad se actualiza con evento "CLIENTES_SINCRONIZADOS_ALTA"
    And GM Integra actualiza el timestamp de último polling exitoso a "<timestamp_actual>"
    And la API responde con un resumen: total consultados, total dados de alta, total errores

    Examples:
      | timestamp_ultimo_polling | total_clientes_nuevos | id_sap     | nombre              | rfc           | timestamp_actual     |
      | 2026-02-23T07:30:00Z     | 3                     | BP-1000001 | GRUPO ANDREA SA CV  | AND820101ABC  | 2026-02-23T08:00:00Z |
      | 2026-02-23T08:00:00Z     | 1                     | BP-1000002 | ANDREA STORES SA CV | AND820101XYZ  | 2026-02-23T08:30:00Z |
      | 2026-02-23T08:30:00Z     | 0                     | (ninguno)  | (ninguno)           | (ninguno)     | 2026-02-23T09:00:00Z |

  Scenario Outline: Ciclo de polling exitoso — detección y actualización de clientes modificados

    # Dado que GM Integra detecta clientes modificados en SAP desde el último polling
    Given que GM Integra ejecuta una consulta GET a la API API_BUSINESS_PARTNER
    And el filtro OData aplicado es "LastChangeDateTime gt <timestamp_ultimo_polling>"
    And SAP devuelve "<total_modificados>" clientes con cambios recientes
    And esos clientes YA EXISTEN en GM Transport ERP con BusinessPartner "<id_sap>"

    # Cuando GM Integra procesa los cambios y actualiza el ERP
    When GM Integra mapea los datos actualizados y los envía al endpoint de actualización del ERP

    # Entonces los clientes quedan actualizados en ERP con los nuevos datos
    Then se actualizan "<total_modificados>" clientes existentes en GM Transport ERP
    And los campos modificados en ERP reflejan los valores actuales de SAP
    And el registro de trazabilidad se actualiza con evento "CLIENTES_SINCRONIZADOS_ACTUALIZACION"
    And GM Integra actualiza el timestamp de último polling exitoso
    And el historial de cambios del cliente en ERP queda registrado con timestamp de sincronización

    Examples:
      | timestamp_ultimo_polling | total_modificados | id_sap     | campo_modificado    |
      | 2026-02-23T08:00:00Z     | 2                 | BP-1000001 | PaymentTerms        |
      | 2026-02-23T08:30:00Z     | 1                 | BP-1000002 | StreetName          |
      | 2026-02-23T09:00:00Z     | 1                 | BP-1000003 | TaxNumber1 (RFC)    |

  Scenario Outline: Ciclo de polling sin cambios — ERP ya está sincronizado

    # Dado que no hubo modificaciones en SAP desde el último polling
    Given que GM Integra ejecuta una consulta GET a la API API_BUSINESS_PARTNER
    And el filtro OData es "LastChangeDateTime gt <timestamp_ultimo_polling>"
    And SAP responde con una lista vacía (0 clientes modificados o creados)

    # Cuando GM Integra procesa la respuesta vacía
    When GM Integra evalúa el resultado del polling

    # Entonces el ciclo termina sin cambios y se registra el resultado
    Then GM Integra NO realiza ninguna operación de alta o actualización en ERP
    And el registro de trazabilidad se actualiza con evento "POLLING_SIN_CAMBIOS"
    And GM Integra actualiza el timestamp de último polling exitoso a "<timestamp_actual>"

    Examples:
      | timestamp_ultimo_polling | timestamp_actual     |
      | 2026-02-23T09:00:00Z     | 2026-02-23T09:30:00Z |
      | 2026-02-23T09:30:00Z     | 2026-02-23T10:00:00Z |

  Scenario Outline: Validación de campos obligatorios antes de sincronizar al ERP

    # Dado que SAP devuelve un cliente con todos los campos requeridos
    Given que el cliente con BusinessPartner "<id_sap>" fue retornado por SAP en el polling
    And el cliente incluye los campos obligatorios:
        BusinessPartnerName "<nombre>",
        TaxNumber1 "<rfc>",
        to_BusinessPartnerAddress con CityName y Country y
        to_CustomerCompany con CompanyCode y PaymentTerms

    # Cuando GM Integra valida y mapea los campos para el ERP
    When GM Integra ejecuta la validación y el mapeo del cliente "<id_sap>"

    # Entonces el cliente pasa la validación y se sincroniza al ERP
    Then la validación del cliente "<id_sap>" resulta "VÁLIDA"
    And GM Integra envía el cliente al ERP para alta o actualización
    And el registro de trazabilidad incluye el mapeo SAP → ERP del cliente "<id_sap>"

    Examples:
      | id_sap     | nombre              | rfc          |
      | BP-1000001 | GRUPO ANDREA SA CV  | AND820101ABC |
      | BP-1000002 | ANDREA STORES SA CV | AND820101XYZ |
      | BP-1000003 | ANDREA NORTH SA CV  | AND820101DEF |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en el ciclo de polling — SAP no disponible o error de autenticación

    # Dado que GM Integra intenta ejecutar el polling pero SAP no responde correctamente
    Given que GM Integra ejecuta una consulta GET a la API API_BUSINESS_PARTNER
    And la consulta presenta la condición de error "<condicion_error>"

    # Cuando GM Integra evalúa la respuesta de SAP
    When GM Integra procesa el resultado del ciclo de polling

    # Entonces el ciclo falla y se gestiona el error sin modificar el timestamp
    Then GM Integra registra el fallo con código "<error_code>" en trazabilidad
    And el timestamp de último polling exitoso NO se actualiza
    And el próximo ciclo de polling usará el mismo timestamp anterior para no perder cambios
    And se genera una alerta al equipo de soporte si el fallo persiste más de "<umbral_fallos>" ciclos consecutivos
    And NO se realizan cambios en el catálogo de clientes del ERP

    Examples:
      | condicion_error                                          | error_code                    | umbral_fallos |
      | SAP no disponible (timeout de conexión OData)            | SAP_CONNECTION_TIMEOUT        | 3             |
      | SAP responde con error 500 interno                       | SAP_INTERNAL_ERROR            | 3             |
      | Credenciales de Communication User de SAP inválidas      | SAP_AUTH_ERROR                | 1             |
      | SAP responde con error 403 (Communication Scenario inactivo)| SAP_FORBIDDEN               | 1             |
      | Respuesta OData de SAP con formato inesperado            | SAP_INVALID_RESPONSE_FORMAT   | 3             |

  Scenario Outline: Cliente de SAP con datos incompletos — se omite y se reporta

    # Dado que SAP devuelve un cliente con campos obligatorios faltantes
    Given que el cliente con BusinessPartner "<id_sap>" fue retornado por SAP en el polling
    And el cliente presenta la condición de datos incompletos "<condicion_error>"

    # Cuando GM Integra valida los datos del cliente
    When GM Integra ejecuta la validación del cliente "<id_sap>"

    # Entonces el cliente es omitido de la sincronización y se reporta el error
    Then la validación del cliente "<id_sap>" resulta "INVÁLIDA"
    And GM Integra NO sincroniza ese cliente al ERP
    And el error queda registrado en trazabilidad con estado "CLIENTE_OMITIDO_DATOS_INCOMPLETOS"
    And el reporte del ciclo incluye el cliente "<id_sap>" en la lista de omitidos con detalle del error
    And el resto de clientes del ciclo se sincronizan normalmente sin interrupciones

    Examples:
      | id_sap     | condicion_error                                           | error_code                       |
      | BP-1000010 | BusinessPartnerName / Name1Org vacío o nulo               | MISSING_CUSTOMER_NAME            |
      | BP-1000011 | TaxNumber1 (RFC) vacío — requerido para México            | MISSING_RFC                      |
      | BP-1000012 | to_BusinessPartnerAddress ausente o sin CityName          | MISSING_ADDRESS                  |
      | BP-1000013 | to_CustomerCompany ausente (sin código de empresa)        | MISSING_COMPANY_CODE             |
      | BP-1000014 | BusinessPartnerCategory con valor no reconocido           | INVALID_PARTNER_CATEGORY         |
      | BP-1000015 | RFC con formato inválido (no cumple estructura SAT)       | INVALID_RFC_FORMAT               |

  Scenario Outline: Fallo en el alta o actualización de cliente en ERP

    # Dado que SAP devolvió un cliente válido pero el ERP falla al procesarlo
    Given que el cliente "<id_sap>" superó la validación de GM Integra
    And el intento de alta o actualización en GM Transport ERP presenta "<condicion_error>"

    # Cuando GM Integra intenta sincronizar el cliente al ERP
    When GM Integra envía la solicitud al endpoint del ERP para el cliente "<id_sap>"

    # Entonces el fallo se registra y el cliente queda pendiente para el siguiente ciclo
    Then GM Integra registra el fallo con código "<error_code>"
    And el estado del cliente "<id_sap>" en trazabilidad es "ERROR_SINCRONIZACION_ERP"
    And el cliente queda marcado para reintento en el próximo ciclo de polling
    And el reporte del ciclo incluye el cliente en la lista de fallos con el detalle del error
    And el fallo NO detiene la sincronización del resto de clientes del ciclo

    Examples:
      | id_sap     | condicion_error                                     | error_code                    |
      | BP-1000001 | GM Transport ERP no disponible (timeout)            | ERP_CONNECTION_TIMEOUT        |
      | BP-1000002 | ERP responde con error 500                          | ERP_INTERNAL_ERROR            |
      | BP-1000003 | RFC duplicado en ERP con diferente BusinessPartner  | ERP_DUPLICATE_RFC             |
      | BP-1000004 | Condiciones de pago no reconocidas en catálogo ERP  | ERP_INVALID_PAYMENT_TERMS     |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-021-A] ¿Cada cuánto tiempo se ejecuta el ciclo de polling?
  #              → SUPUESTO TÉCNICO: cada 30 minutos.
  #              Debe ser configurable en GM Integra sin redespliegue.
  #              → PENDIENTE DE DEFINICIÓN con el equipo de proyecto.
  #
  # [DUDA-021-B] ¿El campo TaxNumber1 de SAP contiene siempre el RFC
  #              mexicano, o puede haber otros tipos de identificación
  #              fiscal según el país del cliente?
  #              → SUPUESTO TÉCNICO: TaxNumber1 = RFC para clientes MX.
  #              → PENDIENTE DE DEFINICIÓN con el área fiscal.
  #
  # [DUDA-021-C] ¿GM Integra se autentica contra SAP con Basic Auth
  #              (Communication User) u OAuth 2.0?
  #              → SUPUESTO TÉCNICO: Basic Auth con Communication User
  #              configurado en SAP_COM_0008, dado que OAuth 2.0 es
  #              el mecanismo interno de GM Integra con sus propios
  #              sistemas, no necesariamente el que SAP expone.
  #              → PENDIENTE DE CONFIRMACIÓN con el equipo de SAP.
  #
  # [DUDA-021-D] ¿El endpoint de alta/actualización de cliente en
  #              GM Transport ERP es el mismo Portal de Clientes o
  #              un endpoint interno del ERP diferente?
  #              → PENDIENTE DE DEFINICIÓN con el equipo de ERP.
  #
  # [DUDA-021-E] ¿Se requiere sincronizar también los datos de
  #              organización de ventas (SalesOrganization,
  #              DistributionChannel, Division) del cliente SAP
  #              al ERP de GM Transport?
  #              → PENDIENTE DE DEFINICIÓN con operaciones y ventas.
  #
  # [DUDA-021-F] En el futuro, si se requiere migrar a push mediante
  #              SAP Event Mesh (tiempo real), el flujo sería:
  #              SAP publica evento BusinessPartner.Created/Changed
  #              → Event Mesh → webhook a GM Integra
  #              → misma lógica de validación y UPSERT en ERP.
  #              Esta opción queda documentada como evolución futura.
  # ----------------------------------------------------------------
