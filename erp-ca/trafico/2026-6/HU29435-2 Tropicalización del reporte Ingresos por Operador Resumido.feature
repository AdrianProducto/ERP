Feature: Tropicalizacion del reporte "Ingresos por Operador Resumido" del modulo de trafico

    Yo como usuario del reporte Ingresos por Operador Resumido del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Ingresos por Operador Resumido"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda                           |
    | Importes convertidos a Quetzales |
    | Importes Convertidos a Dolares   |
    | Importes en su moneda            |

Scenario: Colocar signo de Quetzales en columna "Neto A Pagar"
    When el usuario genere el reporte con la opcion de moneda "Importes convertidos a Quetzales" o "Importes en su moneda "
    And consulte la columna "Neto A Pagar"
    Then los importes en quetzales de la columna se visualizan con el signo "Q"

Scenario: Cambio de nombre a columnas "RFC"
    When el usuario genere el reporte
    Then la columna "RFC" ahora debera de llamarse "NIT"

Scenario: Cambio de nombre a columnas "CURP"
    When el usuario genere el reporte
    Then la columna "CURP" ahora debera de llamarse "CUI"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Ingresos por Operador Resumido" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Ingresos por Operador Resumido" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda
  And cambios en los nombres de columnas
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Ingresos por Operador Resumido" en el listado de reportes del modulo de trafico. 