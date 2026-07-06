# Característica
@Chat
Feature: Notificación de nuevo mensaje en el chat

  Como operador
  Quiero recibir una notificación cuando me manden un mensaje en el chat
  Para saber de qué viaje y trayecto es y poder responder

  # Antecedentes
  Background:
    # Dado
    Given que el operador tiene sesión iniciada en la App Móvil
    # Y
    And que tiene asignado el <viaje> con el <trayecto>

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: Llega un mensaje nuevo y el operador recibe una notificación
    # Dado
    Given que alguien envía un mensaje en el chat del <trayecto> del <viaje>
    # Cuando
    When el sistema detecta el mensaje nuevo
    # Entonces
    Then el operador recibe una notificación en su celular
    # Y
    And la notificación muestra el número de <viaje> y el <trayecto>

  Scenario: El operador toca la notificación y va directo al chat
    # Dado
    Given que el operador recibió una notificación de un mensaje nuevo
    # Cuando
    When toca la notificación
    # Entonces
    Then la App abre el chat del <trayecto> del <viaje>

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  Scenario: El operador tiene el chat abierto y no recibe notificación
    # Dado
    Given que el operador tiene abierto el chat del <trayecto> del <viaje> en su celular
    # Cuando
    When alguien más envía un mensaje en ese mismo chat
    # Entonces
    Then el sistema NO manda notificación porque el operador ya está viendo el chat

  Scenario: El operador no se notifica de sus propios mensajes
    # Dado
    Given que el operador está en el chat del <trayecto> del <viaje>
    # Cuando
    When el mismo operador escribe y envía un mensaje
    # Entonces
    Then el sistema NO manda ninguna notificación al operador

  Scenario: No llega notificación de un viaje que no es del operador
    # Dado
    Given que el <viaje> está asignado a otro operador
    # Cuando
    When alguien envía un mensaje en el chat de ese <viaje>
    # Entonces
    Then el operador actual NO recibe ninguna notificación
