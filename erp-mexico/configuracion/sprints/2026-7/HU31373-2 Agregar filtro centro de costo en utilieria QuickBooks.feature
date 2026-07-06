Feature: Agregar filtro centro de costo en utileria Quickbooks
  Como usuario 
  Necesito filtrar la exportación de Notas de crédito proveedores y clientes por centros de costo específicos
  Para obtener solo los registros que me interesan

  Scenario: Visualizar filtro Centro de costos
    Given el usuario se encuentra en la utilería Exportar Quickbooks
    And cuenta con centro de costos activos
    When selecciona alguna de las siguientes opciones:
      | Notas de crédito proveedores / Vendor Credits |
      | Notas de crédito clientes / Credit Memos      |
    Then el sistema muestra el filtro "Centro de costos" 
    And se encuentra deshabilitado por defualt 
    And cuenta con un indicador que al pasar el cursor muestra el mensaje:
      """
        Este filtro aplica para los registros Notas de crédito proveedores y Notas de crédito clientes
      """

  Scenario: Visualizar centros de costo activos con código y descripción 
    Given el usuario se encuentra en la utilería Exportar Quickbooks
    And selecciona alguna de las siguientes opciones:
      | Notas de crédito proveedores / Vendor Credits |
      | Notas de crédito clientes / Credit Memos      |
    When habilita el filtro "Centro de costos" 
    Then el sistema muestra un listado con los centros de costo activos 
    And por cada registro muestra los datos:
      | Código      |
      | Descripción | 
    
  Scenario: Seleccionar todos los centros de costo a la vez 
    Given el filtro de centros de costo está habilitado 
    When el usuario elige la opción "Seleccionar todos" 
    Then quedan marcados todos los centros de costo activos 
    
  Scenario: Exportar con filtro aplicado solo devuelve registros del CC seleccionado 
    Given el filtro Centro de costos está habilitado 
    And el usuario seleccionó por lo menos centro de costo 
    When solicita generar el archivo 
    Then el sistema únicamente contempla los registros con distribución sobre los centros de costos especificados
    And genera el archivo correspondiente

  Scenario: Validar selección de por lo menos un CC
    Given el filtro Centro de costos está habilitado 
    And el usuario no selecciono por lo menos un centro de costo
    When solicita generar el archivo
    Then el sistema presenta el mensaje:
      """
        Favor de marcar al menos un centro de costo
      """
    And no genera el archivo
    
  Scenario: Exportar sin filtro CC habilitado
    Given el filtro Centro de costos está deshabilitado 
    When el usuario solicita generar el archivo 
    Then el sistema exporta todos los registros sin restricción por CC
