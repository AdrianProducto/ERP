Feature:  Tropicalizacion del reporte "Auxiliar de descuentos por operador"
    Yo como usuario del reporte Auxiliar de descuentos por operador del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala y genera el reporte "Auxiliar de descuentos por operador"

Scenario: Soportar moneda Quetzales en el reporte de Auxiliar de descuentos por operador.
    When el usuario visualice el reporte generado
    Then el reporte debe soportar la moneda "Quetzales"
    And los importes nacionales deben mostrarse en quetzales.

Scenario: Mostrar signo de quetzales en columnas de importes.
    When el usuario visualice las siguientes columnas:
    |Columnas con importes |
    |Importe descantado    |
    |Saldo                 |
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".

Scenario: Mostrar signo de quetzales en los totales del reporte.
    When el usuario visualice los totales por tipo de descuento
    Then el sistema debe de mostrar los importes de los totales con el signo de quetzales "Q".

Scenario: Cambiar etiqueta "RFC" a "NIT" en encabezado del reporte.
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Auxiliar de descuentos por operador" a Excel con la opcion "Exportar XLS"
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
  Given que el usuario accede al reporte "Auxiliar de descuentos por operador" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$"
  And la etiqueta fiscal debe mostrarse como "RFC" en el encabezado del reporte.

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Auxiliar de descuentos por operador" en el listado de reportes del modulo de trafico.