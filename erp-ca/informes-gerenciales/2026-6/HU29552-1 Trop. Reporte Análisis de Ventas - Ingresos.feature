Feature: Tropicalizacion del reporte "Análisis de Ventas / Ingresos" del modulo de informes gerenciales

    Yo como usuario del reporte Análisis de Ventas / Ingresos del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Análisis de Ventas / Ingresos"

Scenario: Nueva opcion "Quetzales" en filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then en el combo aparecera la opcion "Quetzales" en lugar de pesos
    And en el combo se visualizaran solo las siguientes opciones:
    | Moneda    |
    | QUETZALES |
    | DOLARES   |

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte con la <OpcionReporte>
    And seleccione la moneda "Quetzales" en el filtro de moneda
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    #La mayor parte de las columnas del reporte son dinamicas, es decir que el nombre de las columnas puede variar dependiendo los filtros seleccionados   
    Examples:
        | OpcionReporte         | ColumnasConImporte |
        | FILTRAR POR MONEDA    | Totales de periodo |
        | CONVERTIR A LA MONEDA | Enero 2026         |
        |                       | Febrero 2026       |
        |                       | Enero 2025         |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Análisis de Ventas / Ingresos" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Análisis de Ventas / Ingresos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Análisis de Ventas / Ingresos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Análisis de Ventas / Ingresos" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Análisis de Ventas / Ingresos" en el listado de reportes del modulo de informes gerenciales.

