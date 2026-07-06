Feature: Tropicalizacion del reporte "Balanza de Comprobación" del modulo de contabilidad

    Yo como usuario del reporte Balanza de Comprobación del modulo de contabilidad
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Balanza de Comprobación"

Scenario: Generar balanza de comprobación con cuentas contables en quetzales
    When el usuario consulte el campo "Generar balanza de comprobación con cuentas contables en"
    Then en el combo aparecera la opcion "Quetzales" en lugar de pesos
    And en el combo se visualizaran solo las siguientes opciones:
    | Moneda        |
    | AMBAS MONEDAS |
    | QUETZALES     |
    | DOLARES       |

Scenario: Funcionamiento de campo "Generar balanza de comprobación con cuentas contables en" con nueva moneda quetzales
    When el usuario consulte el campo "Generar balanza de comprobación con cuentas contables en"
    And selecciona la opcion "QUETZALES"
    Then el reporte muestra solamente cuentas contables en quetzales

Scenario: Funcionamiento de campo "Generar balanza de comprobación con cuentas contables en" con ambas monedas
    When el usuario consulte el campo "Generar balanza de comprobación con cuentas contables en"
    And selecciona la opcion "AMBAS MONEDAS"
    Then el reporte muestra  cuentas contables en quetzales y en DOLARES realizando conversion
    #Validar que en efecto este es el funcionamiento de la opcion

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario selecciona la <OpcionMoneda> en el filtro "Generar balanza de comprobación con cuentas contables en"
    And genera el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example: 
    | OpcionMoneda  | ColumnasConImporte |
    | AMBAS MONEDAS | Importe Movimiento |
    | QUETZALES     | Importe Autorizado |
    |               | Importe Pasivo     |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Balanza de Comprobación" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Balanza de Comprobación" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Balanza de Comprobación" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Balanza de Comprobación" del módulo de contabilidad en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Balanza de Comprobación" en el listado de reportes del modulo de contabilidad.