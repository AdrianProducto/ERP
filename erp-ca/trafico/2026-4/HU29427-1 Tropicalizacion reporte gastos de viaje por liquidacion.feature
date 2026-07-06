Feature: Tropicalizacion del reporte "Gastos de viaje por liquidacion" del modulo de tráfico

    Yo como usuario del reporte de gastos de viaje por liquidacion del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realziadas en el pais de guatemala.

Background: Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala y genera el reporte "Gastos de viaje por liquidacion"

Scenario: Soportar moneda Quetzales en el reporte Gastos de viaje por liquidacion
  When el usuario genera el reporte
  Then el reporte debe soportar la moneda "Quetzales"
  And los importes nacionales deben mostrarse en quetzales

Scenario: Mostrar opción de moneda Quetzales en filtro de moneda
  When visualiza el filtro "Por moneda"
  Then debe mostrarse la opción "Quetzales" en lugar de "Pesos"
  And deben permanecer disponibles las opciones "Quetzales", "Dolares" y "Ambas"

Scenario: Mostrar signo de quetzales en columnas de importes.
    When el usuario visualice las siguientes columnas:
    |Columnas con importes|
    |Subtotal             |
    |IVA                  |
    |IEPS                 |
    |ISR                  |
    |Retencion IVA        |
    |Retenciones Locales  | 
    |Traslados Locales    |
    |Total                |
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".

Scenario: Mostrar signo de quetzales en grandes totales del reporte.
    When el usuario visualice los siguientes grandes totales del reporte:
    |Totales               |  
    |Total x concepto      |
    |Total por liquidacion |
    |Total general         |
    Then el sistema debe de mostrar los importes referentes a dinero de los grandes totales con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Gastos de viaje por liquidacion" a Excel
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Gastos de viaje por liquidacion" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Gastos de viaje por liquidacion" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC"

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Gastos de viaje por liquidacion" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el filtro "Por moneda" debe conservar la opción "Pesos"
  And los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF

  Scenario: El reporte es visible en base de datos de guatemala.
    Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
    When el usuario entre a una base de datos configurada con el pais de guatemala.
    Then el sistema debera de mostrar el reporte "Gastos de viaje por liquidacion" en el listado de reportes del modulo de trafico.


  

