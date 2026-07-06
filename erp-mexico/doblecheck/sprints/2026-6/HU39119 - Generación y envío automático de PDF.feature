# Característica
@DobleCheck @Inspecciones @EnvioFormularios @GeneracionPDF
Feature: Generación y envío de PDF al finalizar una inspección

  Como operador de Doble Check
  Quiero que el sistema genere y envíe el PDF al guardar un formulario de inspección
  Para que los contactos del cliente reciban los resultados según la modalidad de envío configurada

  # Antecedentes
  Background:
    # Dado
    Given que el operador tiene sesión iniciada en Doble Check
    # Y
    And que el cliente tiene al menos un contacto configurado para el tipo de formulario que se está inspeccionando

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  @happy_path
  Scenario: El sistema genera el PDF al finalizar y guardar una inspección
    # Dado
    Given que la modalidad de envío del cliente está configurada como "Automático"
    # Y
    And que el operador ha completado todos los campos requeridos del formulario de inspección
    # Cuando
    When el operador hace clic en "Finalizar" y confirma el guardado del formulario
    # Entonces
    Then el sistema genera automáticamente el resultado de la inspección en formato PDF
    # Y
    And el PDF es enviado por correo electrónico como archivo adjunto a los contactos configurados

  @happy_path
  Scenario: El correo llega correctamente a los contactos configurados
    # Dado
    Given que la modalidad de envío del cliente está configurada como "Automático"
    # Y
    And que el sistema procesó el envío del PDF al finalizar la inspección
    # Cuando
    When el envío se completa sin errores
    # Entonces
    Then los contactos configurados reciben un correo con el PDF adjunto
    # Y
    And el asunto y cuerpo del correo identifican claramente la inspección correspondiente

  @happy_path
  Scenario: El sistema envía el PDF únicamente a los contactos del formulario específico
    # Dado
    Given que la modalidad de envío del cliente está configurada como "Automático"
    # Y
    And que el formulario "Revisión ocular de la unidad" tiene a "Juan Ramírez" como destinatario
    # Y
    And el formulario "C-TPAT" tiene a "Carlos Villanueva" como destinatario
    # Cuando
    When el operador finaliza una inspección del formulario "Revisión ocular de la unidad"
    # Entonces
    Then el sistema envía el PDF únicamente a "Juan Ramírez"
    # Y
    And "Carlos Villanueva" no recibe ningún correo de esa inspección

  @happy_path
  Scenario: El operador confirma el envío cuando la modalidad es Preguntar
    # Dado
    Given que la modalidad de envío del cliente está configurada como "Preguntar"
    # Cuando
    When el operador finaliza y guarda el formulario de inspección
    # Entonces
    Then el sistema muestra una alerta preguntando si desea enviar el PDF por correo
    # Y
    And si el operador confirma, el PDF es generado y enviado a los contactos configurados
    # Y
    And si el operador cancela, el PDF es generado pero no se envía ningún correo

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES) - CAMINOS TRISTES

  @validacion
  Scenario: El formulario finalizado no tiene contactos configurados para ese cliente
    # Dado
    Given que el cliente no tiene contactos asignados al formulario que se acaba de finalizar
    # Cuando
    When el sistema intenta procesar el envío del PDF
    # Entonces
    Then el sistema genera el PDF igualmente y lo almacena
    # Y
    And no se envía ningún correo
    # Y
    And el sistema registra en el historial de la inspección que no había destinatarios configurados