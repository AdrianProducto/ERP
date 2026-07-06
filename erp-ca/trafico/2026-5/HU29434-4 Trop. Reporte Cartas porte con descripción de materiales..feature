Feature: Tropicalizacion del reporte "Cartas porte con descripción de materiales." del modulo de trafico

    Yo como usuario del reporte Cartas porte con descripción de materiales. del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Cartas porte con descripción de materiales."

Scenario: Mostrar opción de importe convertido a Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a Dolares" e "Mostrar en ambos"

Scenario Outline: Cambio a la columna RFC
    When el usuario genere el reporte en <FormatoReporte> 
    Then la columna "RFC" ahora debe verse como "NIT"

    Example:
    | FormatoReporte |
    | PDF            |
    | Excel          |
    | Ambos          |

Scenario Outline: Cambio a la columna Tarifa Pesos
    When el usuario genere el reporte en <FormatoReporte> 
    Then la columna "Tarifa Pesos" ahora debe verse como "Tarifa Quetzales"

    Example:
    | FormatoReporte |
    | PDF            |
    | Excel          |
    | Ambos          |

Scenario Outline: Cambio a la columna Importe Pesos
    When el usuario genere el reporte en <FormatoReporte> 
    Then la columna "Importe Pesos" ahora debe verse como "Importe Quetzales"

    Example:
    | FormatoReporte |
    | PDF            |
    | Excel          |
    | Ambos          |

Scenario Outline: Lectura de moneda Quetzal en columna moneda
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la opcion "Mostrar en ambos"
    Then la columna "Moneda" muestra el dato "Quetzales" en los registros realizados en moneda quetzales

    Example:
    | FormatoReporte |
    | PDF            |
    | Excel          |
    | Ambos          |

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    Example:
    | FormatoReporte | OpcionMoneda                  | ColumnasConImporte |
    | PDF            | Importes convertidos a Pesos  | Tarifa Quetzales   |
    | Excel          | Mostrar en ambos              | Importe Quetzales  |
    | Ambos          |                               |                    |

Scenario Outline: Signo de Quetzale en columnas con importes del filtro "Mostrar IVA"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    And selecciona el check "Mostrar IVA" de la seccion "Otras opciones"
    And consulte la columna "IVA"
    Then la columna muestra los importes de los registros realizados en quetzales con el signo "Q"

    Example:
    | FormatoReporte | OpcionMoneda                  | 
    | PDF            | Importes convertidos a Pesos  | 
    | Excel          | Mostrar en ambos              | 
    | Ambos          |                               |

Scenario Outline: Signo de Quetzale en columnas con importes del filtro "Mostrar Retención"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    And selecciona el check "Mostrar Retención" de la seccion "Otras opciones"
    And consulte la columna "Retención"
    Then la columna muestra los importes de los registros realizados en quetzales con el signo "Q"

    Example:
    | FormatoReporte | OpcionMoneda                  | 
    | PDF            | Importes convertidos a Pesos  | 
    | Excel          | Mostrar en ambos              | 
    | Ambos          |                               |

Scenario Outline: Signo de Quetzale en columnas con importes del filtro "Mostrar Total de Factura"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    And selecciona el check "Mostrar Total de Factura" de la seccion "Otras opciones"
    And consulte la columna "Total Factura"
    Then la columna muestra los importes de los registros realizados en quetzales con el signo "Q"

    Example:
    | FormatoReporte | OpcionMoneda                  | 
    | PDF            | Importes convertidos a Pesos  | 
    | Excel          | Mostrar en ambos              | 
    | Ambos          |                               |

Scenario: Cambio de nombre al check "Mostrar RFC Cliente"
    When el usuario se encuentre en la seccion "Otras opciones"
    Then la opcion "Mostrar RFC Cliente" debe verse como "Mostrar NIT Cliente"

Scenario Outline: Cambio a columna  "RFC Cliente" con opcion "Mostrar NIT Cliente"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la opcion "Mostrar NIT Cliente"
    Then la columna "RFC Cliente" debe verse como "NIT Cliente"

    Example:
    | FormatoReporte |
    | PDF            |
    | Excel          |
    | Ambos          |

Scenario Outline: Cambio de etiqueta "Total Tarifa Pesos"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    Then El gran total "Total Tarifa pesos" debe verse como "Total Tarifa Quetzales"

    Example:
    | FormatoReporte | OpcionMoneda                     |
    | PDF            | Importes convertidos a quetzales |
    | Excel          | Importes convertidos a quetzales |
    | Ambos          |                                  |

Scenario Outline: Cambio de etiqueta "Total Importe Pesos"
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    Then El gran total "Total Importe Pesos" debe verse como "Total Importe Quetzales"

    Example:
    | FormatoReporte | OpcionMoneda                     |
    | PDF            | Importes convertidos a quetzales |
    | Excel          | Importes convertidos a quetzales |
    | Ambos          |                                  |

Scenario: Colocar signo de quetzales en grandes totales del reporte
    When el usuario genere el reporte en <FormatoReporte> 
    And seleccione la <OpcionMoneda>
    Then los importes de los grandes totales "Total Importe Quetzales" y "Total Tarifa Quetzales" se visualizan con signo de quetzales "Q"

    Example:
    | FormatoReporte | OpcionMoneda                     |
    | PDF            | Importes convertidos a quetzales |
    | Excel          | Importes convertidos a quetzales |
    | Ambos          |                                  |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Cartas porte con descripción de materiales" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Cartas porte con descripción de materiales" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Cartas porte con descripción de materiales" en el listado de reportes del modulo de trafico.