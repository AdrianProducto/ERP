Feature: Tropicalizacion del reporte "Cartas porte general" del modulo de trafico

    Yo como usuario del reporte Cartas porte general del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Cartas porte general"

Scenario: Mostrar opción de importe convertido a Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a Dolares" e "Importes en su moneda"

Scenario Outline: Lectura de moneda Quetzal en columna moneda
    When el usuario genere el reporte con <OpcionMoneda>
    Then la columna "Moneda" muestra el dato "Quetzales" en los registros realizados en moneda quetzales
    Example:
    | OpcionMoneda                     |
    | Importes convertidos a quetzales |
    | Importes en su moneda            |

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere reporte con <OpcionMoneda>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    #Algunas de las columnas son dinamicas, es decir, el nombre de las columnas con importes varia dependiendo los registros del sistema
    Examples: 
    | Importes convertidos a quetzales | ColumnasConImporte |
    | Importes en su moneda            | FLETE              |
    |                                  | REPARTOS           |
    |                                  | Sub Total          |
    |                                  | IVA                |
    |                                  | Retencion          |

Scenario: Cambio a la etiqueta total "TOTAL PESOS"
    When el usuario genere el reporte con <OpcionMoneda>
    Then la etiqueta "TOTAL PESOS" debe de decir "TOTAL QUETZALES"
    And los importes deben de estar con el signo de quetzales "Q"


    Examples: 
    | OpcionMoneda                     |
    | Importes convertidos a quetzales |
    | Importes en su moneda            |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Cartas porte general" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Cartas porte general" en el listado de reportes del modulo de trafico.