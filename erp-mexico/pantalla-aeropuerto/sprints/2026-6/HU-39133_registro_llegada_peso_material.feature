# language: es

Feature: HU-39133 Pestaña Peso por Material en el modal de registro de llegada

  Como monitorista u operador del módulo de tráfico
  Quiero registrar el peso de descarga por material al momento de dar llegada a un viaje
  Para capturar la información de peso por material antes de confirmar el fin del movimiento

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene permisos para operar trayectos

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El usuario visualiza la pestaña Peso por Material al registrar llegada
    # Dado
    Given que el parámetro "Permitir registrar peso descarga por material al terminar viaje" está activo
    # Y
    And que el parámetro "No descontar merma" está inactivo
    # Cuando
    When el usuario abre el modal de registro de llegada
    # Entonces
    Then el modal muestra la pestaña "Peso por Material" junto a "Información del viaje"
    # Y
    And el usuario puede registrar el peso de descarga por material antes de confirmar la llegada

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario Outline: La pestaña Peso por Material no se muestra cuando los parámetros no lo permiten
    # Dado
    Given que el parámetro "Permitir registrar peso descarga por material al terminar viaje" está <param_peso>
    # Y
    And que el parámetro "No descontar merma" está <param_merma>
    # Cuando
    When el usuario abre el modal de registro de llegada
    # Entonces
    Then la pestaña "Peso por Material" no se muestra en el modal

    Examples:
      | param_peso | param_merma |
      | inactivo   | inactivo    |
      | activo     | activo      |
      | inactivo   | activo      |
