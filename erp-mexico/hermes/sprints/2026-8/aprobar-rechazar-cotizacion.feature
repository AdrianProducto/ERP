# language: es

@hermes @sprint-2026-8
Feature: Aprobar y rechazar cotización
  Como usuario autenticado en Hermes
  Quiero aprobar o rechazar una cotización
  Para registrar la decisión y retroalimentar a la IA

  Background:
    Dado que el usuario está autenticado en la aplicación
    Y existe una cotización con estado "pendiente" y una respuesta generada por la IA

  # ─────────────────────────────────────────
  # MODAL DE APROBACIÓN
  # ─────────────────────────────────────────

  @aprobacion @modal
  Escenario: El modal de aprobación muestra la leyenda de inserción en Zoho
    Dado que la cotización tiene RequirementID "#38726"
    Cuando el usuario hace clic en el botón "Aprobar Cotización"
    Entonces se muestra el modal con título "Aprobar cotización"
    Y el modal muestra la leyenda "Al aprobar, las horas estimadas serán insertadas en Zoho"
    Y se muestra el campo "Comentario (opcional)"
    Y se muestran los botones "Cancelar" y "Aprobar Cotización"

  @aprobacion @validacion
  Escenario: No se puede abrir el modal de aprobación sin RequirementID
    Dado que la cotización no tiene RequirementID asignado
    Cuando el usuario hace clic en el botón "Aprobar Cotización"
    Entonces el sistema muestra el mensaje "No es posible aprobar: la cotización no tiene número de requerimiento (#)"
    Y no se abre el modal de aprobación
    Y la cotización mantiene el estado "pendiente"

  @aprobacion @modal
  Escenario: Cancelar aprobación desde el modal
    Dado que la cotización tiene RequirementID "#38726"
    Cuando el usuario hace clic en "Aprobar Cotización"
    Y hace clic en "Cancelar" dentro del modal
    Entonces el modal se cierra
    Y la cotización mantiene el estado "pendiente"

  # ─────────────────────────────────────────
  # FLUJO EXITOSO DE APROBACIÓN
  # ─────────────────────────────────────────

  @aprobacion @smoke
  Escenario: Aprobar cotización exitosamente
    Dado que la cotización tiene RequirementID "#38726"
    Cuando el usuario confirma la aprobación en el modal
    Entonces la cotización queda con estado "aprobada"
    Y se muestra el mensaje de confirmación al usuario

  @aprobacion @modal
  Escenario: Aprobar cotización con comentario opcional
    Dado que la cotización tiene RequirementID "#38726"
    Cuando el usuario escribe "Aprobado por el cliente vía correo" en el campo de comentario
    Y confirma la aprobación en el modal
    Entonces la cotización queda con estado "aprobada"
    Y el comentario queda guardado en la cotización

  @aprobacion @validacion
  Escenario: No se puede aprobar una cotización ya aprobada
    Dado que la cotización tiene estado "aprobada"
    Entonces el botón "Aprobar Cotización" no está disponible
    Y se muestra el estado actual "aprobada" en la pantalla

  # ─────────────────────────────────────────
  # MODAL DE RECHAZO
  # ─────────────────────────────────────────

  @rechazo @modal
  Escenario: El modal de rechazo muestra el campo de motivo obligatorio
    Cuando el usuario hace clic en el botón "Rechazar Cotización"
    Entonces se muestra el modal con título "Rechazar cotización"
    Y se muestra el texto "Por favor selecciona el motivo del rechazo"
    Y se muestra el campo obligatorio "Motivo del rechazo" con la opción por defecto "Selecciona un motivo..."
    Y se muestra el campo opcional "Comentario" con placeholder "Agrega detalles adicionales sobre el rechazo..."
    Y se muestran los botones "Cancelar" y "Rechazar Cotización"

  @rechazo @modal
  Escenario: El dropdown de motivo muestra todas las opciones disponibles
    Cuando el usuario hace clic en "Rechazar Cotización"
    Y abre el dropdown "Motivo del rechazo"
    Entonces se muestran exactamente las siguientes opciones:
      | Rechazado por el cliente |
      | Precio no competitivo    |
      | Tiempo de entrega        |
      | Falla de IA              |
      | Información incompleta   |
      | Fuera del alcance        |
      | Otro                     |

  @rechazo @modal
  Escenario: Cancelar rechazo desde el modal
    Cuando el usuario hace clic en "Rechazar Cotización"
    Y hace clic en "Cancelar" dentro del modal
    Entonces el modal se cierra
    Y la cotización mantiene el estado "pendiente"

  @rechazo @validacion
  Escenario: No se puede rechazar sin seleccionar un motivo
    Cuando el usuario hace clic en "Rechazar Cotización"
    Y hace clic en "Rechazar Cotización" en el modal sin seleccionar motivo
    Entonces el campo "Motivo del rechazo" muestra el error de validación
    Y el modal permanece abierto
    Y la cotización no cambia de estado

  # ─────────────────────────────────────────
  # FLUJO EXITOSO DE RECHAZO
  # ─────────────────────────────────────────

  @rechazo @smoke
  Escenario: Rechazar cotización con motivo obligatorio solamente
    Cuando el usuario hace clic en "Rechazar Cotización"
    Y selecciona el motivo "Falla de IA"
    Y hace clic en "Rechazar Cotización" en el modal
    Entonces la cotización queda con estado "rechazada"
    Y el motivo "Falla de IA" queda guardado en la cotización
    Y se muestra un mensaje de confirmación al usuario

  @rechazo @modal
  Escenario: Rechazar cotización con motivo y comentario adicional
    Cuando el usuario hace clic en "Rechazar Cotización"
    Y selecciona el motivo "Precio no competitivo"
    Y escribe "El cliente esperaba un costo menor al 50% del cotizado" en el campo Comentario
    Y hace clic en "Rechazar Cotización" en el modal
    Entonces la cotización queda con estado "rechazada"
    Y el motivo "Precio no competitivo" queda guardado en la cotización
    Y el comentario queda guardado en la cotización

  @rechazo @validacion
  Escenario: No se puede rechazar una cotización ya rechazada
    Dado que la cotización tiene estado "rechazada"
    Entonces el botón "Rechazar Cotización" no está disponible
    Y se muestra el estado actual "rechazada" con el motivo registrado

  @rechazo @validacion
  Escenario: No se puede rechazar una cotización ya aprobada
    Dado que la cotización tiene estado "aprobada"
    Entonces el botón "Rechazar Cotización" no está disponible
    Y se muestra el estado actual "aprobada" en la pantalla

  # ─────────────────────────────────────────
  # ENTRENAMIENTO DE LA IA (SEGUNDO PLANO)
  # ─────────────────────────────────────────

  @entrenamiento-ia @aprobacion
  Escenario: Se envía feedback a la IA cuando una cotización es aprobada
    Dado que la cotización tiene estado "pendiente"
    Cuando el usuario aprueba la cotización
    Entonces el sistema envía en segundo plano al endpoint de entrenamiento:
      | campo            | valor                                           |
      | decision         | aprobada                                        |
      | pregunta_usuario | (contenido de la cotización)                    |
      | respuesta_ia     | (respuesta generada por IA)                     |
      | comentario       | (comentario del usuario si existe, vacío si no) |
    Y el usuario no percibe ninguna espera adicional por este envío
    Y la cotización queda con estado "aprobada" independientemente del resultado del envío

  @entrenamiento-ia @rechazo
  Escenario: Se envía feedback a la IA cuando una cotización es rechazada
    Dado que la cotización tiene estado "pendiente"
    Cuando el usuario rechaza la cotización con motivo "Falla de IA"
    Entonces el sistema envía en segundo plano al endpoint de entrenamiento:
      | campo            | valor                                           |
      | decision         | rechazada                                       |
      | motivo_rechazo   | Falla de IA                                     |
      | pregunta_usuario | (contenido de la cotización)                    |
      | respuesta_ia     | (respuesta generada por IA)                     |
      | comentario       | (comentario del usuario si existe, vacío si no) |
    Y el usuario no percibe ninguna espera adicional por este envío
    Y la cotización queda con estado "rechazada" independientemente del resultado del envío

  @entrenamiento-ia @reintentos
  Escenario: El sistema reintenta silenciosamente si el endpoint de IA falla
    Dado que la cotización acaba de ser aprobada o rechazada
    Y el endpoint de entrenamiento de la IA no está disponible
    Entonces el sistema programa reintentos automáticos en segundo plano:
      | intento | espera antes de reintentar |
      | 1       | 5 minutos                  |
      | 2       | 15 minutos                 |
      | 3       | 30 minutos                 |
    Y el usuario no recibe ninguna notificación ni alerta sobre los reintentos
    Y el estado de la cotización no cambia durante los reintentos

  @entrenamiento-ia @reintentos
  Escenario: El sistema abandona silenciosamente tras agotar los reintentos con la IA
    Dado que la cotización acaba de ser aprobada o rechazada
    Y el endpoint de entrenamiento falló en los 3 reintentos automáticos
    Entonces el sistema registra el fallo en el log interno de Hermes
    Y no muestra ningún error al usuario
    Y el estado de la cotización permanece sin cambios

  # ─────────────────────────────────────────
  # ESQUEMAS
  # ─────────────────────────────────────────

  @rechazo @smoke
  Esquema del escenario: Todos los motivos de rechazo son válidos
    Cuando el usuario hace clic en "Rechazar Cotización"
    Y selecciona el motivo "<motivo>"
    Y hace clic en "Rechazar Cotización" en el modal
    Entonces la cotización queda con estado "rechazada"
    Y el motivo "<motivo>" queda guardado correctamente

    Ejemplos:
      | motivo                   |
      | Rechazado por el cliente |
      | Precio no competitivo    |
      | Tiempo de entrega        |
      | Falla de IA              |
      | Información incompleta   |
      | Fuera del alcance        |
      | Otro                     |

  @entrenamiento-ia @rechazo
  Esquema del escenario: El motivo de rechazo se transmite correctamente al endpoint de entrenamiento
    Dado que la cotización tiene estado "pendiente"
    Cuando el usuario rechaza la cotización con motivo "<motivo>"
    Entonces el payload enviado al endpoint de entrenamiento contiene motivo_rechazo igual a "<motivo>"

    Ejemplos:
      | motivo                   |
      | Rechazado por el cliente |
      | Precio no competitivo    |
      | Tiempo de entrega        |
      | Falla de IA              |
      | Información incompleta   |
      | Fuera del alcance        |
      | Otro                     |
