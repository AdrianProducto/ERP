Feature: Validaciones para anticipos relacionados a una dispersión
  Como usuario de tráfico
  Necesito que el sistema no me permita manipular anticipos relacionados a una dispersión
  Para mantener la congruencia en las dispersiones registradas

  Background: 
    Given el usuario de encuentra en el listado de Anticipos del modulo de tráfico
    And tiene permisos para eliminar anticipos
    And tiene permisos para desautorizar anticipos
    And tiene permisos para asignar operacion
    And tiene permisos para generar despersiones normales

  Scenario: No eliminar anticipos relacionados a una dispersión avanzada
    Given existen anticipos relacionados a una dispersión avanzada
    When el usuario solicita eliminar un anticipo relacionado a una disperción avanzada
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que el anticipo se encuentra dentro de un proceso de dispersión. Favor de revisar
    """
    And no elimina el anticipo

  Scenario: No desautorizar anticipos relacionados a una dispersión avanzada
    Given existen anticipos relacionados a una dispersión avanzada
    When el usuario solicita desautorizar un anticipo relacionado a una disperción avanzada
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que el anticipo se encuentra dentro de un proceso de dispersión. Favor de revisar
    """
    And no desautoriza el anticipo

  Scenario: No asignar operación a anticipos relacionados a una dispersión avanzada
    Given el usuario selecciono un anticipo relacionados a una dispersión avanzada desde el listado de anticipos
    When el usuario solicita asignar operación
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que el anticipo se encuentra dentro de un proceso de dispersión. Favor de revisar
    """
    And no presenta el formulario para asignar operacion

  Scenario: No asignar operación masiva a anticipos relacionados a una dispersión
    Given el usuario solicita asignar operación masiva
    And selecciona anticipos relacionados a una dispersión avanzada
    When solicita generar la operación
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que existen anticipos seleccionados que se encuentran dentro de un proceso de dispersión. 
      Favor de revisar
    """
    And muestra una lista de los folios de los anticipos seleccionados relacionados a una dispersión avanzada
    And no genera la asignación de la operación

  Scenario: No generar dispersicion normal a anticipos relacionados a una dispersión avanzada
    Given el usuario solicita generar una dispersión normal
    And selecciona anticipos relacionados a una dispersión avanzada
    When solicita finalizar el proceso
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que existen anticipos seleccionados que se encuentran dentro de un proceso de dispersión. 
      Favor de revisar
    """
    And muestra una lista de los folios de los anticipos seleccionados relacionados a una dispersión avanzada
    And no genera la dispersión
    
  