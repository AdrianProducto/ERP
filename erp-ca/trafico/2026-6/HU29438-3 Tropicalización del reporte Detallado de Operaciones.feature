Feature: Tropicalizacion del reporte "Detallado de Operaciones" del modulo de trafico

    Yo como usuario del reporte Detallado de Operaciones del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Detallado de Operaciones"

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte 
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

    Example: ejemplo de algunas columnas que se pueden encontrar en el reporte que contienen importes
    | ColumnaImporte    |
    | Sueldo Operador   |
    | Gastos de Viaje   |
    | Gastos de Diesel  |
    | Anticipos         |
    | Total Liquidación |
    | Subtotal          |
    | Total             |

Scenario: Lectura de moneda quetzales en columna de moneda
    When el usuario genere el reporte
    Then en la columna "Moneda" debe de verse la moneda "Quetzales" en los registros realizados con dicha moneda

Scenario: Ajuste a la condicion del reporte "Total MN"
    Given que el usuario ingresa a la seccion "Condificones del reporte"
    When consulte la condicion "Total MN"
    Then la descripcio de la condificon debe ser la siguiente: "En esta columna se visualizará el monto total de la factura convertido a QUETZALES"

Scenario: Ajuste a la condicion del reporte "Importe Pagado en MN"
    Given que el usuario ingresa a la seccion "Condificones del reporte"
    When consulte la condicion "Importe Pagado en MN"
    Then la descripcio de la condificon debe ser la siguiente: "En esta columna se visualizará el monto del importe pagado en la factura convertido a QUETZALES"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el sistema exporta el reporte "Detallado de Operaciones" a Excel de manera automatica
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Detallado de Operaciones" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Detallado de Operaciones" en el listado de reportes del modulo de trafico. 