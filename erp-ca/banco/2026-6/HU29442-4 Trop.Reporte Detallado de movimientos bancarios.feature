Feature: Tropicalizacion del reporte "Detallado de movimientos bancarios" del modulo de bancos

    Yo como usuario del reporte Detallado de movimientos bancarios del modulo de bancos
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Detallado de movimientos bancarios"

Scenario: Lectura de moneda Quetzal en columnas de moneda
    When el usuario genere el reporte
    And el usuario consulte la columna "Moneda"
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

Scenario Outline: Signo de Quetzale en columnas con importes en moneda quetzal
    When el usuario genere el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo de quetzales "Q"

    Example:
    | ColumnasConImporte      |
    | Deposito                |
    | Retiro                  |
    | Saldo                   | 

Scenario: signo de quetzales en el total "TOTAL DEL MOVIMIENTO DE LA CUENTA"
    When el usuario genere el reporte
    And consulte el campo "TOTAL DEL MOVIMIENTO DE LA CUENTA"
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"

Scenario: signo de quetzales en el total "TOTALES"
    When el usuario genere el reporte
    And consulte el campo "TOTALES"
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"
    #Validar si el reporte esta mezclando en el total "Totales" importes en dolares y quetzales, de ser asi, omitir este escenario y no colocar signo.

Scenario: Cambio a la columna RFC
    When el usuario genere el reporte
    Then la columna "RFC" ahora debe verse como "NIT"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Detallado de movimientos bancarios" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Detallado de movimientos bancarios" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Detallado de movimientos bancarios" del módulo de bancos en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Detallado de movimientos bancarios" en el listado de reportes del modulo de bancos.