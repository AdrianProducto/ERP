# language: es

Feature: HU-39132 Ordenamiento de columnas y alineación de encabezados en la tabla de la Pantalla Aeropuerto

  Como monitorista u operador del módulo de tráfico
  Quiero poder ordenar la tabla por una columna a la vez y ver los encabezados alineados con su contenido
  Para navegar y analizar la operación de forma más eficiente

  Background:
    # Dado
    Given que el parámetro "Pantalla Aeropuerto personalizada" está activo
    # Y
    And que el usuario tiene acceso al módulo de tráfico

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: El usuario ordena la tabla por una columna
    # Dado
    Given que la tabla muestra registros de trayectos
    # Cuando
    When el usuario hace clic en el encabezado de la columna "<columna>"
    # Entonces
    Then el sistema ordena los registros de forma ascendente según esa columna
    # Y
    And el encabezado muestra un indicador visual del criterio de orden activo
    # Cuando
    When el usuario hace clic nuevamente en el mismo encabezado
    # Entonces
    Then el sistema invierte el orden a descendente para esa misma columna

    Examples:
      | columna         |
      | Viaje           |
      | Estatus         |
      | Cliente         |
      | Origen/Destino  |
      | Operador/Unidad |
      | GPS             |
      | Salida          |
      | Llegada         |

  Scenario: Al ordenar por una nueva columna se reemplaza el criterio anterior
    # Dado
    Given que la tabla está ordenada por la columna "Salida"
    # Cuando
    When el usuario hace clic en el encabezado de la columna "Cliente"
    # Entonces
    Then el sistema aplica el orden únicamente por "Cliente"
    # Y
    And el indicador visual se mueve al encabezado "Cliente"
    # Y
    And el encabezado "Salida" deja de mostrar indicador de orden activo

  Scenario: El ordenamiento conserva la búsqueda activa y la página actual
    # Dado
    Given que el usuario tiene aplicada una búsqueda activa
    # Y
    And que se encuentra en una página distinta a la primera
    # Cuando
    When el usuario hace clic en el encabezado de una columna para ordenar
    # Entonces
    Then el sistema aplica el nuevo criterio de orden
    # Y
    And conserva la búsqueda activa sin limpiarla
    # Y
    And conserva la página actual sin regresar a la página 1

  Scenario Outline: El criterio de orden se conserva después de ejecutar acciones operativas
    # Dado
    Given que el usuario tiene aplicado el orden por la columna "<columna>" de forma "<direccion>"
    # Cuando
    When el usuario ejecuta la acción "<accion>"
    # Entonces
    Then el sistema conserva el criterio de orden activo
    # Y
    And actualiza únicamente la fila o datos necesarios sin reiniciar el orden

    Examples:
      | columna         | direccion   | accion            |
      | Salida          | ascendente  | registrar salida  |
      | Llegada         | descendente | registrar llegada |
      | Estatus         | ascendente  | cambiar estatus   |
      | Viaje           | descendente | registrar salida  |
      | Operador/Unidad | ascendente  | cambiar estatus   |

  Scenario Outline: Los encabezados mantienen alineación visual con el contenido en distintos volúmenes
    # Dado
    Given que la tabla contiene <volumen> registros
    # Cuando
    When el usuario visualiza la tabla
    # Entonces
    Then los encabezados de columna están alineados visualmente con el contenido de cada celda

    Examples:
      | volumen   |
      | pocos     |
      | múltiples |
      | parciales |

  Scenario: La alineación se conserva al navegar entre páginas
    # Dado
    Given que la tabla tiene registros distribuidos en varias páginas
    # Cuando
    When el usuario navega a una página diferente
    # Entonces
    Then los encabezados mantienen su alineación con el contenido de cada columna en la página visualizada

  Scenario: La alineación se conserva al hacer scroll horizontal
    # Dado
    Given que la tabla requiere desplazamiento horizontal por la cantidad de columnas visibles
    # Cuando
    When el usuario realiza scroll horizontal
    # Entonces
    Then los encabezados se desplazan junto con su contenido y mantienen la alineación en todo momento

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario Outline: El sistema no reinicia el criterio de orden al ejecutar acciones operativas
    # Dado
    Given que el usuario tiene aplicado el orden por la columna "<columna>"
    # Cuando
    When el usuario ejecuta la acción "<accion>"
    # Entonces
    Then el sistema no regresa al orden por defecto
    # Y
    And no reinicia el criterio de ordenamiento activo

    Examples:
      | columna         | accion            |
      | Salida          | registrar salida  |
      | Llegada         | registrar llegada |
      | Estatus         | cambiar estatus   |

  @validacion
  Scenario: El sistema no desalinea encabezados al actualizar filas individuales
    # Dado
    Given que la tabla está ordenada por una columna específica
    # Cuando
    When el sistema actualiza una fila por una acción operativa
    # Entonces
    Then los encabezados conservan su alineación con el contenido de todas las celdas
