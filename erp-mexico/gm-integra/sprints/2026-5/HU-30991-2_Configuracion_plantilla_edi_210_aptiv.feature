# Característica
Feature: Configuración de Plantilla EDI 210 para APTIV
  Como usuario administrador de configuraciones EDI en GM Integra
  Quiero definir una plantilla estructural del EDI 210 para el Partner APTIV
  Para que el ERP GM Transport pueda interpretarla y generar correctamente la factura logística conforme al carrier

  # Antecedentes
  Background:
    # Dado
    Given que existe un Partner EDI APTIV previamente configurado
    # Y
    And que el usuario tiene permisos para administrar plantillas EDI
    # Y
    And que GM Integra solo configura la plantilla y el ERP interpreta la operación

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Crear una plantilla EDI 210 con estructura válida
    # Dado
    Given que el usuario selecciona el Partner EDI <partner_edi>
    # Y
    And define la versión <version_plantilla>
    # Y
    And configura la estructura <estructura_documento>
    # Y
    And define los campos obligatorios <campos_obligatorios>
    # Y
    And configura nodos repetibles <nodos_repetibles>
    # Y
    And establece el origen de datos <origen_datos>
    # Y
    And asocia los catálogos <catalogos_asociados>
    # Y
    And define las reglas condicionales <reglas_condicionales>
    # Cuando
    When el usuario guarda la plantilla EDI 210
    # Entonces
    Then el sistema registra la plantilla con el resultado <resultado_guardado>
    # Y
    And marca la versión <version_plantilla> con el estado <estado_version>
    # Y
    And permite consultar la estructura EDI 210 con el estado <estado_consulta>

    # Ejemplos
    Examples:
      | partner_edi | version_plantilla | estructura_documento    | campos_obligatorios                    | nodos_repetibles | origen_datos                  | catalogos_asociados                        | reglas_condicionales                    | resultado_guardado           | estado_version | estado_consulta |
      | APTIV_MX    | 1.0               | Header,Detail,Summary   | InvoiceNumber,ShipmentId,ChargeCode    | ChargeLines      | ERP,ValorFijo                | ChargeCodes,CurrencyCodes,References       | Nacional e Internacional                | Plantilla 210 registrada    | Activa         | Consultable     |
      | APTIV_PROD  | 1.1               | Header,Detail,Summary   | InvoiceNumber,ShipmentId,CurrencyCode  | ChargeLines      | ERP,ValorCalculado           | ChargeCodes,CurrencyCodes,ReferenceQualifiers | Solo internacional si aplica         | Plantilla 210 registrada    | Activa         | Consultable     |
      | APTIV_QA    | 2.0               | Header,Detail,Summary   | InvoiceNumber,TotalAmount,Reference    | ChargeLines      | ERP,ValorFijo,Regla          | ChargeCodes,References                     | Por tipo de operación                   | Plantilla 210 registrada    | Borrador       | Consultable     |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Validar errores al guardar una plantilla EDI 210
    # Dado
    Given que el usuario selecciona el Partner EDI <partner_edi>
    # Y
    And define la versión <version_plantilla>
    # Y
    And configura la estructura <estructura_documento>
    # Y
    And define los campos obligatorios <campos_obligatorios>
    # Y
    And configura nodos repetibles <nodos_repetibles>
    # Y
    And establece el origen de datos <origen_datos>
    # Y
    And asocia los catálogos <catalogos_asociados>
    # Y
    And define las reglas condicionales <reglas_condicionales>
    # Cuando
    When el usuario intenta guardar la plantilla EDI 210
    # Entonces
    Then el sistema responde con el mensaje <mensaje_validacion>
    # Y
    And no guarda la plantilla con el estado <resultado_guardado>

    # Ejemplos
    Examples:
      | partner_edi | version_plantilla | estructura_documento  | campos_obligatorios                 | nodos_repetibles | origen_datos        | catalogos_asociados                  | reglas_condicionales     | mensaje_validacion                                                   | resultado_guardado |
      |             | 1.0               | Header,Detail,Summary | InvoiceNumber,ShipmentId            | ChargeLines      | ERP                 | ChargeCodes,CurrencyCodes            | Nacional                 | Debe seleccionarse un Partner EDI                                   | No registrada      |
      | APTIV_MX    |                   | Header,Detail,Summary | InvoiceNumber,ShipmentId            | ChargeLines      | ERP                 | ChargeCodes,CurrencyCodes            | Nacional                 | La versión de la plantilla es obligatoria                           | No registrada      |
      | APTIV_MX    | 1.0               |                       | InvoiceNumber,ShipmentId            | ChargeLines      | ERP                 | ChargeCodes,CurrencyCodes            | Nacional                 | La estructura mínima Header, Detail y Summary es obligatoria        | No registrada      |
      | APTIV_MX    | 1.0               | Header,Detail,Summary |                                    | ChargeLines      | ERP                 | ChargeCodes,CurrencyCodes            | Nacional                 | Debe definirse al menos un campo obligatorio                        | No registrada      |
      | APTIV_MX    | 1.0               | Header,Detail,Summary | InvoiceNumber,ShipmentId            | ChargeLines      |                     | ChargeCodes,CurrencyCodes            | Nacional                 | Debe configurarse el origen de datos de la plantilla                | No registrada      |
      | APTIV_MX    | 1.0               | Header,Detail,Summary | InvoiceNumber,ShipmentId            | ChargeLines      | ERP                 |                                      | Nacional                 | Debe asociarse al menos un catálogo para la interpretación del ERP  | No registrada      |
      | APTIV_MX    | 1.0               | Header,Detail,Summary | InvoiceNumber,ShipmentId            | ChargeLines      | ERP                 | ChargeCodes,CurrencyCodes            | Reglas inconsistentes     | Existen reglas condicionales inválidas o inconsistentes             | No registrada      |

  Scenario: Validar la estructura mínima interpretable de la plantilla EDI 210
    # Dado
    Given que el sistema requiere una estructura interpretable para el ERP
    # Entonces
    Then la plantilla EDI 210 debe respetar la siguiente estructura mínima
      """
      {
        "edi210": {
          "partnerEdi": "APTIV",
          "version": "string",
          "estructura": {
            "header": [],
            "detail": [
              {
                "chargeLines": []
              }
            ],
            "summary": []
          },
          "camposObligatorios": [
            "InvoiceNumber",
            "ShipmentId"
          ],
          "origenDatos": ["ERP", "ValorFijo", "ValorCalculado", "Regla"],
          "catalogos": [
            "ChargeCodes",
            "CurrencyCodes",
            "ReferenceQualifiers"
          ],
          "reglasCondicionales": []
        }
      }
      """
      