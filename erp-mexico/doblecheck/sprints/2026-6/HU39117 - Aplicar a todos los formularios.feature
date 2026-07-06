# Característica
@DobleCheck @Configuraciones @EnvioFormularios @CopiarDestinatarios
Feature: Copiar destinatarios a formularios seleccionados

  Como administrador de Doble Check
  Quiero seleccionar los destinatarios del catálogo de forma masiva y copiarlos a los formularios que yo elija
  Para agilizar la configuración sin afectar formularios que no deben cambiar

  # Antecedentes
  Background:
    # Dado
    Given que el administrador tiene sesión iniciada en Doble Check
    # Y
    And que se encuentra en la pantalla de "Reglas de Envío"
    # Y
    And que ha seleccionado al cliente "TRANSPORTES LÓPEZ S.A. DE C.V."

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  @happy_path
  Scenario: El administrador selecciona todos los contactos del catálogo desde el formulario
    # Dado
    Given que el administrador se encuentra en el panel del formulario "Revisión ocular de la unidad"
    # Cuando
    When hace clic en el botón "Todos" ubicado en la cabecera de destinatarios del panel
    # Entonces
    Then el sistema añade todos los contactos disponibles del catálogo como destinatarios del formulario
    # Y
    And los contactos aparecen como etiquetas en el panel del formulario

  @happy_path
  Scenario: El administrador abre el modal para copiar destinatarios a formularios específicos
    # Dado
    Given que el panel del formulario "Revisión ocular de la unidad" tiene al menos un contacto asignado
    # Cuando
    When el administrador hace clic en el botón "Copiar a…" del panel
    # Entonces
    Then el sistema abre un modal que muestra los destinatarios actuales del formulario origen
    # Y
    And presenta una lista de los demás formularios del cliente con casillas de selección

  @happy_path
  Scenario: El administrador copia destinatarios a formularios seleccionados
    # Dado
    Given que el modal de copia está abierto con el formulario "Revisión ocular de la unidad" como origen
    # Y
    And el administrador selecciona el formulario "Formulario C-TPAT (Seguridad)" como destino
    # Cuando
    When hace clic en el botón "Copiar"
    # Entonces
    Then el sistema copia la lista de destinatarios únicamente al formulario "Formulario C-TPAT (Seguridad)"
    # Y
    And los demás formularios no seleccionados permanecen sin cambios
    # Y
    And el modal se cierra y el sistema muestra confirmación del copiado

  @happy_path
  Scenario: El administrador usa "Seleccionar todos" en el modal para copiar a todos los formularios
    # Dado
    Given que el modal de copia está abierto
    # Cuando
    When el administrador hace clic en "Seleccionar todos" dentro del modal
    # Entonces
    Then el sistema marca todos los formularios destino disponibles
    # Y
    And al confirmar, copia los destinatarios a todos los formularios del cliente

  @happy_path
  Scenario: La copia sobrescribe los contactos previos en los formularios destino seleccionados
    # Dado
    Given que el formulario "Formulario C-TPAT (Seguridad)" ya tiene asignado a "Carlos Villanueva"
    # Y
    And el administrador confirma la copia desde el formulario "Revisión ocular de la unidad"
    # Cuando
    When el sistema aplica la copia al formulario destino seleccionado
    # Entonces
    Then la lista de destinatarios del formulario "Formulario C-TPAT (Seguridad)" queda reemplazada por la del origen
    # Y
    And "Carlos Villanueva" ya no aparece como destinatario en ese formulario

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: El administrador intenta copiar desde un formulario sin destinatarios
    # Dado
    Given que el panel del formulario "Revisión ocular de la unidad" no tiene ningún contacto asignado
    # Cuando
    When el administrador hace clic en el botón "Copiar a…" del panel
    # Entonces
    Then el modal muestra un mensaje indicando que no hay destinatarios que copiar
    # Y
    And el botón "Copiar" permanece deshabilitado

  @validacion
  Scenario: El administrador intenta confirmar la copia sin seleccionar ningún formulario destino
    # Dado
    Given que el modal de copia está abierto con destinatarios disponibles
    # Y
    And el administrador desmarca todos los formularios destino
    # Cuando
    When hace clic en el botón "Copiar"
    # Entonces
    Then el sistema muestra un mensaje indicando que debe seleccionar al menos un formulario de destino
    # Y
    And no se realiza ningún cambio en los formularios

  @validacion
  Scenario: Solo existe un formulario disponible y el ícono de copiar no tiene destinos posibles
    # Dado
    Given que el cliente solo tiene un formulario habilitado en la plataforma
    # Cuando
    When el administrador hace clic en el ícono de copiar de ese formulario
    # Entonces
    Then el modal informa que no hay otros formularios disponibles como destino
