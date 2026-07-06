po# Característica
Feature: Configuración de Partner EDI APTIV
  Como usuario administrador de configuraciones en GM Integra
  Quiero registrar y configurar a APTIV como un Partner EDI asociado a un cliente
  Para habilitar la creación y administración de plantillas EDI que serán interpretadas por el ERP GM Transport

  # Antecedentes
  Background:
    # Dado
    Given que el usuario tiene permisos para administrar configuraciones EDI en GM Integra
    # Y
    And que el módulo de clientes se encuentra disponible
    # Y
    And que GM Integra solo configura plantillas y el ERP ejecuta la operación

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Registrar y consultar un Partner EDI APTIV con datos válidos
    # Dado
    Given que el usuario captura el nombre <nombre_partner>
    # Y
    And que captura el identificador interno <identificador_partner>
    # Y
    And que selecciona el cliente <cliente_relacionado>
    # Y
    And que define el estatus <estatus_partner>
    # Y
    And que define el ambiente <ambiente_partner>
    # Y
    And que habilita los documentos <documentos_edi>
    # Cuando
    When el usuario guarda la configuración del Partner EDI
    # Entonces
    Then el sistema registra el Partner EDI con el resultado <resultado_guardado>
    # Y
    And deja disponible la relación con los documentos EDI <documentos_edi>
    # Y
    And permite consultar la configuración general con el estado <estado_consulta>

    # Ejemplos
    Examples:
      | nombre_partner | identificador_partner | cliente_relacionado | estatus_partner | ambiente_partner | documentos_edi | resultado_guardado              | estado_consulta |
      | APTIV          | APTIV_MX             | Cliente APTIV MX    | Activo          | Pruebas          | 210,214        | Partner EDI registrado         | Consultable     |
      | APTIV          | APTIV_PROD           | Cliente APTIV MX    | Activo          | Productivo       | 210,214        | Partner EDI registrado         | Consultable     |
      | APTIV TEST     | APTIV_QA             | Cliente APTIV USA   | Inactivo        | Pruebas          | 210            | Partner EDI registrado         | Consultable     |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Validar errores al registrar un Partner EDI APTIV
    # Dado
    Given que el usuario captura el nombre <nombre_partner>
    # Y
    And que captura el identificador interno <identificador_partner>
    # Y
    And que selecciona el cliente <cliente_relacionado>
    # Y
    And que define el estatus <estatus_partner>
    # Y
    And que define el ambiente <ambiente_partner>
    # Y
    And que habilita los documentos <documentos_edi>
    # Cuando
    When el usuario intenta guardar la configuración del Partner EDI
    # Entonces
    Then el sistema responde con el mensaje <mensaje_validacion>
    # Y
    And no registra el Partner EDI con el estado <resultado_registro>

    # Ejemplos
    Examples:
      | nombre_partner | identificador_partner | cliente_relacionado | estatus_partner | ambiente_partner | documentos_edi | mensaje_validacion                                         | resultado_registro |
      |                | APTIV_MX             | Cliente APTIV MX    | Activo          | Pruebas          | 210,214        | El nombre del Partner EDI es obligatorio                   | No registrado      |
      | APTIV          |                      | Cliente APTIV MX    | Activo          | Pruebas          | 210,214        | El identificador interno del Partner EDI es obligatorio    | No registrado      |
      | APTIV          | APTIV_MX             |                     | Activo          | Pruebas          | 210,214        | El cliente relacionado es obligatorio                      | No registrado      |
      | APTIV          | APTIV_MX             | Cliente APTIV MX    | Activo          |                  | 210,214        | El ambiente del Partner EDI es obligatorio                 | No registrado      |
      | APTIV          | APTIV_MX             | Cliente APTIV MX    | Activo          | Pruebas          |                | Debe seleccionarse al menos un documento EDI               | No registrado      |
      | APTIV          | APTIV_MX             | Cliente APTIV MX    | Activo          | Pruebas          | 210,214        | Ya existe un Partner EDI con el mismo cliente e identificador | No registrado   |

  Scenario: Validar la estructura mínima de configuración del Partner EDI
    # Dado
    Given que el sistema define la estructura mínima requerida para un Partner EDI
    # Entonces
    Then la configuración debe considerar la siguiente estructura
      """
      {
        "partnerEdi": {
          "nombrePartner": "string",
          "identificadorInterno": "string",
          "clienteRelacionado": "string",
          "estatus": "Activo | Inactivo",
          "ambiente": "Pruebas | Productivo",
          "documentosEdiHabilitados": ["210", "214"],
          "plantillasAsociadas": []
        }
      }
      """
      