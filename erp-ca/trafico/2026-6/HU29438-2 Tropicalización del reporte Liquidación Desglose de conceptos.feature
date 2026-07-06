Feature: Tropicalizacion del reporte "Liquidación: Desglose de conceptos" del modulo de trafico

    Yo como usuario del reporte Liquidación: Desglose de conceptos del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Liquidación: Desglose de conceptos"

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte 
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

    Example: ejemplo de algunas columnas que se pueden encontrar en el reporte que contienen importes
    | ColumnaImporte         |
    | Sueldo de Operador     |
    | Total Percepciones     |
    | Préstamo               |
    | Pensiones Alimenticias |
    | Total Deducción        |
    | Neto a Pagar           |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Liquidación: Desglose de conceptos" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Liquidación: Desglose de conceptos" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Liquidación: Desglose de conceptos" en el listado de reportes del modulo de trafico