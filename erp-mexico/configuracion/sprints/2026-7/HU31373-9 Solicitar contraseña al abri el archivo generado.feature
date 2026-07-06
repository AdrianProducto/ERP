Feature: Solicitar contraseña al abrir el archivo generado
  Como administrador
  Quiero que el archivo generado por la utilería requiera la contraseña de un usuario específico para abrirse
  Para proteger la información exportada

  Scenario: Nuevo parámetro en configuración de parametros generales del sistema
    Given el usuario se encuentra logueado en el sistema
    When solicita ingresar a los Parámetros generales del sistema
    Then el sistema presenta el formulario correspondiente
    And muestra el nuevo parámetro "Solicitar contraseña al Exportar QuickBooks"
    And al pasar el cursor sobre dicho parámetro se presenta el tooltip:
      """
        Al activar esta opción el sistema solicitara la contraseña especificada
        al momento de abrir el archivo generado desde la utileria Exportar QuickBooks.
      """
  
  Scenario: Activar parámetro 
    Given el administrador esta actualizando los parámetros generales
    When el administrador activa el parámetro "Solicitar contraseña al Exportar QuickBooks"
    Then el sistema habilita el campo "Contraseña" 
    And permite al usuario especificar la contraseña que debe solicitarse al abrir los archivos generados desde la utileria Exportar QuickBooks
    
    
  Scenario: Archivo solicita contraseña al abrirse 
    Given se tiene el parámetro activo 
    When se genera y abre el archivo exportado desde la utileria Exportar QuickBooks
    Then el sistema solicita la contraseña configurada 

  Scenario: Parámetro inactivo, el archivo abre sin contraseña 
    Given que no se tiene el parámetro activo 
    When se genera y abre el archivo desde la utileria Exportar QuickBooks
    Then el archivo se abre directamente sin solicitar contraseña