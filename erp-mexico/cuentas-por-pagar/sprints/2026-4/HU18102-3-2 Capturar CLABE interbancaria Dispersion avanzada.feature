Feature: Capturar CLABE interbancaria en dispersión avanzada
  Como usuario de cuentas por pagar
  Necesito poder especificar la CLABE interbancaria a un proveedor en especifico
  Para poder generar el archivo de dispersión de forma correcta.

  Background: 
    Given el usuario desea generar una dispersión avanzada
    And un proveedor no cuenta con su información bancaria completa

  Scenario: Permitir capturar CLABE
    Dado que el cliente selecciona un pasivo del listado
    When solicita Asignar banco/cuenta bancaria
    Then el sistema solicita la siguiente información:
      | campo               |
      | Banco               |
      | Cuenta bancaria     |
      | CLABE interbancaria |
    
      