Feature: Validar integración del Reporte RAMCI con la Bóveda Fiscal
  Como usuario de GM Fiscal
  Quiero consultar el reporte RAMCI
  Para validar datos correctamente

  Background:
    # Dado
    Given que el sistema está integrado con la Bóveda

  # ESCENARIO 1

  Scenario Outline: Consulta exitosa
    # Dado
    Given que el criterio es <criterio>
    # Cuando
    When se consulta el reporte
    # Entonces
    Then el resultado es <resultado>

    Examples:
      | criterio | resultado |
      | Periodo  | Exitoso   |

  # ESCENARIO 2

  Scenario Outline: Error en consulta
    # Dado
    Given que la respuesta es <respuesta>
    # Cuando
    When se consulta el reporte
    # Entonces
    Then el error es <error>

    Examples:
      | respuesta | error         |
      | Vacía     | Sin datos     |
      | Error 500 | Error sistema |