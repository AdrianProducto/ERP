Feature: Tropicalizacion del proceso de llantas del modulo de llantas.

    Yo como usuario del proceso de llantas
    Requiero que el proceso de encuentre adaptado a la moneda nacional quetzales
    Para que los usuario provenientes del pais de guatemala puedan usar el proceso y que encaje con sus actividades.

Background: Given que el usuario se encuentra en una base de datos del pais de guatemala e ingresa al proceso de llantas.

Scenario Outline: Cambio de etiqueta al campo "Costo llanta MN"
    When el usuario ingresa a la <Funcion>
    Then el proceso muestra la etiqueta "Costo llanta GTQ" en lugar de "Costo llanta MN"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

    Example:
    |Funcion   |
    |Agregar   |
    |Modificar |
    |Consultar |

Scenario Outline: Colocar el signo de quetzales en el campo "Costo llanta GTQ"
    When el usuario ingresa a la <Funcion> 
    And utiliza/consulta el campo "Costo llanta GTQ" 
    Then los importes que se ingresen en ese campo se visualizan con el signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

    Example:
    |Funcion   |
    |Agregar   |
    |Modificar |
    |Consultar |

Scenario Outline: Colocar el signo de quetzales en el campo "Tipo Cambio"
    When el usuario ingresa a la <Funcion>
    And utiliza/consulta el campo "Tipo Cambio"
    Then el importe del campo "Tipo Cambio" se visualiza con el signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

    Example:
    |Funcion   |
    |Agregar   |
    |Modificar |
    |Consultar |

Scenario: Colocar el signo de quetzales en la columna "Costo" del listado principal de llantas.
    When el usuario consulta el listo principal del proceso de llantas
    Then los importes nacionales que se encuentren en la columna "Costo" se visualizan con el signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

Scenario Outline:Colocar el signo de quetzales en la columna "Costo" del formato en PDF y excel del listado principal de llantas
    When el usuario da clic en el <Formato> del listado principal
    And consulta el archivo generado
    Then en la columna "Costo" se visualizan tambien los signos de quetzales en los importes nacionales.

    Example: 
    |Formatos|
    |Excel   |
    |PDF     |   

Scenario Outline: Colocar el signo de quetzales en el campo "Costo" de la funcion Asignar / Desasignar Llanta
    When el usuario se encuentre dentro de la funcion "Asignar / Desasignar Llanta"
    And seleccione la <opcion> 
    Then en el campo "Costo" se visualiza el importe con signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

    Example:
    |opcion           |
    |Asignar          |
    |Desasignar       |
    |Revision         |
    |Revision general |

Scenario Outline: Colocar el signo de quetzales en el campo "Costo para unidad" de la funcion Asignar / Desasignar Llanta
    When el usuario se encuentre dentro de la funcion "Asignar / Desasignar Llanta"
    And seleccione la <opcion> 
    Then en el campo "Costo para unidad" se visualiza el importe con signo de quetzales "Q"
    And el proceso debe conservar su funcionamiento actual sin afectaciones 

    Example:
    |opcion           |
    |Asignar          |
    |Desasignar       |
    |Revision         |
    |Revision general | 
    |Rotar            |

Scenario: Cambio de nombre a la columna "Costo llanta MN"
    Given que el usuario desea realizar la importacion de llantas al proceso
    When descarga el layout de importacion del sistema
    And consulta la columna de costo llanta
    Then el layout debe de mostrarse con la columna llamandose "Costo Llanta GTQ" en lugar de "Costo Llanta MN"
      And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: Ajuste en las instrucciones del layout de importacion de llantas
    Given que el usuario desea realizar la importacion de llantas al proceso
    When descarga el layout de importacion del sistema
    And ingresa a la pestaña de instrucciones del layout
    Then la fila "Costo Llanta MN" ahora debe de llamarse "Costo Llanta GTQ"
    And tener las siguientes instrucciones "Campo abierto permite indicar el costo de la llanta en quetzales. Campo Numérico."
    And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El proceso de llantas funciona correctamente desde ordenes de servicio
    Given que el usuario se encuentra dentro del proceso de ordenes de servicio
    When  utiliza el periferico del proceso de llantas
    Then Los cambios aplicados al proceso de llantas se ven correctamente desde el modulo de mantenimiento
    And el proceso funciona correctamente.  

Scenario: El proceso de llantas es visible en base de datos de guatemala.
  Given que el proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el proceso "Llantas" dentro del modulo de llantas

Scenario: Mantener comportamiento actual del proceso llantas para bases de datos de México
  Given que el usuario accede a una base de datos de México
  When el usuario acceda al proceso llantas
  Then los campos monetarios deben mostrarse con el signo "$"
  And el proceso debe conservar su funcionamiento actual sin afectaciones