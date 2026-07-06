@Jaqueline
Feature: Proteccion del usuario GM SOPORTE en el catalogo de usuarios

    Yo como equipo de soporte de GM Transport
    requiero que el usuario GM SOPORTE no pueda ser modificado, inactivado ni alterado por ningun usuario del cliente
    Para que siempre podamos acceder al sistema y brindar un mejor soporte y atencion a los clientes

    #Dado
    Background: Given que el usuario tiene sesion activa con perfil de Administrador
        And el usuario pertenece a la empresa cliente
        And existe el usuario GM SOPORTE registrado en el catalogo de usuarios

    Scenario: Los botones de accion se deshabilitan al seleccionar al usuario GM SOPORTE
        #Dado
        Given el usuario se encuentra en el catalogo de usuarios
        #cuando
        When hace clic en el renglon del usuario GM SOPORTE
        #Entonces
        Then los botones Modificar, Derechos, Copiar Derechos e Imprimir Derechos quedan deshabilitados
        And no es posible ejecutar ninguna de esas acciones sobre ese usuario

    Scenario: Los botones se habilitan normalmente al seleccionar cualquier otro usuario
        #Dado
        Given el usuario se encuentra en el catalogo de usuarios
        #cuando
        When hace clic en el renglon de cualquier usuario distinto al GM SOPORTE
        #Entonces
        Then los botones Modificar, Derechos, Copiar Derechos e Imprimir Derechos se habilitan con normalidad

    Scenario: Intentar guardar cambios sobre el usuario GM SOPORTE
        #Dado
        Given el usuario logra abrir el formulario del usuario GM SOPORTE
        #cuando
        When intenta guardar cualquier cambio sobre el usuario
        #Entonces
        Then el sistema muestra el mensaje "Este usuario no podra ser modificado ya que para un mejor soporte y atencion al cliente es necesario mantener su configuracion intacta"
        And no se aplica ningun cambio

    Scenario: Intentar inactivar al usuario GM SOPORTE
        #Dado
        Given el usuario logra abrir el formulario del usuario GM SOPORTE
        #cuando
        When desmarca la casilla Activo e intenta guardar
        #Entonces
        Then el sistema muestra el mensaje de proteccion
        And el usuario GM SOPORTE permanece activo

    Scenario: Intentar cambiar el tipo de usuario GM SOPORTE
        #Dado
        Given el usuario logra abrir el formulario del usuario GM SOPORTE
        #cuando
        When cambia el tipo de usuario a cualquier opcion distinta de Administrador e intenta guardar
        #Entonces
        Then el sistema muestra el mensaje de proteccion
        And el tipo de usuario del GM SOPORTE permanece como Administrador

    Scenario Outline: Intentar crear un nuevo usuario con el nombre reservado GM
        #Dado
        Given el usuario se encuentra en el formulario de alta de usuario
        #cuando
        When captura el nombre de usuario <nombre> e intenta guardar
        #Entonces
        Then el sistema no permite crear el usuario
        And muestra un mensaje indicando que ese nombre de usuario esta reservado

        Ejemplos:
        | nombre |
        | GM     |
        | gm     |
        | Gm     |

    Scenario: El usuario GM SOPORTE puede modificarse a si mismo
        #Dado
        Given el usuario GM SOPORTE tiene sesion activa en el sistema
        #cuando
        When accede a su propio perfil y realiza un cambio
        #Entonces
        Then el sistema permite guardar los cambios sin restriccion
