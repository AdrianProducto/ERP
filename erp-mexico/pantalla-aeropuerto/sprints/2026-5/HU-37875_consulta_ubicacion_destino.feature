# language: es

Feature: HU-37875 Consulta de ubicación destino en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero abrir la ubicación destino de un trayecto
  Para consultar su referencia geográfica en Google Maps

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que la pantalla muestra el campo de ubicación del trayecto

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Apertura exitosa de la ubicación destino
    # Dado
    Given que el trayecto cuenta con información de ubicación <datos_ubicacion>
    # Cuando
    When el usuario selecciona el enlace de ubicación destino
    # Entonces
    Then el sistema <resultado_apertura>

    Examples:
      | datos_ubicacion     | resultado_apertura                            |
      | coordenadas válidas | abre Google Maps con la ubicación del destino |
      | dirección válida    | abre Google Maps con la referencia de destino |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones cuando no existe información de ubicación
    # Dado
    Given que el trayecto cuenta con información de ubicación <datos_ubicacion>
    # Cuando
    When el usuario selecciona el enlace de ubicación destino
    # Entonces
    Then el sistema responde con <resultado_esperado>

    Examples:
      | datos_ubicacion | resultado_esperado                                         |
      | vacía           | informa que el trayecto no cuenta con ubicación disponible |
      | inválida        | informa que la ubicación no puede abrirse correctamente    |

  Scenario: Validar formato esperado para apertura de ubicación en mapas
    # Dado
    Given que el sistema genera el enlace para abrir la ubicación destino
    # Cuando
    When el sistema construye la URL de apertura
    # Entonces
    Then la estructura esperada puede considerar formatos como:
      """
      https://www.google.com/maps?q={lat},{lng}
      https://www.google.com/maps?q={direccion_destino}
      """