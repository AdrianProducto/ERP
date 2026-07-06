Feature: Mostrar solo ID del centro de costo
  Como usuario de contabilidad
  Necesito que al utilizar la utileria Exportar Quickbooks con distribución de centros de costos
  Solo se cargue el ID del centro de costo
  Para evitar errores al cargar el archivo en Quickbooks

  Background: 
    Given el usuario se enuentra dentro de la utileria 01 - Exportar Quickbooks
    And el parámetro "Desglosar por centro de costo" está activo 

  Scenario: Mostrar ID centro de costo en Facturación/Invoice
    Given una factura tiene distribución de gastos
    When el usuario genera el archivo
    Then el sistema crea una fila por cada CC sobre los que esta distribuida la factura
    And la columna AN - Product/Service Class de cada fila muestra el ID del CC correspondiente

  Scenario: Mostrar ID centro de costo en Pasivos/Bill
    Given un pasivo tiene distribución de gastos
    When el usuario genera el archivo
    Then el sistema carga una fila por cada CC sobre los que esta distribuido el pasivo
    And la columna Expense Class de cada fila muestra el ID del CC correspondiente 

  Scenario: Mostrar ID centro de costo en Notas de crédito proveedores/Vendor credits
    Given el pasivo relacionado a la nota de crédito tiene distribución de gastos
    When el usuario genera el archivo
    Then el sistema carga una fila por cada CC sobre los que esta distribuido el pasivo
    And realiza el prorrateo del importe de la nota de crédito de manera proporcional de acuerdo a la distribución realizada
    And la columna S - Expense Class de cada fila muestra el ID del CC correspondiente 

  Scenario: Mostrar ID centro de costo en Notas de crédito clientes/Memo credits
    Given la factura relacionado a la nota de crédito tiene distribución de gastos
    When el usuario genera el archivo
    Then el sistema carga una fila por cada CC sobre los que esta distribuida la factura
    And realiza el prorrateo del importe de la nota de crédito de manera proporcional de acuerdo a la distribución realizada
    And la columna Y - Product/Service Class de cada fila muestra el ID del CC correspondiente 

