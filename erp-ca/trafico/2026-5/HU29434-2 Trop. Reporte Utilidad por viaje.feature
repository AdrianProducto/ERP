Feature: Tropicalizacion del reporte "Utilidad por viaje" del modulo de trafico

    Yo como usuario del reporte Utilidad por viaje del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Utilidad por viaje"

Scenario: Mostrar opción de importe convertido a Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a Dolares" e "Importes en su moneda"

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario selecciono la <OpcionMoneda> en el filtro moneda
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda                     | titulo                                                                                                          |
    | Importes convertidos a quetzales | Reporte Utilidades por Viaje del 01/04/2026 al 20/04/2026 por viajes, todos e importes convertidos a Quetzales. |
    | Importes convertidos a Dolares   | Reporte Utilidades por Viaje del 01/04/2026 al 20/04/2026 por viajes, todos e importes convertidos a dólares.   |
    | Importes en su moneda            | Reporte Utilidades por Viaje del 01/04/2026 al 20/04/2026 por viajes, todos e importes en su moneda.            |

Scenario Outline: Lectura de moneda Quetzal en columna moneda
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    Then la columna "Moneda" muestra el dato "Quetzales" en los registros realizados en moneda quetzales
    Examples:
    |FormatoReporte| OpcionMoneda                     |
    |PDF           | Importes convertidos a quetzales |
    |Excel         | Importes en su moneda            |
    |Ambos         |                                  |

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    Examples: 
    |FormatoReporte| OpcionMoneda                     | ColumnasConImporte |
    |PDF           | Importes convertidos a quetzales | Tipo Cambio        |
    |Excel         | Importes en su moneda            | Ingresos           |
    |Ambos         |                                  | Egresos            |
    |              |                                  | Utilidad           |
    |              |                                  | Ingresos/Kms       |

Scenario: Cambio a la etiqueta total "TOTALES PESOS"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    Then la etiqueta "TOTALES PESOS" debe de decir "TOTALES QUETZALES"
    And los importes deben de estar con el signo de quetzales "Q"

    Examples: 
    |FormatoReporte | OpcionMoneda                     |
    | PDF           | Importes convertidos a quetzales |
    | Excel         | Importes en su moneda            |
    | Ambos         |                                  |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Utilidad por viaje" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en el formato Excel y PDF
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Utilidad por viaje" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Utilidad por viaje" en el listado de reportes del modulo de trafico.