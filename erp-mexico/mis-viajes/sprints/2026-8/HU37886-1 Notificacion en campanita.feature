# language: es

@Chat @Notificaciones
Característica: Notificación de nuevo mensaje en la campanita

  Como operador
  Quiero ver una notificación en la campanita cuando me manden un mensaje en el chat
  Para saber que tengo mensajes pendientes sin leer

  Antecedentes:
    Dado que el operador tiene sesión iniciada en la App Móvil
    Y tiene asignado el <viaje> con el <trayecto>

  Escenario: Llega un mensaje nuevo y aparece en la campanita
    Dado que alguien envía un mensaje en el chat del <trayecto> del <viaje>
    Cuando el sistema detecta el mensaje nuevo
    Entonces aparece un indicador en la campanita con el número de mensajes sin leer
    Y la notificación muestra el número de <viaje> y el <trayecto>

  Escenario: El contador de la campanita se actualiza con cada mensaje nuevo
    Dado que la campanita ya tiene <n> notificaciones sin leer
    Cuando llega un mensaje nuevo en el chat del <trayecto> del <viaje>
    Entonces el contador de la campanita aumenta en 1

  Escenario: El operador tiene el chat abierto y la campanita no incrementa
    Dado que el operador tiene abierto el chat del <trayecto> del <viaje> en su celular
    Cuando alguien más envía un mensaje en ese mismo chat
    Entonces el sistema NO incrementa el contador de la campanita porque el operador ya está viendo el chat

  Escenario: Los propios mensajes del operador no generan notificación en la campanita
    Dado que el operador está en el chat del <trayecto> del <viaje>
    Cuando el mismo operador escribe y envía un mensaje
    Entonces el sistema NO incrementa el contador de la campanita

  Escenario: No aparece notificación de un viaje que no es del operador
    Dado que el <viaje> está asignado a otro operador
    Cuando alguien envía un mensaje en el chat de ese <viaje>
    Entonces la campanita del operador actual NO muestra ninguna notificación de ese <viaje>

  Esquema del escenario: La campanita refleja correctamente el conteo según el estado del chat
    Dado que el operador tiene el chat "<estado_chat>"
    Cuando llegan "<cantidad>" mensajes nuevos en el chat del <trayecto> del <viaje>
    Entonces la campanita muestra "<notificaciones_esperadas>" notificaciones

    Ejemplos:
      | estado_chat | cantidad | notificaciones_esperadas |
      | cerrado     | 1        | 1                        |
      | cerrado     | 3        | 3                        |
      | abierto     | 1        | 0                        |
      | abierto     | 3        | 0                        |
