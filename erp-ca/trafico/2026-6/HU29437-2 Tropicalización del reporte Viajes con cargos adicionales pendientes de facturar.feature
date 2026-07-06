Feature: Tropicalizacion del reporte "Viajes con cargos adicionales pendientes de facturar" del modulo de trafico

    Yo como usuario del reporte Viajes con cargos adicionales pendientes de facturar del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Viajes con cargos adicionales pendientes de facturar"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda                           |
    | Importes convertidos a Quetzales |
    | Importes convertidos a Dólares   |
    | Importes en su moneda            |

Scenario: Lectura de moneda quetzales en columnas de moneda
    When el usuario genere el reporte
    Then en las columnas "Moneda" debe de verse la moneda "Quetzales" en los registros realizados con dicha moneda

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: 
    | OpcionMoneda                     | ColumnaImporte |
    | Importes convertidos a Quetzales | Importe        |
    | Importes en su moneda            | IVA            |
    |                                  | Retención      |
    |                                  | Total          |

Scenario Outline: Cambio de nombre al gran total en moneda nacional
    When El usuario genere el reporte con la <OpcionMoneda>
    Then el gran total "TOTAL X CLIENTE PESOS" ahora debe llamarse "TOTAL X CLIENTE QUETZALES"

    Example: 
    | OpcionMoneda                     |
    | Importes convertidos a Quetzales |
    | Importes en su moneda            |

Scenario Outline: Signo de quetzales en el gran total en moneda nacional del reporte
    When el usuario genere el reporte con la <OpcionMoneda>
    And Consulte el gran total en quetzales al final del reporte
    Then los importes del gran total "TOTAL X CLIENTE QUETZALES" se visualizan con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda                     |
    | Importes convertidos a Quetzales |
    | Importes en su moneda            |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Viajes con cargos adicionales pendientes de facturar" a Excel con la opcion "Exportar XLS" o "Exportar en XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Viajes con cargos adicionales pendientes de facturar" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Viajes con cargos adicionales pendientes de facturar" en el listado de reportes del modulo de trafico