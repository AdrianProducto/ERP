Feature: Tropicalizacion del reporte "Relaciones de ordenes de compra por proveedor" del modulo de inventarios

    Yo como usuario de la reporte Relaciones de ordenes de compra por proveedor del modulo de inventarios
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Relaciones de ordenes de compra por proveedor"

Scenario: Signo de Quetzales en columna "Monto Total"
    When el usuario genera el reporte
    And consulte la columna  "Monto Total"
    Then los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en total por proveedor
    When el usuario genera el reporte
    And consulte el total "TOTAL PROVEEDOR"
    Then el importe de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"
    
Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relaciones de ordenes de compra por proveedor" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Relaciones de ordenes de compra por proveedor" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Relaciones de ordenes de compra por proveedor" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relaciones de ordenes de compra por proveedor" del módulo de inventarios en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relaciones de ordenes de compra por proveedor" en el listado de reportes del modulo de inventarios.