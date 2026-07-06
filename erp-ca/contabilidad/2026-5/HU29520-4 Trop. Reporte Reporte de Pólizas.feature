Feature: Tropicalizacion del reporte "Reporte de Pólizas" del modulo de contabilidad

    Yo como usuario del reporte Reporte de Pólizas del modulo de contabilidad
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Reporte de Pólizas"

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genera el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Cargos             |
    | Abonos             |

Scenario: Signo de Quetzale en total "Total Póliza:"
    When el usuario genera el reporte
    And consulte el total "Total Póliza"
    Then el importe en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: Signo de Quetzale en total "Total al [Fecha]"
    When el usuario genera el reporte
    And consulte el total "Total al [Fecha]"
    Then el importe en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: Signo de Quetzale en total "Total General"
    When el usuario genera el reporte
    And consulte el total "Total General"
    Then el importe en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Reporte de Pólizas" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Reporte de Pólizas" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Reporte de Pólizas" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en los formatos PDF y Excel
  Then las adecuaciones de moneda aplicadas en el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Reporte de Pólizas" del módulo de contabilidad en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Reporte de Pólizas" en el listado de reportes del modulo de contabilidad.