# language: es

@erp @mis-viajes @parametros @catalogo-clientes @CH-439 @HU-43408
Característica: Configuración en ERP para notificaciones de llegada de Mis Viajes
  Como administrador del ERP
  Quiero poder habilitar el envío de correos de llegada y configurar qué contactos los reciben
  Para controlar las notificaciones automáticas que genera la app Mis Viajes

  Escenario: Habilitar el envío de notificaciones de llegada a nivel empresa
    Dado que el administrador accede a los Parámetros de Configuración de Tráfico
    Cuando activa el parámetro "EnviarNotificacionesLlegada" en la pestaña Apps Móviles y guarda los cambios
    Entonces el parámetro "EnviarNotificacionesLlegada" queda persistido como activo en la configuración de la empresa

  Escenario: Deshabilitar el envío de notificaciones de llegada a nivel empresa
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está activo
    Cuando el administrador desactiva el parámetro en la pestaña Apps Móviles y guarda los cambios
    Entonces el parámetro "EnviarNotificacionesLlegada" queda persistido como inactivo en la configuración de la empresa

  Escenario: Habilitar "RecibirNotificacionesMisViajes" en un contacto del cliente
    Dado que existe un cliente con al menos un contacto registrado en el catálogo
    Cuando el administrador habilita el campo "RecibirNotificacionesMisViajes" en ese contacto y guarda
    Entonces el contacto queda marcado para recibir correos de notificación de llegada

  Escenario: Deshabilitar "RecibirNotificacionesMisViajes" en un contacto del cliente
    Dado que existe un contacto con el campo "RecibirNotificacionesMisViajes" habilitado
    Cuando el administrador deshabilita el campo en ese contacto y guarda
    Entonces el contacto queda marcado para no recibir correos de notificación de llegada

  Escenario: Solo los contactos con el parámetro activo son devueltos al consultar destinatarios
    Dado que un cliente tiene tres contactos registrados
    Y dos de ellos tienen "RecibirNotificacionesMisViajes" activo y uno no
    Cuando el backend de Mis Viajes consulta los contactos habilitados del cliente para notificaciones
    Entonces retorna únicamente los dos contactos con el parámetro activo
    Y el contacto sin el parámetro no aparece en el resultado
