Feature: Tropicalizacion del reporte "Reporte de operaciones" del modulo de trafico

    Yo como usuario del reporte de operaciones del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al "Reporte de operaciones"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda                      |
    | Ambas (Quetzales y Dolares) |
    | Quetzales                   |
    | Dolares                     |

Scenario: Funcionamiento del filtro "Moneda" en reportes
  When el usuario aplica el filtro "Moneda"
  Then los siguientes reportes deben de mostrar la informacion correspondiente a la moneda seleccionada:
    | Reportes   |
    | Clientes   |
    | Operadores |
    | Unidades   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <Opcion moneda>
    When genere alguno de los siguientes reportes:
    | Reportes |
    | Clientes |
    | Unidades |
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        | Opcion moneda             | titulo                                                                                                               |
        | Ambas Quetzales y Dolares | Reporte de operaciones realizadas por cliente, fecha de viaje del 01/0..........Moneda Del Viaje Quetzales y Dólares |
        | Quetzales                 | Reporte de operaciones por Unidades, fecha de viaje del 01/04..........Moneda Del Viaje Quetzales                    |
        | Dolares                   | Reporte de operaciones realizadas por cliente, fecha de viaje del 01/0..........Moneda Del Viaje Dolares             |

Scenario Outline: Lectura de moneda Quetzal en columna "Moneda"
    When el usuario genere el <Reporte>
    And consulte la columna "Moneda"
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

    Example: 
    |Reporte    |
    |Clientes   |
    |Operadores |
    |Unidades   |

Scenario Outline: Signo de Quetzale en columna "importe"
    When el usuario genere el <Reporte>
    And consulte la columna "Importe"
    Then la columna muestra los importes realizados en quetzales con el signo "Q"

    Example: 
    |Reporte |
    |Clientes|
    |Unidades|

Scenario: Cambio a la columna "Importe Pesos"
    When el usuario genere el reporte de "Operadores"
    And consulte la seccion de importes
    Then la columna "Importe Pesos" debe se llamarse "Importe Quetzales"

Scenario: signo de quetzales en columna "Importe Quetzales"
    When el usuario genere el reporte "Operadores"
    And consulte la columna "Importe Quetzales"
    Then los importes correspondientes a quetzales deberan de verse con el signo de quetzales "Q"

Scenario: signo de quetzales en columna "Importe Total"
    When el usuario genere el reporte "Clientes"
    And consulte la columna "Importe Total"
    Then los importes correspondientes a quetzales deberan de verse con el signo de quetzales "Q"

Scenario Outline: Cambio en nombre de grandes totales del reporte "Unidades"
    When el usuario genere el reporte de "unidades"
    And seleccione la <Opcion> en el filtro de moneda
    And consulte los grandes totales del reporte
    Then el gran total "TOTAL X UNIDAD PESOS" ahora se muestra como "TOTAL X UNIDAD QUETZALES"
    And los importes deben de estar con el signo de quetzales "Q"

    Example:
    |Opcion                      |
    |Ambas (Quetzales y Dolares) |
    |Quetzales                   |

Scenario: Cambio en nombre de gran total "Totales" en reporte "Operadores"
    When el usuario genere el reporte de "Operadores"
    And consulte el gran total "Totales" del reporte
    Then el importe correspondiente al total de la columna "Importe Quetzales" se visualiza con el signo de quetzales "Q"
    And los importes deben de estar con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el <Reporte> a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    |Reporte    | formulas    |
    |Clientes   | Autosuma    |
    |Operadores | Multiplicar |
    |Unidades   | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el "Reporte de operaciones" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el "Reporte de operaciones" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en los formatos PDF y Excel
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al "Reporte de operaciones" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Reporte de operaciones" en el listado de reportes del modulo de trafico.    