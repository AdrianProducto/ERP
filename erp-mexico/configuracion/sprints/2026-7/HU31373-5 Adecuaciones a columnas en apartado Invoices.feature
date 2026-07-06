Feature: Adecuaciones a columnas en apartado Invoices
  Como usuario
  Quiero que el archivo de Invoices muestre el número de viaje del cliente, la ruta o conceptos según el tipo de factura, y el centro de costo por distribución
  Para que QuickBooks reciba información completa y clasificada

  Scenario: Columna AG renombrada a P.O Number con No. Viaje Cliente 
    Given el usuario genera el archivo desde la utileria QuickBooks
    And se encuentra activa la opción "Mostrar No. Viaje Cliente en columna AG y nombre de columna como P.O. Number"
    When el sistema esta exportando la informacion del apartado Invoices 
    Then la columna AG se llama "P.O Number" 
    And contiene el número de viaje del cliente relacionado a la factura 
    
  Scenario: Columna AR renombrada a Sales Rep con No. Viaje GM 
    Given el usuario genera el archivo desde la utileria QuickBooks
    And se encuentra activa la opción "Mostrar Número de viaje en columna AR y nombre de columna como Sales Rep"
    When el sistema esta exportando la informacion del apartado Invoices 
    Then la columna AR se llama "Sales Rep" 
    And contiene el número de viaje generado en GM para esa factura 
    
  Scenario: Columna X muestra ruta si la factura es POR VIAJE 
    Given el usuario genera el archivo desde la utileria QuickBooks
    And se encuentra activa la opción "Mostrar Ruta/Conceptos en columna X "
    When el sistema esta exportando la informacion del apartado Invoices
    And la factura es de tipo POR VIAJE 
    Then la columna X  muestra la ruta del viaje 
    
  Scenario: Columna X muestra conceptos si la factura es POR CONCEPTO 
    Given el usuario genera el archivo desde la utileria QuickBooks
    And se encuentra activa la opción "Mostrar Ruta/Conceptos en columna X "
    When el sistema esta exportando la informacion del apartado Invoices
    And la factura es de tipo POR CONCEPTO 
    Then la columna X muestra los conceptos incluidos en la factura 

  Scenario: Una fila por distribución cuando el parámetro está activo 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And una factura tiene distribución en CC001 y CC002 
    When el usuario genera el archivo
    Then el sistema crea dos filas para esa factura, una por cada CC 
    And la columna Product/Service Class de cada fila muestra el CC correspondiente 
  
  Scenario: Factura sin distribución se exporta a nivel concepto
    Given el parámetro está activo 
    And la factura no tiene distribución de CC 
    When el usuario solicita generar el archivo 
    Then el sistema crea una fila por cada concepto incluido en la factura
    And deja sin valor la columna Product/Service Class
    
