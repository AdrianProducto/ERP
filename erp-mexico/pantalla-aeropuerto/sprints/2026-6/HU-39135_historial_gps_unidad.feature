# language: es

Feature: HU-39135 Acceso al historial de ubicaciones en ruta desde la Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero acceder al historial de ubicaciones de una unidad directamente desde la Pantalla Aeropuerto
  Para consultar la trayectoria GPS recorrida sin salir de la operación

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario se encuentra en la Pantalla Aeropuerto

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El usuario accede al historial GPS desde el hipervínculo de la unidad
    # Dado
    Given que el trayecto tiene salida registrada
    # Y
    And que la unidad del trayecto tiene GPS asignado
    # Cuando
    When el usuario hace clic en el hipervínculo de la unidad
    # Entonces
    Then el sistema abre la vista "Historial de ubicaciones en ruta"
    # Y
    And muestra la ruta trazada en el mapa con los datos GPS del trayecto
    # Y
    And el usuario puede regresar a la Pantalla Aeropuerto desde el botón "Regresar"

  Scenario: El sistema habilita el hipervínculo únicamente cuando el trayecto tiene salida registrada
    # Dado
    Given que el trayecto tiene salida registrada
    # Cuando
    When el sistema carga el registro en pantalla
    # Entonces
    Then la unidad se muestra como hipervínculo activo hacia el historial de ubicaciones en ruta

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: El sistema requiere salida registrada como condición para acceder al historial GPS
    # Dado
    Given que el trayecto no tiene salida registrada
    # Cuando
    When el sistema carga el registro en pantalla
    # Entonces
    Then el campo de unidad no se presenta como hipervínculo activo
    # Y
    And si el usuario intenta interactuar con el campo, el sistema informa que el trayecto no cuenta con historial GPS disponible

  @validacion
  Scenario: La unidad sin GPS asignado no presenta hipervínculo
    # Dado
    Given que la unidad del trayecto no tiene GPS asignado
    # Cuando
    When el sistema carga el registro en pantalla
    # Entonces
    Then el campo de unidad no muestra hipervínculo
    # Y
    And no permite acceder al historial de ubicaciones en ruta
