Feature: Tropicalizacion del reporte "Comparativo de Venta Mensual por Clientes" del modulo de trafico

    Yo como usuario del reporte Comparativo de Venta Mensual por Clientes del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Comparativo de Venta Mensual por Clientes"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones:
    | Moneda    |
    | Quetzales |
    | Dolares   |

Scenario: Funcionamiento del filtro "Moneda" con nueva moneda Quetzales
  When el usuario selecciona la nueva moneda "Quetzles" en el filtro "Moneda"
  And seleccione la opcion "Filtrar por moneda" en el filtro "Condiciones"
  Then el reporte debera de mostrar registros realizados en la moneda quetzales

Scenario: Funcionamiento del filtro "Moneda" con nueva moneda Quetzales
  When el usuario selecciona la nueva moneda "Quetzles" en el filtro "Moneda"
  And seleccione la opcion "Convertir a la moneda" en el filtro "Condiciones"
  Then el reporte debera de mostrar registros convertidos en la moneda quetzales

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario selecciono la <OpcionMoneda>
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        | OpcionMoneda | titulo                                                                                |
        | Quetzales    | Reporte Comparativo de Venta Mensual por Clientes Abril de 2026 filtrado en Quetzales |
        | Dolares      | Reporte Comparativo de Venta Mensual por Clientes Abril de 2026 filtrado en Dólares   |

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte con la opcion "Quetzales"
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    #Las columnas son dinamicas, es decir, el nombre de las columnas con importes varia dependiendo los filtros seleccionados
    Example: 
    | ColumnasConImporte                       |
    | Marzo 2026                               |
    | Abril 2026                               |
    | Diferencia entre Abril 2026 y Marzo 2026 |
    | Diferencia entre Abril 2026 y Abril 2025 |
    | Acumulado 2026                           |

Scenario: Signo de quetzales en el gran total "Total"
    When el usuario genere el reporte con la opcion "Quetzales"
    Then el importe del gran total "Total" se muestra con signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Comparativo de Venta Mensual por Clientes" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Comparativo de Venta Mensual por Clientes" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Comparativo de Venta Mensual por Clientes" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Comparativo de Venta Mensual por Clientes" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Comparativo de Venta Mensual por Clientes" en el listado de reportes del modulo de trafico.