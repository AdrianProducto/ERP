Feature: Tropicalizacion de la reporte "Análisis Gastos Comparativo Por Centro De Costos" del modulo de contabilidad

    Yo como usuario del reporte Análisis Gastos Comparativo Por Centro De Costos del modulo de contabilidad
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa a la reporte "Análisis Gastos Comparativo Por Centro De Costos"

Scenario Outline: Signo de Quetzales en columnas con importes en moneda quetzal
    When el usuario genere el reporte con la <OpcionAnalisis>
    And consulte las columnas correspondientes a los centros de costos que se incluyeron en el reporte
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo de quetzales "Q"

    Example: 
    | OpcionAnalisis |
    | Gastos         |
    | Ingresos       |

Scenario Outline: Signo de Quetzale en columna total
    When el usuario genere el reporte con la <OpcionAnalisis>
    And consulte la columna "Total"
    Then los importes de los registros realizados en quetzales con el signo de quetzales "Q"

    Example: 
    | OpcionAnalisis |
    | Gastos         |
    | Ingresos       |

Scenario: Signo de Quetzale en total del reporte
    When el usuario genere el reporte con la opcion de analisis "Gastos"
    And consulte el total "TOTAL DE EGRESOS"
    Then los importes de los registros realizados en quetzales con el signo de quetzales "Q"

Scenario: Signo de Quetzale en total del reporte
    When el usuario genere el reporte con la opcion de analisis "ingresos"
    And consulte el total "TOTAL DE INGRESOS"
    Then los importes de los registros realizados en quetzales con el signo de quetzales "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Análisis Gastos Comparativo Por Centro De Costos" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el sistema  exporta el reporte "Análisis Gastos Comparativo Por Centro De Costos" a Excel 
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Análisis Gastos Comparativo Por Centro De Costos" del módulo de contabilidad en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Análisis Gastos Comparativo Por Centro De Costos" en el listado de reportes del modulo de contabilidad.