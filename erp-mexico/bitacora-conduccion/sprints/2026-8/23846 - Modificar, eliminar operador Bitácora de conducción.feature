
Feature: Incluir  botones Modificar y Eliminar en Bitácora de conducción

  Como usuario de Bitácora de conducción
  Quiero visualizar los botones "Modificar" y "Eliminar" en el listado de operadores
  Para administrar la información de los operadores de bitácora de conducción.

  Scenario: Visualización de nuevos botones en el listado de operadores
    Given que el usuario se encuentra en el módulo de Bitácora de conducción
    And existe al menos un operador registrado en el listado
    When el sistema muestra la información de los operadores
    Then deberá mostrar el botón "Modificar"
    And deberá mostrar el botón "Eliminar"

  Scenario: Modificar número de teléfono del operador
    Given que el usuario se encuentra en el módulo de Bitácora de conducción
    And existe un operador registrado en el listado
    When el usuario selecciona el botón "Modificar"
    And captura un nuevo número de teléfono
    Then el sistema deberá guardar el nuevo número de teléfono del operador
    And solo deberá permitir modificar el número de teléfono

  Scenario: Eliminar operador del listado
    Given que el usuario se encuentra en el módulo de Bitácora de conducción
    And existe un operador registrado en el listado
    When el usuario selecciona el botón "Eliminar"
    Then el sistema deberá eliminar al operador del listado
    And el operador ya no deberá mostrarse en Bitácora de conducción