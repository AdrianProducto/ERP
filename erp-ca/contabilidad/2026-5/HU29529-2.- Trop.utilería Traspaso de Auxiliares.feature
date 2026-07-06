Feature: Tropicalizacion de la utileria "Traspaso de Auxiliares" del modulo de contabilidad

    Yo como usuario de la utileria Traspaso de Auxiliares del modulo de contabilidad
    Requiero que la utileria se encuentre adaptada para el uso con moneda de quetzales
    Para que la utileria encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa a la utileria "Traspaso de Auxiliares"

Scenario: Signo de quetzales en las columnas con importes nacionales
    When el usuario aplique la seleccion de filtros de la utileria
    Then en la columna "Importe" los importes realizados en moneda nacional se visualizan con el signo de quetzales.

Scenario Outline: Signo de quetzales en columnas con importes nacionales en evidencia de utileria
    When el usuario corra la utileria y realice el traspaso de las polizas
    And desea descargar a evidencia de las polizas traspasadas
    Then en la columna "Importe" los importes realizados en moneda nacional se visualizan con el signo de quetzales "Q"
    And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Mantener comportamiento actual de la utileria para bases de datos de México
  Given que el usuario accede a la utileria "Traspaso de Auxiliares" del módulo de contabilidad en una base de datos de México
  When ingresa a la utileria
  Then la utileria no debe de presentar ningun ajuste relacionado con la tropicalizacion al pais de guatemala
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: La utileria es visible en base de datos de guatemala.
  Given que la utileria ya se encuentra tropicalizada para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar la utileria "Traspaso de Auxiliares" en el listado de utilerias del modulo de contabilidad.