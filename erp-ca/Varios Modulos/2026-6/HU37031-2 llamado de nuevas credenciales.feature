Feature: Actualización del web service de timbrado para Guatemala

  Como sistema
  Quiero modificar el web service de timbrado
  Para que utilice los nuevos campos "LlaveWS" y "TokenSigner" en bases de datos de Guatemala

  Scenario: Uso de nuevos campos para timbrado en Guatemala
    Given que la base de datos pertenece a Guatemala
    And existen valores configurados en los campos "LlaveWS" y "TokenSigner"
    When se realiza una solicitud al web service de timbrado
    Then el sistema debe tomar los valores de "LlaveWS" y "TokenSigner"
    And debe enviarlos como credenciales en la petición al web service

Scenario: Compatibilidad con bases de datos de otros países
    Given que la base de datos no pertenece a Guatemala
    When se realiza una solicitud al web service de timbrado
    Then el sistema debe utilizar los campos "usuario" y "contraseña"
    And no debe enviar "LlaveWS" ni "TokenSigner"