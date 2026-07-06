# Característica
Feature: CRUD de Rutas por Cliente con folio autoincrementable, tarifa por KM y paradas predefinidas (sin afectar histórico)

  Como Operaciones
  Quiero administrar el catálogo de Rutas por Cliente, incluyendo tarifa por KM y paradas predefinidas
  Para programar Recorridos/Viajes usando configuraciones estándar y mantener el historial de viajes sin afectaciones ante cambios posteriores

  # Antecedentes
  Background:
    # Dado
    Given que el usuario autenticado tiene un rol permitido en el MVP <rol_usuario> (Operaciones/Admin)
    # Y
    And que una Ruta pertenece a un Cliente
    # Y
    And que el sistema asigna un folio/código autoincrementable a la Ruta al momento de crearla
    # Y
    And que la Ruta maneja estatus "Activo/Inactivo"
    # Y
    And que no se permite programar viajes con rutas en estatus "Inactivo"
    # Y
    And que las rutas incluyen una tarifa decimal por KM para cálculo dinámico del costo
    # Y
    And que existe un catálogo interno de moneda para "México", "USA" y "Guatemala"
    # Y
    And que las paradas se definen en la Ruta y se cargan automáticamente en el Viaje, sin afectar el historial de viajes ya creados

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Crear, editar, consultar, eliminar o desactivar una Ruta con tarifa por KM y moneda interna
    # Dado
    Given que la operación solicitada es <operacion>
    # Y
    And que el cliente asociado a la ruta es <cliente>
    # Y
    And que el nombre de la ruta es <nombre_ruta>
    # Y
    And que la tarifa por KM es <tarifa_km>
    # Y
    And que la moneda configurada para la ruta es <moneda>
    # Y
    And que el estatus inicial de la ruta es <estatus_inicial>
    # Y
    And que la ruta tiene viajes relacionados <tiene_viajes_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de rutas
    # Entonces
    Then el sistema completa la operación y obtiene el resultado <resultado_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | operacion   | cliente    | nombre_ruta       | tarifa_km | moneda   | estatus_inicial | tiene_viajes_relacionados | resultado_esperado                                                                 |
      | Operaciones | Crear       | Cliente A  | "Ruta Parque 1"   | 12.50     | MXN      | Activo          | No                        | "Ruta creada exitosamente con folio autoincrementable y estatus Activo."          |
      | Admin       | Editar      | Cliente A  | "Ruta Parque 1"   | 13.00     | MXN      | Activo          | Sí                        | "Ruta actualizada sin afectar el historial de viajes existentes."                 |
      | Operaciones | Consultar   | N/A        | N/A               | N/A       | N/A      | N/A             | N/A                       | "Se muestra el listado/detalle de rutas según filtros."                            |
      | Admin       | Desactivar  | Cliente B  | "Ruta Planta 3"   | 10.00     | USD      | Activo          | Sí                        | "Ruta desactivada: estatus cambia a Inactivo y se conserva historial."            |
      | Admin       | Eliminar    | Cliente C  | "Ruta Centro"     | 9.75      | GTQ      | Activo          | No                        | "Ruta eliminada físicamente (sin viajes relacionados)."                           |

  # Esquema del escenario
  Scenario Outline: Administrar paradas de una Ruta (crear/editar/eliminar) y asegurar que cambios no afecten viajes históricos
    # Dado
    Given que existe una ruta con folio <folio_ruta> para el cliente <cliente> y con paradas predefinidas <paradas_iniciales>
    # Y
    And que existen viajes históricos creados con esa ruta <existen_viajes_historicos>
    # Cuando
    When el usuario ejecuta la operación de paradas <operacion_parada> sobre la parada <parada_objetivo>
    # Entonces
    Then el sistema refleja el cambio de paradas en la ruta para usos futuros
    # Y
    And el sistema garantiza que el detalle de paradas de los viajes históricos no se modifica
    # Y
    And el sistema obtiene el resultado <resultado_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | folio_ruta | cliente    | paradas_iniciales | existen_viajes_historicos | operacion_parada | parada_objetivo                                   | resultado_esperado                                   |
      | Operaciones | R-000001   | Cliente A  | P1,P2,P3          | Sí                        | Crear            | "P4:Parada 4:orden 4:Intermedia"                  | "Parada agregada a la ruta; viajes históricos intactos." |
      | Admin       | R-000001   | Cliente A  | P1,P2,P3          | Sí                        | Editar           | "P2:Parada 2 Mod:orden 2:Salida"                  | "Parada actualizada en la ruta; viajes históricos intactos." |
      | Operaciones | R-000001   | Cliente A  | P1,P2,P3,P4       | Sí                        | Eliminar         | "P3"                                              | "Parada eliminada de la ruta; viajes históricos intactos."  |
      | Admin       | R-000002   | Cliente B  | P1,P2             | No                        | Editar           | "P1:Parada 1 Mod:orden 1:Entrada"                 | "Parada actualizada en la ruta."                          |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear operaciones por campos obligatorios, tarifa/moneda inválida, uso de ruta inactiva o eliminación con viajes relacionados
    # Dado
    Given que la condición inválida es <condicion_invalida>
    # Y
    And que la operación solicitada es <operacion>
    # Y
    And que el cliente asociado es <cliente>
    # Y
    And que el nombre de la ruta es <nombre_ruta>
    # Y
    And que la tarifa por KM es <tarifa_km>
    # Y
    And que la moneda configurada es <moneda>
    # Y
    And que la ruta tiene viajes relacionados <tiene_viajes_relacionados>
    # Cuando
    When el usuario intenta ejecutar la operación en el catálogo de rutas
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | condicion_invalida                           | operacion  | cliente    | nombre_ruta     | tarifa_km | moneda | tiene_viajes_relacionados | error_esperado                                                                 |
      | Operaciones | "Nombre vacío"                               | Crear      | Cliente A  | VACIO          | 12.50     | MXN    | No                        | "El nombre de la ruta es obligatorio."                                         |
      | Operaciones | "Cliente vacío"                              | Crear      | VACIO      | "Ruta X"       | 12.50     | MXN    | No                        | "El cliente es obligatorio para crear una ruta."                               |
      | Operaciones | "Tarifa por KM inválida"                     | Crear      | Cliente A  | "Ruta X"       | -1        | MXN    | No                        | "La tarifa por KM debe ser mayor a 0."                                         |
      | Operaciones | "Moneda inválida (fuera de catálogo interno)"| Crear      | Cliente A  | "Ruta X"       | 12.50     | EUR    | No                        | "La moneda no es válida: seleccione una del catálogo interno (MXN/USD/GTQ)."   |
      | Admin       | "Eliminar ruta con viajes relacionados"      | Eliminar   | Cliente A  | "Ruta Parque 1"| 12.50     | MXN    | Sí                        | "No se puede eliminar: la ruta tiene viajes relacionados. Use Desactivar."     |
      | Operaciones | "Ruta inactiva (uso no permitido)"           | CrearViaje | Cliente B  | "Ruta Planta 3"| 10.00     | USD    | Sí                        | "No se puede programar viajes: la ruta se encuentra Inactiva."                 |

  # Esquema del escenario
  Scenario Outline: Bloquear gestión del catálogo de rutas/paradas por permisos insuficientes
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta acceder o modificar el catálogo de rutas o paradas
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                      |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para administrar rutas."     |

  # Escenario adicional requerido para validar estructuras complejas (estructura de Ruta, moneda interna y paradas) usando Doc Strings
  Scenario: Validar estructura mínima de Ruta por Cliente con tarifa por KM, moneda interna y paradas predefinidas
    # Dado
    Given que la estructura mínima esperada de una ruta es la siguiente
      """
      {
        "folio_ruta": "R-000001",
        "cliente": "Cliente A",
        "nombre": "Ruta Parque 1",
        "tarifa_km": 12.50,
        "moneda": "MXN|USD|GTQ",
        "estatus": "Activo|Inactivo",
        "paradas": [
          {"clave":"P1","nombre":"Parada 1","orden":1,"direccion":"texto","tipo":"Entrada|Salida|Intermedia"},
          {"clave":"P2","nombre":"Parada 2","orden":2,"direccion":"texto","tipo":"Entrada|Salida|Intermedia"}
        ]
      }
      """
    # Cuando
    When el sistema valida la creación o actualización de una ruta
    # Entonces
    Then el sistema debe requerir cliente, nombre, tarifa_km válida y moneda dentro del catálogo interno, además de permitir paradas predefinidas