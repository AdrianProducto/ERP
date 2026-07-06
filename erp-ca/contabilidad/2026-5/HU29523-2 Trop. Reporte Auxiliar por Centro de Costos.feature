Feature: Tropicalizacion del reporte "Reporte Auxiliar por Centro de Costos" del modulo de contabilidad

    Yo como usuario de la reporte Reporte Auxiliar por Centro de Costos del modulo de contabilidad
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Reporte Auxiliar por Centro de Costos"

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte 
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Cargos             |
    | Abonos             |
    | Saldo              |

Scenario: signo de quetzales en totales por centros de costos
    When el usuario genera el reporte 
    And consulte los totales por centros de costos
    Then los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: signo de quetzales en gran total
    When el usuario genera el reporte 
    And consulte el gran total del reporte
    Then los importes de los registros realizados en moneda nacional se visualizan con el signo de quetzales "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Reporte Auxiliar por Centro de Costos" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Reporte Auxiliar por Centro de Costos" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Reporte Auxiliar por Centro de Costos" del módulo de bancos en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Reporte Auxiliar por Centro de Costos" en el listado de reportes del modulo de bancos.