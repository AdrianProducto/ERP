# language: es
# ══════════════════════════════════════════════════════════════════════
#  🆘  HU-35074 · ENVÍO DE NOTIFICACIÓN SOS SIN INTERFAZ GPS
#  📱  Contexto: App Mis Viajes — Acción del Operador
#  📅  Sprint: Junio 2026
# ══════════════════════════════════════════════════════════════════════
#
#  Reglas clave:
#  · La campanita del ERP se dispara SIEMPRE al pulsar SOS (a todos los usuarios del cliente)
#  · El check "Enviar notificación SOS por correo" solo controla el envío de correo
#  · Sin señal: el SOS se encola y se envía al recuperar conexión
#  · Reintentos de correo: 3 intentos totales (1 original + 2 reintentos cada 30s)
#  · Sin ubicación disponible: el campo muestra "Sin información"
#  · Sin datos del viaje (operador/unidad): el campo muestra "Sin información"
# ══════════════════════════════════════════════════════════════════════

Feature: Envío de alerta SOS desde la app Mis Viajes
  Como operador de la app Mis Viajes
  Quiero poder enviar una alerta SOS aunque mi cliente no tenga GPS contratado
  Para que el equipo de tráfico sea notificado de inmediato ante cualquier emergencia

  Background:
    Given el operador tiene sesión activa en la app Mis Viajes
    And el operador tiene un viaje activo asignado

  # ══════════════════════════════════════════════════════════════════
  #  ✅  FLUJO PRINCIPAL — Alerta SOS disparada correctamente
  # ══════════════════════════════════════════════════════════════════

  Scenario: Operador pulsa SOS — cliente sin GPS, check de correo activo y correos configurados
    Given el cliente del viaje no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo en los parámetros del cliente
    And el cliente tiene al menos un correo SOS configurado
    And el celular del operador tiene ubicación disponible
    When el operador pulsa el botón SOS en la app
    Then el sistema envía una notificación a la campanita del ERP para todos los usuarios del cliente
    And el sistema envía un correo a todos los destinatarios configurados
    And el correo incluye: operador, número de viaje, origen, destino, trayecto, unidad y ubicación del celular

  Scenario: Operador pulsa SOS — cliente CON GPS, check de correo activo y correos configurados
    Given el cliente del viaje tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo en los parámetros del cliente
    And el cliente tiene al menos un correo SOS configurado
    When el operador pulsa el botón SOS en la app
    Then el sistema ejecuta el flujo GPS estándar al ERP
    And el sistema envía una notificación a la campanita del ERP para todos los usuarios del cliente
    And el sistema envía un correo a todos los destinatarios configurados con los datos del viaje

  Scenario: Correo incluye ubicación GPS y ubicación del celular cuando el cliente tiene GPS
    Given el cliente del viaje tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    And el celular del operador tiene ubicación disponible
    When el operador pulsa el botón SOS en la app
    Then el correo enviado incluye la ubicación GPS del vehículo
    And el correo también incluye la ubicación del celular del operador

  # ══════════════════════════════════════════════════════════════════
  #  🔀  FLUJOS ALTERNATIVOS — Variantes válidas del flujo principal
  # ══════════════════════════════════════════════════════════════════

  Scenario: Operador pulsa SOS — celular sin permiso de ubicación
    Given el cliente del viaje no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    And el celular del operador no tiene permiso de ubicación o el GPS del móvil está desactivado
    When el operador pulsa el botón SOS en la app
    Then el sistema envía una notificación a la campanita del ERP para todos los usuarios del cliente
    And el sistema envía el correo a los destinatarios configurados
    And el campo "Ubicación del celular" del correo muestra "Sin información"

  Scenario: Operador pulsa SOS — cliente con GPS pero sin señal GPS en ese momento
    Given el cliente del viaje tiene GPS configurado
    And el GPS del vehículo no tiene señal en ese momento
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    When el operador pulsa el botón SOS en la app
    Then el sistema envía una notificación a la campanita del ERP para todos los usuarios del cliente
    And el sistema envía el correo a los destinatarios configurados
    And el campo "Ubicación GPS" del correo muestra "Sin información"

  Scenario: Operador pulsa SOS — check de correo desactivado
    Given el cliente del viaje no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está desactivado
    When el operador pulsa el botón SOS en la app
    Then el sistema envía una notificación a la campanita del ERP para todos los usuarios del cliente
    And no se envía ningún correo

  Scenario: Operador pulsa SOS — check activo pero sin correos configurados
    Given el cliente del viaje no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente no tiene ningún correo SOS configurado
    When el operador pulsa el botón SOS en la app
    Then el sistema envía únicamente la notificación a la campanita del ERP para todos los usuarios del cliente
    And no se envía ningún correo

  Scenario: Operador pulsa SOS — viaje con datos incompletos
    Given el cliente no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    And el viaje no tiene operador o unidad asignados
    When el operador pulsa el botón SOS en la app
    Then el sistema envía la notificación a la campanita del ERP para todos los usuarios del cliente
    And el sistema envía el correo normalmente
    And los campos sin datos muestran el texto "Sin información"

  Scenario: Operador pulsa SOS varias veces seguidas
    Given el cliente no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    When el operador pulsa el botón SOS en la app 3 veces consecutivas
    Then el sistema genera 3 notificaciones independientes en la campanita del ERP
    And envía 3 correos a los destinatarios configurados

  # ══════════════════════════════════════════════════════════════════
  #  📶  SIN SEÑAL — Encolamiento y envío diferido
  # ══════════════════════════════════════════════════════════════════

  Scenario: Operador pulsa SOS sin señal de red — se encola y envía al recuperar conexión
    Given el operador no tiene señal de red en su celular
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    When el operador pulsa el botón SOS en la app
    Then la app registra la alerta SOS en la cola local del dispositivo
    And cuando el celular recupera la señal de red el SOS se envía automáticamente
    And el sistema envía la notificación a la campanita del ERP para todos los usuarios del cliente
    And el sistema envía el correo a los destinatarios configurados

  Scenario: Operador pulsa SOS varias veces sin señal — todas las alertas se envían al recuperar conexión
    Given el operador no tiene señal de red en su celular
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    When el operador pulsa el botón SOS en la app 3 veces consecutivas sin señal
    Then la app registra las 3 alertas SOS en la cola local del dispositivo
    And cuando el celular recupera la señal se envían las 3 alertas en orden
    And el sistema genera 3 notificaciones en la campanita del ERP
    And el sistema envía 3 correos a los destinatarios configurados

  # ══════════════════════════════════════════════════════════════════
  #  ❌  REINTENTOS Y ERRORES — Fallos en el envío de correo o campanita
  # ══════════════════════════════════════════════════════════════════

  Scenario: El envío de correo falla en el primer intento y tiene éxito en el segundo
    Given el cliente no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    And el servicio de correo está configurado para fallar en el primer intento
    When el operador pulsa el botón SOS en la app
    Then el sistema envía la notificación a la campanita del ERP correctamente
    And el sistema reintenta el envío del correo tras 30 segundos
    And el correo llega a los destinatarios en el segundo intento

  Scenario: El envío de correo falla en los 3 intentos totales
    Given el cliente no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    And el servicio de correo está configurado para fallar en los 3 intentos
    When el operador pulsa el botón SOS en la app
    Then el sistema envía la notificación a la campanita del ERP correctamente
    And el sistema reintenta el correo 2 veces adicionales con intervalo de 30 segundos
    And al agotar los 3 intentos aparece una notificación de error en la campanita del ERP indicando que el correo no pudo enviarse

  Scenario: La campanita del ERP falla al recibir la notificación SOS
    Given el cliente no tiene GPS configurado
    And el servicio de notificaciones del ERP no está disponible
    When el operador pulsa el botón SOS en la app
    Then el sistema registra el fallo en el log interno con los datos del viaje y el timestamp
    And el SOS queda registrado en el log aunque no haya podido notificarse al ERP

  Scenario: La campanita falla y el correo también falla simultáneamente
    Given el cliente no tiene GPS configurado
    And el check "Enviar notificación SOS por correo" está activo
    And el cliente tiene al menos un correo SOS configurado
    And el servicio de notificaciones del ERP no está disponible
    And el servicio de correo está configurado para fallar en los 3 intentos
    When el operador pulsa el botón SOS en la app
    Then el sistema registra ambos fallos en el log interno con los datos del viaje y el timestamp
