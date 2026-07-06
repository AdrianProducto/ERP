Feature: Agregar filtro de sucursal en utileria QuickBooks
  Como usuario
  Necesito filtrar los pagos de clientes por sucursal al exportar
  Para obtener únicamente los pagos de las sucursales que necesito

  Scenario: Visualizar filtro Sucursales
    Given el usuario se encuentra en la utilería Exportar Quickbooks
    When selecciona la opcion "Pagos de clientes / Receive payment" 
    Then el sistema muestra el filtro "Sucursal" 
    And muestra un listado con las sucursales activas 
    And por cada registro muestra su Descripción
    And cuenta con un indicador que al pasar el cursor muestra el mensaje:
      """
        Este filtro aplica para los registros Pasivos y Pago a clientes
      """ 

  Scenario: Seleccionar todas las sucursales 
    Given el filtro de sucursales está activo 
    When el usuario elige "Todas" 
    Then quedan marcados todas las sucursales activas
    
  Scenario: Filtrar por una o varias sucursales 
    Given el usuario seleccionó por lo menos una sucursal
    When solicita generar el archivo 
    Then el sistema únicamente contempla los registros pertenecientes a las sucursales especificadas
    And genera el archivo correspondiente

  Scenario: Validar selección de por lo menos una sucursal
    Given el usuario no selecciono por lo menos una sucursal
    When solicita generar el archivo
    Then el sistema presenta el mensaje:
      """
        Favor de marcar al menos una sucursal
      """
    And no genera el archivo
