Feature: Adecuaciones al calculo baseDR en pagos/abonos
  Como usuario del módulo de Cobranza 
  Necesito que al registrar un pago o abono a una factura que tenga asociada una nota de crédito tipo PEMEX, el cálculo de la BaseDR considere los importes de dicha nota de crédito 
  Para asegurar que los importes del complemento de pago sean correctos.

  Background: 
    Given el usuario se encuentra en el listado de Pagos/Abonos del modulo de Cobranza
    And cuenta con los permisos para gestionar pagos
    And solicita agregar un pago/abono

  Scenario Outline: Cálculo de BaseDR con una o múltiples notas de crédito aplicadas a una factura
      Given una factura con saldo original de <saldo_original>
      And cuenta con notas de crédito tipo PEMEX cuyo monto total es <nc_aplicada>
      When el usuario registra un pago o abono
      Then la BaseDR debe ser <base_dr>

      Examples:
        | saldo_original | nc_aplicada | base_dr |
        | 1000.00        | 0.00        | 1000.00 |
        | 1000.00        | 200.00      | 800.00  |
        | 1000.00        | 100.00      | 900.00  |
        | 1000.00        | 300.00      | 700.00  |
        | 1000.00        | 1000.00     | 0.00    |

  Scenario: Cálculo con múltiples notas de crédito
    Given una factura con múltiples notas de crédito tipo PEMEX relacionadas
    When el usuario registra un pago
    Then el sistema debe sumar los totales de todas las notas de crédito
    And debe considerar dicha suma para el cálculo de la BaseDR

  Scenario: Aplicación de reglas de redondeo
    Given que se calcula la BaseDR con valores decimales
    When el sistema obtiene el resultado
    Then debe aplicar las reglas de precisión y redondeo actuales

  Scenario: Consistencia con el complemento de pago
    Given que se registra un pago con BaseDR calculada
    When se genera el complemento de pago
    Then los importes deben ser consistentes con la BaseDR calculada

  Scenario: Mantener BaseDR en pagos históricos
    Given una factura con una nota de crédito tipo PEMEX relacionada
    And se registró un pago a dicha factura
    And posteriormente la nota de crédito es cancelada
    When se consulta el pago registrado
    Then la BaseDR debe conservar su valor original
    And no debe ser modificada ni recalculada

  Scenario Outline: Cálculo de BaseDR después de cancelar la nota de crédito
    Given una factura con saldo original de <saldo_original>
    And tiene una nota de crédito relacionada de <nc_aplicada>
    And la nota de crédito ha sido cancelada
    When el usuario registra un nuevo pago
    Then la BaseDR debe ser <base_dr>

    Examples:
      | saldo_original | nc_aplicada | base_dr |
      | 1000.00        | 200.00      | 1000.00 |
      | 1000.00        | 500.00      | 1000.00 |

  Scenario: Cálculo de BaseDR sin notas de crédito
    Given una factura sin notas de crédito tipo PEMEX asociadas
    When el usuario registra un pago
    Then el cálculo de la BaseDR debe realizarse conforme al comportamiento actual del sistema