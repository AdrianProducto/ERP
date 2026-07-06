Feature: Tropicalizacion del reporte "Cobranza por antigüedad" del modulo de cobranza

    Yo como usuario del reporte Cobranza por antigüedad del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Cobranza por antigüedad"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda    |
    | Quetzales |
    | Dolares   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda | titulo                                                     |
    | Quetzales    | Reporte Cobranza por antigüedad en quetzales al 07/05/2026 |
    | Dólares      | Reporte Cobranza por antigüedad en dolares al 07/05/2026   |

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la moneda "Quetzales"
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: ejemplo de algunas columnas que se pueden encontrar en el reporte que contienen importes
    | ColumnaImporte |
    | 15 Días        |
    | 30 Días        |
    | 45 Días        |
    | +60 Días       |
    | Tipo de cambio |

Scenario: Signo de quetzales en total por cliente
    When el usuario genere el reporte con la moneda "Quetzales"
    And consulte el total por cliente
    Then los importes en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en gran total
    When el usuario genere el reporte con la moneda "Quetzales"
    And consulte el gran total
    Then los importes en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario Outline: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el usuario selecciona el <TipoReporte> en el filtro "Tipo de reporte"
    And el sistema exporta el reporte "Cobranza por antigüedad" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

    Examples:
    | TipoReporte |
    | PDF         |
    | AMBOS       |

Scenario Outline: Aplicar ajustes en exportación a Excel
    Given que el usuario selecciona el <TipoReporte> en el filtro "Tipo de reporte"
    And el sistema exporta el reporte de manera automatica a Excel
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
    And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel y tipos de reportes con los que se detona el escenario
    | TipoReporte | formulas    |
    | EXCEL       | Autosuma    |
    | AMBOS       | Multiplicar |
    |             | Promedio    |

Scenario: Aplicar adecuaciones de moneda y etiquetas en el segundo plano del reporte
  When el reporte genera información en el segundo plano en el formato Excel y PDF por exceso de registros
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Cobranza por antigüedad" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Cobranza por antigüedad" en el listado de reportes del modulo de cobranza.