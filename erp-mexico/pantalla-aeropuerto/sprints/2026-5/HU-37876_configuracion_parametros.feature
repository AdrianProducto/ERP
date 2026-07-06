# language: es

Feature: HU-37876 Configuración de parámetros en la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero configurar los parámetros de comportamiento de la pantalla
  Para adaptar la vista a mis necesidades operativas

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene acceso al modal de parámetros

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Guardado exitoso de parámetros de configuración
    # Dado
    Given que el usuario configura <parametro>
    # Y
    And que el valor capturado es <valor_capturado>
    # Cuando
    When el usuario guarda la configuración
    # Entonces
    Then el sistema aplica <resultado_esperado>

    Examples:
      | parametro                        | valor_capturado          | resultado_esperado                                   |
      | Filtrar por grupo de unidades    | activo                   | el filtro queda aplicado conforme a la configuración |
      | Movimiento automático de páginas | activo                   | la pantalla habilita el cambio automático            |
      | Intervalo de cambio              | 3 minutos                | el sistema usa el intervalo configurado              |
      | Ordenar por                      | Más recientes            | la tabla se ordena por más recientes                 |
      | Ordenar por                      | Último cambio de estatus | la tabla se ordena por último cambio de estatus      |
      | Incluir unidades sin viaje       | activo                   | la pantalla incluye unidades sin viaje               |
      | Minutos por falta reporte GPS    | activo                   | se habilita la evaluación de tiempo GPS              |
      | Cantidad de minutos GPS          | 15                       | el sistema usa el umbral configurado                 |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Validaciones del modal de parámetros
    # Dado
    Given que el usuario configura <parametro>
    # Y
    And que el valor capturado es <valor_capturado>
    # Cuando
    When el usuario guarda la configuración
    # Entonces
    Then el sistema responde con <resultado_esperado>

    Examples:
      | parametro               | valor_capturado | resultado_esperado                           |
      | Intervalo de cambio     | vacío           | muestra mensaje de validación del intervalo  |
      | Intervalo de cambio     | 0               | muestra mensaje de validación del intervalo  |
      | Intervalo de cambio     | texto           | muestra mensaje de validación del intervalo  |
      | Cantidad de minutos GPS | vacío           | muestra mensaje de validación de minutos GPS |
      | Cantidad de minutos GPS | -5              | muestra mensaje de validación de minutos GPS |
      | Cantidad de minutos GPS | texto           | muestra mensaje de validación de minutos GPS |

  Scenario: Validar catálogo de parámetros configurables
    # Dado
    Given que el usuario abre el modal de parámetros
    # Cuando
    When el sistema carga la configuración disponible
    # Entonces
    Then el modal debe contemplar:
      """
      - Filtrar por grupo de unidades
      - Movimiento automático de páginas
      - Intervalo de cambio en minutos
      - Ordenar por
      - Incluir unidades sin viaje
      - Minutos por falta de reporte GPS
      - Cantidad de minutos para evaluación de GPS
      """