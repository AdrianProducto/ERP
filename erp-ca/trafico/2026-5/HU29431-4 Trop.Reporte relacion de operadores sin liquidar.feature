Feature: Tropicalizacion del reporte "Relación de operadores sin liquidar" del modulo de trafico

    Yo como usuario del reporte Relación de operadores sin liquidar del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And genera el reporte "Relación de operadores sin liquidar"

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

    Example: 
    | ColumnaImporte                   |
    | Anticipos pendientes de liquidar |
    | Moneda Gastos sin Liquidar       |

Scenario: Colocar signo de quetzales en totales por operador
    When el usuario consulte el totales por operador
    Then los totales en moneda nacional se visualiza con signo de quetzales "Q"

Scenario: Colocar signo de quetzales en totales generales
    When el usuario consulte los totales generales
    Then los totales en moneda nacional se visualiza con signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relación de operadores sin liquidar" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Relación de operadores sin liquidar" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Relación de operadores sin liquidar" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relación de operadores sin liquidar" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa, en Excel y PDF
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relación de operadores sin liquidar" en el listado de reportes del modulo de trafico.