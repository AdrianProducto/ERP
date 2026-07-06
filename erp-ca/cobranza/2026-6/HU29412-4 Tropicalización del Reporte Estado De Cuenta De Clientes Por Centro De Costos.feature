Feature: Tropicalizacion del reporte "Estado De Cuenta De Clientes Por Centro De Costos" del modulo de cobranza

    Yo como usuario del reporte Estado De Cuenta De Clientes Por Centro De Costos del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Estado De Cuenta De Clientes Por Centro De Costos"

Scenario Outline: Cambio de nombre a la columna "Saldo pesos"
    When el usuario genere  el reporte
    Then la columna "Saldo pesos" ahora debe verse como "Saldo quetzales"

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: 
    | ColumnaImporte  |
    | Cargo           |
    | Abono           |
    | Saldo quetzales |

Scenario Outline: Cambio de nombre en los totales de saldos vencidos en moneda nacional
    When el usuario genere  el reporte
    And consulte la seccion "Saldos vencidos"
    Then el total "En pesos" ahora debe verse como "En quetzales"

Scenario: Signo de quetzales en total de saldos vencidos en quetzales
    When el usuario genere el reporte
    And consulte la seccion de saldos vencidos en quetzales
    Then los importes en quetzales se visualizan con el signo "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Estado De Cuenta De Clientes Por Centro De Costos" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Estado De Cuenta De Clientes Por Centro De Costos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Estado De Cuenta De Clientes Por Centro De Costos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Estado De Cuenta De Clientes Por Centro De Costos" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Estado De Cuenta De Clientes Por Centro De Costos" en el listado de reportes del modulo de cobranza.