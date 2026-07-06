Feature: Tropicalizacion del reporte "Estado de Resultado por Unidad" del modulo de informes gerenciales

    Yo como usuario del reporte Estado de Resultado por Unidad del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Estado de Resultado por Unidad"

Scenario: Nueva opcion "Quetzales" en filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then en el combo aparecera la opcion "Quetzales" en lugar de pesos
    And en el combo se visualizaran solo las siguientes opciones:
    | Moneda    |
    | QUETZALES |
    | DOLARES   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        | OpcionMoneda | titulo                                                                                            |
        | QUETZALES    | Reporte Estado de Resultados Por unidad de Mayo 2026 a Mayo 2026 Convertido a la Moneda Quetzales |
        | DOLARES      | Reporte Estado de Resultados Por unidad de Mayo 2026 a Mayo 2026 Convertido a la Moneda Dolares   |

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Examples:
    | ColumnasConImporte |
    | Enero              |
    | Febrero            |
    | Marzo              |
    | Abril              |
    | Mayo               |

Scenario: Signo de quetzales en el total "Utilidad"
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte la utilidad de la unidad
    Then el importe de la utilidad se muestra con el signo de quetzales "Q"

Scenario: Signo de quetzales en el total "Utilidad de la Flota"
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte la Utilidad de la Flota
    Then el importe de la utilidad se muestra con el signo de quetzales "Q"

Scenario: Signo de quetzales en la seccion "Resumen Estado de Resultados"
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte los importes de la seccion "Resumen Estado de Resultados"
    Then los importes se muestran con el signo de quetzales "Q"

Scenario: Ajuste a la descripcion general de las condiciones del reporte
    Given que el usuario ingresa a la condiciones del reporte
    When consulte la descripcion general de las descripciones
    Then contara con la siguientes descripcion 
    "Este informe ofrece un análisis financiero de las unidades del mes de Mayo del 2026. Contiene ingresos por unidad, gastos de viaje, 
    mantenimiento y gastos indirectos. Los resultados obtenidos en el reporte se van a convertir a la moneda quetzales. También presenta la utilidad neta
    y categorías con porcentaje."

Scenario: Ajuste a la condicion "Ingresos por unidad"
    Given que el usuario ingresa a la condiciones del reporte
    When consulte la condicion "Ingresos por unidad"
    Then contara con la siguientes descripcion 
    "Son los subtotales de aquellos viajes/Trayectos, con fecha de salida en el mes seleccionado, que no estén cancelados y que la unidad asignada a
    cada Trayecto esté marcada en el filtro de unidades, este reporte debe cuadrar con el reporte de salidas diarias con importe #3,con los importes convertidos a quetzales."

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Estado de Resultado por Unidad" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Estado de Resultado por Unidad" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Estado de Resultado por Unidad" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Estado de Resultado por Unidad" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Estado de Resultado por Unidad" en el listado de reportes del modulo de informes gerenciales.