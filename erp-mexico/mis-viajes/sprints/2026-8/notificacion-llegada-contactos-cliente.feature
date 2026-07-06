# language: es

Feature: Notificación de entrega a contactos del cliente al registrar llegada
  Como operador de la aplicación Mis Viajes
  Quiero que al registrar la llegada de un trayecto se notifique por correo a los contactos del cliente
  Para que el cliente tenga visibilidad en tiempo real del estatus de entrega de su mercancía

  Background:
    Dado que la aplicación Mis Viajes está en funcionamiento
    Y el operador tiene sesión activa en la aplicación
    Y existe un viaje asignado al operador con trayecto en estatus "En tránsito"

  # ─────────────────────────────────────────────
  # FLUJO PRINCIPAL
  # ─────────────────────────────────────────────

  Escenario: Registro de llegada con notificación exitosa a contactos del cliente
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el viaje tiene el flag "Enviar a contactos" activo en el ERP
    Y el cliente tiene al menos un contacto con el check "Seguimiento de viajes" activado
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces el sistema registra la llegada del trayecto en el ERP exitosamente
    Y el sistema consulta el flag "Enviar a contactos" del viaje en el ERP
    Y el sistema obtiene la lista de contactos del cliente con "Seguimiento de viajes" activo
    Y el sistema envía un correo HTML a cada contacto con el estatus "Entregado"
    Y el correo incluye el folio del viaje, nombre del operador, origen, destino y descripción del trayecto
    Y el correo incluye la fecha y hora de llegada registrada
    Y el correo incluye las evidencias cargadas como archivos adjuntos
    Y la aplicación muestra al operador el mensaje "Llegada registrada correctamente"

  # ─────────────────────────────────────────────
  # PRECONDICIÓN: EVIDENCIAS
  # ─────────────────────────────────────────────

  Escenario: El operador intenta registrar la llegada sin haber cargado evidencias
    Dado que el operador no ha cargado las evidencias requeridas del viaje
    Cuando el operador intenta presionar el botón "Llegada" en la aplicación
    Entonces el sistema bloquea la acción de llegada
    Y la aplicación muestra el mensaje "Debes cargar las evidencias requeridas antes de registrar la llegada"
    Y no se registra llegada en el ERP
    Y no se envía ningún correo a los contactos del cliente

  # ─────────────────────────────────────────────
  # CONTROL DEL FLAG Y CONTACTOS
  # ─────────────────────────────────────────────

  Escenario: Registro de llegada cuando el flag "Enviar a contactos" está desactivado
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el viaje tiene el flag "Enviar a contactos" desactivado en el ERP
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces el sistema registra la llegada del trayecto en el ERP exitosamente
    Y el sistema consulta el flag "Enviar a contactos" del viaje en el ERP
    Y el sistema no envía ningún correo dado que el flag está desactivado
    Y la aplicación muestra al operador el mensaje "Llegada registrada correctamente"

  Escenario: Registro de llegada cuando el cliente no tiene contactos con seguimiento activo
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el viaje tiene el flag "Enviar a contactos" activo en el ERP
    Y el cliente no tiene contactos con el check "Seguimiento de viajes" activado
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces el sistema registra la llegada del trayecto en el ERP exitosamente
    Y el sistema obtiene una lista vacía de contactos con "Seguimiento de viajes"
    Y el sistema no envía ningún correo por falta de destinatarios
    Y la aplicación muestra al operador el mensaje "Llegada registrada correctamente"

  # ─────────────────────────────────────────────
  # RESILIENCIA Y REINTENTOS
  # ─────────────────────────────────────────────

  Escenario: Registro de llegada con fallo en el envío de correo por falta de red
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el viaje tiene el flag "Enviar a contactos" activo en el ERP
    Y el cliente tiene contactos con el check "Seguimiento de viajes" activado
    Y el servicio de correo no está disponible al momento de registrar la llegada
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces el sistema registra la llegada del trayecto en el ERP exitosamente
    Y el sistema encola el envío del correo para reintentarlo cuando haya conexión
    Y el sistema notifica al ERP que el correo quedó en estado "Pendiente"
    Y la aplicación muestra al operador el mensaje "Llegada registrada correctamente"
    Y el correo es enviado automáticamente cuando el servicio de correo se recupera

  Escenario: Envío de correo a múltiples contactos con algunos correos inválidos
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el viaje tiene el flag "Enviar a contactos" activo en el ERP
    Y el cliente tiene 3 contactos con "Seguimiento de viajes" activo
    Y uno de los contactos tiene una dirección de correo inválida o vacía
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces el sistema registra la llegada del trayecto en el ERP exitosamente
    Y el sistema envía el correo correctamente a los 2 contactos con correo válido
    Y el sistema omite el contacto con correo inválido sin bloquear el proceso
    Y la aplicación muestra al operador el mensaje "Llegada registrada correctamente"

  # ─────────────────────────────────────────────
  # DUPLICADOS
  # ─────────────────────────────────────────────

  Escenario: El operador intenta registrar llegada en un trayecto ya entregado
    Dado que el trayecto ya tiene una llegada registrada en el ERP
    Cuando el operador intenta presionar el botón "Llegada" nuevamente
    Entonces el sistema rechaza la operación
    Y la aplicación muestra el mensaje "Este trayecto ya tiene una llegada registrada"
    Y no se envía correo duplicado a los contactos del cliente

  # ─────────────────────────────────────────────
  # CONTENIDO DEL CORREO
  # ─────────────────────────────────────────────

  Escenario: Verificación del contenido y formato HTML del correo enviado
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el viaje tiene el flag "Enviar a contactos" activo en el ERP
    Y el cliente tiene contactos con el check "Seguimiento de viajes" activado
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces el sistema envía un correo con formato HTML con diseño visual
    Y el asunto del correo incluye el folio del viaje
    Y el cuerpo del correo muestra el nombre del operador
    Y el cuerpo del correo muestra el origen y destino del viaje
    Y el cuerpo del correo muestra la descripción del trayecto
    Y el cuerpo del correo muestra la fecha y hora de llegada registrada
    Y el cuerpo del correo muestra el estatus "Entregado"
    Y las evidencias están adjuntas al correo como archivos

  # ─────────────────────────────────────────────
  # ESQUEMA COMBINACIONES
  # ─────────────────────────────────────────────

  Esquema del escenario: Comportamiento según flag y disponibilidad de contactos
    Dado que el operador ha cargado todas las evidencias requeridas del viaje
    Y el flag "Enviar a contactos" en el ERP está "<flag_activo>"
    Y el cliente tiene "<num_contactos>" contactos con "Seguimiento de viajes" activo
    Cuando el operador presiona el botón "Llegada" en la aplicación
    Entonces la llegada queda registrada con resultado "<resultado_llegada>"
    Y el sistema "<accion_correo>"

    Ejemplos:
      | flag_activo | num_contactos | resultado_llegada | accion_correo                               |
      | activo      | 3             | exitoso           | envía correo a los 3 contactos              |
      | activo      | 0             | exitoso           | no envía correo por falta de contactos      |
      | desactivado | 3             | exitoso           | no envía correo porque el flag está apagado |
      | desactivado | 0             | exitoso           | no envía correo porque el flag está apagado |
