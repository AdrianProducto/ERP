Feature: Tropicalizacion del reporte "Balance General a 12 periodos" del modulo de contabilidad

    Yo como usuario de la reporte Balance General a 12 periodos del modulo de contabilidad
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Balance General a 12 periodos"

Scenario: Nueva opcion "Quetzales" en filtro moneda
    When el usuario consulte el filtro "Moneda"
    Then en el combo aparecera la opcion "Quetzales" en lugar de pesos
    And en el combo se visualizaran solo las siguientes opciones:
    | Moneda    |
    | QUETZALES |
    | DOLARES   |

Scenario: Signo de quetzales en el filtro tipo de cambio
    When el usuario consulte el campo "Tipo de cambio"
    Then el importe que se visualiza en el campo debe de tener el signo de quetzales "Q"

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genera el reporte con la opcion "Quetzales" en el filtro moneda
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Enero              |
    | Febrero            |
    | Marzo              |
    | Fin Ejercicio      |

Scenario: Signo de quetzales en totales del reporte
    When el usuario genera el reporte con la opcion "Quetzales" en el filtro moneda
    And Consulte el <TotalSeccion>
    Then el importe en moneda nacional se visualizan con el signo de quetzales "Q"

    Example:
    | TotalSeccion                      |
    | TOTAL ACTIVO ACTIVO A CORTO PLAZO |
    | TOTAL ACTIVO ACTIVO A LARGO PLAZO |
    | SUMA DEL ACTIVO                   |
    | TOTAL PASIVO PASIVO A CORTO PLAZO |
    | TOTAL PASIVO PASIVO A LARGO PLAZO |
    | SUMA DEL PASIVO                   |
    | TOTAL CAPITAL CONTABLE            |
    | UTILIDAD O PÉRDIDA DEL EJERCICIO  |
    | SUMA CAPITAL                      |
    | SUMA DEL PASIVO Y CAPITAL         |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Balance General a 12 periodos" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Balance General a 12 periodos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Balance General a 12 periodos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Balance General a 12 periodos" del módulo de contabilidad en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Balance General a 12 periodos" en el listado de reportes del modulo de contabilidad.