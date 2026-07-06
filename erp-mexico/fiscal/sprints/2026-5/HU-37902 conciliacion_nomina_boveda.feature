        Feature: Validar integración de Conciliación de Nómina con la Bóveda Fiscal
  Como usuario de GM Fiscal
  Quiero ejecutar la conciliación de Nómina usando la Bóveda Fiscal
  Para validar correctamente la información fiscal

  Background:
    # Dado
    Given que GM Fiscal está integrado con la Bóveda Fiscal

  # ESCENARIO 1: LO QUE SÍ PASA

  Scenario Outline: Conciliación de nómina exitosa
    # Dado
    Given que el periodo es <periodo>
    # Y
    And la respuesta de la Bóveda es <respuesta_boveda>
    # Cuando
    When el usuario ejecuta la conciliación
    # Entonces
    Then el sistema muestra <resultado>

    Examples:
      | periodo | respuesta_boveda | resultado       |
      | 2026-03 | Válida           | Coincidencias   |
      | 2026-03 | Válida           | Diferencias     |

  # ESCENARIO 2: ERRORES

  Scenario Outline: Errores en conciliación de nómina
    # Dado
    Given que la respuesta es <respuesta_boveda>
    # Cuando
    When se ejecuta la conciliación
    # Entonces
    Then el sistema muestra <error>

    Examples:
      | respuesta_boveda | error                    |
      | Vacía            | Sin información          |
      | Timeout          | Error comunicación       |