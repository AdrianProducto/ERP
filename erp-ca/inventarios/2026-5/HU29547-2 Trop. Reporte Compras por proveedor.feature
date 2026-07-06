Feature: Tropicalizacion del reporte "Compras por proveedor" del modulo de inventarios

    Yo como usuario de la reporte Compras por proveedor del modulo de inventarios
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Compras por proveedor"

Scenario: Nueva opcion "Quetzales" en filtro "Filtrar por la Moneda"
    When el usuario consulte el filtro "Filtrar por la Moneda"
    Then en el combo aparecera la opcion "Quetzales" en lugar de pesos
    And en el combo se visualizaran solo las siguientes opciones:
    | Moneda    |
    | QUETZALES |
    | DOLARES   |
    | AMBAS     |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario selecciona la <OpcionMoneda>
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        | OpcionMoneda | titulo                                                                 |
        | QUETZALES    | Reporte de compras por proveedor del 01/04/2026 al 23/04/2026, pesos   |
        | DOLARES      | Reporte de compras por proveedor del 01/05/2025 al 23/04/2026, dólares |
        | AMBAS        | Reporte de compras por proveedor del 01/05/2025 al 23/04/2026, dólares |

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda | ColumnasConImporte |
    | QUETZALES    | Sub Total          |
    | AMBAS        | Descuento          |
    |              | Iva                |
    |              | Retencion          |
    |              | Total              |

Scenario Outline: Cambio de etiqueta al total en pesos
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte los totales del reporte
    Then el total "TOTALES PESOS" se visualiza ahora como "TOTALES QUETZALES"

    Example: 
    | OpcionMoneda |
    | QUETZALES    |          
    | AMBAS        |  

Scenario Outline: Signo de Quetzales en totales en quetzales
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte el total "TOTALES QUETZALES"
    Then Los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda |
    | QUETZALES    |          
    | AMBAS        |  

Scenario Outline: Cambio de etiqueta al total general en pesos
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte los totales del reporte
    Then el total "TOTALES GENERALES PESOS" se visualiza ahora como "TOTALES GENERALES QUETZALES"

    Example: 
    | OpcionMoneda |
    | QUETZALES    |          
    | AMBAS        |  

Scenario Outline: Signo de Quetzales en totales generales en quetzales
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte el total "TOTALES GENERALES QUETZALES"
    Then Los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda |
    | QUETZALES    |          
    | AMBAS        |

Scenario: Lectura de moneda Quetzal en columna "Moneda"
    When el usuario genere el reporte
    And consulte la columna "Moneda"
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Compras por proveedor" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Compras por proveedor" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Compras por proveedor" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Compras por proveedor" del módulo de inventarios en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Compras por proveedor" en el listado de reportes del modulo de inventarios. 