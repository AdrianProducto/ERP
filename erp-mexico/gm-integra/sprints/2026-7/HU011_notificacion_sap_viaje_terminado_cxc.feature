# ============================================================
# PROYECTO   : Integración GM Transport ERP – Grupo Andrea
# ÉPICA      : 5 – Integración administrativa con SAP S/4HANA
# HU         : HU-011
# NOMBRE     : Notificación a SAP de viaje terminado y generación
#              automática de Cuenta por Cobrar
# AUTOR      : Analista Funcional / Product Owner
# VERSIÓN    : 1.0
# FECHA      : 2026-04-27
# ============================================================

# -----------------------------------------------------------------
# CONTEXTO
# Cuando un viaje alcanza el estatus TERMINADO en GM Transport ERP,
# la API de integración debe notificar a SAP S/4HANA para que se
# genere automáticamente la Cuenta por Cobrar (CxC) correspondiente
# al servicio de transporte prestado a Grupo Andrea.
#
# FLUJO CONFIRMADO:
#   1. ERP notifica a API: viaje TERMINADO (HU-009)
#   2. API propaga a SAP: notificación de viaje terminado
#   3. SAP crea CxC automáticamente con los datos del servicio
#   4. SAP devuelve a la API el número de documento contable generado
#   5. API registra la correlación: Load Number ↔ Documento SAP
#   6. GM Transport ERP genera CFDI → PAC externo lo timbra
#      (flujo ya integrado en ERP, transparente para la API)
#   7. CFDI timbrado queda disponible para el proceso de cobro
#
# DATOS QUE LA API ENVÍA A SAP:
#   - load_number         (referencia externa / clave de correlación)
#   - customer_id         (ID de Grupo Andrea en SAP)
#   - service_date        (fecha de término del viaje)
#   - amount              (importe del servicio)
#   - currency            (MXN)
#   - payment_terms       (condiciones de pago acordadas)
#   - reference_document  (folio del viaje / Carta Porte)
#   - origin_system       (WMS-GA / SIAV-GA / BOXSTORE-GA)
# -----------------------------------------------------------------

Feature: HU-011 – Notificación a SAP de viaje terminado y generación automática de CxC

  Como sistema API de GM Transport,
  quiero notificar a SAP S/4HANA cuando un viaje alcanza el estatus TERMINADO,
  para que SAP genere automáticamente la Cuenta por Cobrar correspondiente
  al servicio de transporte prestado a Grupo Andrea.

  # ================================================================
  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)
  # ================================================================

  Scenario Outline: Notificación exitosa a SAP y generación automática de CxC

    # Dado que el viaje alcanzó el estatus TERMINADO
    Given que el Load Number "<load_number>" cambió a estatus "TERMINADO"
    And la Carta Porte asociada tiene los materiales cargados con claves SAT completas
    And SAP S/4HANA tiene el endpoint de integración activo y disponible
    And el cliente "<customer_id>" existe como socio comercial activo en SAP

    # Cuando la API envía la notificación de servicio terminado a SAP
    When la API envía a SAP S/4HANA la notificación con los campos:
        load_number "<load_number>",
        customer_id "<customer_id>",
        service_date "<service_date>",
        amount "<amount>",
        currency "MXN",
        payment_terms "<payment_terms>" y
        reference_document "<folio_viaje>"

    # Entonces SAP genera la CxC y confirma el documento contable
    Then SAP S/4HANA crea la CxC y devuelve el número de documento contable "<doc_sap>"
    And la CxC queda como partida abierta en la cuenta del cliente "<customer_id>" en SAP
    And la fecha base para el cálculo del vencimiento es "<service_date>"
    And la API almacena la correlación Load Number "<load_number>" ↔ Documento SAP "<doc_sap>"
    And el registro de trazabilidad se actualiza a estado "CXC_GENERADA_SAP"
    And la API responde al proceso con confirmación de CxC generada

    Examples:
      | load_number     | customer_id | service_date | amount    | payment_terms | folio_viaje   | doc_sap        |
      | LN-20260223-001 | GA-SAP-0001 | 2026-02-24   | 15000.00  | 30 días       | VJ-2026-00001 | SAP-DOC-000001 |
      | LN-20260227-010 | GA-SAP-0001 | 2026-02-28   | 8500.00   | 30 días       | VJ-2026-00010 | SAP-DOC-000002 |
      | LN-20260227-020 | GA-SAP-0002 | 2026-02-28   | 12000.00  | 30 días       | VJ-2026-00020 | SAP-DOC-000003 |

  Scenario Outline: Correlación correcta entre Load Number y documento SAP generado

    # Dado que SAP generó una CxC para un viaje terminado
    Given que el Load Number "<load_number>" tiene una CxC generada con documento SAP "<doc_sap>"

    # Cuando se consulta la correlación en la API
    When la API busca la correlación del Load Number "<load_number>"

    # Entonces devuelve la relación correcta con el documento SAP
    Then la API devuelve el documento SAP "<doc_sap>" asociado al Load Number "<load_number>"
    And la correlación incluye: load_number, folio_viaje, doc_sap, customer_id y fecha_generacion
    And el estado de la CxC en la trazabilidad es "PENDIENTE_PAGO"

    Examples:
      | load_number     | doc_sap        |
      | LN-20260223-001 | SAP-DOC-000001 |
      | LN-20260227-010 | SAP-DOC-000002 |

  # ================================================================
  # ESCENARIO 2: LO QUE NO PASA (ERRORES, VALIDACIONES Y SEGURIDAD)
  # ================================================================

  Scenario Outline: Fallo en la generación de CxC en SAP

    # Dado que la notificación a SAP presenta algún problema
    Given que el Load Number "<load_number>" cambió a estatus "TERMINADO"
    And la notificación hacia SAP presenta la condición de error "<condicion_error>"

    # Cuando la API intenta notificar a SAP
    When la API envía la notificación de servicio terminado a SAP S/4HANA

    # Entonces el proceso falla y se gestiona el error
    Then la API registra el fallo con código "<error_code>"
    And el registro de trazabilidad se actualiza a estado "ERROR_CXC_SAP"
    And la API aplica política de reintentos automáticos (máx. 3 intentos, intervalo 30 seg)
    And si se agotan los reintentos, la notificación queda en cola de errores para revisión manual
    And se genera alerta al equipo de soporte con detalle del fallo
    And el estatus del viaje en la API permanece "TERMINADO" independientemente del fallo en SAP

    Examples:
      | load_number     | condicion_error                                          | error_code                      |
      | LN-20260223-001 | SAP no disponible (timeout de conexión)                  | SAP_CONNECTION_TIMEOUT          |
      | LN-20260223-001 | SAP responde con error interno 500                       | SAP_INTERNAL_ERROR              |
      | LN-20260227-010 | Cliente no existe como socio comercial en SAP            | SAP_INVALID_CUSTOMER            |
      | LN-20260227-010 | Condiciones de pago no configuradas en SAP para cliente  | SAP_INVALID_PAYMENT_TERMS       |
      | LN-20260227-020 | CxC duplicada: ya existe documento SAP para ese viaje    | SAP_DUPLICATE_DOCUMENT          |
      | LN-20260227-020 | Credenciales de integración API → SAP inválidas          | SAP_AUTH_ERROR                  |
      | LN-20260223-001 | Importe del servicio igual a cero o negativo             | INVALID_SERVICE_AMOUNT          |

  # ----------------------------------------------------------------
  # DUDAS FUNCIONALES / PENDIENTES DE DEFINICIÓN
  # ----------------------------------------------------------------
  # [DUDA-011-A] ¿Qué API de SAP S/4HANA se usa para crear la CxC?
  #              Candidatos según documentación SAP:
  #              - Journal Entry Post (síncrona)
  #              - Billing Document API
  #              - Customer Invoice OData API
  #              → PENDIENTE DE DEFINICIÓN con el equipo de SAP.
  #
  # [DUDA-011-B] ¿El importe del servicio (amount) lo calcula
  #              GM Transport ERP o lo define un catálogo de tarifas
  #              en SAP? → PENDIENTE DE DEFINICIÓN.
  #
  # [DUDA-011-C] ¿Se requiere centro de costo (cost_center) o
  #              centro de beneficio (profit_center) en el documento
  #              contable de SAP? → PENDIENTE con equipo de SAP/finanzas.
  #
  # [DUDA-011-D] ¿La CxC en SAP se genera en moneda MXN siempre,
  #              o puede haber operaciones en USD?
  #              → SUPUESTO TÉCNICO: MXN. Confirmación requerida.
  # ----------------------------------------------------------------
