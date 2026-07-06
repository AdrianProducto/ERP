Feature: Tropicalizacion del reporte "Saldos Bancarios" del modulo de bancos

    Yo como usuario del reporte Saldos Bancarios del modulo de bancos
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Saldos Bancarios"

Scenario Outline: Signo de Quetzale en columnas con importes en moneda quetzal
    When el usuario genere el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo de quetzales "Q"

    Example:
    | ColumnasConImporte      |
    | Deposito                |
    | Retiro                  |
    | Saldo                   |    

Scenario: signo de quetzales en el campo "Saldo Anterior"
    When el usuario genere el reporte
    And consulte el campo "Saldo Anterior"
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"

Scenario: signo de quetzales en el campo "SALDO AL FINAL DEL DIA PROYECTADO"
    When el usuario genere el reporte
    And consulte el campo "SALDO AL FINAL DEL DIA PROYECTADO"
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"

Scenario: signo de quetzales en el campo "SALDO AL FINAL DEL DIA REAL"
    When el usuario genere el reporte
    And consulte el campo "SALDO AL FINAL DEL DIA REAL"
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"

Scenario: signo de quetzales en el campo "TOTAL DEL MOVIMIENTO DE LA CUENTA"
    When el usuario genere el reporte
    And consulte el campo "TOTAL DEL MOVIMIENTO DE LA CUENTA"
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"

Scenario: Lectura de moneda Quetzal en columnas de moneda
    When el usuario genere el reporte con la opcion "Agregar Resumen de Saldos"
    And el usuario consulte la columna "Moneda"
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

Scenario Outline: Signo de Quetzale en columnas con importes en moneda quetzal con opcion "Agregar Resumen de Saldos" activa
    When el usuario genere el reporte con la opcion "Agregar Resumen de Saldos"
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo de quetzales"Q"

    Example:
    | ColumnasConImporte      |
    | Saldo Anterior          |
    | Saldo Proyectado        |
    | Total Cheques Retenidos |
    | Saldo Real              |

Scenario: Cambio en nombre de gran total "Saldo Real en Pesos"
    When el usuario genere el reporte con la opcion "Agregar Resumen de Saldos"
    And consulte los grandes totales del reporte
    Then el el gran total "Saldo Real en Pesos" se debe de ver como "Saldo Real en Quetzales"

Scenario: signo de quetzales en el campo "Saldo Real en Quetzales"
    When el usuario genere el reporte con la opcion "Agregar Resumen de Saldos"
    And consulte el total "Saldo Real en Quetzales"
    Then el importe se muestra con el signo de quetzales "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Saldos Bancarios" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Saldos Bancarios" a PDF con la opcion "Exportar PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Saldos Bancarios" a PDF con la opcion "Exportar PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en segundo plano 
  Then los cambios solicitados en los escenarios anteriores deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Saldos Bancarios" del módulo de bancos en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Saldos Bancarios" en el listado de reportes del modulo de bancos.