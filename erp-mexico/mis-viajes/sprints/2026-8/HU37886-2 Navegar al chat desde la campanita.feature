# language: es

@Chat @Notificaciones @Navegacion
Característica: Navegar al chat correspondiente desde la campanita

  Como operador
  Quiero tocar una notificación en la campanita y que me lleve directo al chat
  Para poder responder rápidamente sin buscar el viaje manualmente

  Antecedentes:
    Dado que el operador tiene sesión iniciada en la App Móvil
    Y tiene asignado el <viaje> con el <trayecto>
    Y la campanita tiene al menos una notificación sin leer del <trayecto> del <viaje>

  Escenario: El operador toca la campanita y ve la lista de notificaciones
    Cuando el operador toca la campanita
    Entonces se despliega la lista de notificaciones pendientes
    Y cada notificación muestra el número de <viaje> y el <trayecto> correspondiente

  Escenario: El operador selecciona una notificación y va directo al chat
    Dado que el operador abrió la lista de notificaciones desde la campanita
    Cuando toca la notificación del <trayecto> del <viaje>
    Entonces la App abre el chat del <trayecto> del <viaje>
    Y el contador de la campanita se reduce en 1

  Escenario: Al entrar al chat desde la notificación los mensajes se marcan como leídos
    Dado que el operador navegó al chat desde la campanita
    Cuando visualiza el chat del <trayecto> del <viaje>
    Entonces los mensajes nuevos se marcan como leídos
    Y la notificación desaparece de la campanita

  Escenario: La notificación no lleva al chat de otro viaje
    Dado que la campanita tiene notificaciones de varios viajes
    Cuando el operador toca la notificación del <trayecto> del <viaje>
    Entonces la App abre únicamente el chat del <trayecto> del <viaje> correspondiente a esa notificación
    Y NO abre ni muestra el chat de otro <viaje>

  Esquema del escenario: La campanita navega al chat correcto según el viaje seleccionado
    Dado que la campanita tiene notificaciones de los viajes "<viaje_a>" y "<viaje_b>"
    Cuando el operador toca la notificación de "<viaje_seleccionado>"
    Entonces la App abre el chat de "<viaje_seleccionado>"
    Y NO muestra el chat de "<viaje_ignorado>"

    Ejemplos:
      | viaje_a | viaje_b | viaje_seleccionado | viaje_ignorado |
      | V-001   | V-002   | V-001              | V-002          |
      | V-001   | V-002   | V-002              | V-001          |
