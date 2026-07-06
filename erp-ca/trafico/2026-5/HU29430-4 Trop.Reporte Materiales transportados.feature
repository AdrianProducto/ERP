Feature: Tropicalizacion del reporte "Materiales Transportados" del modulo de trafico

    Yo como usuario del reporte de Materiales Transportados del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And genera el reporte "Materiales Transportados"

Scenario Outline: Lectura de moneda Quetzal en columna "Moneda"
    When el usuario consulte la columna "Moneda"
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

Scenario: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte las siguientes columnas:
    | Columnas con importes |
    | Subtotal              |
    | IVA                   |
    | Retencion             |
    | Total                 |
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

Scenario: Cambio de nombre a la etiqueta "TOTAL X CLIENTE PESOS"
    When el usuario genere el reporte
    Then el gran total "TOTAL X CLIENTE PESOS" debe decir "TOTAL X CLIENTE QUETZALES"

Scenario: Cambio de nombre a la etiqueta "GRAN TOTAL PESOS"
    When el usuario genere el reporte
    Then el gran total "GRAN TOTAL PESOS" debe decir "GRAN TOTAL QUETZALES"

Scenario Outline: Colocar signo de quetzales en gran total por cliente
    When el usuario consulte el gran total "TOTAL X CLIENTE QUETZALES"
    Then el importe del gran total se mira con el signo de quetzales "Q"

Scenario Outline: Colocar signo de quetzales en gran total del reporte
    When el usuario consulte el gran total "GRAN TOTAL QUETZALES"
    Then el importe del gran total se mira con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Materiales Transportados" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And la columna moneda debe de leer el tipo de moneda "Quetzales"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Materiales Transportados" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta
    And la columna moneda debe de leer el tipo de moneda "Quetzales"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Materiales Transportados" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Materiales Transportados" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa, en Excel y PDF
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And la columna moneda debe de mostrar solo informacion en pesos y dolares
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Materiales Transportados" en el listado de reportes del modulo de trafico.