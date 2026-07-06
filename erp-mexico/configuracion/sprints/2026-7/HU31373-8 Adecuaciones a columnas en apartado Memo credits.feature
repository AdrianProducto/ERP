Feature: Adecuaciones a columnas en apartado Credits Memos
  Como usuario
  Necesito que las notas de crédito se desglosen por la distribución de CC de la factura relacionada y que los conceptos duplicados se agrupen
  Para una importación limpia en QuickBooks

  Scenario: Una fila por distribución por concepto cuando el parámetro está activo 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And la factura relacionado a la nota de crédito tiene distribución a nivel concepto en CC001 y CC002 
    When el usuario genera el archivo
    Then el sistema carga una fila por cada CC y concepto para esa nota de credito
    And realiza el prorrateo del importe de la nota de crédito de manera proporcional de acuerdo a la distribución realizada
    And la columna Product/Service Class de cada fila muestra el CC correspondiente 

  Scenario: Prorrateo con distribución por CC a nivel concepto
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
    
  Scenario: Exportar por concepto con agrupación 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And está aplicada a más de una factura con conceptos repetidos 
    When se genera el archivo 
    Then el sistema agrupa los conceptos repetidos con el mismo centro de costo en un solo renglón por concepto-centro de costo
    

