Feature: AMPLIAR NOMBRE EN ALTA DE CLIENTE
  Como usuario 
  Necsito poder capturar una razon social extensa 
  Para poder tener la informacióm completa de mis clientes

  Scenario: Ampliar nombre fiscal al registrar cliente
    Given el usuario se encuentra registrando un cliente 
    When capture el Nombre fiscal
    Then el sistema debe permitir capturar hasta 254 caracteres

  Scenario: Ampliar nombre fiscal al modificar nombre/RFC
    Given el usuario se encuentra modificando el nombre o RFC de un cliente
    When capture el Nombre fiscal
    Then el sistema debe permitir capturar hasta 254 caracteres