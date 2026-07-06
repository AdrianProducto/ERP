Feature: Tropicalizacion del reporte "Descargas de Combustible" del modulo de mantenimiento

    Yo como usuario del reporte Descargas de Combustible del modulo de mantenimiento
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Descargas de Combustible"

Scenario: Colocar signo de Quetzales en columna "Costo x Litro"
    When el usuario genere el reporte
    And consulte la columna "Costo x Litro"
    Then los importes en quetzales de la columna se visualizan con el signo "Q"

Scenario: Colocar signo de Quetzales en total "TOTAL DE INGRESOS"
    When el usuario genere el reporte
    And consulte el total "TOTAL DE INGRESOS"
    Then los importes en quetzales del total se visualizan con el signo "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Descargas de Combustible" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Descargas de Combustible" en formato Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Descargas de Combustible" del módulo de mantenimiento en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Descargas de Combustible" en el listado de reportes del modulo de mantenimiento.