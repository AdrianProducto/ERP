Feature: Tropicalizacion del reporte de relacion de anticipos del modulo de trafico.

    Yo como usuario del reporte de relacion de anticipos del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala
And  genera el reporte "Detallado de viajes"

Scenario: Mostrar signo de quetzales en columnas de importes nacionales.
    When el usuario visualice la columna "Importe" con importe nacional
    Then el sistema debe de mostrar los importes de la columna con el signo de quetzales "Q".
    And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: Mostrar signo de quetzales en los totales del reporte.
    When el usuario visualice los siguientes totales:
    |Totales        |
    |Total Operador |
    |Total General  |
    Then el sistema debe de mostrar los importes de los totales con el signo de quetzales "Q".
    And el proceso debe conservar su funcionamiento actual sin afectaciones


Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relacion de anticipos" a Excel
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Relacion de anticipos" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Relacion de anticipos" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relacion de anticipos" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$"
  And el reporte en PDF debe de seguir mostrando la etiqueta "RFC" en el encabezado
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relacion de anticipos" en el listado de reportes del modulo de trafico.