Feature: Adecuaciones a columnas en apartado Vendor credits
  Como usuario
  Necesito que cada pago en Vendor Credits se exporte en un solo renglón con el centro de costo correcto
  Para evitar duplicados y facilitar la importación en QuickBooks

  Scenario: Generar un renglón por pago fusionando la información 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And un pago genera dos renglones actualmente 
    When se exporta el archivo 
    Then se genera un solo renglón con datos del primer renglón 
    And las columnas M, W y X toman los valores del segundo renglón    

  Scenario: Una fila por distribución general cuando el parámetro está activo
    Given el parámetro "Desglosar por centro de costo" está activo 
    And el pasivo relacionado a la nota de crédito tiene distribución general en CC001 y CC002 
    When el usuario genera el archivo
    Then el sistema carga dos filas para esa nota de credito, una por cada CC 
    And realiza el prorrateo del importe de la nota de crédito de manera proporcional de acuerdo a la distribución realizada
    And la columna Expense Class de cada fila muestra el CC correspondiente 

  Scenario: Una fila por distribución por concepto cuando el parámetro está activo 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And el pasivo relacionado a la nota de crédito tiene distribución a nivel concepto en CC001 y CC002 
    When el usuario genera el archivo
    Then el sistema carga una fila por cada CC y concepto para esa nota de credito
    And realiza el prorrateo del importe de la nota de crédito de manera proporcional de acuerdo a la distribución realizada
    And la columna Expense Class de cada fila muestra el CC correspondiente 
  
  Scenario: Pasivo sin distribución se exporta a nivel nota de crédito 
    Given el parámetro está activo 
    And el pasivo relacionado a la nota de credito no tiene distribución de CC 
    When el usuario solicita generar el archivo 
    Then el sistema crea una sola fila para la nota de crédito sin valor en Expense Class

  Scenario: Prorrateo con distribución por CC a nivel concepto por porcentaje
    Given una factura de $1,000 con conceptos:
      | concepto | monto | CC001 | CC002 | CC003 |
      | FLETE    | $600  | 70%   | 30%   |       |
      | REPARTOS | $400  | 50%   |       | 50%   |
    And se registra una pago con documento por $500 
    When se genera el archivo con desglose por CC 
    Then el sistema realiza el prorrateo proporcional del importe de la nota de crédito de acuerdo a los porcentajes correspondientes:
      | concepto | CC001   | CC002  | CC003   |
      | FLETE    | $210.00 | $90.00 |         |
      | REPARTOS | $100.00 |        | $100.00 |

  Scenario: Prorrateo con distribución por CC a nivel concepto por monto
    Given una factura de $1,000 con conceptos:
      | concepto | monto | CC001 | CC002 | CC003 |
      | FLETE    | $600  | $100  | $500  |       |
      | REPARTOS | $400  | $200  |       | $200  |
    And se registra una pago con documento por $500 
    When se genera el archivo con desglose por CC 
    Then el sistema realiza el prorrateo proporcional del importe de la nota de crédito de acuerdo a los porcentajes correspondientes:
      | concepto | CC001   | CC002   | CC003   |
      | FLETE    | $50.01  | $249.99 |         |
      | REPARTOS | $100.00 |         | $100.00 |
 
  Scenario: Redondeo a 2 decimales sin pérdida de centavos 
    Given el prorrateo genera fracciones en los importes 
    When se genera el archivo 
    Then todos los importes están redondeados a 2 decimales 
    And la suma de los montos prorrateados es igual al monto original