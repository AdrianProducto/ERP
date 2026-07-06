    # Característica
Feature: Configuración de Plantilla EDI 214 para APTIV
  Como usuario administrador de configuraciones EDI en GM Integra
  Quiero definir una plantilla estructural del EDI 214 para el Partner APTIV
  Para que el ERP GM Transport pueda interpretarla y generar correctamente la estructura de seguimiento y estatus de embarques

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
  Scenario Outline: Crear una plantilla EDI 214 con estructura válida de eventos
    # Dado
    Given que el usuario selecciona el Partner EDI <partner_edi>
    # Y
    And define la versión <version_plantilla>
    # Y
    And configura la estructura de eventos <estructura_eventos>
    # Y
    And define los campos obligatorios <campos_obligatorios>
    # Y
    And configura eventos repetibles <eventos_repetibles>
    # Y
    And establece el origen de datos <origen_datos>
    # Y
    And asocia los catálogos <catalogos_asociados>
    # Y
    And define las reglas condicionales <reglas_condicionales>
    # Cuando
    When el usuario guarda la plantilla EDI 214
    # Entonces
    Then el sistema registra la plantilla con el resultado <resultado_guardado>
    # Y
    And marca la versión <version_plantilla> con el estado <estado_version>
    # Y
    And permite consultar la estructura EDI 214 con el estado <estado_consulta>

    # Ejemplos
    Examples:
      | partner_edi | version_plantilla | estructura_eventos         | campos_obligatorios                    | eventos_repetibles | origen_datos            | catalogos_asociados      | reglas_condicionales                  | resultado_guardado           | estado_version | estado_consulta |
      | APTIV_MX    | 1.0               | Shipment,Status,Location   | ShipmentId,StatusCode,EventDate        | StatusEvents       | ERP,ValorFijo          | StatusCodes,DelayCodes   | Delay code solo cuando aplique        | Plantilla 214 registrada    | Activa         | Consultable     |
      | APTIV_PROD  | 1.1               | Shipment,Status,Location   | ShipmentId,StatusCode,Location         | StatusEvents       | ERP,Regla              | StatusCodes              | Eventos según tipo de operación       | Plantilla 214 registrada    | Activa         | Consultable     |
      | APTIV_QA    | 2.0               | Shipment,Status,Location   | ShipmentId,StatusCode,EventDate,Time   | StatusEvents       | ERP,ValorCalculado     | StatusCodes,DelayCodes   | Condiciones por estatus y retraso     | Plantilla 214 registrada    | Borrador       | Consultable     |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Validar errores al guardar una plantilla EDI 214
    # Dado
    Given que el usuario selecciona el Partner EDI <partner_edi>
    # Y
    And define la versión <version_plantilla>
    # Y
    And configura la estructura de eventos <estructura_eventos>
    # Y
    And define los campos obligatorios <campos_obligatorios>
    # Y
    And configura eventos repetibles <eventos_repetibles>
    # Y
    And establece el origen de datos <origen_datos>
    # Y
    And asocia los catálogos <catalogos_asociados>
    # Y
    And define las reglas condicionales <reglas_condicionales>
    # Cuando
    When el usuario intenta guardar la plantilla EDI 214
    # Entonces
    Then el sistema responde con el mensaje <mensaje_validacion>
    # Y
    And no guarda la plantilla con el estado <resultado_guardado>

    # Ejemplos
    Examples:
      | partner_edi | version_plantilla | estructura_eventos       | campos_obligatorios             | eventos_repetibles | origen_datos | catalogos_asociados    | reglas_condicionales     | mensaje_validacion                                                      | resultado_guardado |
      |             | 1.0               | Shipment,Status,Location | ShipmentId,StatusCode           | StatusEvents       | ERP          | StatusCodes            | Por evento               | Debe seleccionarse un Partner EDI                                      | No registrada      |
      | APTIV_MX    |                   | Shipment,Status,Location | ShipmentId,StatusCode           | StatusEvents       | ERP          | StatusCodes            | Por evento               | La versión de la plantilla es obligatoria                              | No registrada      |
      | APTIV_MX    | 1.0               |                          | ShipmentId,StatusCode           | StatusEvents       | ERP          | StatusCodes            | Por evento               | La estructura mínima de eventos es obligatoria                         | No registrada      |
      | APTIV_MX    | 1.0               | Shipment,Status,Location |                                | StatusEvents       | ERP          | StatusCodes            | Por evento               | Debe definirse al menos un campo obligatorio                           | No registrada      |
      | APTIV_MX    | 1.0               | Shipment,Status,Location | ShipmentId,StatusCode           | StatusEvents       |              | StatusCodes            | Por evento               | Debe configurarse el origen de datos de la plantilla                   | No registrada      |
      | APTIV_MX    | 1.0               | Shipment,Status,Location | ShipmentId,StatusCode           | StatusEvents       | ERP          |                        | Por evento               | Debe asociarse al menos un catálogo para la interpretación del ERP     | No registrada      |
      | APTIV_MX    | 1.0               | Shipment,Status,Location | ShipmentId,StatusCode           | StatusEvents       | ERP          | StatusCodes            | Reglas inconsistentes     | Existen reglas condicionales inválidas para la estructura de eventos   | No registrada      |

  Scenario: Validar la estructura mínima interpretable de la plantilla EDI 214
    # Dado
    Given que el sistema requiere una estructura interpretable para eventos de seguimiento
    # Entonces
    Then la plantilla EDI 214 debe respetar la siguiente estructura mínima
      """
      {
        "edi214": {
          "partnerEdi": "APTIV",
          "version": "string",
          "estructuraEventos": {
            "shipment": [],
            "status": [
              {
                "statusEvents": []
              }
            ],
            "location": []
          },
          "camposObligatorios": [
            "ShipmentId",
            "StatusCode",
            "EventDate"
          ],
          "origenDatos": ["ERP", "ValorFijo", "ValorCalculado", "Regla"],
          "catalogos": [
            "StatusCodes",
            "DelayCodes"
          ],
          "reglasCondicionales": []
        }
      }
      """