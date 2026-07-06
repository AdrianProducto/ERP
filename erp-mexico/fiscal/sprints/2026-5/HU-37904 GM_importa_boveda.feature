Feature: Validar integración de GM Importa con la Bóveda Fiscal
  Como usuario de GM Fiscal
  Quiero ejecutar GM Importa usando la Bóveda
  Para asegurar correcta importación

  Background:
    # Dado
    Given que GM Importa está conectado a la Bóveda

  # ESCENARIO 1

  Scenario Outline: Importación exitosa
    # Dado
    Given que la respuesta es <respuesta_boveda>
    # Cuando
    When el usuario ejecuta GM Importa
    # Entonces
    Then el resultado es <resultado>

    Examples:
      | respuesta_boveda | resultado |
      | Válida           | Exitoso   |

  # ESCENARIO 2

  Scenario Outline: Errores en importación
    # Dado
    Given que la respuesta es <respuesta_boveda>
    # Cuando
    When el usuario ejecuta GM Importa
    # Entonces
    Then el sistema muestra <error>

    Examples:
      | respuesta_boveda | error          |
      | Vacía            | Sin datos      |
      | Error 500        | Error servicio |