Feature: Tropicalizacion del reporte "Estado de cuenta por tipo de cobro" del modulo de cobranza

    Yo como usuario del reporte Estado de cuenta por tipo de cobro del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Estado de cuenta por tipo de cobro"

Scenario: Lectura de moneda quetzales en columna de moneda
    When el usuario genere el reporte
    Then en la columna "Moneda" debe de verse la moneda "Quetzales" en los registros realizados con dicha moneda

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

Scenario: Signo de quetzales en la columna "Tipo de cambio"
    When el usuario genere el reporte con el filtro "Mostrar tipo de cambio"
    And consulte la columna "Tipo de cambio"
    Then los importes en moneda nacional deben de verse con el signo de quetzales "Q"

Scenario: Cambio de nombre al filtro "Mostrar Subtotal de factura en pesos"
    When el usuario consulte la seccion "Otras opciones"
    Then la opcion "Mostrar Subtotal de factura en pesos" se muestra ahora como "Mostrar Subtotal de factura en quetzales"
    And el funcionamiento de la opcion sigue igual, pero orientado a quetzales.

Scenario Outline: Cambio de nombre a la columna "Subtotal pesos"
    When el usuario genere el reporte con el filtro "Mostrar Subtotal de factura en quetzales"
    Then la columna "Subtotal pesos" ahora debe verse como "SubTotal quetzales"

Scenario: Signo de quetzales en la columna "SubTotal quetzales"
    When el usuario genere el reporte con el filtro "Mostrar Subtotal de factura en quetzales"
    And consulte la columna "SubTotal quetzales"
    Then los importes en moneda nacional deben de verse con el signo de quetzales "Q"

Scenario: Cambio de nombre al filtro "Mostrar RFC del Cliente"
    When el usuario consulte la seccion "Otras opciones"
    Then la opcion "Mostrar RFC del Cliente" se muestra ahora como "Mostrar NIT del Cliente"
    And el funcionamiento de la opcion sigue igual, pero orientado al NIT.

Scenario Outline: Cambio de nombre a la columna "RFC"
    When el usuario genere el reporte con el filtro "Mostrar NIT del Cliente"
    Then la columna "RFC" ahora debe verse como "NIT"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Estado de cuenta por tipo de cobro" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Estado de cuenta por tipo de cobro" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Estado de cuenta por tipo de cobro" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Estado de cuenta por tipo de cobro" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Estado de cuenta por tipo de cobro" en el listado de reportes del modulo de cobranza.