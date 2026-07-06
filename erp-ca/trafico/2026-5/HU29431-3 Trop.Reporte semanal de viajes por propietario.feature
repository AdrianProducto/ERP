Feature: Tropicalizacion del reporte "Semanal de Viajes por Propietario" del modulo de trafico

    Yo como usuario del reporte Semanal de Viajes por Propietario del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And genera el reporte "Semanal de Viajes por Propietario"

Scenario: Colocar signo de Quetzales en importes nacionales de la seccion "Ingresos" del reporte
    When el usuario consulte la columna "Subtotal"
    Then los importes en quetzales de la columna se visualizan con el signo "Q"

Scenario: Colocar signo de quetzales en "Total ingresos"
    When el usuario consulte el total "TOTAL INGRESOS"
    Then el importe en quetzales de la columna se visualiza con el signo "Q"

Scenario Outline: Colocar signo de Quetzales en importes nacionales de la seccion "Gastos" del reporte
    When el usuario consulte las <ColumnaImporte>
    And este generando el reporte con <OpcionMoneda>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

    Example: 
    | ColumnaImporte |
    | Subtotal       |
    | Total          |

Scenario: Colocar signo de quetzales en "TOTAL GASTOS"
    When el usuario consulte el total "TOTAL GASTOS"
    Then el importe en quetzales de la columna se visualiza con el signo "Q"

Scenario: Colocar signo de quetzales en "UTILIDAD"
    When el usuario consulte el total "UTILIDAD"
    Then el importe en quetzales de la columna se visualiza con el signo "Q"

Scenario: Colocar signo de Quetzales en importes nacionales de la seccion "PASIVOS PENDIENTES DE PAGO" del reporte
    When el usuario consulte la columna "Importe a pagar"
    Then los importes en quetzales de la columna se visualizan con el signo "Q"

Scenario: Colocar signo de quetzales en "Total" la seccion "PASIVOS PENDIENTES DE PAGO" del reporte
    When el usuario consulte el total "Total" de la seccion "Pasivos pendientes de pago"
    Then el importe en quetzales de la columna se visualiza con el signo "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Semanal de Viajes por Propietario" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Semanal de Viajes por Propietario" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Semanal de Viajes por Propietario" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Semanal de Viajes por Propietario" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa, en Excel y PDF
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Semanal de Viajes por Propietario" en el listado de reportes del modulo de trafico.