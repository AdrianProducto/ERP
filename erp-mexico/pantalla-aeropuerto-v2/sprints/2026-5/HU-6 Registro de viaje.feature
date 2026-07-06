# Característica
Feature: Alta de Recorrido/Viaje (Programación) con paradas, tipo ida/vuelta y validación de cruces

  Como Operaciones
  Quiero crear y programar un Recorrido/Viaje con cliente, ruta, fecha, turno, tipo (ida/vuelta/ida y vuelta), paradas y asignación opcional de operador/unidad
  Para planificar la operación diaria y habilitar el control operativo y la prefacturación del servicio

  # Antecedentes
  Background:
    # Dado
    Given que existen clientes, rutas con paradas predefinidas, operadores y unidades disponibles en el sistema
    # Y
    And que el turno se captura mediante un selector fijo (Matutino/Nocturno/Quebrado)
    # Y
    And que el sistema genera un folio global consecutivo al momento de crear el Recorrido/Viaje

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Crear Recorrido/Viaje programado (tipo simple: ida o vuelta) con asignación opcional
    # Dado
    Given que el usuario de Operaciones cuenta con permisos para crear Recorridos/Viajes
    # Y
    And que el cliente es <cliente>
    # Y
    And que la ruta es <ruta> y tiene paradas predefinidas
    # Y
    And que la fecha del viaje es <fecha>
    # Y
    And que el turno seleccionado es <turno>
    # Y
    And que el tipo de viaje es <tipo_viaje_simple>
    # Y
    And que el operador asignado es <operador_asignado>
    # Y
    And que la unidad asignada es <unidad_asignada>
    # Y
    And que los horarios programados del tramo son <salida> y <llegada>
    # Y
    And que las paradas seleccionadas del viaje son <paradas_seleccionadas>
    # Cuando
    When el usuario intenta crear el Recorrido/Viaje con la información capturada
    # Entonces
    Then el sistema crea el Recorrido/Viaje en estado "Programado"
    # Y
    And el sistema asigna un folio global consecutivo al Recorrido/Viaje
    # Y
    And el sistema registra las paradas seleccionadas del viaje en estado "Pendiente"
    # Y
    And el sistema permite que el Recorrido/Viaje quede sin operador o sin unidad si fueron capturados como "SIN_ASIGNAR"

    # Ejemplos
    Examples:
      | cliente   | ruta   | fecha       | turno    | tipo_viaje_simple | operador_asignado | unidad_asignada | salida | llegada | paradas_seleccionadas |
      | Cliente A | Ruta 1 | 2026-04-03  | Matutino | Solo ida          | SIN_ASIGNAR       | SIN_ASIGNAR     | 08:00  | 09:00   | P1,P2,P3              |
      | Cliente A | Ruta 1 | 2026-04-03  | Nocturno | Solo vuelta       | Operador 10       | Unidad 25       | 20:00  | 21:15   | P2,P3                 |
      | Cliente C | Ruta 2 | 2026-04-05  | Matutino | Solo ida          | SIN_ASIGNAR       | Unidad 12       | N/A    | N/A     | P1,P2                 |

  # Esquema del escenario
  Scenario Outline: Crear Recorrido/Viaje programado (tipo ida y vuelta) con 2 tramos y horarios opcionales
    # Dado
    Given que el usuario de Operaciones cuenta con permisos para crear Recorridos/Viajes
    # Y
    And que el cliente es <cliente>
    # Y
    And que la ruta es <ruta> y tiene paradas predefinidas
    # Y
    And que la fecha del viaje es <fecha>
    # Y
    And que el turno seleccionado es <turno>
    # Y
    And que el tipo de viaje es "Ida y vuelta"
    # Y
    And que el operador asignado es <operador_asignado>
    # Y
    And que la unidad asignada es <unidad_asignada>
    # Y
    And que los horarios programados del tramo ida son <salida_ida> y <llegada_ida>
    # Y
    And que los horarios programados del tramo vuelta son <salida_vuelta> y <llegada_vuelta>
    # Y
    And que las paradas seleccionadas del viaje son <paradas_seleccionadas>
    # Cuando
    When el usuario intenta crear el Recorrido/Viaje con la información capturada
    # Entonces
    Then el sistema crea el Recorrido/Viaje en estado "Programado"
    # Y
    And el sistema asigna un folio global consecutivo al Recorrido/Viaje
    # Y
    And el sistema registra las paradas seleccionadas del viaje en estado "Pendiente"

    # Ejemplos
    Examples:
      | cliente   | ruta   | fecha       | turno    | operador_asignado | unidad_asignada | salida_ida | llegada_ida | salida_vuelta | llegada_vuelta | paradas_seleccionadas |
      | Cliente B | Ruta 3 | 2026-04-04  | Quebrado | Operador 21       | Unidad 07       | 06:30      | 07:40       | 16:00         | 17:05          | P1,P2,P4,P5           |
      | Cliente B | Ruta 3 | 2026-04-04  | Quebrado | Operador 21       | Unidad 07       | N/A        | N/A         | N/A           | N/A            | P1,P2                 |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear creación por campos obligatorios faltantes (Programación)
    # Dado
    Given que el usuario intenta crear un Recorrido/Viaje con el campo obligatorio faltante <campo_faltante>
    # Cuando
    When el usuario intenta guardar el Recorrido/Viaje
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | campo_faltante | error_esperado                                                         |
      | Cliente        | "El cliente es obligatorio para programar un Recorrido/Viaje."          |
      | Ruta           | "La ruta es obligatoria para programar un Recorrido/Viaje."             |
      | Fecha          | "La fecha es obligatoria para programar un Recorrido/Viaje."            |
      | Turno          | "El turno es obligatorio (Matutino/Nocturno/Quebrado)."                 |
      | Tipo de viaje  | "El tipo de viaje es obligatorio (Solo ida/Solo vuelta/Ida y vuelta)."  |

  # Esquema del escenario
  Scenario Outline: Bloquear creación por cruce de horarios en viajes no terminados (Operador/Unidad)
    # Dado
    Given que existe un viaje no terminado asignado al mismo <recurso> con rango horario <rango_existente>
    # Y
    And que el usuario intenta programar un nuevo viaje con el mismo <recurso> y rango horario <rango_nuevo>
    # Cuando
    When el usuario intenta guardar el Recorrido/Viaje
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | recurso  | rango_existente | rango_nuevo | error_esperado                                                                 |
      | Operador | 08:00-09:00     | 08:30-09:30 | "Conflicto: el operador ya tiene un viaje no terminado que cruza el horario."  |
      | Unidad   | 08:00-09:00     | 08:30-09:30 | "Conflicto: la unidad ya tiene un viaje no terminado que cruza el horario."    |

  # Esquema del escenario
  Scenario Outline: Bloquear creación por falta de permisos
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta crear un Recorrido/Viaje
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                          |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para crear Recorridos/Viajes."  |

  # Escenario adicional requerido para validar estructuras complejas (catálogos y paradas) usando Doc Strings
  Scenario: Validar estructura de paradas por ruta y su selección en el Recorrido/Viaje
    # Dado
    Given que la ruta "Ruta 1" tiene la siguiente estructura de paradas predefinidas
      """
      [
        {"clave":"P1","nombre":"Parada 1","orden":1},
        {"clave":"P2","nombre":"Parada 2","orden":2},
        {"clave":"P3","nombre":"Parada 3","orden":3}
      ]
      """
    # Y
    And que el usuario selecciona las siguientes paradas para el Recorrido/Viaje
      """
      ["P1","P3"]
      """
    # Cuando
    When el usuario crea el Recorrido/Viaje para "Ruta 1"
    # Entonces
    Then el sistema debe registrar exactamente las paradas seleccionadas en el viaje con estado "Pendiente" y respetando el orden definido en la ruta