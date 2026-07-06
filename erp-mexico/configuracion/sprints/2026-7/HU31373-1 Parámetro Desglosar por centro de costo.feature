Feature: Parámetro Desglosar por centro de costo
  Como usuario del sistema, 
  Quiero activar la opción "Desglosar por centro de costo" en la utilería de exportación a QuickBooks, 
  Para que los archivos generados reflejen la distribución de gastos por centro de costo.

  Scenario: Nuevo parametro Desglosar por centro de costo
    Given el usuario ha iniciado sesión en el sistema
    And cuenta con centro de costos activos
    When entre en la utileria Exportar Quickbooks
    Then el sistema debe mostrar el parametro “Desglosar por centro de costo”
    And el parametro se encuenta desactivado por Default

  Scenario: Activar el parámetro y exportar con distribución 
    Given el usuario se encuentra en la utilería 01 - Exportar QuickBooks del modulo Configuración
    And existen registros con distribución de centro de costo 
    When activa el parámetro "Desglosar por centro de costo" 
    And genera el archivo 
    Then el archivo presenta una fila por cada distribución de centro de costo 
    
  Scenario: Registro sin distribución cuando el parámetro está activo 
    Given el parámetro "Desglosar por centro de costo" está activo 
    And existe un registro sin distribución asignada 
    When se genera el archivo 
    Then el registro se exporta en su nivel estándar
  
  Scenario: Generar archivo con parámetro inactivo 
    Given el parámetro "Desglosar por centro de costo" está inactivo 
    When el usuario genera el archivo 
    Then el archivo se genera igual que antes del cambio