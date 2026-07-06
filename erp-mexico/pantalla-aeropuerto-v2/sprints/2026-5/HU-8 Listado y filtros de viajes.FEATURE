# Característica
Feature: Listado y filtros de Recorridos/Viajes con acciones rápidas (Ver, Editar, Cancelar, Iniciar y Finalizar)

  Como Operaciones
  Quiero visualizar un listado de Recorridos/Viajes por defecto del día, con filtros y paginación
  Para gestionar rápidamente la operación (consultar, editar, cancelar, iniciar y finalizar viajes) según su estado y reglas del negocio

  # Antecedentes
  Background:
    # Dado
    Given que existen Recorridos/Viajes registrados con diferentes fechas, clientes, folios, estados y tipos de viaje
    # Y
    And que los Recorridos/Viajes de tipo "Ida y vuelta" se muestran como un solo registro en el listado
    # Y
    And que el ordenamiento por defecto del listado es por "Fecha" descendente
    # Y
    And que el listado cuenta con paginación habilitada
    # Y
    And que los viajes "Cancelados" se pueden incluir o excluir mediante un filtro

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Consultar listado del día y aplicar filtros (rango de fechas, cliente, folio y estados múltiples) con paginación
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que el usuario se encuentra en la pantalla "Listado de Recorridos/Viajes"
    # Y
    And que el filtro de fechas está configurado como <rango_fechas>
    # Y
    And que el filtro de cliente está configurado como <cliente>
    # Y
    And que el filtro de folio está configurado como <folio_busqueda>
    # Y
    And que el filtro de estados está configurado como <estados_seleccionados>
    # Y
    And que el filtro "Incluir cancelados" está configurado como <incluir_cancelados>
    # Cuando
    When el usuario aplica los filtros y navega a la página <pagina>
    # Entonces
    Then el sistema muestra el listado con los Recorridos/Viajes que cumplen <resultado_esperado>
    # Y
    And el sistema mantiene el ordenamiento por "Fecha" descendente
    # Y
    And el sistema muestra la paginación con el indicador de página <pagina>

    # Ejemplos
    Examples:
      | rol_usuario  | rango_fechas                 | cliente    | folio_busqueda | estados_seleccionados                  | incluir_cancelados | pagina | resultado_esperado                                                                 |
      | Operaciones  | Hoy                          | TODOS      | VACIO          | Programado,En curso,Finalizado         | No                 | 1      | "Se muestran solo viajes del día no cancelados con estados seleccionados."        |
      | Operaciones  | 2026-04-03 a 2026-04-10       | Cliente A  | VACIO          | Programado,En curso,Finalizado,Cancelado | Sí               | 1      | "Se muestran viajes del rango para Cliente A, incluyendo cancelados."             |
      | Operaciones  | 2026-04-03 a 2026-04-10       | TODOS      | V-000123       | Programado,En curso,Finalizado,Cancelado | Sí               | 1      | "Se muestran únicamente los viajes cuyo folio coincide con la búsqueda."          |
      | Admin        | Hoy                          | Cliente B  | VACIO          | Programado,En curso                    | No                 | 2      | "Se muestran viajes del día para Cliente B en página 2, excluyendo cancelados."   |

  # Esquema del escenario
  Scenario Outline: Ejecutar acciones rápidas desde el listado según estado y reglas del negocio
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Y
    And que existe un Recorrido/Viaje con folio <folio> en estado <estado_viaje>
    # Y
    And que el Recorrido/Viaje tiene la condición de edición <condicion_edicion>
    # Cuando
    When el usuario intenta ejecutar la acción <accion> desde el listado sobre el folio <folio>
    # Entonces
    Then el sistema ejecuta la acción y obtiene el resultado <resultado_esperado>

    # Ejemplos
    Examples:
      | rol_usuario | folio    | estado_viaje | condicion_edicion                           | accion       | resultado_esperado                                                                 |
      | Operaciones | V-000101 | Programado   | "Sin paradas terminadas"                    | Ver detalle  | "Se abre el detalle del viaje."                                                    |
      | Operaciones | V-000101 | Programado   | "Sin paradas terminadas"                    | Editar       | "Se permite editar el viaje."                                                      |
      | Operaciones | V-000102 | Programado   | "Sin paradas terminadas"                    | Cancelar     | "El viaje cambia a estado Cancelado y se registra el comentario de cancelación."   |
      | Operaciones | V-000103 | Programado   | "Sin paradas terminadas"                    | Iniciar      | "El viaje cambia a estado En curso."                                               |
      | Operaciones | V-000104 | En curso     | "Con paradas en proceso/pendientes"         | Finalizar    | "El viaje cambia a estado Finalizado si cumple reglas de finalización (HU07)."     |
      | Admin       | V-000105 | Programado   | "Sin paradas terminadas"                    | Cancelar     | "El viaje cambia a estado Cancelado y se registra el comentario de cancelación."   |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Bloquear acciones desde el listado por estado inválido, reglas de edición o restricciones de ejecución
    # Dado
    Given que existe un Recorrido/Viaje con folio <folio> en estado <estado_viaje>
    # Y
    And que el Recorrido/Viaje tiene la condición <condicion_negocio>
    # Cuando
    When el usuario intenta ejecutar la acción <accion> desde el listado
    # Entonces
    Then el sistema bloquea la operación y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | folio    | estado_viaje | condicion_negocio                                   | accion    | error_esperado                                                                 |
      | V-000201 | Finalizado   | "Viaje finalizado"                                 | Editar    | "No se puede editar: el viaje no está en estado Programado."                   |
      | V-000202 | Programado   | "Con al menos una parada terminada"                | Editar    | "No se puede editar: existen paradas terminadas en el viaje."                  |
      | V-000203 | En curso     | "Viaje en curso"                                   | Cancelar  | "No se puede cancelar: solo se permiten cancelaciones en estado Programado."   |
      | V-000204 | Programado   | "Sin operador o sin unidad asignados"              | Finalizar | "No se puede finalizar: el operador y la unidad son obligatorios."             |
      | V-000205 | En curso     | "Existen paradas pendientes"                       | Finalizar | "No se puede finalizar: todas las paradas seleccionadas deben estar terminadas."|

  # Esquema del escenario
  Scenario Outline: Bloquear consulta por permisos insuficientes
    # Dado
    Given que el usuario autenticado tiene el rol <rol_usuario>
    # Cuando
    When el usuario intenta acceder al "Listado de Recorridos/Viajes"
    # Entonces
    Then el sistema bloquea el acceso y muestra el error <error_esperado>

    # Ejemplos
    Examples:
      | rol_usuario  | error_esperado                                                     |
      | SinPermisos  | "Acceso denegado: no cuenta con permisos para visualizar viajes."   |

  # Escenario adicional requerido para validar estructuras complejas (columnas del grid) usando Doc Strings
  Scenario: Validar estructura de columnas visibles del listado de Recorridos/Viajes en el MVP
    # Dado
    Given que el listado de Recorridos/Viajes debe mostrar exactamente las siguientes columnas en el grid
      """
      [
        "Folio",
        "Fecha",
        "Cliente/Empresa",
        "Ruta",
        "Turno",
        "Tipo de viaje",
        "Operador",
        "Unidad",
        "Estado",
        "Pasajeros totales",
        "Horario salida/llegada (resumen)",
        "Incidencia (sí/no)"
      ]
      """
    # Cuando
    When el usuario visualiza el listado de Recorridos/Viajes
    # Entonces
    Then el sistema debe renderizar el grid con dichas columnas en el orden especificado