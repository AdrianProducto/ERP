Feature: Nuevo menú de Dashboard de KPIs para clientes como usuario
    Yo como Analista de Producto,
    Quiero que se cree un nuevo menú de Dashboard de KPIs en el sistema GM Transport ERP,
    Para que los usuarios puedan visualizar de manera clara y concisa los indicadores clave de desempeño relacionados con sus operaciones de transporte.

  Background:
    Given que en el menú del sistema GM Transport ERP existe una opción para acceder a diferentes módulos
      And la opción para entrar a un dashboard de KPIs se habilita mediante el sistema de ADMON

  Scenario: Entrar al nuevo menú de Dashboard de KPIs desde el menú del ERP
    Given que el usuario se encuentra dentro del sistema GM Transport ERP
      And el sistema tiene habilitado el módulo de KPIs en el listado de módulos
     When el usuario seleccione el módulo de KPIs para poder ingresar al dashboard
     Then el sistema mostrará el nuevo menú de KPIs en una nueva pestaña en el navegador
      And se generará un token de acceso para que se validen las credenciales del usuario que ingresó al ERP para poder acceder al dashboard de KPIs
      And el dashboard de KPIs contará con un nuevo diseño que tendrá las siguientes características:
      '''
      - Un Header con el título de "Dashboard KPIs" en el centro, el logo de GM Transport a la izquierda y la información del usuario a la derecha.
      - La información del usuario será el nombre del Cliente, el nombre del usuario y la foto de perfil de la empresa.
      - El color del Header será de color Naranja #FF9015 y el color del logo de GM Transport y texto serán de color Blanco.
      - Tendrá un mensaje de bienvenida que diga "¡Bienvenido, "+NombreUsuario+"!" debajo del Header.
      - El dashboard tendrá un fondo de color #F9FAFB. 
      - El Dashboard contará con una barra de búsqueda dinámica para buscar los reportes de KPIs por nombre o categoría que pertenezca el reporte. La barra se ubicará en el centro del Dashboard, a la altura del mensaje de bienvenida al usuario.
      - A lado de la barra de búsqueda, se tendrá un botón de "Filtros" que al hacer clic desplegará un menú lateral con opciones para filtrar el listado de reportes.
      - Un listado de reportes de KPIs que se mostrarán en forma de tarjetas por default debajo de la barra de búsqueda, cada tarjeta tendrá el nombre del reporte, una breve descripción, la categoría a la que pertenece el reporte y al seleccionarlo se abrirá el reporte en una nueva pestaña del navegador.
      - Habrá una opción para modificar la vista del listado de reportes, permitiendo a los usuarios elegir entre una vista de tarjetas o una vista de lista.
      - El dashboard de KPIs será responsivo, adaptándose a diferentes tamaños de pantalla para garantizar una experiencia de usuario óptima.
      '''

