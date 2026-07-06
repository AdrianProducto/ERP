Feature: Tropicalizacion del reporte "Resumen de Ventas" del modulo de cobranza

    Yo como usuario del reporte Resumen de Ventas del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Resumen de Ventas"

Scenario: Signo de quetzales en importes nacionales de la seccion ventas diarias
    When el usuario genere el reporte
    And consulte los importes de la columna "M.N." de la seccion "Ventas nacionales"
    Then los importes se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en importes nacionales de la seccion Pendientes de facturar
    When el usuario genere el reporte
    And consulte los importes de la columna "M.N." de la seccion "Pendiente de facturar"
    Then los importes se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en importes nacionales de la seccion cartera
    When el usuario genere el reporte
    And consulte los importes de la columna "M.N." de la seccion "Cartera"
    Then los importes se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en importes nacionales de la seccion Recuperacion de cartera
    When el usuario genere el reporte
    And consulte los importes de la columna "M.N." de la seccion "Recuperacion de cartera"
    Then los importes se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en importes nacionales de la seccion Ventas
    When el usuario genere el reporte
    And consulte los importes de la columna "M.N." de la seccion "Ventas"
    Then los importes se visualizan con el signo de quetzales "Q"

Scenario: signo de quetzales en gran total del reporte
    When el usuario genere el reporte
    And consulte el "Total" del reporte
    Then los importes totales correspondientes a los importes nacionales se visualizan con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Resumen de Ventas" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Ajuste en reporte realizado manualmente
  Given que el reporte en excel fue realizado de manera manual
  When el usuario genere el reporte en formato excel
  Then el reporte debe de contar con la funcion generada previamente para una correcta implementacion de formulas en el formato excel

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Resumen de Ventas" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Resumen de Ventas" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Resumen de Ventas" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Resumen de Ventas" en el listado de reportes del modulo de cobranza.