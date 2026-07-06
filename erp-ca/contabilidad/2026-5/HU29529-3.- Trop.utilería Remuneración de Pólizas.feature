Feature: Tropicalizacion de la utileria "Remuneración de Pólizas" del modulo de contabilidad

    Yo como usuario de la utileria Remuneración de Pólizas del modulo de contabilidad
    Requiero que la utileria se encuentre adaptada para el uso con moneda de quetzales
    Para que la utileria encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa a la utileria "Remuneración de Pólizas"

Scenario Outline: Signo de quetzales en las columnas con importes nacionales
    When el usuario aplique la seleccion de filtros de la utileria
    Then en las <ColumnasConImportes> los importes realizados en moneda nacional se visualizan con el signo de quetzales.
    
    Example:
    | ColumnasConImportes |
    | Cargos              |
    | Abonos              |

Scenario Outline: Signo de quetzales en columnas con importes nacionales en el respaldo de polizas
    When el usuario corra la utileria y realice la renumeracion de las polizas
    And Seleccione "si" al momento que el sistema le pregunte si desea realizar respaldo de las polizas a renumerar
    Then en las <ColumnasConImportes> los importes realizados en moneda nacional se visualizan con el signo de quetzales "Q"
    And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Example:
    | ColumnasConImportes | formulas    |
    | Cargos              | Autosuma    |
    | Abonos              | Multiplicar |

Scenario: Mantener comportamiento actual de la utileria para bases de datos de México
  Given que el usuario accede a la utileria "Remuneración de Pólizas" del módulo de contabilidad en una base de datos de México
  When ingresa a la utileria
  Then la utileria no debe de presentar ningun ajuste relacionado con la tropicalizacion al pais de guatemala
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: La utileria es visible en base de datos de guatemala.
  Given que la utileria ya se encuentra tropicalizada para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar la utileria "Remuneración de Pólizas" en el listado de utilerias del modulo de contabilidad.