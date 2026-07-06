Feature: Tropicalizacion del reporte "Diario de Material Transportado Detallado" del modulo de trafico

    Yo como usuario del reporte Diario de Material Transportado Detallado del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Diario de Material Transportado Detallado"

Scenario: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte la columna "Costo Total del Flete"
    Then los importes en quetzales de la columna se visualizan con el signo "Q"

Scenario: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte la columna "Costo de Flete Unitario "
    Then los importes en quetzales de la columna se visualizan con el signo "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el sistema exporta el reporte "Diario de Material Transportado Detallado" a Excel de manera automatica
  When el usuario abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Diario de Material Transportado Detallado" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Diario de Material Transportado Detallado" en el listado de reportes del modulo de trafico. 