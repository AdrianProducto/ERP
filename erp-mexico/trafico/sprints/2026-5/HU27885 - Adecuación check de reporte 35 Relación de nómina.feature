Feature: Impresión de detalle de gastos en PDF en reporte #35 Relación de Nómina

  Como usuario de Tráfico
  Quiero que al activar el check "Ver detalle en Gastos" en el reporte #35 
  que se incluya el desglose de gastos por trayecto en la impresión en formato PDF

  Background:
    Given que existen liquidaciones con trayectos registrados
    And los trayectos cuentan con gastos asociados
    And el usuario accede al reporte #35 Relación de Nómina

  Scenario: Visualización de detalle de gastos en pantalla
    Given el usuario activa el check "Ver detalle en Gastos"
    When consulta el reporte
    Then se muestra el desglose de gastos por cada trayecto
    And cada gasto incluye Concepto, Viaje, Comprobante, Subtotal, IVA y Total

  Scenario: Impresión en PDF con detalle de gastos
    Given el usuario activa el check "Ver detalle en Gastos"
    And consulta el reporte con información disponible
    When presiona el botón "Imprimir PDF"
    Then se genera un archivo en formato PDF
    And el PDF incluye la información de liquidaciones, trayectos y gastos
    And se agrega una fila de "Detallado de gastos" debajo de "Total Percepciones"
    And cada gasto incluye las filas:
      | Concepto | Viaje | Comprobante | Subtotal | IVA | Total |
    And se muestra el detalle de gastos por cada trayecto que tenga gastos asociados

  Scenario: Impresión en formato HTML desde nuevo botón
    Given el usuario consulta el reporte
    When presiona el botón "Imprimir HTML"
    Then se genera la impresión en formato HTML con la funcionalidad actual

  Scenario: Reubicación de funcionalidad de impresión HTML
    Given que existe un botón de impresión actual en formato HTML
    When se implementa la nueva funcionalidad
    Then la impresión en formato HTML se mueve al botón "Imprimir HTML"
    And el botón "Imprimir PDF" genera únicamente archivos PDF