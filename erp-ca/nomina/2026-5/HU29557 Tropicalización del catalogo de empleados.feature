Feature: Tropicalizacion del catalogo de empleados del modulo de nominas

    Yo como usuario del catalogo de empleados del modulo de nominas
    Requiero que el catalogo se encuentre adaptado al contexto del pais de guatemala 
    Para que el usuario se encuentre familiarizado con los registros que realizara

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al catalogo de empleados del modulo de nominas

Scenario Outline: Cambio de nombre en pestaña "IMSS"
    When el usuario ingrese a la <Funcion>
    And consulte las pestañas del catalogo de empleados
    Then la pestaña "IMSS" ahora se llama "IGSS"

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Cambio de nombre en etiqueta "No.IMSS"
    When el usuario ingrese a la <Funcion>
    And ingrese a la pestaña "IGSS"
    Then la etiqueta "No.IMSS" ahora se llama "No.IGSS"

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Cambio de nombre en etiqueta "RFC"
    When el usuario ingrese a la <Funcion>
    And ingrese a la pestaña "IGSS"
    Then la etiqueta "RFC" ahora se llama "NIT"

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Registro de NIT correcto
    When el usuario ingrese a la <Funcion>
    And  ingrese a la pestaña "IGSS"
    And ingresa un NIT en el campo "NIT"
    And el NIT tiene una longitud minima de 2 , maxima de 12
    And un tipo de dato alfanumerico
    Then el registro del empleado se realiza sin problema

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Registro de NIT con longitud incorrecta
    When el usuario ingrese a la <Funcion>
    And  ingrese a la pestaña "IGSS"
    And ingresa un NIT en el campo "NIT"
    And el NIT no tiene una longitud minima de 2 , maxima de 12 
    Then al querer guardar el empleado el sistema arroja el siguiente mensaje "El NIT ingresado debe ser de un mínimo de 2 caracteres hasta 12 caracteres, Favor de verificar."
    And el empleado no se registra en el sistema

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Registro de NIT con tipo de dato incorrecto
    When el usuario ingrese a la <Funcion>
    And  ingrese a la pestaña "IGSS"    
    And el usuario ingresa un NIT en el campo "NIT"
    And el tipo de dato no es alfanumerico
    Then al querer guardar el empleado el sistema arroja el siguiente mensaje "El NIT ingresado no cumple con el formato correcto, favor de verificar."
    And el empleado no se registra en el sistema

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline: Cambio de nombre en etiqueta "CURP"
    When el usuario ingrese a la <Funcion>
    And ingrese a la pestaña "IGSS"
    Then la etiqueta "CURP" ahora se llama "CUI"

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Registro de CUI correcto
    When el usuario ingrese a la <Funcion>
    And  ingrese a la pestaña "IGSS"      
    And ingresa un CUI en el campo "CUI"
    And el CUI tiene una longitud minima de 13 , maxima de 13
    And un tipo de dato numerico
    Then el registro del empleado se realiza sin problema

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Registro de CUI con longitud incorrecta
    When el usuario ingrese a la <Funcion>
    And  ingrese a la pestaña "IGSS"  
    And ingresa un CUI en el campo "CUI"
    And el CUI no tiene una longitud minima de 13 , maxima de 13
    Then al querer guardar el empleado el sistema arroja el siguiente mensaje "El CUI ingresado debe ser de 13 caracteres, Favor de verificar."
    And el empleado no se registra en el sistema

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Registro de CUI con tipo de dato incorrecto
    When el usuario ingrese a la <Funcion>
    And  ingrese a la pestaña "IGSS"   
    And ingresa un CUI en el campo "CUI"
    And el tipo de dato no es numerico
    Then al querer guardar el empleado el sistema arroja el siguiente mensaje "El CUI ingresado no cumple con el formato correcto, favor de verificar."
    And el empleado no se registra en el sistema

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario Outline:: Signo de quetzales en columna "Sueldo" de pestaña "Tipos de Sueldos"
    When el usuario ingrese a la <Funcion>
    And ingrese a la pestaña "Tipos de Sueldos"
    And consulte la tabla de Sueldos
    Then Los importes de moneda nacional se visualizan con signo de quetzales "Q" en la columna "Sueldo" 

    Example: 
    | Funcion   |
    | Agregar   |
    | Modificar |

Scenario: Modificación de columnas en el layout de importación de empleados
    Given que el usuario descarga o visualiza el layout de importación de empleados
    When revisa las columnas del layout
    Then la columna "RFC" debe mostrarse como "NIT"
    And la columna "CURP" debe mostrarse como "CUI"
    And la columna "Numero IMSS" debe mostrarse como "Numero IGSS"

Scenario: Actualización de instrucción de llenado para la columna NIT en el layout de empleados
    Given que el usuario descarga o visualiza el layout de importación de empleados
    When el usuario consulta las instrucciones del layout de importación de empleados
    Then la instrucción de la columna "NIT" debe ser "NIT del empleado" 

Scenario: Mantener comportamiento actual del catalogo para bases de datos de México
  Given que el usuario accede al catalogo "Empleados" del módulo de nominas en una base de datos de México
  When consulte el catalogo
  Then el catalogo no debe de presentar ningun cambio referente a la tropicalizacion
  And el catalogo  debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el catalogo ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el catalogo "Empleados" en el listado de catalogos del modulo de nominas