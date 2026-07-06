Feature: Habilitar botón "Más Clientes" en la ventana de Factura por Viaje en listado de Viajes mediante derecho
    Yo como Analista del ERP,
    Quiero que se agregue un nuevo derecho para habilitar el botón "Más Clientes" en la ventana de Factura por Viaje en el listado de Viajes,
    Para que los usuarios puedan acceder a esta funcionalidad solo si tienen el derecho asignado.

  Scenario: Entrar al catálogo de derechos de usuario para consultar el nuevo derecho
    Given que el usuario está en el catálogo de derechos de usuario,
     When el usuario esté habilitando el derecho de facturar desde el listado de Viajes 
      And quiera consultar los derechos relacionados
     Then debe aparecer el nuevo derecho llamado "Más Clientes" como un derecho especial de ese proceso

  Scenario: Habilitar el nuevo derecho
    Given que el usuario está en el catálogo de derechos de usuario,
     When el usuario habilite el derecho "Más Clientes" para un perfil específico
     Then los usuarios con ese perfil podrán ver y utilizar el botón "Más Clientes" en la ventana de Factura por Viaje en el listado de Viajes

  Scenario: Dejar inhabilitado el nuevo derecho
    Given que el usuario está en el catálogo de derechos de usuario,
     When el usuario deje inhabilitado el derecho "Más Clientes" para un perfil específico
     Then los usuarios con ese perfil no podrán ver ni utilizar el botón "Más Clientes" en la ventana de Factura por Viaje en el listado de Viajes

