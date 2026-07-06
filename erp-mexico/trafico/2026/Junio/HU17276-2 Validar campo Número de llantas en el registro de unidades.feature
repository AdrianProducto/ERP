Feature: Validar campo Número de llantas en el registro de unidades
  Como usuario responsable del registro de unidades
  Quiero que el sistema valide la captura obligatoria del campo Número de llantas
  Para garantizar información completa que permita la asignación automática de la Clave SAT

  Background:
    Given que el parámetro "Asignación automática de Clave SAT a unidades" se encuentra habilitado
    And el usuario ha accedido al módulo de registro de unidades

  Scenario: Campo obligatorio para tipos de unidad distintos a Contenedor
    Given el usuario esta registrando una nueva unidad con tipo de unidad distinto a "CONTENEDOR"
    When intenta guardar el registro sin capturar el campo Número de llantas
    Then el sistema debe impedir el guardado del registro
    And debe mostrar un mensaje indicando que el campo Número de llantas es obligatorio:
      """
        El número de llantas es un dato obligatorio favor de verificar.
      """

  Scenario: Campo no obligatorio para tipo de unidad Contenedor
    Given que el usuario esta registrando una nueva unidad con tipo de unidad "CONTENEDOR"
    When guarda el registro sin capturar el campo Número de llantas
    Then el sistema debe permitir el guardado del registro exitosamente

  Scenario Outline: Registro exitoso con número de llantas capturado
    Given el usuario esta registrando una nueva unidad con tipo de unidad "<tipo_unidad>"
    When capturo el número de ejes "<numero_ejes>" y el número de llantas "<numero_llantas>"
    And guardo el registro
    Then el sistema debe almacenar correctamente la información de ejes y llantas de la unidad

    Example:   
      | tipo_unidad                 | numero_ejes | numero_llantas |
      | VEHICULO UNITARIO - TORTON  | 2           | 6              |
      | TRACTOCAMION - TRACTOCAMION | 3           | 10             |
      | SEMIREMOLQUE - TOLVA        | 2           | 8              |