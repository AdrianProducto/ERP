# Característica
Feature: CRUD de Unidades con ID autoincrementable, capacidad de pasajeros, rendimiento y estatus Activo/Inactivo

  Como Operaciones
  Quiero administrar el catálogo de Unidades (vehículos) con capacidad y rendimiento
  Para asignarlas a Recorridos/Viajes, validar la capacidad de pasajeros y habilitar cálculos de costo por KM

  # Antecedentes
  Background:
    # Dado
    Given que el usuario autenticado tiene un rol permitido en el MVP <rol_usuario> (Operaciones/Admin)
    # Y
    And que el catálogo de Unidades maneja los campos: id autoincrementable, tipo de vehículo, marca/modelo, capacidad de pasajeros, rendimiento y estatus Activo/Inactivo
    # Y
    And que no se permite programar viajes con unidades en estatus "Inactivo"
    # Y
    And que solo se permite eliminar físicamente una unidad si no tiene viajes relacionados
    # Y
    And que el listado de unidades permite búsqueda por identificador, filtro Activo/Inactivo y paginación

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Crear, editar, consultar, eliminar o desactivar una unidad cumpliendo reglas del catálogo
    # Dado
    Given que la operación solicitada es <operacion>
    # Y
    And que el tipo de vehículo es <tipo_vehiculo>
    # Y
    And que la marca/modelo es <marca_modelo>
    # Y
    And que la capacidad de pasajeros es <capacidad_pasajeros>
    # Y
    And que el rendimiento de la unidad es <rendimiento>
    # Y
    And que el estatus inicial de la unidad es <estatus_inicial>
    # Y
    And que la unidad tiene viajes relacionados <tiene_viajes_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de unidades
    # Entonces
    Then el sistema completa la operación y obtiene el resultado <resultado_esperado>
    # Y
    And el sistema asigna un id autoincrementable a la unidad cuando la operación es "Crear"

    # Ejemplos
    Examples:
      | rol_usuario | operacion   | tipo_vehiculo     | marca_modelo        | capacidad_pasajeros | rendimiento | estatus_inicial | tiene_viajes_relacionados | resultado_esperado                                                                  |
      | Operaciones | Crear       | "Camión"          | "Freightliner 2020" | 40                  | 3.5        | Activo          | No                        | "Unidad creada exitosamente con id autoincrementable y estatus Activo."           |
      | Admin       | Editar      | "Camioneta"       | "Toyota Hiace 2022" | 15                  | 8.0        | Activo          | Sí                        | "Unidad actualizada exitosamente."                                                |
      | Operaciones | Consultar   | N/A               | N/A                 | N/A                 | N/A        | N/A             | N/A                       | "Se muestra el listado/detalle de unidades según filtros."                        |
      | Admin       | Desactivar  | "Autobús"         | "Volvo 2019"        | 45                  | 3.0        | Activo          | Sí                        | "Unidad desactivada: estatus cambia a Inactivo (historial conservado)."           |
      | Admin       | Eliminar    | "Camioneta"       | "Nissan Urvan 2018" | 12                  | 9.0        | Activo          | No                        | "Unidad eliminada físicamente (sin viajes relacionados)."                         |

  # Esquema del escenario
  Scenario Outline: Consultar unidades con búsqueda por id, filtro de estatus y paginación
    # Dado
    Given que el usuario se encuentra en el listado de unidades
    # Y
    And que el criterio de búsqueda por id es <busqueda_id>
    # Y
    And que el filtro de estatus está configurado como <filtro_estatus>
    # Y
    And que el usuario navega a la página <pagina>
    # Cuando
    When el usuario aplica los filtros del listado de unidades
    # Entonces
    Then el sistema muestra <resultado_esperado> con paginación activa en la página <pagina>

    # Ejemplos
    Examples:
      | rol_usuario | busqueda_id | filtro_estatus      | pagina | resultado_esperado                                                  |
      | Operaciones | 101         | Activo              | 1      | "Lista de unidades activas cuyo id coincide con la búsqueda."        |
      | Admin       | VACIO       | Activo,Inactivo     | 2      | "Lista de unidades activas e inactivas en la página solicitada."     |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear operaciones por campos obligatorios, valores inválidos o eliminación con registros relacionados
    # Dado
    Given que la condición inválida es <condicion_invalida>
    # Y
    And que la operación solicitada es <operacion>
    # Y
    And que el tipo de vehículo es <tipo_vehiculo>
    # Y
    And que la capacidad de pasajeros es <capacidad_pasajeros>
    # Y
    And que el rendimiento de la unidad es <rendimiento>
    # Y
    And que la unidad tiene viajes relacionados <tiene_viajes_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de unidades
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | condicion_invalida                         | operacion | tipo_vehiculo | capacidad_pasajeros | rendimiento | tiene_viajes_relacionados | error_esperado                                                                  |
      | Operaciones | "Tipo de vehículo vacío"                   | Crear     | VACIO        | 40                  | 3.5        | No                        | "El tipo de vehículo es obligatorio."                                           |
      | Operaciones | "Capacidad inválida"                       | Crear     | "Camión"     | 0                   | 3.5        | No                        | "La capacidad de pasajeros debe ser mayor a 0."                                 |
      | Operaciones | "Rendimiento inválido"                     | Crear     | "Camión"     | 40                  | -1         | No                        | "El rendimiento debe ser mayor a 0."                                            |
      | Admin       | "Eliminar unidad con viajes relacionados"  | Eliminar  | "Camión"     | 40                  | 3.5        | Sí                        | "No se puede eliminar: la unidad tiene viajes relacionados. Use Desactivar."    |
      | Operaciones | "Unidad inactiva (uso no permitido)"       | CrearViaje| "Camión"     | 40                  | 3.5        | Sí                        | "No se puede programar viajes: la unidad se encuentra Inactiva."                |

  # Esquema del escenario
  Scenario Outline: Bloquear gestión del catálogo de unidades por permisos insuficientes
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta acceder o modificar el catálogo de unidades
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                    |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para administrar unidades."|

  # Escenario adicional requerido para validar estructuras complejas (estructura mínima de Unidad) usando Doc Strings
  Scenario: Validar estructura mínima de Unidad en el MVP
    # Dado
    Given que la estructura mínima esperada de una unidad es la siguiente
      """
      {
        "id_unidad": 101,
        "tipo_vehiculo": "Camión|Camioneta|Autobús|Otro",
        "marca_modelo": "texto",
        "capacidad_pasajeros": 40,
        "rendimiento": 3.5,
        "estatus": "Activo|Inactivo"
      }
      """
    # Cuando
    When el sistema valida la creación o actualización de una unidad
    # Entonces
    Then el sistema debe requerir tipo_vehiculo, capacidad_pasajeros válida y rendimiento válido, y permitir el estatus Activo/Inactivo
