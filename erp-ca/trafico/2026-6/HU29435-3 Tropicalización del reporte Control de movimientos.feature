Feature: Tropicalizacion del reporte "Control de movimientos" del modulo de trafico

    Yo como usuario del reporte Control de movimientos del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Control de movimientos"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda    |
    | Quetzales |
    | Dolares   |
    | Ambos     |

Scenario Outline: Cambio de nombre al gran total en moneda nacional
    When El usuario genere el reporte con la <OpcionMoneda>
    Then el gran total "Total en pesos" ahora debe llamarse "Total en quetzales"

    Example: 
    | OpcionMoneda |
    | Quetzales    |
    | Ambos        |

Scenario Outline: Signo de quetzales en el gran total en moneda nacional del reporte
    When el usuario genere el reporte con la <OpcionMoneda>
    And Consulte el gran total en quetzales al final del reporte
    Then los importes del gran total "Total en quetzales" se visualizan con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda |
    | Quetzales    |
    | Ambos        |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Control de movimientos" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Control de movimientos" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Control de movimientos" a Excel
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Control de movimientos" a PDF
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Aplicar adecuaciones de moneda y etiquetas en el segundo plano del reporte
  When el reporte genera información en el segundo plano en el formato Excel y PDF por exceso de registros
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Control de movimientos" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Control de movimientos" en el listado de reportes del modulo de trafico.