Feature: Tropicalizacion del reporte "Estado de Resultados por C. Costos y Unidad de Negocio" del modulo de contabilidad

    Yo como usuario de la reporte Estado de Resultados por C. Costos y Unidad de Negocio del modulo de contabilidad
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Estado de Resultados por C. Costos y Unidad de Negocio"

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte 
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Periodo            |
    | Acumulado          |

Scenario: Signo de quetzales en totales del reporte
    When el usuario genera el reporte
    And Consulte el <TotalSeccion>
    Then el importe en moneda nacional se visualizan con el signo de quetzales "Q"

    Example:
    | TotalSeccion                     |
    | Total Ingresos                   |
    | Total Ingresos                   |
    | Utilidad o Pérdida del Ejercicio |

Scenario: La sencibilidad de la columna "Periodo" funciona correctamente
    When el usuario ingrese al reporte "Reporte Auxiliar por Centro de Costos" desde la columna "Periodo"
    Then el reporte debe de mostrar los ajustes realizados en la HU29523-2

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Estado de Resultados por C. Costos y Unidad de Negocio" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Estado de Resultados por C. Costos y Unidad de Negocio" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Estado de Resultados por C. Costos y Unidad de Negocio" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Estado de Resultados por C. Costos y Unidad de Negocio" del módulo de contabilidad en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Estado de Resultados por C. Costos y Unidad de Negocio" en el listado de reportes del modulo de contabilidad.