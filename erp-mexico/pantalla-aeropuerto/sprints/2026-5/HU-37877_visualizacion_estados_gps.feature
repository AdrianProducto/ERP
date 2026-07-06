# language: es

Feature: HU-37877 Visualización de estados GPS en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero visualizar el estado del GPS de cada trayecto
  Para identificar rápidamente condiciones operativas o alertas

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que la pantalla muestra la columna de GPS

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Visualización correcta del estado GPS
    # Dado
    Given que el trayecto tiene estado GPS <estado_gps>
    # Cuando
    When el sistema carga el registro en pantalla
    # Entonces
    Then muestra <resultado_visual>

    Examples:
      | estado_gps | resultado_visual                       |
      | con señal  | el indicador visual de GPS activo      |
      | sin señal  | el indicador visual de GPS sin señal   |
      | SOS        | el indicador visual de alerta especial |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Manejo de estados GPS no reconocidos o sin dato
    # Dado
    Given que el trayecto tiene estado GPS <estado_gps>
    # Cuando
    When el sistema carga el registro en pantalla
    # Entonces
    Then el sistema responde con <resultado_esperado>

    Examples:
      | estado_gps  | resultado_esperado                                           |
      | vacío       | muestra comportamiento por defecto sin romper la pantalla    |
      | desconocido | muestra comportamiento por defecto sin romper la pantalla    |

  Scenario: Validar catálogo visual de estados GPS
    # Dado
    Given que el sistema carga la referencia de estados GPS
    # Cuando
    When se consulta el catálogo visual esperado
    # Entonces
    Then debe contemplar:
      """
      - Con señal
      - Sin señal
      - SOS o alerta especial
      """