# language: es

Feature: HU-39132 Ordenamiento por columna y consistencia visual de encabezados en la Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero poder ordenar la tabla por cualquier columna y ver los encabezados alineados con su contenido
  Para navegar y analizar la operación de forma más eficiente

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario se encuentra en la Pantalla Aeropuerto con registros cargados

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: El usuario ordena la tabla por columna
    # Dado
    Given que la tabla operativa tiene registros cargados
    # Cuando
    When el usuario hace clic en el encabezado de la columna <columna>
    # Entonces
    Then el sistema ordena los registros de forma <direccion>
    # Y
    And conserva la búsqueda activa y la página actual sin reiniciar el contexto

    Examples:
      | columna         | direccion              |
      | Viaje           | ascendente/descendente |
      | Estatus         | ascendente/descendente |
      | Cliente         | ascendente/descendente |
      | Origen/Destino  | ascendente/descendente |
      | Operador/Unidad | ascendente/descendente |
      | Salida          | ascendente/descendente |
      | Llegada         | ascendente/descendente |

  Scenario: El criterio de orden se conserva después de una acción operativa
    # Dado
    Given que el usuario tiene aplicado un orden por columna
    # Cuando
    When ejecuta una acción como registrar salida, llegada o cambiar estatus
    # Entonces
    Then el sistema conserva el criterio de ordenamiento activo
    # Y
    And actualiza únicamente la fila o datos necesarios

  Scenario Outline: Los encabezados mantienen alineación con el contenido de la tabla
    # Dado
    Given que la pantalla carga registros con <volumen>
    # Cuando
    When el sistema renderiza la tabla operativa
    # Entonces
    Then los encabezados de columna mantienen alineación visual con el contenido de cada celda
    # Y
    And la alineación se conserva al navegar entre páginas y al hacer scroll horizontal

    Examples:
      | volumen             |
      | pocos registros     |
      | múltiples registros |
      | datos parciales     |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: El orden activo no se pierde al ejecutar acciones operativas
    # Dado
    Given que el usuario ordenó la tabla por la columna "Salida" de forma descendente
    # Cuando
    When ejecuta cualquier acción operativa sobre un registro
    # Entonces
    Then el sistema no reinicia el criterio de ordenamiento
    # Y
    And no regresa automáticamente al orden por defecto
