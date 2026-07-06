Feature: Tropicalizacion del reporte "Existencia en inventario por almacén" del modulo de inventarios

    Yo como usuario de la reporte Existencia en inventario por almacén del modulo de inventarios
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Existencia en inventario por almacén"

Scenario: Nueva opcion "Quetzales" en filtro "Moneda"
    When el usuario consulte el filtro "Valorar el inventario en"
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
        | OpcionMoneda | titulo                                                                                                   |
        | QUETZALES    | Reporte de inventario de artículos por almacén (PEPS) a la fecha: 22/04/2026, en Quetzales               |
        | DOLARES      | Reporte de inventario de artículos por almacén (PEPS) a la fecha: 22/04/2026, en dólares                 |
        | AMBAS        | Reporte de inventario de artículos por almacén (PEPS) a la fecha: 22/04/2026, ambas (Quetzales, dólares) |

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda | ColumnasConImporte |
    | QUETZALES    | Costo MN           |
    | AMBAS        | Importe MN         |
  

Scenario: Signo de Quetzales en totales por almacen
    When el usuario genera el reporte con <OpcionMoneda>
    And consulte el "TOTAL ALMACEN"
    Then los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Existencia en inventario por almacén" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Existencia en inventario por almacén" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Existencia en inventario por almacén" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Existencia en inventario por almacén" del módulo de inventarios en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Existencia en inventario por almacén" en el listado de reportes del modulo de inventarios.