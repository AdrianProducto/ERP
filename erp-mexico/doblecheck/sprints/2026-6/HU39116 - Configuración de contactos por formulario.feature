# Característica

Feature: Asignar y remover contactos destinatarios por formulario de inspección

  Como administrador de Doble Check
  Quiero asignar contactos específicos del ERP a cada tipo de formulario de un cliente
  Para que los resultados de inspección en PDF lleguen únicamente a las personas correctas

  # Antecedentes
  Background:
    # Dado
    Given que el administrador tiene sesión iniciada en Doble Check
    # Y
    And que se encuentra en la pantalla de "Reglas de Envío"
    # Y
    And que ha seleccionado un cliente 
    # Y
    And que visualiza los paneles individuales de cada formulario disponible

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El administrador añade un contacto activo con correo a un formulario
    # Dado
    Given que el administrador se encuentra en el panel del formulario "Revisión ocular de la unidad"
    # Cuando
    When hace clic en el botón "+ Añadir"
    # Entonces
    Then el sistema despliega el catálogo del ERP con los contactos asociados a ese cliente
    # Y
    And el administrador puede seleccionar a un contacto con correo registrado
    # Y
    And el contacto seleccionado aparece como etiqueta con su nombre en el panel del formulario

  Scenario: El administrador añade múltiples contactos al mismo formulario
    # Dado
    Given que el panel del formulario "Revisión ocular de la unidad" ya tiene un contacto asignado
    # Cuando
    When el administrador hace clic en "+ Añadir" y selecciona otro contacto con correo
    # Entonces
    Then el nuevo contacto se agrega a la lista de destinatarios del panel
    # Y
    And ambos contactos se muestran como etiquetas dentro del mismo panel de formulario

  Scenario: El administrador remueve un contacto de un formulario
    # Dado
    Given que el panel del formulario "Revisión ocular de la unidad" tiene contactos asignados
    # Cuando
    When el administrador hace clic en el ícono "X" de la etiqueta de un contacto
    # Entonces
    Then el contacto es removido de la lista de destinatarios de ese formulario
    # Y
    And los demás contactos permanecen intactos en el panel

  Scenario: El formulario sin contactos configurados muestra estado vacío
    # Dado
    Given que ningún contacto ha sido asignado al formulario "Formulario Auto - 3 Casillas"
    # Cuando
    When el administrador visualiza el panel de ese formulario
    # Entonces
    Then el panel del formulario muestra el mensaje "Sin destinatarios configurados"
    # Y
    And el botón "+ Añadir" está disponible para iniciar la asignación de contactos

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES) - CAMINOS TRISTES

  Scenario: El catálogo del ERP no tiene contactos disponibles para el cliente
    # Dado
    Given que el administrador hace clic en "+ Añadir" en un panel de formulario
    # Y
    And el cliente seleccionado no tiene contactos con correo registrado en el ERP
    # Cuando
    When el sistema consulta el catálogo del ERP
    # Entonces
    Then el sistema muestra el mensaje "No hay correos configurados"
    # Y
    And no se puede asignar ningún destinatario hasta que se actualice la información en el ERP
