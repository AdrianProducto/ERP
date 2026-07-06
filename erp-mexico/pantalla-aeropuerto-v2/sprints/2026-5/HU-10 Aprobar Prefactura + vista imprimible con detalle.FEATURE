@registro-nuevo
# Característica
Feature: Aprobación/Rechazo de Prefactura y vista imprimible (Borrador y Aprobada)

  Como Operaciones
  Quiero aprobar o rechazar una Prefactura generada en estado Borrador
  Para controlar el proceso previo a facturación y disponer de una vista imprimible para revisión y entrega

  # Antecedentes
  Background:
    # Dado
    Given que existen Prefacturas generadas en estado "Borrador" con detalle de viajes y total calculado
    # Y
    And que la vista imprimible de la Prefactura está disponible tanto en estado "Borrador" como en estado "Aprobada"
    # Y
    And que los viajes en estado "Finalizado" no deben poder cambiar su estatus

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Aprobar una Prefactura en Borrador cumpliendo validaciones mínimas
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que existe una Prefactura con folio <folio_prefactura> en estado <estado_inicial>
    # Y
    And que la Prefactura pertenece al cliente <cliente>
    # Y
    And que el detalle contiene <cantidad_viajes> viaje(s)
    # Y
    And que todos los viajes del detalle están en estado <estado_viajes_detalle>
    # Y
    And que el total de la Prefactura es <total>
    # Cuando
    When el usuario intenta aprobar la Prefactura
    # Entonces
    Then el sistema cambia el estado de la Prefactura a <estado_final>
    # Y
    And el sistema permite visualizar la vista imprimible de la Prefactura con estado <estado_final>

    # Ejemplos
    Examples:
      | rol_usuario | folio_prefactura | estado_inicial | cliente    | cantidad_viajes | estado_viajes_detalle | total  | estado_final |
      | Operaciones | PF-000001        | Borrador       | Cliente A  | 1               | Finalizado            | 1500.0 | Aprobada     |
      | Admin       | PF-000002        | Borrador       | Cliente B  | 1               | Finalizado            | 800.0  | Aprobada     |

  # Esquema del escenario
  Scenario Outline: Rechazar una Prefactura en Borrador capturando comentario libre
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que existe una Prefactura con folio <folio_prefactura> en estado <estado_inicial>
    # Y
    And que el usuario captura el comentario de rechazo <comentario_rechazo>
    # Cuando
    When el usuario intenta rechazar la Prefactura
    # Entonces
    Then el sistema cambia el estado de la Prefactura a <estado_final>
    # Y
    And el sistema conserva el comentario de rechazo <comentario_rechazo>
    # Y
    And el sistema permite visualizar la vista imprimible de la Prefactura con estado <estado_final>

    # Ejemplos
    Examples:
      | rol_usuario | folio_prefactura | estado_inicial | comentario_rechazo                   | estado_final |
      | Operaciones | PF-000003        | Borrador       | "Falta validar datos con el cliente" | Rechazada    |
      | Admin       | PF-000004        | Borrador       | "Revisar tarifa aplicada"            | Rechazada    |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear aprobación por validaciones del detalle o total inválido
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que existe una Prefactura con folio <folio_prefactura> en estado <estado_inicial>
    # Y
    And que el detalle contiene <cantidad_viajes> viaje(s)
    # Y
    And que el estado de los viajes del detalle es <estado_viajes_detalle>
    # Y
    And que el total de la Prefactura es <total>
    # Cuando
    When el usuario intenta aprobar la Prefactura
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | folio_prefactura | estado_inicial | cantidad_viajes | estado_viajes_detalle | total  | error_esperado                                                               |
      | Operaciones | PF-000010        | Borrador       | 0               | N/A                   | 0.0    | "No se puede aprobar: la Prefactura debe contener al menos un viaje."         |
      | Operaciones | PF-000011        | Borrador       | 1               | En curso              | 1500.0 | "No se puede aprobar: todos los viajes del detalle deben estar Finalizados." |
      | Admin       | PF-000012        | Borrador       | 1               | Finalizado            | 0.0    | "No se puede aprobar: el total de la Prefactura debe ser mayor a 0."          |

  # Esquema del escenario
  Scenario Outline: Bloquear aprobación o rechazo por permisos insuficientes o estado inválido de la Prefactura
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que existe una Prefactura con folio <folio_prefactura> en estado <estado_prefactura>
    # Cuando
    When el usuario intenta <accion>
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | folio_prefactura | estado_prefactura | accion              | error_esperado                                                            |
      | SinPermisos  | PF-000013        | Borrador          | "Aprobar Prefactura"| "Acceso denegado: no cuenta con permisos para aprobar/rechazar Prefacturas."|
      | Operaciones  | PF-000014        | Aprobada          | "Aprobar Prefactura"| "No se puede aprobar: la Prefactura no está en estado Borrador."           |
      | Admin        | PF-000015        | Rechazada         | "Rechazar Prefactura"| "No se puede rechazar: la Prefactura no está en estado Borrador."          |

  # Escenario adicional requerido para validar estructuras complejas (estructura de impresión) usando Doc Strings
  Scenario: Validar estructura mínima de la vista imprimible de Prefactura (Borrador y Aprobada)
    # Dado
    Given que la vista imprimible de la Prefactura debe contener la siguiente estructura mínima
      """
      {
        "encabezado": {
          "folio_prefactura": "PF-000001",
          "cliente": "Cliente A",
          "fecha_generacion": "YYYY-MM-DD",
          "estatus": "Borrador|Aprobada|Rechazada",
          "total": 0.0
        },
        "detalle": [
          {
            "folio_viaje": "V-000101",
            "ruta": "Ruta 1",
            "tipo_viaje": "Solo ida|Solo vuelta|Ida y vuelta",
            "tarifa": 0.0,
            "importe": 0.0
          }
        ]
      }
      """
    # Cuando
    When el usuario visualiza la vista imprimible de una Prefactura en estado "Borrador" o "Aprobada"
    # Entonces
    Then el sistema debe mostrar el encabezado y detalle conforme a la estructura mínima definida
