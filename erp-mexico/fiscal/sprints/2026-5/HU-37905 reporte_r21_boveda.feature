    Feature: Validar integración del Reporte R21 con la Bóveda Fiscal
  Como usuario de GM Fiscal
  Quiero consultar el reporte R21
  Para obtener resultados correctos

  Background:
    # Dado
    Given que el sistema está integrado con la Bóveda

  # ESCENARIO 1

  Scenario Outline: Generar reporte exitoso
    # Dado
    Given que el periodo es <periodo>
    # Cuando
    When se consulta el reporte
    # Entonces
    Then el resultado es <resultado>

    Examples:
      | periodo | resultado |
      | 2026-03 | Exitoso   |

  # ESCENARIO 2

  Scenario Outline: Error en reporte
    # Dado
    Given que la respuesta es <respuesta>
    # Cuando
    When se consulta el reporte
    # Entonces
    Then el error es <error>

    Examples:
      | respuesta | error            |
      | Vacía     | Sin datos        |
      | Timeout   | Error conexión   |