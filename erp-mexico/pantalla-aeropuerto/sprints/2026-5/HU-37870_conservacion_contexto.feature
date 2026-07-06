# language: es

Feature: HU-37870 Conservación de contexto en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero que la pantalla conserve mi contexto actual después de operar registros
  Para no perder tiempo regresando a la página inicial ni reaplicando filtros

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario se encuentra operando registros en la Pantalla Aeropuerto

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Conservación exitosa del contexto después de una acción
    # Dado
    Given que el usuario está en la página <pagina_actual>
    # Y
    And que tiene aplicada la búsqueda <busqueda>
    # Y
    And que tiene aplicado el orden <orden>
    # Cuando
    When el usuario ejecuta la acción <accion>
    # Entonces
    Then el sistema conserva la página <pagina_actual>
    # Y
    And conserva la búsqueda <busqueda>
    # Y
    And conserva el orden <orden>
    # Y
    And actualiza únicamente <alcance_actualizacion>

    Examples:
      | pagina_actual | busqueda | orden                    | accion                    | alcance_actualizacion      |
      | 2             | Jorge    | Más recientes            | registrar salida          | la fila o datos necesarios |
      | 3             | T-017    | Último cambio de estatus | registrar llegada         | la fila o datos necesarios |
      | 2             | VJ-2025  | Más recientes            | cambiar estatus           | la fila o datos necesarios |
      | 1             | Cliente  | Más recientes            | actualizar manualmente    | los datos de la pantalla   |
      | 2             | Ruta     | Último cambio de estatus | guardar parámetros        | la vista conforme al ajuste|

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Comportamientos no permitidos sobre el contexto de navegación
    # Dado
    Given que el usuario está en la página <pagina_actual>
    # Y
    And que tiene aplicada la búsqueda <busqueda>
    # Y
    And que tiene aplicado el orden <orden>
    # Cuando
    When el usuario ejecuta la acción <accion>
    # Entonces
    Then el sistema no debe <comportamiento_no_permitido>

    Examples:
      | pagina_actual | busqueda | orden                    | accion                 | comportamiento_no_permitido                              |
      | 2             | Jorge    | Más recientes            | registrar salida       | regresar automáticamente a la página 1                  |
      | 3             | T-017    | Último cambio de estatus | registrar llegada      | limpiar la búsqueda aplicada sin intervención del usuario|
      | 2             | VJ-2025  | Más recientes            | cambiar estatus        | reiniciar el criterio de ordenamiento                   |
      | 1             | Cliente  | Más recientes            | actualizar manualmente | perder el contexto actual de navegación                 |