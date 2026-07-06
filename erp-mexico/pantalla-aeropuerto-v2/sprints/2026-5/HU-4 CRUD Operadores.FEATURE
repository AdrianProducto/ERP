# Característica
Feature: CRUD de Operadores con código autoincrementable, estatus Activo/Inactivo y restricciones de uso en viajes

  Como Operaciones
  Quiero administrar el catálogo de Operadores (crear, editar, consultar, eliminar o desactivar)
  Para asignarlos a Recorridos/Viajes y controlar su disponibilidad sin afectar el historial operativo

  # Antecedentes
  Background:
    # Dado
    Given que el usuario autenticado tiene un rol permitido en el MVP <rol_usuario> (Operaciones/Admin)
    # Y
    And que el catálogo de Operadores maneja los campos: nombre completo, código autoincrementable, teléfono, correo, licencia (número/vencimiento), observaciones y estatus Activo/Inactivo
    # Y
    And que el código del operador es único y se genera automáticamente (autoincrementable)
    # Y
    And que un operador puede quedar como "SIN_ASIGNAR" en un Recorrido/Viaje al programarlo
    # Y
    And que no se permite programar viajes asignando un operador en estatus "Inactivo"
    # Y
    And que un operador inactivo puede conservar viajes históricos y esos viajes pueden continuar su flujo (iniciar/finalizar) si ya estaban asignados

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Crear, editar, consultar, eliminar o desactivar un operador cumpliendo reglas del catálogo
    # Dado
    Given que la operación solicitada es <operacion>
    # Y
    And que el nombre completo del operador es <nombre_completo>
    # Y
    And que el teléfono es <telefono>
    # Y
    And que el correo es <correo>
    # Y
    And que el número de licencia es <licencia_numero> y su vencimiento es <licencia_vencimiento>
    # Y
    And que las observaciones son <observaciones>
    # Y
    And que el estatus inicial del operador es <estatus_inicial>
    # Y
    And que el operador tiene viajes relacionados <tiene_viajes_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de operadores
    # Entonces
    Then el sistema completa la operación y obtiene el resultado <resultado_esperado>
    # Y
    And el sistema asigna un código autoincrementable al operador cuando la operación es "Crear"

    # Ejemplos
    Examples:
      | rol_usuario | operacion   | nombre_completo     | telefono    | correo               | licencia_numero | licencia_vencimiento | observaciones               | estatus_inicial | tiene_viajes_relacionados | resultado_esperado                                                             |
      | Operaciones | Crear       | "Pedro González"    | "686000000" | "pedro@correo.com"   | "LIC123"        | 2028-12-31           | "Sin observaciones"         | Activo          | No                        | "Operador creado exitosamente con código autoincrementable y estatus Activo."  |
      | Admin       | Editar      | "Pedro González"    | "686111111" | "pedro2@correo.com"  | "LIC123"        | 2029-12-31           | "Actualización de datos"    | Activo          | Sí                        | "Operador actualizado exitosamente."                                          |
      | Operaciones | Consultar   | N/A                 | N/A         | N/A                  | N/A             | N/A                  | N/A                         | N/A             | N/A                       | "Se muestra el listado/detalle de operadores según filtros."                   |
      | Admin       | Desactivar  | "María López"       | "686222222" | "maria@correo.com"   | "LIC999"        | 2027-06-30           | "Baja temporal"             | Activo          | Sí                        | "Operador desactivado: estatus cambia a Inactivo (historial conservado)."      |
      | Admin       | Eliminar    | "Juan Pérez"        | "686333333" | "juan@correo.com"    | "LIC777"        | 2026-05-01           | "Sin observaciones"         | Activo          | No                        | "Operador eliminado físicamente (sin viajes relacionados)."                    |

  # Esquema del escenario
  Scenario Outline: Consultar operadores con búsqueda por nombre/código, filtro de estatus y paginación
    # Dado
    Given que el usuario se encuentra en el listado de operadores
    # Y
    And que el criterio de búsqueda por nombre es <busqueda_nombre>
    # Y
    And que el criterio de búsqueda por código es <busqueda_codigo>
    # Y
    And que el filtro de estatus está configurado como <filtro_estatus>
    # Y
    And que el usuario navega a la página <pagina>
    # Cuando
    When el usuario aplica los filtros del listado de operadores
    # Entonces
    Then el sistema muestra <resultado_esperado> con paginación activa en la página <pagina>

    # Ejemplos
    Examples:
      | rol_usuario | busqueda_nombre | busqueda_codigo | filtro_estatus      | pagina | resultado_esperado                                                    |
      | Operaciones | "Pedro"         | VACIO           | Activo              | 1      | "Lista de operadores activos cuyo nombre coincide con la búsqueda."    |
      | Admin       | VACIO           | "OP-0001"       | Activo,Inactivo     | 2      | "Lista de operadores por código, incluyendo activos e inactivos."      |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear operaciones por campos obligatorios o eliminación con registros relacionados
    # Dado
    Given que la condición inválida es <condicion_invalida>
    # Y
    And que la operación solicitada es <operacion>
    # Y
    And que el nombre completo del operador es <nombre_completo>
    # Y
    And que el operador tiene viajes relacionados <tiene_viajes_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de operadores
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | condicion_invalida                        | operacion | nombre_completo   | tiene_viajes_relacionados | error_esperado                                                                 |
      | Operaciones | "Nombre vacío"                            | Crear     | VACIO            | No                        | "El nombre completo del operador es obligatorio."                              |
      | Admin       | "Eliminar operador con viajes relacionados"| Eliminar  | "Pedro González" | Sí                        | "No se puede eliminar: el operador tiene viajes relacionados. Use Desactivar." |

  # Esquema del escenario
  Scenario Outline: Bloquear uso de operador inactivo al programar un viaje, pero permitir iniciar/finalizar viajes históricos
    # Dado
    Given que el operador <operador> se encuentra en estatus <estatus_operador>
    # Y
    And que la acción solicitada sobre viajes es <accion_viaje>
    # Cuando
    When el usuario intenta usar el operador en la acción de viaje
    # Entonces
    Then el sistema obtiene el resultado <resultado_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | operador     | estatus_operador | accion_viaje                         | resultado_esperado                                                          |
      | Operaciones | OP-0005      | Inactivo         | "Programar viaje con operador"       | "Se bloquea: no se puede programar viajes con operador Inactivo."           |
      | Operaciones | OP-0005      | Inactivo         | "Iniciar/Finalizar viaje histórico"  | "Se permite: el viaje ya estaba asignado históricamente al operador."       |

  # Esquema del escenario
  Scenario Outline: Bloquear gestión del catálogo de operadores por permisos insuficientes
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta acceder o modificar el catálogo de operadores
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                        |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para administrar operadores." |

  # Escenario adicional requerido para validar estructuras complejas (estructura mínima de Operador) usando Doc Strings
  Scenario: Validar estructura mínima de Operador en el MVP
    # Dado
    Given que la estructura mínima esperada de un operador es la siguiente
      """
      {
        "codigo_operador": "OP-000001",
        "nombre_completo": "Pedro González",
        "telefono": "686000000",
        "correo": "pedro@correo.com",
        "licencia": {
          "numero": "LIC123",
          "vencimiento": "YYYY-MM-DD"
        },
        "observaciones": "texto",
        "estatus": "Activo|Inactivo"
      }
      """
    # Cuando
    When el sistema valida la creación o actualización de un operador
    # Entonces
    Then el sistema debe requerir nombre completo obligatorio y generar un código autoincrementable único
