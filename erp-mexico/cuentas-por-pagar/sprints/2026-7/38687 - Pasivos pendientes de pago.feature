Feature: Tolerancia de redondeo en pagos de pasivos
  Como usuario de cuentas por pagar
  Quiero que el sistema ajuste automáticamente el monto ingresado al registrar un pago
  Para que el pasivo quede liquidado sin necesidad de solicitar se realiza el ajuste por base de datos

  Background:
    Given que existe un pasivo de proveedor con saldo real de "$150.2605"
    And el sistema muestra el saldo redondeado a 2 decimales "$150.26"

  Scenario: Ajuste automático al registrar el pago final con diferencia menor a $0.01
    Given que el pasivo no tiene abonos previos
    When el usuario ingresa el monto "$150.26" como pago total
    Then el sistema debe ajustar internamente el monto a "$150.2605"
    And el pasivo debe quedar registrado como "Pagado"
      | campo              | valor     |
      | monto ingresado    | 150.26    |
      | monto aplicado     | 150.2605  |
      | diferencia ajuste  | 0.0005    |

  Scenario: Ajuste automático al registrar el último abono con diferencia menor a $0.01
    Given que el pasivo tiene abonos previos por "$100.00"
    And el saldo pendiente real es "$50.2605"
    And el sistema muestra el saldo pendiente como "$50.26"
    When el usuario ingresa el monto "$50.26" como pago
    Then el sistema debe ajustar internamente el monto a "$50.2605"
    And el pasivo debe quedar registrado como "Pagado"
      | campo              | valor    |
      | monto ingresado    | 50.26    |
      | monto aplicado     | 50.2605  |
      | diferencia ajuste  | 0.0005   |

  Scenario: Sin ajuste cuando el abono es parcial y el saldo residual es mayor a $0.01
    Given que el pasivo no tiene abonos previos
    When el usuario ingresa el monto "$100.00" como abono parcial
    Then el sistema NO debe aplicar ajuste por tolerancia
    And el saldo pendiente debe quedar en "$50.2605"
    And el pasivo debe quedar en estatus "Pendiente"

  Scenario: Sin ajuste cuando la diferencia es igual o mayor a $0.01
    Given que el pasivo no tiene abonos previos
    When el usuario ingresa el monto "$150.20" como pago total
    Then el sistema NO debe aplicar ajuste por tolerancia
    And el saldo pendiente debe quedar en "$0.0605"
    And el pasivo debe quedar en estatus "Pendiente"

  Scenario: Sin ajuste cuando el monto ingresado supera el saldo real
    Given que el pasivo no tiene abonos previos
    When el usuario ingresa el monto "$160.00" como pago
    Then el sistema NO debe aplicar ajuste
    