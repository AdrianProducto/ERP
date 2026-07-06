Feature: Tropicalizacion del reporte "Detallado de flotilla" del modulo de informes gerenciales

    Yo como usuario del reporte Detallado de flotilla del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Detallado de flotilla"

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    #Algunas de las columnas del reporte son dinamicas, es decir que el nombre de las columnas puede variar dependiendo los filtros seleccionados   
    Examples:
    | ColumnasConImporte            |
    | Facturación                   |
    | Partes de órdenes de servicio |
    | VIATICOS                      |
    | DIESEL A CREDITO              |

Scenario: Signo de Quetzales en total del reporte
    When el usuario genera el reporte
    And consulte el total "TOTALES" del reporte
    Then Los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: Signo de Quetzales en total general
    When el usuario genera el reporte
    And consulte el total "TOTALES GENERALES" del reporte
    Then Los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Detallado de flotilla" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Detallado de flotilla" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Detallado de flotilla" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Detallado de flotilla" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Detallado de flotilla" en el listado de reportes del modulo de informes gerenciales.