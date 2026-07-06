Feature: Tropicalizacion del reporte "Facilidades" del modulo de contabilidad

    Yo como usuario de la reporte Facilidades del modulo de contabilidad
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Facilidades"

Scenario: Signo de Quetzales en columna "Total"
    When el usuario genera el reporte 
    And consulte la columna "Total"
    Then la columna muestra los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Facilidades" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Facilidades" del módulo de contabilidad en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Facilidades" en el listado de reportes del modulo de contabilidad.