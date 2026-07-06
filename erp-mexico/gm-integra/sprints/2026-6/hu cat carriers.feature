# Característica
Feature: Consultar catálogo de Carriers de GM Integra desde el ERP
  Como usuario del ERP que opera procesos relacionados con EDI
  Quiero que el ERP consulte el catálogo de Carriers definido en GM Integra
  Para validar que los Carriers estén sincronizados y poder utilizar nuevos Carriers creados en GM Integra dentro de los procesos del ERP

  # Antecedentes
  Background:
    # Dado
    Given que GM Integra administra el catálogo maestro de Carriers para configuraciones EDI
    # Y
    And que el ERP cuenta con integración habilitada hacia GM Integra
    # Y
    And que existe un servicio disponible para consultar el catálogo de Carriers desde GM Integra
    # Y
    And que el usuario tiene permisos para ejecutar procesos relacionados con EDI en el ERP

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Consultar exitosamente desde el ERP el catálogo de Carriers definido en GM Integra
    # Dado
    Given que en GM Integra existe un Carrier con estatus "<estatusCarrier>"
    # Cuando
    When el ERP consulta el catálogo de Carriers de GM Integra
    # Entonces
    Then el sistema obtiene los Carriers disponibles definidos en GM Integra
    # Y
    And cada Carrier recuperado incluye al menos los datos "<camposEsperados>"
    # Y
    And el ERP puede usar esta información para validaciones y procesos relacionados con EDI
    # Y
    And el catálogo consultado queda disponible para identificar Carriers sincronizados

    # Ejemplos
    Examples:
      | estatusCarrier | camposEsperados                              |
      | Activo         | clave, nombre, estatus                       |
      | Activo         | clave, nombre, identificador, estatus        |
      | Activo         | clave, nombre, versión, estatus              |



  # Esquema del escenario
  Scenario Outline: Validar en el ERP que un Carrier utilizado en un proceso existe y está sincronizado con GM Integra
    # Dado
    Given que el ERP va a utilizar el Carrier "<carrierProceso>" en un proceso relacionado con EDI
    # Cuando
    When el ERP valida el Carrier contra el catálogo obtenido desde GM Integra
    # Entonces
    Then el sistema confirma que el Carrier existe en GM Integra
    # Y
    And valida que su estatus sea "<estatusValidacion>"
    # Y
    And permite continuar con el proceso en el ERP
    # Y
    And deja consistencia entre el Carrier configurado en GM Integra y el Carrier utilizado en ERP



  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear el uso de un Carrier en ERP cuando no exista o no esté sincronizado con GM Integra
    # Dado
    Given que el ERP intenta usar el Carrier con la condición "<condicionCarrier>"
    # Cuando
    When el sistema valida dicho Carrier contra el catálogo de GM Integra
    # Entonces
    Then el ERP bloquea la continuación del proceso relacionado con EDI
    # Y
    And muestra el mensaje "<mensajeEsperado>"
    # Y
    And no permite operar con un Carrier no sincronizado o inconsistente

    # Ejemplos
    Examples:
      | condicionCarrier                    | mensajeEsperado                                                      |
      | no existe en GM Integra             | El Carrier no existe en el catálogo maestro de GM Integra           |
      | no ha sido sincronizado             | El Carrier no se encuentra sincronizado con GM Integra              |
      | identificador inválido o incompleto | El Carrier no cuenta con información válida para utilizarse en ERP  |

  # Esquema del escenario
  Scenario Outline: Informar error cuando el ERP no puede consultar el catálogo de Carriers de GM Integra
    # Dado
    Given que el ERP requiere consultar el catálogo de Carriers desde GM Integra
    # Y
    And que ocurre la condición técnica "<condicionError>"
    # Cuando
    When el ERP intenta obtener la información del catálogo
    # Entonces
    Then el sistema no utiliza información incompleta o no validada
    # Y
    And muestra el mensaje "<mensajeTecnico>"
    # Y
    And registra el evento para seguimiento técnico y funcional

    # Ejemplos
    Examples:
      | condicionError           | mensajeTecnico                                                     |
      | servicio no disponible   | No fue posible consultar el catálogo de Carriers en GM Integra     |
      | timeout de integración   | La consulta del catálogo de Carriers excedió el tiempo de espera   |
      | respuesta inválida       | La información recibida de GM Integra no es válida                 |
      | error interno            | Ocurrió un error al consultar el catálogo de Carriers              |

  # Esquema del escenario
  Scenario Outline: Evitar duplicidad lógica de Carriers entre ERP y GM Integra
    # Dado
    Given que el Carrier "<carrierDuplicado>" ya existe en el catálogo maestro de GM Integra
    # Cuando
    When el ERP intenta operar con una referencia local distinta o inconsistente para ese Carrier
    # Entonces
    Then el sistema identifica la inconsistencia de sincronización
    # Y
    And muestra el mensaje "<mensajeDuplicidad>"
    # Y
    And solicita utilizar la referencia sincronizada proveniente de GM Integra
    # Y
    And evita generar duplicidad lógica entre ambos sistemas

    # Ejemplos
    Examples:
      | carrierDuplicado | mensajeDuplicidad                                                       |
      | Carrier A        | El Carrier debe utilizar la referencia sincronizada de GM Integra      |
      | Carrier B        | No es posible operar con un Carrier no homologado con GM Integra       |