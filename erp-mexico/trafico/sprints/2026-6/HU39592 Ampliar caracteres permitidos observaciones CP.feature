Feature: Ampliar caracteres en observaciones de la carta porte
  Como usuario de trafico 
  Necesito que sea posible campturar hasta 1000 caracteres en el campo Observaciones de la Carta Porte
  Para poder especificar comentarios extensos o información necesaria

  Scenario: Permitir hasta 1000 caracteres en el campo observaciones
    Given el usuario se encuentra registrando una carta porte o viaje
    When captura información en el campo observaciones 
    And ingresa menos de 1000 caracteres
    Then el sistema permite la ingresar la informacion solicitada

  Scenario: Impide mas 1000 caracteres en el campo observaciones
    Given el usuario se encuentra registrando una carta porte o viaje
    When captura información en el campo observaciones 
    And ingresa mas de 1000 caracteres
    Then el sistema presenta el mensaje 
    """
      Capture menos de 1000 caracteres
    """
    And marca el campo en rojo