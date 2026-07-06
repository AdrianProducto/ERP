Feature: Tropicalizacion del reporte "Cartas Porte con Materiales Detallado" del modulo de trafico

    Yo como usuario del reporte Cartas Porte con Materiales Detallado del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Cartas Porte con Materiales Detallado"

Scenario: Colocar signo de Quetzales en los importes nacionales
    When el usuario genere el reporte
    And consulte la columna "Tarifa"
    Then los importes en moneda nacional de la columna se visualizan con el signo de quetzales "Q"

Scenario: Colocar signo de Quetzales en gran total "Total Tarifa"
    When el usuario genere el reporte
    And consulte el gran total "Total Tarifa"
    Then el importe en moneda nacional se visualiza con el signo de quetzales "Q"

Scenario: Colocar signo de Quetzales en los importes nacionales con filtro "Mostrar Importe"
    When el usuario genere el reporte con el filtro "Mostrar Importe" seleccionado
    And consulte la columna "Importe"
    Then los importes en moneda nacional de la columna se visualizan con el signo de quetzales "Q"

Scenario: Colocar signo de Quetzales en gran total "Total Importe"
    When el usuario genere el reporte con el filtro "Mostrar Importe" seleccionado
    And consulte el gran total "Total Importe"
    Then el importe en moneda nacional se visualiza con el signo de quetzales "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Cartas Porte con Materiales Detallado" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Cartas Porte con Materiales Detallado" a Excel
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genere información en el segundo plano en PDF y Excel
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Cartas Porte con Materiales Detallado" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Cartas Porte con Materiales Detallado" en el listado de reportes del modulo de trafico