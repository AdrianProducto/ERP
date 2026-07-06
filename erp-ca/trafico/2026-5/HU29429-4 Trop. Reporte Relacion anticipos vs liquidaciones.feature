Feature: Tropicalizacion del reporte "Relación De Anticipos vs Gastos Por Liquidación" del modulo de trafico

    Yo como usuario del reporte Relación De Anticipos vs Gastos Por Liquidación del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Relación De Anticipos vs Gastos Por Liquidación"

Scenario: Colocar signo de quetzales en importes nacionales de totales
    When el usuario genere el reporte
    And  consulte los siguientes totales:
    |Totales                  |
    |TOTAL DE ANTICIPOS X LIQ |
    |TOTAL DE GASTOS X LIQ    |
    |DIFERENCIA X LIQ         |
    Then los importes de los totales se visualizan con el signo de quetzales "Q"

Scenario: Colocar signo de quetzales en importes nacionales de grandes totales
    When el usuario genere el reporte
    And  consulte los siguientes grandes totales:
    |GrandesTotales         |
    |GRAN TOTAL DE ANTICIPO |
    |GRAN TOTAL DE GASTOS	|			
    |DIFERENCIA GLOBAL      |
    Then los importes de los totales se visualizan con el signo de quetzales "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en encabezado del reporte
    When el usuario consulte el encabezado del reporte
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relación De Anticipos vs Gastos Por Liquidación" a Excel con la opcion "EXCEL"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en los formatos PDF y Excels
  Then las adecuaciones de moneda aplicadas en el reporte deben reflejarse en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relación De Anticipos vs Gastos Por Liquidación" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel y PDF
  And la etiqueta fiscal debe mostrarse como "RFC" en el encabezado del reporte

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Relación De Anticipos vs Gastos Por Liquidación" en el listado de reportes del modulo de trafico.

