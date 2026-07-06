# Característica
Feature: Generación de Prefactura por Cliente seleccionando viajes finalizados (MVP)

  Como Operaciones
  Quiero generar una Prefactura para un Cliente seleccionando viajes finalizados
  Para consolidar el cobro del servicio con base en la tarifa fija de la ruta y preparar el proceso de aprobación

  # Antecedentes
  Background:
    # Dado
    Given que existen Clientes con viajes registrados y rutas con tarifa fija configurada
    # Y
    And que el sistema genera un folio global consecutivo para Prefacturas al momento de crearla
    # Y
    And que solo pueden prefacturarse viajes en estado "Finalizado"
    # Y
    And que un viaje no puede pertenecer a más de una Prefactura
    # Y
    And que la Prefactura se genera inicialmente en estado "Borrador"
    # Y
    And que la vista imprimible de la Prefactura está disponible desde la generación

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Generar Prefactura seleccionando viajes finalizados del mismo cliente (MVP: un viaje a la vez)
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que el cliente seleccionado es <cliente>
    # Y
    And que el usuario selecciona los viajes <viajes_seleccionados> para prefacturar
    # Y
    And que los viajes seleccionados pertenecen al mismo cliente <cliente>
    # Y
    And que cada viaje seleccionado se encuentra en estado <estado_viaje>
    # Y
    And que el tipo de viaje es <tipo_viaje> (Solo ida/Solo vuelta/Ida y vuelta)
    # Cuando
    When el usuario genera la Prefactura
    # Entonces
    Then el sistema crea la Prefactura con folio consecutivo y estado <estado_prefactura>
    # Y
    And el sistema calcula el total de la Prefactura como <total_prefactura> usando la tarifa fija de la ruta del viaje
    # Y
    And el sistema registra el detalle con los folios de viajes incluidos <viajes_seleccionados>
    # Y
    And el sistema muestra la vista imprimible de la Prefactura

    # Ejemplos
    Examples:
      | rol_usuario | cliente    | viajes_seleccionados | estado_viaje | tipo_viaje   | estado_prefactura | total_prefactura |
      | Operaciones | Cliente A  | V-000101             | Finalizado   | Solo ida     | Borrador          | "TarifaRuta(V-000101)" |
      | Admin       | Cliente B  | V-000205             | Finalizado   | Ida y vuelta | Borrador          | "TarifaRuta(V-000205)" |

  # Esquema del escenario
  Scenario Outline: Excluir automáticamente viajes ya prefacturados y generar Prefactura con los elegibles
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que el cliente seleccionado es <cliente>
    # Y
    And que el usuario selecciona los viajes <viajes_seleccionados> para prefacturar
    # Y
    And que los viajes ya prefacturados son <viajes_ya_prefacturados>
    # Cuando
    When el usuario genera la Prefactura
    # Entonces
    Then el sistema advierte que los viajes <viajes_ya_prefacturados> ya fueron prefacturados y serán excluidos
    # Y
    And el sistema genera la Prefactura incluyendo únicamente los viajes elegibles <viajes_elegibles>
    # Y
    And el sistema calcula el total de la Prefactura como <total_prefactura> usando la tarifa fija de la ruta de cada viaje elegible
    # Y
    And el sistema muestra la vista imprimible de la Prefactura

    # Ejemplos
    Examples:
      | rol_usuario | cliente    | viajes_seleccionados     | viajes_ya_prefacturados | viajes_elegibles | total_prefactura                         |
      | Operaciones | Cliente A  | V-000101,V-000102         | V-000101                | V-000102          | "TarifaRuta(V-000102)"                   |
      | Admin       | Cliente B  | V-000205,V-000206         | V-000205                | V-000206          | "TarifaRuta(V-000206)"                   |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear generación de Prefactura por validaciones de cliente, estado de viaje o selección inválida
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que la condición inválida es <condicion_invalida>
    # Y
    And que el cliente seleccionado es <cliente>
    # Y
    And que el usuario selecciona los viajes <viajes_seleccionados> para prefacturar
    # Y
    And que el estado del viaje es <estado_viaje>
    # Cuando
    When el usuario genera la Prefactura
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | condicion_invalida                                 | cliente    | viajes_seleccionados | estado_viaje | error_esperado                                                                 |
      | Operaciones | "Sin cliente seleccionado"                         | VACIO      | V-000101             | Finalizado   | "El cliente es obligatorio para generar una Prefactura."                       |
      | Operaciones | "Sin viajes seleccionados"                         | Cliente A  | VACIO                | N/A          | "Debe seleccionar al menos un viaje para generar la Prefactura."               |
      | Operaciones | "Viaje no finalizado"                              | Cliente A  | V-000103             | En curso     | "No se puede prefacturar: solo se permiten viajes en estado Finalizado."       |
      | Operaciones | "Viaje pertenece a otro cliente"                   | Cliente A  | V-000205             | Finalizado   | "No se puede prefacturar: todos los viajes deben pertenecer al cliente seleccionado." |
      | Admin       | "Todos los viajes seleccionados ya están prefacturados" | Cliente B  | V-000205             | Finalizado   | "No se generó la Prefactura: todos los viajes seleccionados ya fueron prefacturados."|

  # Esquema del escenario
  Scenario Outline: Bloquear generación de Prefactura por permisos insuficientes
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta generar una Prefactura
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                      |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para generar Prefacturas."  |

  # Escenario adicional requerido para validar estructuras complejas (estructura de Prefactura y detalle) usando Doc Strings
  Scenario: Validar estructura mínima de la Prefactura y su detalle de viajes en el MVP
    # Dado
    Given que la Prefactura debe almacenarse con la siguiente estructura mínima
      """
      {
        "folio_prefactura": "PF-000001",
        "cliente": "Cliente A",
        "fecha_generacion": "YYYY-MM-DD",
        "estatus": "Borrador|Aprobada",
        "observaciones": "texto",
        "total": 0.0,
        "detalle_viajes": [
          {
            "folio_viaje": "V-000101",
            "tipo_viaje": "Solo ida|Solo vuelta|Ida y vuelta",
            "ruta": "Ruta 1",
            "tarifa_ruta": 0.0,
            "importe": 0.0
          }
        ]
      }
      """
    # Cuando
    When el usuario genera una Prefactura seleccionando un viaje finalizado
    # Entonces
    Then el sistema debe persistir la Prefactura y su detalle respetando la estructura mínima definida