# language: es

Feature: HU-37686 Listado y carga inicial de la Nueva Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero visualizar la nueva Pantalla Aeropuerto con los trayectos documentados
  Para consultar la operación en tiempo real desde una vista clara y funcional

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y0Z
    And que el usuario tiene acceso a la Pantalla Aeropuerto
    # Y
    And que existen trayectos previamente documentados para consulta

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: Carga correcta del listado inicial de trayectos
    # Dado
    Given que existen registros con <volumen_registros>
    # Cuando
    When el usuario ingresa a la nueva Pantalla Aeropuerto
    # Entonces
    Then el sistema muestra <resultado_listado>
    # Y
    And muestra la paginación <paginacion>
    # Y
    And muestra el reloj en tiempo real <reloj>
    # Y
    And muestra el botón de actualización manual <refresh>
    # Y
    And muestra el botón de parámetros <parametros>

    Examples:
      | volumen_registros   | resultado_listado                                                      | paginacion | reloj   | refresh | parametros |
      | pocos registros     | la tabla operativa con los registros disponibles                       | visible    | visible | visible | visible    |
      | múltiples registros | la tabla operativa con los registros distribuidos en varias páginas    | visible    | visible | visible | visible    |
      | datos parciales     | la tabla operativa mostrando los campos disponibles sin bloquear carga | visible    | visible | visible | visible    |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  Scenario Outline: Restricciones de acceso o activación de la nueva pantalla
    # Dado
    Given que el parámetro de pantalla personalizada está <estado_parametro>
    # Y
    And que los permisos del usuario son <permisos_usuario>
    # Cuando
    When el usuario intenta ingresar a la Pantalla Aeropuerto
    # Entonces
    Then el sistema responde con <resultado_esperado>

    Examples:
      | estado_parametro | permisos_usuario | resultado_esperado                                                          |
      | inactivo         | válidos          | se mantiene la experiencia actual y no se muestra la pantalla personalizada |
      | activo           | insuficientes    | se bloquea el acceso conforme a seguridad                                   |
      | inactivo         | insuficientes    | no permite el acceso a la nueva experiencia                                 |

  Scenario: Validar estructura mínima visible del listado operativo
    # Dado
    Given que el usuario ingresa a la nueva Pantalla Aeropuerto
    # Cuando
    When el sistema carga la vista principal
    # Entonces
    Then la pantalla debe contemplar la siguiente estructura:
      """
      Columnas mínimas:
      - Viaje
      - Estatus
      - Cliente
      - Origen Trayecto / Destino Trayecto
      - Operador / Unidad
      - Remolques
      - GPS
      - Ubicación
      - Salida
      - Llegada

      Elementos generales:
      - Buscador superior
      - Paginación visible
      - Reloj en tiempo real
      - Botón de actualización manual
      - Botón de parámetros
      - Botón para cerrar la vista
      """