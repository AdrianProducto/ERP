# Característica
@DobleCheck @Inspecciones @EnvioFormularios @ReenvioCorreo
Feature: Reenvío de PDF desde el menú de acciones de una inspección

  Como administrador o usuario autorizado de Doble Check
  Quiero poder reenviar el PDF de una inspección ya finalizada
  Para corregir casos en que el envío original no fue recibido o se requiere una nueva entrega

  # Antecedentes
  Background:
    # Dado
    Given que el usuario tiene sesión iniciada en Doble Check
    # Y
    And que existe una inspección finalizada con PDF generado
    # Y
    And que el cliente de esa inspección tiene al menos un contacto configurado para ese formulario

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  @happy_path
  Scenario: El usuario reenvía el PDF desde el menú de acciones de la inspección
    # Dado
    Given que el usuario localiza la inspección en el listado y abre su menú de acciones
    # Cuando
    When selecciona la opción "Reenviar PDF"
    # Entonces
    Then el sistema procesa nuevamente el envío del PDF a los contactos configurados del cliente
    # Y
    And muestra una notificación confirmando que el PDF fue reenviado exitosamente

  @happy_path
  Scenario: El sistema registra el reenvío como un evento adicional
    # Dado
    Given que el usuario ejecutó la acción "Reenviar PDF" sobre una inspección
    # Cuando
    When el sistema completa el reenvío
    # Entonces
    Then el sistema registra la acción de reenvío en el historial de la inspección
    # Y
    And el registro incluye fecha, hora y usuario que solicitó el reenvío

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES) - CAMINOS TRISTES

  @validacion
  Scenario: El usuario intenta reenviar pero el cliente no tiene contactos configurados
    # Dado
    Given que el cliente de la inspección no tiene contactos asignados a ese formulario
    # Cuando
    When el usuario selecciona "Reenviar PDF" desde el menú de acciones
    # Entonces
    Then el sistema muestra un mensaje de advertencia indicando que no hay destinatarios configurados
    # Y
    And sugiere ir a "Configuraciones > Envío de Formularios" para añadir contactos

