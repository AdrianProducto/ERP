# language: es

Feature: HU-37872 Registro de llegada en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero registrar la llegada de un trayecto
  Para dejar evidencia operativa del fin del movimiento

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene permisos para operar trayectos

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Registro exitoso de llegada
    # Dado
    Given que el trayecto tiene salida <estado_salida>
    # Y
    And que el trayecto tiene llegada <estado_llegada>
    # Cuando
    When el usuario intenta registrar la llegada
    # Entonces
    Then el sistema responde con <resultado>
    # Y
    And actualiza el campo de llegada <actualizacion_llegada>

    Examples:
      | estado_salida | estado_llegada | resultado                            | actualizacion_llegada    |
      | registrada    | no registrada  | la llegada se registra correctamente | con fecha y hora capturada |
      | registrada    | no registrada  | la fila queda actualizada correctamente | con fecha y hora capturada |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones para impedir registro inválido de llegada
    # Dado
    Given que el trayecto tiene salida <estado_salida>
    # Y
    And que el trayecto tiene llegada <estado_llegada>
    # Y
    And que los permisos del usuario son <permisos>
    # Cuando
    When el usuario intenta registrar la llegada
    # Entonces
    Then el sistema responde con <error_esperado>

    Examples:
      | estado_salida | estado_llegada | permisos      | error_esperado                                                           |
      | no registrada | no registrada  | válidos       | no permite registrar llegada porque el trayecto no tiene salida previa   |
      | registrada    | registrada     | válidos       | no permite registrar llegada porque el trayecto ya cuenta con llegada    |
      | registrada    | no registrada  | insuficientes | bloquea la acción por falta de permisos                                  |