# language: es

Feature: HU-40577 Precarga de tipo de cambio desde el viaje en la Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero que el campo Tipo de Cambio se precargue automáticamente con el valor registrado en el viaje
  Para evitar captura manual y garantizar que el tipo de cambio sea consistente con el viaje operado

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene acceso a la Pantalla Aeropuerto

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: El tipo de cambio se precarga correctamente sin importar la moneda del viaje
    # Dado
    Given que el viaje tiene moneda <moneda>
    # Y
    And que el viaje tiene un tipo de cambio registrado de <tipo_cambio>
    # Cuando
    When el usuario abre el detalle o modal del trayecto en la Pantalla Aeropuerto
    # Entonces
    Then el campo "Tipo de Cambio" muestra el valor <tipo_cambio>
    # Y
    And el campo "Tipo de Cambio" está deshabilitado y no es editable por el usuario

    Examples:
      | moneda | tipo_cambio |
      | MXN    | 18.50       |
      | USD    | 17.50       |
      | GTQ    | 2.30        |

  Scenario: El campo Tipo de Cambio permanece deshabilitado en todo momento
    # Dado
    Given que el detalle o modal del trayecto está abierto
    # Cuando
    When el usuario intenta modificar el campo "Tipo de Cambio"
    # Entonces
    Then el sistema no permite la edición del campo
    # Y
    And el valor original proveniente del viaje se mantiene sin cambios

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: El tipo de cambio no se muestra si el viaje no tiene valor registrado
    # Dado
    Given que el viaje no tiene tipo de cambio registrado
    # Cuando
    When el usuario abre el detalle o modal del trayecto
    # Entonces
    Then el campo "Tipo de Cambio" aparece vacío o con valor cero
    # Y
    And el campo permanece deshabilitado

  Scenario: Validar comportamiento visual del campo deshabilitado
    # Dado
    Given que el campo "Tipo de Cambio" está precargado con el valor del viaje
    # Cuando
    When el sistema renderiza el detalle o modal del trayecto
    # Entonces
    Then el campo muestra visualmente que está deshabilitado (estilo distinto al campo editable)
    # Y
    And no presenta cursor de texto ni estado de foco al interactuar con él
