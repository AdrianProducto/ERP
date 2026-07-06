# Característica
@DobleCheck @Configuraciones @EnvioFormularios @ModalidadEnvio
Feature: Configuración de la modalidad de envío general para un cliente

  Como administrador de Doble Check
  Quiero definir una modalidad de envío predeterminada para los reportes de un cliente
  Para controlar si el PDF se enviará de forma automática o bajo confirmación del operador

  # Antecedentes
  Background:
    # Dado
    Given que el administrador tiene sesión iniciada en Doble Check
    # Y
    And que se encuentra en la pantalla de "Reglas de Envío"
    # Y
    And que ha seleccionado un cliente

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El toggle de modalidad se muestra con "Automático" activo por defecto
    # Dado
    Given que el administrador visualiza la barra de "Preferencias Generales"
    # Entonces
    Then el sistema muestra un toggle compacto con las opciones "Automático" y "Preguntar"
    # Y
    And la opción "Automático" aparece seleccionada por defecto

  Scenario: El administrador selecciona la modalidad Automático
    # Dado
    Given que el administrador visualiza el toggle de modalidad de envío
    # Cuando
    When hace clic en "Automático"
    # Entonces
    Then el sistema marca "Automático" como la opción activa en el toggle
    # Y
    And "Preguntar" queda visualmente inactivo

  Scenario: El administrador selecciona la modalidad Preguntar
    # Dado
    Given que el administrador visualiza el toggle de modalidad de envío
    # Cuando
    When hace clic en "Preguntar"
    # Entonces
    Then el sistema marca "Preguntar" como la opción activa en el toggle
    # Y
    And "Automático" queda visualmente inactivo

  Scenario: El sistema guarda automáticamente la modalidad al seleccionarla
    # Cuando
    When el administrador selecciona una modalidad en el toggle
    # Entonces
    Then el sistema guarda automáticamente la configuración para ese cliente sin necesidad de confirmar
    # Y
    And muestra una confirmación visual breve indicando que la selección fue guardada

  Scenario: La modalidad Automático se aplica al completar una inspección
    # Dado
    Given que el cliente tiene configurada la modalidad "Automático"
    # Y
    And que el operador finaliza y guarda un formulario de inspección
    # Cuando
    When el sistema procesa el cierre del formulario
    # Entonces
    Then el sistema genera el PDF automáticamente
    # Y
    And lo envía por correo a los contactos configurados sin mostrar ninguna alerta al operador

  Scenario: La modalidad Preguntar se aplica al completar una inspección
    # Dado
    Given que el cliente tiene configurada la modalidad "Preguntar"
    # Y
    And que el operador finaliza y guarda un formulario de inspección
    # Cuando
    When el sistema procesa el cierre del formulario
    # Entonces
    Then el sistema muestra una alerta al operador preguntando si desea enviar el PDF por correo
    # Y
    And el envío solo se realiza si el operador confirma la acción
