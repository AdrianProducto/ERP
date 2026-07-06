Feature: Revision y adaptacion de XMLs de guatemala

    Yo como usuario del sistema
    Requiero que los XML del sistema tomen la informacion de la direccion del nuevo campo "Direccion"
    para que la informacion de direccion de los documentos fiscales no queden vacios dada la reestructuracion del sistema

Scenario Outline: Lectura del campo direccion
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingrese al <Proceso>
    When genere un XML de <Tipo> del registro
    And consulte el atributo "Direccion" del nodo "Receptor"
    Then la informacion que se visualice en la direccion debe ser la ingresada en el nuevo campo "Direccion" del catalogo de clientes.
    And el resto de armado de los XML no debe presentar cambios.

    Ejemplos:
    |Proceso                       | Tipo                  |
    |Facturacion por concepto      | Factura               |
    |Facturacion por viaje         | Facturacion especial  |
    |Facturacion por viaje parcial | Nota de credito       |
    |Notas de credito              | Nota de debito        |
    |                              | Facturacion cambiaria |

Scenario: El dato de direccion se toma de la seccion de Mexico
    Given que el usuario se encuentra dentro de una base de datos de Mexico
    And ingrese al <Proceso>
    When genere un XML del registro
    And consulte el atributo "Direccion" del nodo "Receptor"
    Then la informacion que se visualice en la direccion debe ser la ingresada en la seccion de direccion que no fue modificada.
    And el resto del XML no debe de presentar cambios.

    Ejemplos:
    |Proceso                     
    |Facturacion por concepto       |  
    |Facturacion por viaje          |
    |Facturacion por viaje parcial  |
    |Notas de credito               |