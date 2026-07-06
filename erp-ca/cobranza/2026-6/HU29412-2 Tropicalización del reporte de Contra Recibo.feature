Feature: Tropicalizacion del reporte "Reporte de Contra Recibo" del modulo de cobranza

    Yo como usuario del reporte Reporte de Contra Recibo del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Reporte de Contra Recibo"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda    |
    | AMBAS     |
    | QUETZALES |
    | DOLARES   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda | titulo                                                                                                                       |
    | AMBAS        | Reporte de Contra Recibo del 01/04/2026 al 07/05/2026 desde el Cliente 000001 hasta el Cliente 265425 En Quetzales y Dólares |
    | QUETZALES    | Reporte de Contra Recibo del 01/04/2026 al 07/05/2026 desde el Cliente 000001 hasta el Cliente 265425 En Quetzales           |
    | DOLARES      | Reporte de Contra Recibo del 01/04/2026 al 07/05/2026 desde el Cliente 000001 hasta el Cliente 265425 En Dólares             |

Scenario: Lectura de moneda quetzales en columna de moneda
    When el usuario genere el reporte
    Then en la columna "Moneda" debe de verse la moneda "Quetzales" en los registros realizados con dicha moneda

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: ejemplo de algunas columnas que se pueden encontrar en el reporte que contienen importes
    | OpcionMoneda | ColumnaImporte  |
    | QUETZALES    | SubTotal        |
    | AMBAS        | IVA             |
    |              | Retención       |
    |              | Total           |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Reporte de Contra Recibo" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Reporte de Contra Recibo" en formato Excel con la opcion "Descargar Excel"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Reporte de Contra Recibo" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Reporte de Contra Recibo" en el listado de reportes del modulo de cobranza.