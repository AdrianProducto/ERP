Feature: Tropicalizacion del reporte "Bitácora Estado de Resultados Por Unidad" del modulo de trafico

    Yo como usuario del reporte Bitácora Estado de Resultados Por Unidad del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Bitácora Estado de Resultados Por Unidad"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones:
    | Moneda    |
    | Quetzales |
    | Dolares   |

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte con la opcion "Quetzales" en el filtro de moneda
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    Example:
    | ColumnasConImporte |
    | Importe            |
    | Gasto              |
    | Total              |

Scenario: Colocar signo de quetzales en gran total "TOTAL DE UTILIDAD"
    When el usuario genere el reporte
    And seleccione la opcion "Quetzales" en el filtro de moneda
    Then el importe del gran total "TOTAL DE UTILIDAD" se visualiza con signo de quetzales "Q"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Bitácora Estado de Resultados Por Unidad" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Bitácora Estado de Resultados Por Unidad" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Bitácora Estado de Resultados Por Unidad" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Bitácora Estado de Resultados Por Unidad" en el listado de reportes del modulo de trafico.   