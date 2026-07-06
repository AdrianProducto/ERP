Feature: Mostrar nombre de el empleado GM en la tabla de bitácora de procesos del sistema al utilizar el usuario GM
    Yo como usuario GM del sistema GM Transport ERP,
    Quiero poder ver el correo del empleado que está ejecutando acciones con el usuario GM en la tabla de bitácora de procesos del sistema,
    Para una mejor gestión de los usuarios y seguridad del sistema.

  Background:
    Given que cada acción que un usuario del sistema GM realiza se registra en la tabla de bitácora de procesos del sistema
      And el usuario GM es un usuario compartido que puede ser utilizado por varios empleados GM para realizar acciones en el sistema

  Scenario: Consultar la tabla de bitácora de procesos del sistema para ver el correo del empleado GM que está utilizando el usuario GM
    Given que el usuario GM ha sido utilizado por un empleado GM para realizar acciones en el sistema
      And el usuario del sistema haya iniciado sesión con el usuario GM
     When el usuario consulta la tabla de bitácora de procesos del sistema para revisar las acciones realizadas con el usuario GM
     Then el usuario podrá ver el correo del empleado GM que realizó cada acción con el usuario GM registrado en la tabla de bitácora de procesos del sistema
      And el correo del empleado GM se mostrará en la columna "Usuario" de la tabla generada de bitácora de la siguiente manera
       '''
        GM - [Correo del empleado GM que realizó la acción]
       '''
      And el Correo del empleado GM se tomará de el dato "CorreoEmpleado" de la tabla de "SisSessiones" de la base de datos


