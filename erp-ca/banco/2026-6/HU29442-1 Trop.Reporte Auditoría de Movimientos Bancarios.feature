Feature: Tropicalizacion del reporte "Auditoría de Movimientos Bancarios" del modulo de bancos

    Yo como usuario del reporte Auditoría de Movimientos Bancarios del modulo de bancos
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Auditoría de Movimientos Bancarios"

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Importe Movimiento |
    | Importe Autorizado |
    | Importe Pasivo     |

Scenario: signo de quetzales en el total por cuenta
    When el usuario genere el reporte
    And consulte el total por cuenta
    Then el importe realizado en quetzales se muestra con el signo de quetzales "Q"

Scenario: Cambio a la etiqueta del gran total por pesos
    When el usuario genere el reporte
    And consulte los grandes totales del reporte
    Then el gran total "GRAN TOTAL PESOS" debe verse como "GRAN TOTAL QUETZALES"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Auditoría de Movimientos Bancarios" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Auditoría de Movimientos Bancarios" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Auditoría de Movimientos Bancarios" del módulo de bancos en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Auditoría de Movimientos Bancarios" en el listado de reportes del modulo de bancos.