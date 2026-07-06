# language: es

Feature: HU-37869 Búsqueda de registros en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero buscar trayectos por diferentes criterios
  Para localizar rápidamente un viaje dentro de la operación

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario se encuentra dentro de la nueva Pantalla Aeropuerto

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Búsqueda exitosa de trayectos
    # Dado
    Given que existen registros con criterio <criterio_busqueda>
    # Cuando
    When el usuario captura <texto_busqueda> en el buscador general
    # Entonces
    Then el sistema muestra <resultado_busqueda>
    # Y
    And mantiene la pantalla operativa <estado_pantalla>

    Examples:
      | criterio_busqueda | texto_busqueda | resultado_busqueda                                         | estado_pantalla |
      | viaje             | VJ-2025-017    | los registros que coinciden con el número de viaje         | estable         |
      | unidad            | T-017          | los registros que coinciden con la unidad                  | estable         |
      | operador          | Jorge          | los registros que coinciden con el operador                | estable         |
      | cliente           | Electrónica    | los registros que coinciden con el cliente                 | estable         |
      | ruta              | Querétaro      | los registros que coinciden con origen o destino           | estable         |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones de búsqueda sin coincidencias
    # Dado
    Given que el usuario tiene registros visibles en pantalla
    # Cuando
    When el usuario captura <texto_busqueda> en el buscador general
    # Entonces
    Then el sistema responde con <resultado_esperado>
    # Y
    And conserva la operación general <estado_pantalla>

    Examples:
      | texto_busqueda | resultado_esperado                                            | estado_pantalla |
      | XYZ###         | no muestra coincidencias y no genera error del sistema        | estable         |
      |                | muestra el listado completo o sin filtro aplicado             | estable         |
      | @@##$$         | no muestra coincidencias y mantiene el comportamiento normal  | estable         |