Feature: No precardar cuenta bancaria al generar dispersión
  Como usuario
  Necesito que al momento de querer registrar una dispersion avanzada de anticipos no se precargue un valor por default en la cuenta bancaria
  Para evitar errores y que el movimiento se cargue a una cuenta equivocada

  Scenario: No precarga por defualt cuenta bancaria
    Given el usuario solicita generar una dispersion avanzada de anticipos
    When el sistema presenta el formulario correspondiente
    Then el campo "Cuenta bancaria" se presenta vacio por default