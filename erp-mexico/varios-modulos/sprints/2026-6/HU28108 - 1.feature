Feature: Mejora para el proceso de doble autenticación como usuario GM
    Yo como usuario GM del sistema GM Transport ERP,
    Quiero poder ver quién es la persona que está utilizando el usuario GM al momento de hacer la doble autenticación si el sistema indica que existe un usuario ya activo,
    Para una mejor gestión de los usuarios y seguridad del sistema.

  Background:
    Given el proceso de doble autenticación ya está implementado para el usuario GM
      And el proceso requiere que el empleado GM ingrese su correo de empleado para validar su identidad
      And el proceso requiere validar que la contraseña del usuario GM sea correcta

  Scenario: Un empleado GM intenta iniciar sesión con el usuario GM cuando ya hay otro empleado GM activo
    Given que el usuario GM ya está activo en el sistema
      And el empleado GM que aún no ha entrado se encuentra en la pantalla de inicio de sesión del sistema
     When el empleado GM intenta iniciar sesión con el usuario GM
      And el proceso de doble autenticación valida las credenciales del empleado GM
      And el sistema detecta que el usuario GM ya está activo
     Then el sistema notificará al empleado que ya se encuentra activo el usuario GM
      And el sistema mostrará información sobre la persona que está utilizando el usuario GM con el siguiente mensaje
        '''
        El usuario GM ya se encuentra activo con el empleado: [Nombre del empleado que está utilizando el usuario GM].
        ¿Desea cerrar la sesión del usuario activo?
        '''
      And el usuario tendrá la opción de cerrar la sesión del usuario GM activo para que el nuevo empleado pueda iniciar sesión con el usuario GM o de cancelar la acción para no cerrar la sesión del usuario GM activo

  Scenario: El empleado forza el cierre de sesión del usuario GM activo para entrar al sistema
    Given que el usuario GM ya está activo en el sistema
      And el empleado GM que aún no ha entrado se encuentra en la pantalla de inicio de sesión del sistema
      And el empleado inicia sesión con el usuario GM
      And el proceso de doble autenticación valida las credenciales del empleado GM
      And el sistema informa al usuario que el usuario GM ya se encuentra activo con otro empleado
     When el empleado GM selecciona la opción de cerrar la sesión del usuario activo
     Then el sistema cerrará la sesión del usuario GM activo
      And el nuevo empleado podrá iniciar sesión con el usuario GM
