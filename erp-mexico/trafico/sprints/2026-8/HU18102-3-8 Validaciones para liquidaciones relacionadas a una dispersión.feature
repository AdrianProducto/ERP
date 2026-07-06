Feature: Validaciones para liquidaciones relacionadas a una dispersión
  Como usuario de tráfico
  Necesito que el sistema no me permita manipular liquidaciones relacionadas a una dispersión
  Para mantener la congruencia en las dispersiones registradas

  Background: 
    Given el usuario de encuentra en el listado de Liquidaciones del modulo de tráfico
    And tiene permisos para eliminar liquidaciones
    And tiene permisos para desautorizar liquidaciones
    And tiene permisos para pagar/timbrar liquidaciones
    And tiene permisos para generar despersiones normales

  Scenario: No eliminar liquidaciones relacionadas a una dispersión avanzada
    Given existen liquidaciones relacionados a una dispersión avanzada
    When el usuario solicita eliminar una liqudación relacionada a una disperción avanzada
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que la liquidación se encuentra dentro de un proceso de dispersión. Favor de revisar
    """
    And no elimina el liquidación

  Scenario: No desautorizar aliquidaciones relacionadas a una dispersión avanzada
    Given existen liquidaciones relacionados a una dispersión avanzada
    When el usuario solicita desautorizar una liqudación relacionada a una disperción avanzada
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que la liquidación se encuentra dentro de un proceso de dispersión. Favor de revisar
    """
    And no desautoriza la liqudación

  Scenario: No pagar liquidaciones relacionadas a una dispersión avanzada
    Given existen liquidaciones relacionados a una dispersión avanzada
    When el usuario solicita pagar una liqudación relacionada a una disperción avanzada
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que la liquidación se encuentra dentro de un proceso de dispersión. Favor de revisar
    """
    And no realiza la acción

  Scenario: No pagar/timbrar liquidaciones relacionadas a una dispersión avanzada
    Given el usuario solicita pagar/timbrar liquidaciones masivamente
    And selecciona liquidaciones relacionadas a una dispersión avanzada
    When solicita generar la operación
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que existen liquidaciones seleccionadas que se encuentran dentro de un proceso de dispersión. 
      Favor de revisar
    """
    And muestra una lista de los folios de los anticipos seleccionados relacionados a una dispersión avanzada
    And no realiza la acción
 
  Scenario: No timbrar liquidaciones relacionadas a una dispersión avanzada
    Given el usuario solicita timbrar liquidaciones masivamente
    And selecciona liquidaciones relacionadas a una dispersión avanzada
    When solicita generar la operación
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que existen liquidaciones seleccionadas que se encuentran dentro de un proceso de dispersión. 
      Favor de revisar
    """
    And muestra una lista de los folios de los anticipos seleccionados relacionados a una dispersión avanzada
    And no realiza la acción

  Scenario: No generar dispersicion normal a liquidaciones relacionadas a una dispersión avanzada
    Given el usuario solicita generar una dispersión normal
    And selecciona liquidaciones relacionadas a una dispersión avanzada
    When solicita generar la operación
    Then el sistema muestra el mensaje:
    """
      No es posible realizar la acción ya que existen liquidaciones seleccionadas que se encuentran dentro de un proceso de dispersión. 
      Favor de revisar
    """
    And muestra una lista de los folios de los anticipos seleccionados relacionados a una dispersión avanzada
    And no realiza la acción
 

    
  