Feature: Tropicalizacion del reporte "Listado de Cheques por estatus" del modulo de bancos

    Yo como usuario del reporte Listado de Cheques por estatus del modulo de bancos
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Listado de Cheques por estatus"

Scenario: Lectura de moneda Quetzlaes en columna moneda
    When el usuario genere el reporte
    And consulte la columna moneda
    Then en el columna "Moneda" se visualiza el nomnbre de la moneda "Quetzales" en los registros realizados en la moneda nacional.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Listado de cheques" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then la columna de moneda debe de leer el tipo de moneda "Quetzales"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Listado de Cheques por estatus" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then la columna de moneda debe de leer el tipo de moneda "Quetzales"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Listado de Cheques por estatus" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Listado de Cheques por estatus" del módulo de bancos en una base de datos de México
  When genera el reporte
  Then la columna moneda debe de mostrar solo informacion en pesos y dolares
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Listado de Cheques por estatus" en el listado de reportes del modulo de bancos.