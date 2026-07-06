Feature: Tropicalizacion del reporte "Relación de Nómina" del modulo de trafico

    Yo como usuario del reporte de Relación de Nómina del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And genera el reporte "Relación de Nómina"

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

    Example: 
    | ColumnaImporte                 |
    | Gastos                         |
    | Flete                          |
    | A pagar                        |
    | Utilidad                       |
    | sueldo operador                |
    | Comision por viaje             |
    | Total importe base liquidacion |

Scenario: Cambio de etiquta en total por liquidacion
    When el usuario consulte el total por liquidacion del reporte
    Then el total tendra por nombre "Moneda Quetzales" en lugar de "Moneda PESOS"
    And los importes deben de estar con el signo de quetzales "Q"


Scenario: Cambio de etiquta en grandes totales del reporte
    When el usuario consulte el gran total del reporte
    Then el total tendra por nombre "Totales en Quetzales" en lugar de "Totales en pesos"
    And los importes deben de estar con el signo de quetzales "Q"

Scenario: Colocar signo de quetzales en importes de la funcion "Ver detalle en Gastos"
    When el usuario genere el reporte con la opcion "Ver detalle en gastos"
    And seleccione la sensibilidad de la columna "Gastos"
    Then los importes de las siguientes columnas se visualizan con signo de quetzales "Q"
    | ColumnaImporte |
    | Subtotal       |
    | IVA            |
    | Total          |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relación de Nómina" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Relación de Nómina" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Relación de Nómina" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relación de Nómina" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa, en Excel y PDF
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relación de Nómina" en el listado de reportes del modulo de trafico.