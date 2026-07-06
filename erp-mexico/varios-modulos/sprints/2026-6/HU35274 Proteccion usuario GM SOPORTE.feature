@Jaqueline
Feature: Protección del usuario GM SOPORTE para que no pueda ser modificado por usuarios del cliente

    Yo como equipo de soporte de GM Transport
    requiero que el usuario GM SOPORTE no pueda ser modificado, inactivado ni se le quiten derechos por ningún usuario del cliente
    Para que siempre podamos acceder al sistema y brindar soporte correctamente

    #Dado
    Background: Given que el usuario tiene sesión activa con perfil de Administrador
        And el usuario pertenece a la empresa cliente
        And existe el usuario GM SOPORTE registrado en el catálogo de usuarios

    Scenario: Intentar modificar al usuario GM SOPORTE desde el listado
        #Dado
        Given el usuario se encuentra en el catálogo de usuarios
        And selecciona al usuario GM SOPORTE en la lista
        #cuando
        When hace clic en el botón "Modificar"
        #Entonces
        Then el sistema muestra un mensaje indicando que el usuario GM SOPORTE no puede ser modificado
        And no abre el formulario de edición
        And el usuario GM SOPORTE permanece sin cambios

    Scenario: Intentar guardar cambios sobre el usuario GM SOPORTE desde el formulario
        #Dado
        Given el usuario logra abrir el formulario del usuario GM SOPORTE
        #cuando
        When intenta guardar cualquier cambio sobre el usuario
        #Entonces
        Then el sistema bloquea la operación
        And muestra un mensaje indicando que ese usuario no puede ser modificado
        And no se aplica ningún cambio

    Scenario: Intentar inactivar al usuario GM SOPORTE
        #Dado
        Given el usuario se encuentra en el formulario del usuario GM SOPORTE
        #cuando
        When desmarca la casilla "Activo" e intenta guardar
        #Entonces
        Then el sistema bloquea la operación
        And muestra un mensaje indicando que el usuario GM SOPORTE no puede ser inactivado
        And el usuario GM SOPORTE permanece activo en el sistema

    Scenario: Intentar cambiar el tipo de usuario GM SOPORTE a uno distinto de Administrador
        #Dado
        Given el usuario logra abrir el formulario del usuario GM SOPORTE
        #cuando
        When cambia el tipo de usuario a cualquier opción diferente de Administrador e intenta guardar
        #Entonces
        Then el sistema bloquea la operación
        And muestra un mensaje indicando que ese usuario siempre debe ser de tipo Administrador
        And el tipo de usuario del GM SOPORTE permanece como Administrador

    Scenario: Intentar modificar los derechos del usuario GM SOPORTE
        #Dado
        Given el usuario se encuentra en el catálogo de usuarios
        And selecciona al usuario GM SOPORTE en la lista
        #cuando
        When hace clic en el botón "Derechos"
        #Entonces
        Then el sistema muestra un mensaje indicando que los derechos de ese usuario no pueden ser modificados
        And no permite guardar ningún cambio en sus permisos

    Scenario: Intentar copiar derechos de otro usuario sobre el usuario GM SOPORTE
        #Dado
        Given el usuario se encuentra en el catálogo de usuarios
        And selecciona al usuario GM SOPORTE en la lista
        #cuando
        When hace clic en el botón "Copiar Derechos"
        #Entonces
        Then el sistema muestra un mensaje indicando que esa acción no está permitida para este usuario
        And no realiza ninguna copia ni modifica los derechos del usuario GM SOPORTE

    Scenario: El usuario GM SOPORTE sigue visible en el listado de usuarios
        #Dado
        Given el usuario se encuentra en el catálogo de usuarios
        #cuando
        When consulta la lista completa de usuarios del sistema
        #Entonces
        Then el usuario GM SOPORTE aparece en el listado
        And es visible pero sus opciones de modificación están restringidas

    Scenario: Modificar un usuario distinto al GM SOPORTE sigue funcionando con normalidad
        #Dado
        Given el usuario se encuentra en el catálogo de usuarios
        And selecciona a cualquier usuario diferente al GM SOPORTE
        #cuando
        When realiza acciones de modificar, derechos o copiar derechos
        #Entonces
        Then el sistema responde con normalidad
        And permite realizar los cambios sin restricción adicional
