Feature: Nuevo Dashboard de KPIs para clientes como Administrador
    Yo como Administrador del Dashboard de KPIs,
    Quiero que se implemente un nuevo Dashboard de KPIs con funcionalidades de administración en los reportes de KPIs,
    Para que los usuarios puedan visualizar de manera clara y concisa los indicadores clave de desempeño relacionados.
    
  Background:
    Given que en el mení del sistema GM Transport ERP existe una opción para acceder a diferentes módulos
      And la opción para entrar a un dashboard de KPIs se habilita mediante el sistema de ADMON

  Scenario: Entrar al nuevo Dashboard de KPIs desde la pantalla de Login para el Administrador
    Given que el usuario se encuentra en la pantalla de Login del Dashboard de KPIs
      And el usuario ingresa sus credenciales válidas para acceder al Dashboard de KPIs
     When el usuario haga clic en el botón de "Iniciar Sesión"
     Then el sistema validará las credenciales ingresadas y, si son correctas, mostrará el nuevo Dashboard de KPIs con funcionalidades de administración para los reportes de KPIs
      And el usuario administrador tendrá la capacidad de crear y editar reportes
      And el usuario administrador podrá cambiar la vista de los elementos del dashboard de forma personalizada, podrá elegir entre una vista de tarjetas o una vista de lista
      And el usuario podrá configurar la foto de perfil que está ubicada en el header del dashboard
      And el usuario podrá ver que el dashboard de KPIs es responsivo, adaptándose a diferentes tamaños de pantalla para garantizar una experiencia de usuario óptima
      And el diseño del dashboard de KPIs será limpio y profesional, utilizando los colores corporativos de GM Transport, con un Header de color Naranja #FF9015, el logo de GM Transport y texto en color Blanco, y un fondo de color #F9FAFB
      And el dashboard de KPIs contará con un mensaje de bienvenida que diga "¡Bienvenido, "+NombreUsuario+"!" debajo del Header
      And el dashboard de KPIs contará con una barra de búsqueda dinámica para buscar los reportes de KPIs por nombre o categoría que pertenezca el reporte, ubicada en el centro del Dashboard, a la altura del mensaje de bienvenida al usuario
      And a lado de la barra de búsqueda, se tendrá un botón de "Filtros" que al hacer clic desplegará un menú lateral con opciones para filtrar el listado de reportes

