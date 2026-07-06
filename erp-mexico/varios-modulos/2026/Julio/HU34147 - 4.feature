Feature: Pantalla de Login para el usuario Administrador del Dashboard de KPIs
    Yo como Administrador del Dashboard de KPIs,
    Quiero que se implemente una pantalla de Login para acceder al dashboard,
    Para garantizar la seguridad y el acceso controlado a la información de los indicadores clave de desempeño.

  Scenario: Acceder a la pantalla de Login del Dashboard de KPIs
    Given que el usuario administrador del Dashboard de KPIs tiene el enlace de la página de Login
    When el usuario ingrese al enlace de la página de Login del Dashboard de KPIs
    Then el sistema mostrará la pantalla de Login con los siguientes elementos:
        '''
        - Un campo para ingresar el nombre de usuario o correo electrónico.
        - Un campo para ingresar la contraseña.
        - Un botón de "Iniciar Sesión" para enviar las credenciales.
        - Un mensaje de bienvenida que diga "Bienvenido al Dashboard de KPIs" en la parte superior de la pantalla.
        - El diseño de la pantalla debe ser limpio y profesional, utilizando los colores corporativos de GM Transport.
        '''

