Feature: Tropicalizacion del reporte "Ingresos por Operador Tabular" del modulo de trafico

    Yo como usuario del reporte Ingresos por Operador Tabular del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Ingresos por Operador Tabular"

Scenario: signo de quetzales en el filtro "T.C"
    When el usuario consulte el filtro de tipo cambio
    Then el tipo de cambio que se visualice dentro del filtro tendra signo de quetzales "Q"

Scenario: Mostrar opción de importe convertido a Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a Dolares" e "Importes en su moneda"

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario selecciono el <TipoReporte>
    And selecciono la <OpcionMoneda> en el filtro moneda
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | TipoReporte                   | OpcionMoneda | titulo                                                                                                             |
    | Reporte Detallado             | Quetzales    | Reporte Ingresos por Operador Tabular Detallado  Importes convertidos a Quetzales , con liquidaciones fiscales ... |
    | Reporte Acumulado             | Dolares      | Reporte Ingresos por Operador Tabular Acumulado  Importes convertidos a Dolares , con liquidaciones fiscales ...   |
    | Reporte Agrupado por operador |              |                                                                                                                    |

Scenario Outline: Lectura de moneda Quetzal en columna "Moneda"
    When el usuario genere el reporte <TipoReporte>
    Then la columna "Moneda" muestra el dato "Quetzales" en los registros realizados en moneda quetzales

    Example: 
    | TipoReporte       |
    | Reporte Detallado |
    | Reporte Acumulado |

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el <TipoReporte>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    #Algunas de las columnas son dinamicas, es decir, el nombre de las columnas con importes varia dependiendo los registros del sistema
    Examples: 
    | Reporte detallado             | ColumnasConImporte     |
    | Reporte acumulado             | Tipo de cambio         |
    | Reporte agrupado por operador | Sueldo operador        |
    |                               | Comision por viaje     |
    |                               | Estadia                |
    |                               | Comision por objetivos |

Scenario: Cambio a la etiqueta total "TOTAL OPERADOR PESOS"
    When el usuario genere el <TipoReporte>
    And seleccione la <OpcionMoneda>
    Then la etiqueta "TOTAL OPERADOR PESOS" debe de decir "TOTAL OPERADOR QUETZALES"
    And los importes deben de estar con el signo de quetzales "Q"


    Examples: 
    | TipoReporte                   | ColumnasConImporte           |
    | Reporte detallado             | Importes convertidos a Pesos |
    | Reporte acumulado             | Importes en su moneda        |
    | Reporte agrupado por operador |                              |

Scenario: Cambio a la etiqueta total "TOTAL GENERAL PESOS"
    When el usuario genere el <TipoReporte>
    And seleccione la <OpcionMoneda>
    Then la etiqueta "TOTAL GENERAL PESOS" debe de decir "TOTAL GENERAL QUETZALES"
    And los importes deben de estar con el signo de quetzales "Q"


    Examples: 
    | TipoReporte                   | ColumnasConImporte           |
    | Reporte detallado             | Importes convertidos a Pesos |
    | Reporte acumulado             | Importes en su moneda        |
    | Reporte agrupado por operador |                              |
    
Scenario Outline: Cambio a la etiqueta RFC
    When el usuario genere el <TipoReporte>
    Then la etiqueta "RFC" debe de decir "NIT"

    Example: 
    | TipoReporte                   |
    | Reporte detallado             |
    | Reporte acumulado             |
    | Reporte agrupado por operador |

Scenario Outline: Cambio a la etiqueta CURP
    When el usuario genere el <TipoReporte>
    Then la etiqueta "CURP" debe de decir "CUI"

    Example: 
    | TipoReporte                   |
    | Reporte detallado             |
    | Reporte acumulado             |
    | Reporte agrupado por operador |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Ingresos por Operador Tabular" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda e informacion fiscal
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Ingresos por Operador Tabular" en el listado de reportes del modulo de trafico.