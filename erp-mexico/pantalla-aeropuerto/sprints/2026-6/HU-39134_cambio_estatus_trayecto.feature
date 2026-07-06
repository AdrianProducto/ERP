# language: es

Feature: HU-39134 Gestión de estatus por trayecto en el panel de detalle de la Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero agregar, modificar y eliminar estatus del historial de un trayecto seleccionado
  Para mantener el historial operativo actualizado y con la información correcta

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene permisos para cambiar estatus

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El panel inferior muestra el historial de estatus al seleccionar un trayecto
    # Dado
    Given que el listado muestra los trayectos disponibles
    # Cuando
    When el usuario selecciona un trayecto del listado
    # Entonces
    Then el sistema despliega el panel inferior con el historial de estatus de ese trayecto
    # Y
    And en la parte superior del panel se muestran los campos: Estatus, Fecha, Hora, selector de Trayecto y botón Agregar
    # Y
    And cada registro del historial muestra el estatus, fecha, hora, usuario y las opciones Modificar y Eliminar


  Scenario: El usuario modifica un estatus del historial
    # Dado
    Given que el historial del panel inferior contiene al menos un registro
    # Cuando
    When el usuario hace clic en Modificar de un registro
    # Entonces
    Then el sistema muestra un formulario con los campos: Estatus, Fecha, Hora, Comentario, Motivo de retraso y Estatus afectado
    # Y
    And el usuario puede editar los campos y confirmar con Aceptar o cancelar con Cancelar
    # Y
    And al aceptar, el registro se actualiza en el historial

  Scenario: El usuario elimina un estatus del historial
    # Dado
    Given que el historial del panel inferior contiene al menos un registro
    # Cuando
    When el usuario hace clic en Eliminar de un registro
    # Entonces
    Then el registro desaparece del historial de estatus del trayecto

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: No se puede agregar un estatus sin capturar los campos requeridos
    # Dado
    Given que el panel inferior está visible
    # Cuando
    When el usuario intenta agregar un estatus sin llenar los campos obligatorios
    # Entonces
    Then el sistema impide el registro e indica los campos requeridos
