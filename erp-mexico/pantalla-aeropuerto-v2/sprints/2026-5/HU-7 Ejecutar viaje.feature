# Característica
Feature: Ejecución de Recorrido/Viaje (Iniciar, registrar paradas con arribos, pasajeros e incidencias y finalizar)

  Como Operaciones
  Quiero iniciar un Recorrido/Viaje y registrar la ejecución por paradas (salida/llegada), pasajeros e incidencias
  Para controlar el cumplimiento operativo del servicio y asegurar que el viaje solo finalice cuando todas las paradas estén completadas

  # Antecedentes
  Background:
    # Dado
    Given que existe un Recorrido/Viaje en estado "Programado" con una ruta y paradas seleccionadas en estado "Pendiente"
    # Y
    And que el Recorrido/Viaje tiene un tipo de viaje <tipo_viaje> (Solo ida/Solo vuelta/Ida y vuelta)
    # Y
    And que la unidad asignada tiene una capacidad máxima de pasajeros configurada

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Ejecutar un viaje iniciándolo, registrando arribos por parada (con orden) y finalizándolo con pasajeros dentro de capacidad
    # Dado
    Given que el Recorrido/Viaje tiene operador <operador_asignado> y unidad <unidad_asignada> asignados
    # Y
    And que el usuario de Operaciones tiene permisos para ejecutar Recorridos/Viajes
    # Cuando
    When el usuario marca el Recorrido/Viaje como "Iniciado"
    # Entonces
    Then el sistema cambia el estado del Recorrido/Viaje a "En curso"
    # Y
    And el sistema permite registrar para la parada <parada_1> la salida <salida_1> y llegada <llegada_1> del tramo <tramo_1>
    # Y
    And el sistema marca la parada <parada_1> como "Terminada"
    # Y
    And el sistema permite registrar para la parada <parada_2> la salida <salida_2> y llegada <llegada_2> del tramo <tramo_2>
    # Y
    And el sistema marca la parada <parada_2> como "Terminada"
    # Y
    And el sistema permite registrar el total de pasajeros <pasajeros_totales> durante la ejecución del viaje
    # Y
    And el sistema permite registrar la incidencia <incidencia_tipo> con el comentario <incidencia_comentario>
    # Cuando
    When el usuario intenta finalizar el Recorrido/Viaje
    # Entonces
    Then el sistema finaliza el Recorrido/Viaje y cambia su estado a "Finalizado"
    # Y
    And el sistema conserva el registro de arribos por parada y tramo, el total de pasajeros y las incidencias capturadas

    # Ejemplos
    Examples:
      | tipo_viaje   | operador_asignado | unidad_asignada | parada_1 | salida_1 | llegada_1 | tramo_1 | parada_2 | salida_2 | llegada_2 | tramo_2 | pasajeros_totales | incidencia_tipo | incidencia_comentario              |
      | Solo ida     | Operador 10       | Unidad 25       | P1       | 08:00    | 08:20     | Ida    | P2       | 08:25    | 08:45     | Ida    | 18               | Retardo        | "Tráfico pesado en acceso"         |
      | Solo vuelta  | Operador 21       | Unidad 07       | P1       | 19:00    | 19:25     | Vuelta | P2       | 19:30    | 19:55     | Vuelta | 12               | Accidente      | "Golpe leve sin lesionados"        |
      | Ida y vuelta | Operador 30       | Unidad 12       | P1       | 06:30    | 06:50     | Ida    | P2       | 16:00    | 16:20     | Vuelta | 20               | Multa          | "Infracción por estacionamiento"   |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear ejecución por asignación faltante, orden de paradas, capacidad de pasajeros o finalización incompleta
    # Dado
    Given que el usuario intenta ejecutar o finalizar el viaje con la condición inválida <condicion_invalida>
    # Y
    And que el Recorrido/Viaje tiene operador <operador_asignado> y unidad <unidad_asignada> asignados
    # Y
    And que la unidad tiene capacidad máxima <capacidad_maxima>
    # Y
    And que el usuario intenta registrar la parada <parada_objetivo> con salida <salida> y llegada <llegada> del tramo <tramo>
    # Cuando
    When el usuario intenta <accion>
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | condicion_invalida                            | operador_asignado | unidad_asignada | capacidad_maxima | parada_objetivo | salida | llegada | tramo  | accion                      | error_esperado                                                                 |
      | Viaje sin operador asignado                   | SIN_ASIGNAR       | Unidad 25       | 20               | P1              | 08:00  | 08:20   | Ida    | "Iniciar viaje"             | "No se puede iniciar el viaje: el operador es obligatorio."                    |
      | Viaje sin unidad asignada                     | Operador 10       | SIN_ASIGNAR     | 20               | P1              | 08:00  | 08:20   | Ida    | "Iniciar viaje"             | "No se puede iniciar el viaje: la unidad es obligatoria."                      |
      | Intentar terminar una parada fuera de orden   | Operador 10       | Unidad 25       | 20               | P3              | 08:40  | 09:00   | Ida    | "Terminar parada"           | "No se puede terminar la parada: existen paradas anteriores pendientes."       |
      | Pasajeros exceden la capacidad de la unidad   | Operador 10       | Unidad 25       | 20               | P1              | 08:00  | 08:20   | Ida    | "Registrar pasajeros"       | "Cantidad inválida: el total de pasajeros excede la capacidad de la unidad."   |
      | Finalizar viaje con paradas pendientes        | Operador 10       | Unidad 25       | 20               | P2              | 08:25  | 08:45   | Ida    | "Finalizar viaje"           | "No se puede finalizar: todas las paradas seleccionadas deben estar terminadas."|
      | Usuario sin permisos                          | Operador 10       | Unidad 25       | 20               | P1              | 08:00  | 08:20   | Ida    | "Iniciar viaje"             | "Acceso denegado: no cuenta con permisos para ejecutar Recorridos/Viajes."     |

  # Escenario adicional requerido para validar estructuras complejas (lista fija de estatus y estructura de registro por parada) usando Doc Strings
  Scenario: Validar estructura de registro de arribos por parada y estatus permitidos en el MVP
    # Dado
    Given que los estatus permitidos para paradas en el MVP son los siguientes
      """
      ["Pendiente","En proceso","Terminada"]
      """
    # Y
    And que el registro de ejecución por parada debe capturar la siguiente estructura mínima
      """
      {
        "parada":"P1",
        "tramo":"Ida|Vuelta",
        "salida":"HH:mm",
        "llegada":"HH:mm",
        "estatus":"Pendiente|En proceso|Terminada",
        "pasajeros_totales": 0,
        "incidencias":[{"tipo":"Retardo|Multa|Accidente","comentario":"texto"}]
      }
      """
    # Cuando
    When el usuario registra la salida y llegada de una parada y la marca como "Terminada"
    # Entonces
    Then el sistema debe almacenar la información respetando la estructura y validar que el estatus de la parada sea uno de los permitidos en el MVP