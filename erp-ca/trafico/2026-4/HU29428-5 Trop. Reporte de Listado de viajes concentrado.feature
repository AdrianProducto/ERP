Feature: Tropicalizacion del reporte "Listado de viajes concentrado" del modulo de trafico

    Yo como usuario del reporte de Listado de viajes concentrado del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala
And  genera el reporte "Listado de viajes concentrado"

Scenario: Adaptar columna "Moneda" para lectura de quetzales
    When el usuario consulte la columna "Moneda"
    Then en la columna se debera de visualizar el dato "Quetzales" en los registros que corresponda dicho tipo de moneda
    And en el caso de moneda extranjera debe de continuar mostrando "Dolares"

Scenario Outline: Mostrar signo de quetzales en columnas de importes nacionales.
    When el usuario visualice las <Columnas> con importer nacionales
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".

    Example:
    |Columnas  |
    |Subtotal  |
    |iva       |
    |retencion |
    |total     |

Scenario: Cambio de etiqueta "Total x cliente pesos"
    When el usuario consulte los grandes totales del reporte
    Then el reporte debe mostrar el gran total "Total x cliente pesos" como "Total x cliente quetzales"
    And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: Mostrar signo de quetzales en los totales del reporte.
    When el usuario visualice el gran total "Total x cliente quetzales"
    Then el sistema debe de mostrar el importe del gran total con el signo de quetzales "Q".
    And el proceso debe conservar su funcionamiento actual sin afectaciones.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Listado de viajes concentrado" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And la columna "Moneda" debe de mostrar la moneda correcta.
  And el total general de moneda nacional debe de decir "Total x cliente quetzales"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Listado de viajes concentrado" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta
    And la columna "Moneda" debe de mostrar la moneda correcta.
    And el total general de moneda nacional debe de decir "Total x cliente quetzales"
    And la columna "Moneda" debe de mostrar la moneda correcta.

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Cartas porte a revision" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano
  Then las adecuaciones aplicadas en el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Listado de viajes concentrado" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel y PDF
  And la columna moneda debera de leer solo los datos Pesos y Dolares
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el gran total de moneda nacional debe de visualizarse como "Total x cliente pesos"
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Listado de viajes concentrado" en el listado de reportes del modulo de trafico.