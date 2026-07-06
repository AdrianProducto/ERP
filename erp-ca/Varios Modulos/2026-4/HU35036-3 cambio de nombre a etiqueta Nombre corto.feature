Feature: Cambio de etiqueta de "Nombre corto" a "Nombre comercial" en catalogo de clientes y proveedores

    Yo como usuario del catalogo de clientes y proveedores
    requiero que se cambie el nombre del campo "Nombre corto" por "Nombre comercial"
    Para que el campo sea mas acorde a las actividades de guatemala.

    #Dado
    Background: Given que el usuario trabaja en una base de datos configurada para el país "Guatemala"

    Scenario Outline: Cambio del campo "Nombre corto" por "Nombre comercial"
        #cuando
        When el usuario accede al catálogo de <catalogo>
        #Entonces
        Then el campo "Nombre Corto" debe mostrarse con la etiqueta "Nombre comercial"

         Ejemplos:
         | Catalogo    |
         | clientes    |
         | Proveedores |

    Scenario Outline: visualizar la columna "Nombre comercial" en listado principal de los catalogos.
        #Cuando
        When el usuario este en el listado principal del catalogo de <catalogo>
        #Entonces
        Then la columna "Nombre corto" debe de mostrarse ahora como "Nombre comercial"

         Ejemplos:
         | Catalogo    |
         | Clientes    |
         | Proveedores |

    Scenario Outline: Visualizar "Nombre comercial" en las funciones de consultar y modificar
         When el usuario accede al catálogo de <catalogo>
         And selecciona la funcion <Funcion>
        Then el campo "Nombre corto" del formulario debe mostrarse con la etiqueta "Nombre comercial"

        Ejemplos:
        | catalogo    | Funcion   |
        | clientes    | Modificar |
        | proveedores | consultar |

    Scenario Outline:Visualizar la columna "Nombre comercial" en la funcion de impresion de los catalogos.
        #cuando
        When el usuario use la funcion de imprimir del catalogo de <catalogo>
        #y
        And seleccione la opcion <TipoDeReporte>
        #Entonces
        Then la columna "Nombre corto" del reporte debe de mostrarse ahora como "Nombre comercial"

         Ejemplos:
         | catalogo    | TipoDeReporte |
         | Clientes    | Resumido      |
         | Proveedores | Detallado     |

    Scenario Outline:Visualizar la columna "Nombre comercial" en el formato Excel de la funcion impresion de los catalogos.
        #cuando
        When el usuario use la funcion de imprimir del catalogo de <catalogo>
        #y
        And selecciona la opcion <TipoDeReporte>
        And seleccione la opcion "Exportar XLS"
        #Entonces
        Then la columna "nombre corto" del reporte debe de mostrarse ahora como "Nombre comercial"

        Ejemplos:
         | catalogo    | TipoDeReporte |
         | Clientes    | Resumido      |
         | Proveedores | Detallado     |

    Scenario: Visualización del campo para países distintos de Guatemala
        #Dado
        Given una base de datos configurada con un país distinto de "Guatemala"
        #cuando
        When el usuario accede al catálogo de clientes y/o proveedores
        #Entonces
        Then el campo debe seguir mostrándose con la etiqueta "Nombre Corto"