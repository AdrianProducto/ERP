Feature: Tropicalizacion del reporte "Listado de movimientos bancarios" del modulo de bancos

    Yo como usuario del reporte Listado de movimientos bancarios del modulo de bancos
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Listado de movimientos bancarios"

Scenario: Cambio a la columna RFC
    When el usuario genere el reporte
    Then la columna "RFC" ahora debe verse como "NIT"

Scenario: Lectura de moneda Quetzal en columnas de moneda
    When el usuario genere el reporte
    And el usuario consulte la columna "Moneda"
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Listado de movimientos bancarios" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then La columna RFC debe verse como NIT
  And la columna de moneda debe de leer el tipo de moneda "Quetzales"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Listado de movimientos bancarios" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then La columna RFC debe verse como NIT
    And la columna de moneda debe de leer el tipo de moneda "Quetzales"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Listado de movimientos bancarios" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Listado de movimientos bancarios" del módulo de bancos en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa y en Excel
  And la columna moneda debe de mostrar solo informacion en pesos y dolares
  And la columna debe conservar el nombre de RFC
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Listado de movimientos bancarios" en el listado de reportes del modulo de bancos.