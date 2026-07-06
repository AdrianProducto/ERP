Feature: Tropicalizacion del proceso de inventario de almacen del modulo de inventarios.

    Yo como usuario del proceso de inventario de almacen del modulo de inventarios
    Requiero que los importes nacionales dentro del proceso de encuentren tropicalizados a la moneda
    Para que el proceso se pueda utilizar en el pais de guatemala y encaje con las actividades reales del usuario.

Background: Given que el usuario se encuentra dentro de una base de datos configurada con el pais de guatemala.
Scenario Outline: Colocar signo de quetzales en columna "Precio unitario"
    When el usuario ingrese al proceso de "Inventario de almacen"
    And seleccione la <Funcion>
    And consulte la columna "precio unitario"
    Then el sistema debe de mostrar los importes que se encuentran dentro de la columna con signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones

    Example:
    |Funcion   |
    |Agregar   |
    |Modificar |
    |Consultar |

Scenario Outline: Colocar signo de quetzales en campo "Precio unitario"
    When el usuario ingrese al proceso de "Inventario de almacen"
    And  el usuario seleccione la <Opcion> dentro del proceso
    Then el importe ingresado en el campo "Precio unitario" debe de visualizarse con el signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones

    Example:
    |Opcion    |
    |Agregar   |
    |Modificar |

Scenario: El proceso de inventario de almacen es visible en base de datos de guatemala.
  Given que el proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el proceso "Inventario de almacen" dentro del modulo de inventarios.

Scenario: Mantener comportamiento actual del proceso inventario de almacen para bases de datos de México
  Given que el usuario accede a una base de datos de México
  When el usuario acceda al proceso de inventartio de almacen
  Then los campos monetarios deben mostrarse con el signo "$"
  And el proceso debe conservar su funcionamiento actual sin afectaciones   
    