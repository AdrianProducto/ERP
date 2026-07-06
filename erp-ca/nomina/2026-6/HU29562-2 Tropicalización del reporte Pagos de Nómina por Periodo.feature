Feature: Tropicalizacion del reporte "Pagos de Nómina por Periodo" del modulo de nominas

    Yo como usuario del reporte de Pagos de Nómina por Periodo del modulo de nominas
    Requiero que el reporte se encuentre adaptado al contexto del pais de guatemala 
    Para que el usuario se encuentre familiarizado con los registros que realizara

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte de Pagos de Nómina por Periodo del modulo de nominas

Scenario: Colocar signo de Quetzales en columna "Neto A Pagar"
    When el usuario genere el reporte
    And consulte la columna "Neto A Pagar" 
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

Scenario Outline: Colocar signo de Quetzales en totales
    When el usuario genere el reporte
    And consulte los <Totales> del reporte
    Then los importes en quetzales de los totales se visualizan con el signo "Q"

    Example:
    | Totales        |
    | TOTAL X DEPTO. |
    | TOTAL          |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Pagos de Nómina por Periodo" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Pagos de Nómina por Periodo" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Pagos de Nómina por Periodo" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Pagos de Nómina por Periodo" del módulo de nomina en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Pagos de Nómina por Periodo" en el listado de reportes del modulo de nomina. 