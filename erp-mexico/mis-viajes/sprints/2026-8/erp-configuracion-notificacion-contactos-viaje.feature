# language: es

Feature: Configuración de notificación a contactos del cliente en el ERP
  Como administrador del ERP
  Quiero configurar qué viajes envían notificación de entrega y qué contactos del cliente la reciben
  Para tener control granular sobre las notificaciones de seguimiento que se generan al registrar una llegada

  Background:
    Dado que el sistema ERP está en funcionamiento
    Y existe al menos un viaje registrado en el sistema
    Y existe al menos un cliente con contactos registrados

  # ─────────────────────────────────────────────
  # FLAG "ENVIAR A CONTACTOS" EN EL VIAJE
  # ─────────────────────────────────────────────

  Escenario: Activar el flag "Enviar a contactos" en un viaje
    Dado que existe un viaje con el flag "Enviar a contactos" desactivado
    Cuando el usuario activa el flag "Enviar a contactos" en el viaje
    Entonces el sistema guarda el cambio correctamente en la base de datos
    Y el viaje queda con el flag "Enviar a contactos" en estado activo
    Y el cambio queda registrado en la bitácora del sistema

  Escenario: Desactivar el flag "Enviar a contactos" en un viaje
    Dado que existe un viaje con el flag "Enviar a contactos" activado
    Cuando el usuario desactiva el flag "Enviar a contactos" en el viaje
    Entonces el sistema guarda el cambio correctamente en la base de datos
    Y el viaje queda con el flag "Enviar a contactos" en estado inactivo
    Y el cambio queda registrado en la bitácora del sistema

  Escenario: Consultar el flag "Enviar a contactos" de un viaje desde la API
    Dado que existe un viaje con el flag "Enviar a contactos" configurado
    Cuando la aplicación Mis Viajes consulta el viaje por su IdViaje
    Entonces la respuesta de la API incluye el campo "EnviarAContactos" con su valor actual
    Y el campo está disponible en el objeto del viaje o del trayecto

  # ─────────────────────────────────────────────
  # CHECK "SEGUIMIENTO DE VIAJES" EN CONTACTOS
  # ─────────────────────────────────────────────

  Escenario: Activar el check "Seguimiento de viajes" en un contacto del cliente
    Dado que existe un cliente con al menos un contacto registrado
    Y el contacto tiene el check "Seguimiento de viajes" desactivado
    Cuando el usuario activa el check "Seguimiento de viajes" en ese contacto
    Entonces el sistema guarda el cambio en la base de datos
    Y el contacto queda marcado para recibir notificaciones de entrega

  Escenario: Desactivar el check "Seguimiento de viajes" en un contacto del cliente
    Dado que existe un contacto del cliente con el check "Seguimiento de viajes" activado
    Cuando el usuario desactiva el check "Seguimiento de viajes" en ese contacto
    Entonces el sistema guarda el cambio en la base de datos
    Y el contacto deja de estar marcado para recibir notificaciones de entrega

  Escenario: El sistema valida que el contacto tenga correo electrónico antes de activar el check
    Dado que existe un contacto del cliente sin correo electrónico registrado
    Cuando el usuario intenta activar el check "Seguimiento de viajes" en ese contacto
    Entonces el sistema muestra una advertencia indicando que el contacto no tiene correo registrado
    Y permite guardar el check activo pero con la advertencia visible

  # ─────────────────────────────────────────────
  # CONSULTA DE CONTACTOS DESDE API
  # ─────────────────────────────────────────────

  Escenario: Consultar contactos del cliente con "Seguimiento de viajes" activo desde la API
    Dado que un cliente tiene 5 contactos registrados
    Y 3 de ellos tienen el check "Seguimiento de viajes" activado
    Cuando la aplicación Mis Viajes consulta los contactos del cliente por IdCliente
    Entonces la API devuelve únicamente los 3 contactos con "Seguimiento de viajes" activo
    Y cada contacto incluye al menos nombre y correo electrónico

  Escenario: La API devuelve lista vacía cuando ningún contacto tiene seguimiento activo
    Dado que un cliente tiene contactos pero ninguno con "Seguimiento de viajes" activo
    Cuando la aplicación Mis Viajes consulta los contactos del cliente por IdCliente
    Entonces la API devuelve una lista vacía
    Y el código de respuesta es 200 (no es un error)

  # ─────────────────────────────────────────────
  # NOTIFICACIÓN DE CORREO PENDIENTE
  # ─────────────────────────────────────────────

  Escenario: El ERP recibe notificación de correo pendiente por fallo en el envío
    Dado que un viaje registró llegada correctamente en el ERP
    Y el servicio de correo de Mis Viajes falló al intentar enviar la notificación
    Cuando la aplicación Mis Viajes notifica al ERP que el correo quedó pendiente de envío
    Entonces el ERP registra el evento de correo pendiente asociado al viaje
    Y el estado del correo queda como "Pendiente" en la bitácora del viaje
    Y es visible para el administrador en el ERP

  Escenario: El ERP actualiza el estado del correo a "Enviado" cuando el reintento es exitoso
    Dado que un viaje tiene un correo de notificación en estado "Pendiente"
    Cuando la aplicación Mis Viajes notifica al ERP que el correo fue enviado exitosamente en el reintento
    Entonces el ERP actualiza el estado del correo a "Enviado"
    Y registra la fecha y hora del envío exitoso en la bitácora del viaje

  Esquema del escenario: Combinaciones de flag y contactos que el ERP debe exponer correctamente
    Dado que el viaje tiene el flag "Enviar a contactos" en estado "<flag>"
    Y el cliente tiene "<contactos_con_seguimiento>" contactos con "Seguimiento de viajes" activo
    Cuando la aplicación Mis Viajes consulta la configuración de notificación del viaje
    Entonces la API devuelve flag "<flag>" y "<contactos_con_seguimiento>" contactos elegibles

    Ejemplos:
      | flag        | contactos_con_seguimiento |
      | activo      | 3                         |
      | activo      | 0                         |
      | desactivado | 3                         |
      | desactivado | 0                         |
