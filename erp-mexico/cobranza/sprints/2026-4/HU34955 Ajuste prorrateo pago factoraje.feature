Feature: Ajuste de prorrateo en pagos por factoraje
  Como usuario de cobranza
  Necesito que al registrar un pago por factoraje la suma del monto prorrateado entre las facturas seleccionadas sea exactamente igual al monto del concepto de compensación
  Para evitar inconsistencias en el XML del pago y asegurar la integridad de la información financiera

  Rule: Ajustar diferencia positiva distribuyendo centavos
    Cuando la suma del prorrateo es menor al monto de compensación,
    el sistema debe incrementar el prorrateo en 0.01 centavos hasta igualar el monto.
    Y debe disminuir el importe del pago en 0.01 de las facturas afectadas en el recalculo del prorrateo

    Scenario: Distribución de diferencia positiva
      Given un pago de 11136.00
      And un monto de compensación de 3201.23
      And las siguientes facturas seleccionadas:
        | Factura | Saldo   | Importe_a_pagar | Compensacion | 
        | FA01    | 3712.00 | 2644.93         | 1067.07      |
        | FA02    | 3712.00 | 2644.93         | 1067.07      |
        | FA03    | 3712.00 | 2644.93         | 1067.07      |
      And la suma del prorrateo es 3201.21
      When el usuario guarda el pago
      Then el sistema distribuye la diferencia de 0.02 agregando 0.01 a las facturas en orden secuencial
      And disminuye 0.01 al importe a pagar de cada factura afectada
      And el resultado final es:
        | Factura | Saldo   | Importe_a_pagar | Compensacion | 
        | FA01    | 3712.00 | 2644.92         | 1067.08      |
        | FA02    | 3712.00 | 2644.92         | 1067.08      |
        | FA03    | 3712.00 | 2644.93         | 1067.07      |
      And la suma final es igual a 3201.23

  Rule: Ajustar diferencia negativa distribuyendo centavos
    Cuando la suma del prorrateo es mayor al monto de compensación,
    el sistema debe disminuir el prorrateo en 0.01 centavos hasta igualar el monto.
    Y debe aumentar el importe del pago en 0.01 de las facturas afectadas en el recalculo del prorrateo

    Scenario: Distribución de diferencia negativa
      Given un pago de 12000.00
      And un monto de compensación de 4589.29
      And las siguientes facturas seleccionadas:
        | Factura | Saldo   | Importe_a_pagar | Compensacion |
        | FA01    | 2000.00 | 1235.11         | 764.89       |
        | FA02    | 2000.00 | 1235.11         | 764.89       |
        | FA03    | 2000.00 | 1235.11         | 764.89       |
        | FA04    | 2000.00 | 1235.11         | 764.89       |
        | FA05    | 2000.00 | 1235.11         | 764.89       |
        | FA06    | 2000.00 | 1235.11         | 764.89       |
      And la suma del prorrateo es 4589.34
      When el usuario guarda el pago
      Then el sistema distribuye la diferencia de 0.05 restando 0.01 a las facturas en orden secuencial
      And aumenta 0.01 al importe a pagar de cada factura afectada
      And el resultado final es:
        | Factura | Saldo   | Importe_a_pagar | Compensacion |
        | FA01    | 2000.00 | 1235.12         | 764.88       |
        | FA02    | 2000.00 | 1235.12         | 764.88       |
        | FA03    | 2000.00 | 1235.12         | 764.88       |
        | FA04    | 2000.00 | 1235.12         | 764.88       |
        | FA05    | 2000.00 | 1235.12         | 764.88       |
        | FA06    | 2000.00 | 1235.11         | 764.89       | 
      And la suma final es igual a 4589.29
      
  Background:
    Given que el parámetro "Distribución libre de factoraje" del modulo de cobranza se encuentra inactivo
    And existen facturas seleccionadas con saldo disponible

  Scenario Outline: Ajustar prorrateo según tipo de diferencia
    Given un monto de compensación de <compensacion>
    And <numero_facturas> facturas seleccionadas
    And un prorrateo inicial total de <total_prorrateo>
    And una diferencia de <diferencia>
    When el usuario intenta guardar el pago
    Then el sistema realiza un ajuste de tipo <tipo_ajuste> de 0.01 a la compensacion de cada factura de forma secuencial
    And realiza un ajuste tipo <ajuste_pago> de 0.01 al importe a pagar de cada factura afectada
    And la suma final del prorrateo debe ser igual a <compensacion>

    Examples:
      | compensacion | numero_facturas | total_prorrateo | diferencia | tipo_ajuste | ajuste_pago |
      | 3201.23      | 3               | 3201.21         | 0.02       | suma        | resta       |
      | 4589.29      | 6               | 4589.34         | 0.05       | resta       | suma        |
      | 100.01       | 2               | 100.00          | 0.01       | suma        | resta       |

  Scenario Outline: Validar que el prorrateo coincide exactamente con la compensación
    Given un monto de compensación de <compensacion> 
    And un prorrateo cuya suma es igual a <total_prorrateo> 
    When el usuario intenta guardar el pago
    And la suma del prorrateo es igual a la compensación
    Then el sistema permite guardar el pago sin ajustes

    Examples:
        | compensacion | total_prorrateo | 
        | 1000.00      | 1000.00         | 
        | 2563.01      | 2563.01         |
        | 1558.99      | 1558.99         |

  Scenario Outline: Validar que la suma de la compensación y total a pagar coincidan con el saldo de la factura
    Given una factura con un saldo de <saldo>
    And un monto de compensación de <compensacion> 
    And un monto a pagar de <Importe_a_pagar>
    When el usuario intenta guardar el pago
    And la suma de la compensacion y el total a pagar es igual al saldo
    Then el sistema permite guardar el pago sin ajustes

    Examples:
        | saldo   | compensacion | Importe_a_pagar | 
        | 2050.00 | 1000.00      | 1050.00         | 
        | 5000.00 | 2563.01      | 2436.99         |
        | 3645.00 | 1558.99      | 2086.01         |

  Scenario Outline: Distribución cíclica cuando la diferencia excede el número de facturas  
    Given un monto de compensación de <compensacion>
    And <numero_facturas> facturas seleccionadas
    And una diferencia total de <diferencia>
    When el usuario intenta guardar el pago
    Then el sistema distribuye la diferencia en ciclos de 0.01 por factura
    And realiza un ajuste 0.01 al importe a pagar de cada factura afectada
    And realiza <vueltas> vueltas completas hasta que la diferencia sea 0
    And la suma final coincide con el monto de compensación

    Examples:
      | compensacion | numero_facturas | diferencia | vueltas |
      | 1000.10      | 5               | 0.10       | 2       |
      | 500.15       | 3               | 0.15       | 5       |
      | 200.06       | 2               | 0.06       | 3       |

  Scenario Outline: Recalcular prorrateo al modificar facturas
    Given un monto de compensación de <compensacion>
    And <numero_facturas> facturas seleccionadas
    When el usuario agrega o elimina <nuevo_numero_facturas> facturas
    Then el sistema recalcula el prorrateo automáticamente
    And valida que la suma coincida con la compensación antes de guardar

    Examples:
        | compensacion | numero_facturas | nuevo_numero_facturas |
        | 1000.00      | 15              | 17                    | 
        | 2563.01      | 9               | 8                     |

  Scenario: No aplicar ajuste cuando el parámetro está activo
    Given que el parámetro "Distribución libre de factoraje" se encuentra activo
    And existe una diferencia entre el prorrateo y la compensación
    When el usuario intenta guardar el pago por factoraje
    Then el sistema no realiza ajustes automáticos
    And permite continuar según la configuración establecida