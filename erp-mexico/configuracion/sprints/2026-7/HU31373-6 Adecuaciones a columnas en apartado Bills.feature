Feature: Adecuaciones a columnas en apartado Bills
  Como usuario
  Necesito que los pasivos se desglosen por centro de costo en el archivo de Bills y que la columna Expense Class lo refleje
  Para importar la información contable correctamente en QuickBooks.

  Scenario: Una fila por distribución cuando el parámetro está activo 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And un pasivo tiene distribución en CC001 y CC002 
    When el usuario genera el archivo
    Then el sistema carga dos filas para ese pasivo, una por cada CC 
    And la columna Expense Class de cada fila muestra el CC correspondiente 
  
  Scenario: Pasivo sin distribución se exporta a nivel pasivo 
    Given el parámetro está activo 
    And el pasivo no tiene distribución de CC 
    When el usuario solicita generar el archivo 
    Then el sistema crea una sola fila para ese pasivo sin valor en Expense Class