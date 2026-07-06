Feature: Tropicalizacion del "Reporte de Permisionarios" del modulo de trafico

    Yo como usuario del reporte de Permisionarios del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al "Reporte de Permisionarios"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones:
    | Moneda    |
    | Quetzales |
    | Dolares   |
    | Ambas     |

Scenario: Funcionamiento del filtro "Moneda" con nueva moneda Quetzales
  When el usuario selecciona la nueva moneda "Quetzles" en el filtro "Moneda"
  Then el reporte debera de mostrar registros realizados en la moneda quetzales

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario selecciono la <OpcionMoneda>
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        | OpcionMoneda | titulo                                                                                                                     |
        | Quetzales    | Reporte de Resumen de Permisionarios del 01/04/2026 al 20/04/2026 Viajes Liquidados y No Liquidados en Quetzales           |
        | Dolares      | Reporte de Resumen de Permisionarios del 01/01/2025 al 20/04/2026 Viajes Liquidados y No Liquidados en Dólares             |
        | Ambas        | Reporte de Resumen de Permisionarios del 01/04/2026 al 20/04/2026 Viajes Liquidados y No Liquidados en Quetzales y Dólares |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros con reporte acumulado
    Given que el usuario selecciono la <OpcionMoneda>
    And  activo la opcion "Generar reporte acumulado"
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda | titulo                                                                         |
    | Quetzales    | Reporte de Resumen de Permisionarios del 01/01/2025 al 20/04/2026 en Quetzales |
    | Dolares      | Reporte de Resumen de Permisionarios del 01/01/2025 al 20/04/2026 en Dólares   |
    
Scenario Outline: Lectura de moneda Quetzal en columnas con nombres de moneda
    When el usuario genere el reporte con <OpcionMoneda>
    Then la columna <ColumnaConMoneda> muestra el dato "Quetzales" en los registros realizados en moneda quetzales

    Examples: 
    | OpcionMoneda | ColumnaConMoneda  |
    | Quetzales    | "Moneda Viaje/CP" |
    | Ambas        | Moneda Factura    |
    

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    Example: 
    |OpcionMoneda                    | ColumnasConImporte             |
    |Quetzales                       | Comisión de Permisionario      |
    |Ambas                           | Subtotal Factura Permisionario |
    |                                | IVA                            |
    |                                | Retencion                      |
    |                                | Importe por Facturar Cliente   |
    |                                | Importe Facturado Cliente      |
    |                                | Utilidad                       |
    |                                | Gastos                         |
    |                                | Cargos Adicionales             |

Scenario Outline: Signo de Quetzale en columnas con importes en reporte acumulado
    When el usuario genere el reporte con la opcion "Generar reporte acumulado" activa
    And seleccione la opcion "Quetzales" en el filtro de moneda
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    Examples:
    | OpcionMoneda | ColumnasConImporte   |
    | Quetzales    | Importe por facturar |
    | Ambas        | Importe facturado    |
    |              | Importe por facturar |
    |              | Importe facturado    |

Scenario Outline: Cambio en nombre de grandes totales
    When el usuario genere el reporte
    And seleccione la <OpcionMoneda> en el filtro de moneda
    And consulte los grandes totales del reporte
    Then el gran total "Total Pesos" ahora se muestra como "Total Quetzales"

Scenario: Signo de quetzales en el gran total "Total Quetzales"
    When el usuario genere el reporte 
    And seleccione la <OpcionMoneda> en el filtro de moneda
    Then el importe del gran total "Total Quetzales" se muestra con signo de quetzales.

Scenario: Signo de quetzales en el grandes totales en reporte acumulado
    When el usuario genere el reporte con la opcion "Generar reporte acumulado" activa
    And seleccione la opcion "Quetzales" en el filtro de moneda
    Then los importes de los <GrandesTotales> se muestra con signo de quetzales.

    Example: 
    | GrandesTotales         |
    | Nos debe cliente       |
    | Debemos permisionarios |
    | Saldo                  |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el "Reporte de Permisionarios" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And funcionan de igual forma con la opcion "Generar reporte acumulado"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    |Reporte    | formulas    |
    |Clientes   | Autosuma    |
    |Operadores | Multiplicar |
    |Unidades   | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el "Reporte de Permisionarios" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el "Reporte de Permisionarios" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en reporte acumulado
    Given que el usuario genera el "Reporte de Permisionarios" con la opcion "Generar reporte acumulado"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte.

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al "Reporte de Permisionarios" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Reporte de Permisionarios" en el listado de reportes del modulo de trafico.   