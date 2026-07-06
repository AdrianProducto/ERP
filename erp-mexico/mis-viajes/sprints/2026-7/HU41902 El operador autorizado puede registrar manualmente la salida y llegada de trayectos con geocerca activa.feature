@salidaManualGeocerca
# HU41902: El operador autorizado puede registrar manualmente la salida y llegada de trayectos con geocerca activa
Feature: Permitir salida manual en trayectos con geocerca si el operador tiene derecho

  Historia de Usuario:
    Como operador autorizado con el derecho "Dar salida (manual)"
    Quiero poder registrar manualmente la salida o llegada de un trayecto que tiene geocerca configurada
    Para que las operaciones no se bloqueen cuando la geocerca falla o está mal configurada

  Contexto de negocio:
    Las geocercas pueden fallar por problemas de señal GPS, configuración incorrecta de coordenadas
    o zonas muertas en la ubicación del operador. En esos casos, el trayecto quedaría bloqueado
    indefinidamente sin poder registrar salida ni llegada. Para mitigar esto, se otorga a operadores
    específicos el derecho de hacer el registro de forma manual, dejando trazabilidad de que la acción
    fue una intervención humana sobre un trayecto con geocerca activa.

  # Nota técnica: la información de geocercas del trayecto vive en la tabla CatRutasTrayectos
  #               (campos IdGeocercaDisparaSalida, GeocercaDisparaSalidaES, entre otros).

  Antecedentes:
    Dado que estoy en la pantalla de trayectos
    Y veo un trayecto que aún no ha salido

  Escenario: Trayecto con geocerca SIN derecho manual - Botón bloqueado
    Dado que el trayecto tiene geocerca configurada
    Y el operador NO tiene derecho "Dar salida (manual)"
    Cuando veo el botón de acción primaria
    Entonces el botón está deshabilitado
    Y muestra el mensaje "No puedes dar salida manual - Geocerca activada"
    Y muestra el ícono de candado (Icons.lock_rounded)
    Y el color es rojo/error (AppColors.onCancelledContainer)

  Escenario: Trayecto con geocerca CON derecho manual - Botón habilitado con etiqueta
    Dado que el trayecto tiene geocerca configurada
    Y el operador SÍ tiene derecho "Dar salida (manual)"
    Y el operador puede registrar salida (puedeRegistrarSalida = true)
    Cuando veo el botón de acción primaria
    Entonces el botón está habilitado
    Y el label muestra "Registrar Salida (Geocerca)"
    Y el ícono es play_arrow_rounded
    Y el color es primario (AppColors.primary)

  Escenario: Trayecto SIN geocerca CON derecho manual - Botón normal
    Dado que el trayecto NO tiene geocerca configurada
    Y el operador SÍ tiene derecho "Dar salida (manual)"
    Y el operador puede registrar salida (puedeRegistrarSalida = true)
    Cuando veo el botón de acción primaria
    Entonces el botón está habilitado
    Y el label muestra "Registrar Salida"
    Y NO aparece el indicador "(Geocerca)"
    Y el ícono es play_arrow_rounded

  Escenario: Trayecto con geocerca SIN derecho manual - Prioridad 2 Solicitud Salida
    Dado que el trayecto tiene geocerca configurada
    Y el operador NO tiene derecho "Dar salida (manual)"
    Y el operador SÍ tiene derecho "Dar salida (solicitud)"
    Y el operador puede registrar salida (puedeRegistrarSalida = true)
    Cuando veo el botón de acción primaria
    Entonces el botón está deshabilitado
    Y muestra el mensaje "No puedes dar salida manual - Geocerca detectada"
    Y NO se muestra el botón de solicitud (geocerca bloquea todo)

  Escenario: Trayecto con geocerca - Registrar llegada CON derecho manual
    Dado que el trayecto tiene geocerca configurada
    Y el trayecto ya tiene salida registrada (fechaSalida != null)
    Y el operador NO tiene derecho "Dar salida (manual)"
    Y el operador SÍ tiene derecho "Dar llegada (manual)"
    Y el operador puede registrar llegada (puedeRegistrarLlegada = true)
    Cuando veo el botón de acción primaria
    Entonces el botón está habilitado
    Y el label muestra "Registrar Llegada (Geocerca)"
    Y el ícono es flag_rounded

  Escenario: Trayecto con geocerca - Llegada completada
    Dado que el trayecto tiene geocerca configurada
    Y el trayecto ya tiene salida y llegada registradas
    Cuando veo el botón de acción primaria
    Entonces el botón está deshabilitado
    Y muestra el mensaje "El trayecto es geocerca y ya se completó"
    Y muestra ícono de check_circle_rounded

  Escenario: Prioridad de acciones cuando hay geocerca
    Dado que el trayecto tiene geocerca configurada
    Y el operador tiene derechos: "Dar salida (manual)", "Dar salida (solicitud)"
    Cuando evalúo las prioridades de acción
    Entonces Prioridad 1: Registrar Salida (manual) - habilitada
    Y Prioridad 2: No evalúa solicitud (geocerca bloquea primero)
    Entonces se muestra "Registrar Salida (Geocerca)"