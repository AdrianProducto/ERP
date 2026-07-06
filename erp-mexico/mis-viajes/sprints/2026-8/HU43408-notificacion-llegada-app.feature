# language: es

@mis-viajes @notificaciones @llegada @CH-439 @HU-43408
Característica: Envío de correo de notificación al registrar llegada del viaje
  Como operador de la app Mis Viajes
  Quiero que al registrar la llegada al destino se notifique automáticamente a los contactos del cliente
  Para que el cliente reciba confirmación de entrega en tiempo real

  Antecedentes:
    Dado que la aplicación Mis Viajes está en funcionamiento
    Y el operador ha iniciado sesión con credenciales válidas
    Y existe un viaje activo con trayecto en curso asignado al operador
    Y el operador ha cargado las evidencias del viaje

  Escenario: Correo enviado al registrar llegada cuando las notificaciones están habilitadas
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está activo
    Y el cliente del viaje tiene al menos un contacto con "RecibirNotificacionesMisViajes" habilitado
    Cuando el operador registra la llegada del trayecto
    Entonces el sistema registra la llegada exitosamente
    Y el sistema envía un correo HTML a cada contacto habilitado del cliente
    Y el correo contiene el número de viaje, origen, destino, nombre del operador y unidad
    Y el correo incluye las evidencias cargadas como documentos adjuntos
    Y el correo indica el estatus "Entregado"

  Escenario: No se envía correo cuando el parámetro de la empresa está inactivo
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está inactivo
    Cuando el operador registra la llegada del trayecto
    Entonces el sistema registra la llegada exitosamente
    Y el sistema no envía ningún correo de notificación

  Escenario: No se envía correo cuando ningún contacto del cliente tiene el parámetro habilitado
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está activo
    Y el cliente del viaje no tiene contactos con "RecibirNotificacionesMisViajes" habilitado
    Cuando el operador registra la llegada del trayecto
    Entonces el sistema registra la llegada exitosamente
    Y el sistema no envía ningún correo de notificación

  Escenario: La llegada se registra aunque el envío del correo falle
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está activo
    Y el cliente del viaje tiene contactos con "RecibirNotificacionesMisViajes" habilitado
    Y el servicio de correo no está disponible
    Cuando el operador registra la llegada del trayecto
    Entonces el sistema registra la llegada exitosamente
    Y el fallo del servicio de correo no revierte ni bloquea el registro de llegada

  Escenario: Llegada registrada en modo offline queda encolada localmente
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está activo
    Y el cliente del viaje tiene contactos con "RecibirNotificacionesMisViajes" habilitado
    Y el dispositivo no tiene conexión a internet
    Cuando el operador registra la llegada del trayecto
    Entonces el sistema encola el registro de llegada localmente
    Y el correo de notificación no se envía hasta que se recupere la conexión

  Escenario: Correo enviado al sincronizar llegada encolada tras recuperar conexión
    Dado que el parámetro "EnviarNotificacionesLlegada" de la empresa está activo
    Y el cliente del viaje tiene contactos con "RecibirNotificacionesMisViajes" habilitado
    Y existe un registro de llegada encolado pendiente de sincronización
    Cuando el dispositivo recupera la conexión a internet
    Entonces el sistema sincroniza el registro de llegada con el servidor
    Y el sistema envía el correo de notificación a los contactos habilitados del cliente
