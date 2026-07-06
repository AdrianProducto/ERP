# Característica
@DobleCheck 
Feature: Mostrar el LoadNumber al seleccionar un viaje en el formulario

  Como inspector de Doble Check
  Quiero ver el LoadNumber del viaje al momento de llenarlo en el formulario
  Para que el cliente pueda identificar el número de viaje que le corresponde

  # Antecedentes
  Background:
    # Dado
    Given que el inspector tiene sesión iniciada en Doble Check
    # Y
    And que está creando un nuevo formulario 
    # Y
    And que seleccionó "Viaje" como Tipo de Movimiento

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El viaje tiene LoadNumber y se muestra en el formulario
    # Dado
    Given que el inspector selecciona el <viaje> en el campo Viaje de Datos Generales
    # Cuando
    When el sistema consulta el LoadNumber de ese <viaje> en el ERP
    # Entonces
    Then el sistema muestra el LoadNumber en el formulario

  Scenario: El viaje no tiene LoadNumber y el campo aparece vacío
    # Dado
    Given que el inspector selecciona el <viaje> en el campo Viaje de Datos Generales
    # Cuando
    When el sistema consulta el LoadNumber de ese <viaje> en el ERP
    # Entonces
    Then el sistema muestra el campo LoadNumber vacío
    # Y
    And el inspector puede continuar llenando el formulario sin problema

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  Scenario: No se muestra el campo LoadNumber si no se ha seleccionado un viaje
    # Dado
    Given que el inspector aún no ha seleccionado ningún viaje en el formulario
    # Entonces
    Then el campo LoadNumber no se muestra

  Scenario: El tipo de movimiento no es Viaje y no se muestra el LoadNumber
    # Dado
    Given que el inspector seleccionó "Patio" u "Otro" como Tipo de Movimiento
    # Entonces
    Then el campo LoadNumber no se muestra
