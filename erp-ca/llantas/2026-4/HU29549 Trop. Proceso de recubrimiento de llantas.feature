Feature: Tropicalizacion del proceso de recubrimiento de llantas del modulo de llantas

    Yo como usuario del proceso de recubrimiento de llantas
    Requiero que el proceso de encuentre adaptado a la moneda nacional quetzales
    Para que los usuario provenientes del pais de guatemala puedan usar el proceso y que encaje con sus actividades.

Background: Given que el usuario se encuentra dentro de una base de datos de guatemala

Scenario Outline: Mostrar la moneda quetzales en la funcion de OC desde recubrimiento de llantas.
    Given que el usuario ingresa al proceso de recubrimiento de llantas del modulo de llantas
    And ingresa a la <Funcion>
    When marca la opcion "Generar orden de compra" dentro del proceso 
    Then los <Campos> que contengan importes se visualizan con el signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 


    Examples:
        |Funcion   | Campos         |
        |Agregar   | Subtotal       |
        |Modificar | Mano de obra   |
        |Consultar | Descuento      |
        |          | Tipo de cambio |

Scenario Outline: Mostrar impuestos de guatemala en los campos de impuestos.
    Given que el usuario ingresa al proceso de recubrimiento de llantas del modulo de llantas
    And ingresa a la <Funcion>
    When el usuario este generando una OC desde el proceso
    Then en los combos de los campos de impuestos deberan de verse los impuestos configurados para guatemala.
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

    Example:
    |Funcion   |
    |Agregar   |
    |Modificar |

Scenario: Mostrar la moneda "Quetzales" en el campo moneda del proceso de retorno de llantas
    Given que el usuario ingresa al proceso de recubrimiento de llantas del modulo de llantas
    When el usuario acceda a la funcion "Retorno de llantas"
    Then en el campo "Moneda" se visualizan las siguientes opciones:
    |Moneda    |
    |Quetzales |
    |Dolares   |
     And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario Outline: Mostrar signo de quetzales en los campos de importes nacionales en la funcion de retorno de llantas
    Given que el usuario ingresa al proceso de recubrimiento de llantas del modulo de llantas
    When el usuario acceda a la funcion "Retorno de llantas"
    And tenga seleccionada la opcion "Quetzales" en e campo "Moneda"
    Then los <campos> dondo se visualicen importes en moneda quetzales se mirara el signo de quetzales "Q"
     And el proceso debe conservar su funcionamiento actual sin afectaciones

    Example:
    |campos         |
    |Tipo de cambio |
    |Subtotal       |
    |Mano de obra   |
    |Descuento      |

Scenario: Mostrar signo de quetzales en la funcion "Modificar"
    Given que el usuario ingresa al proceso de recubrimiento de llantas del modulo de llantas
    When el usuario acceda a la funcion "Retorno de llantas"
    And selecciona la opcion "Quetzales" en el campo de moneda
    And ingresa a la funcion de modificar de la pestaña de articulos
    Then en la ventana se visualiza el signo de quetzales en el campo "Importe"
     And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El proceso de recubrimiento de llantas es visible en base de datos de guatemala.
  Given que el proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el proceso "recubrimiento de llantas" dentro del modulo de llantas

Scenario: Mantener comportamiento actual del proceso recubrimiento de llantas para bases de datos de México
  Given que el usuario accede a una base de datos de México
  When el usuario acceda al proceso recubrimiento de llantas
  Then los campos monetarios deben mostrarse con el signo "$"
  And en el campo moneda de la funcion "Retorno de llantas" deben de verse solamente las siguientes opciones:
  |Moneda  |
  |Pesos   |
  |Dolares |
  And el proceso debe conservar su funcionamiento actual sin afectaciones