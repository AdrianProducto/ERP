Feature: Mensaje claro cuando el PAC está en mantenimiento 

  Como usuario del sistema GM Transport ERP
  Quiero recibir un mensaje claro cuando el timbrado falle por mantenimiento del PAC
  Para conocer el motivo por el cual no puedo timbrar y evitar confusión

  Scenario: Mostrar mensaje cuando el PAC está en mantenimiento
    Given que el usuario intenta realizar el timbrado
    And el servicio del PAC no está disponible por mantenimiento
    When el sistema detecta la falla en el timbrado
    Then el sistema debe mostrar un mensaje claro al usuario
    And el mensaje debe ser:
      """
      No es posible realizar el timbrado en este momento.
      El servicio de timbrado (PAC) se encuentra en mantenimiento.
      Por favor, intente de nuevo más tarde.
      """

  Scenario: Flujo normal cuando el PAC está disponible
    Given que el usuario intenta realizar el timbrado
    And el PAC está disponible
    When el timbrado se realiza correctamente
    Then el sistema debe completar el proceso sin mostrar mensajes de error