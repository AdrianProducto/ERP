Feature: Tropicalizacion del reporte "Detallado de viajes" del modulo de trafico.

    Yo como usuario del reporte detallado de viajes del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala
And  genera el reporte "Detallado de viajes"

Scenario: Cambio de nombre al filtro "Mostrar subtotal en pesos"
When el usuario consulta la seccion "Otras opciones"
Then el check "Mostrar subtotal en pesos" debe mostrarse como "Mostrar subtotal en Quetzales"
And la funcionalidad del check debe de continuar la misma logica, pero realizar la conversion a quetzales.

Scenario Outline: Mostrar signo de quetzales en columnas de importes nacionales.
    When el usuario visualice las <Columnas> con importer nacionales
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".

    Example:
    |Columnas         |
    |Importe diesel   |
    |Casetas efectivo |
    |Anticipos        | 
    |Extra            | 
    |FLETE            |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Detallado de viajes" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano
  Then las adecuaciones de moneda aplicadas en el reporte principal deben reflejarse también en el segundo plano
  And los importes nacionales deben mostrarse con el signo "Q"

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Detallado de viajes" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$"

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Detallado de viajes" en el listado de reportes del modulo de trafico.