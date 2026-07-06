# language: es

Feature: HU-37873 Cambio de estatus en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero cambiar el estatus de un trayecto
  Para reflejar su situación operativa actual dentro de la pantalla

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene permisos para cambiar estatus

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Cambio exitoso de estatus desde la pantalla
    # Dado
    Given que el trayecto tiene el estatus actual <estatus_actual>
    # Cuando
    When el usuario selecciona el nuevo estatus <nuevo_estatus>
    # Entonces
    Then el sistema responde con <resultado>
    # Y
    And actualiza el indicador visual <indicador_visual>

    Examples:
      | estatus_actual | nuevo_estatus | resultado                            | indicador_visual          |
      | Asignado       | En Ruta       | el estatus se actualiza correctamente| conforme al nuevo estatus |
      | En Ruta        | Terminado     | el estatus se actualiza correctamente| conforme al nuevo estatus |
      | Documentado    | Retrasado     | el estatus se actualiza correctamente| conforme al nuevo estatus |
      | Retrasado      | Terminado     | el estatus se actualiza correctamente| conforme al nuevo estatus |
      | Sin Salida     | Asignado      | el estatus se actualiza correctamente| conforme al nuevo estatus |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones y restricciones del cambio de estatus
    # Dado
    Given que el trayecto tiene el estatus actual <estatus_actual>
    # Y
    And que los permisos del usuario son <permisos>
    # Cuando
    When el usuario intenta cambiar el estatus a <nuevo_estatus>
    # Entonces
    Then el sistema responde con <error_esperado>

    Examples:
      | estatus_actual | permisos      | nuevo_estatus | error_esperado                          |
      | En Ruta        | insuficientes | Terminado     | bloquea la acción por falta de permisos |
      | Terminado      | insuficientes | En Ruta       | bloquea la acción por falta de permisos |
      | Asignado       | insuficientes | Retrasado     | bloquea la acción por falta de permisos |

  Scenario: Validar catálogo visible de estatus en el modal
    # Dado
    Given que el usuario abre el modal de cambio de estatus
    # Cuando
    When el sistema carga las opciones disponibles
    # Entonces
    Then el catálogo visible debe contemplar:
      """
      - En Ruta
      - Terminado
      - Sin Salida
      - Retrasado
      - Documentado
      - Asignado
      """   