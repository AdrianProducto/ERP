# language: es

Feature: HU-37871 Registro de salida en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero registrar la salida de un trayecto
  Para dejar evidencia operativa del inicio del movimiento

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene permisos para operar trayectos

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Registro exitoso de salida
    # Dado
    Given que el trayecto tiene salida <estado_salida>
    # Y
    And que el estatus actual es <estatus_actual>
    # Cuando
    When el usuario intenta registrar la salida
    # Entonces
    Then el sistema responde con <resultado>
    # Y
    And actualiza el campo de salida <actualizacion_salida>

    Examples:
      | estado_salida | estatus_actual | resultado                           | actualizacion_salida       |
      | no registrada | Asignado       | la salida se registra correctamente | con fecha y hora capturada |
      | no registrada | Documentado    | la salida se registra correctamente | con fecha y hora capturada |
      | no registrada | Sin Salida     | la salida se registra correctamente | con fecha y hora capturada |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones para impedir registro inválido de salida
    # Dado
    Given que el trayecto tiene salida <estado_salida>
    # Y
    And que el estatus actual es <estatus_actual>
    # Y
    And que los permisos del usuario son <permisos>
    # Cuando
    When el usuario intenta registrar la salida
    # Entonces
    Then el sistema responde con <error_esperado>

    Examples:
      | estado_salida | estatus_actual | permisos      | error_esperado                                                |
      | registrada    | En Ruta        | válidos       | no permite registrar salida porque el trayecto ya tiene salida|
      | registrada    | Terminado      | válidos       | no permite registrar salida porque el trayecto ya tiene salida|
      | no registrada | Asignado       | insuficientes | bloquea la acción por falta de permisos                       |