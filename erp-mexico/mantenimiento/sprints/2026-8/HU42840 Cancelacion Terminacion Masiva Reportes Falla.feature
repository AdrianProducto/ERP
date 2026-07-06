@Jaqueline @HU42840 @ReportesFallaMasivo
Feature: Utilería para Cancelación y/o Terminación Masiva de Reportes de Falla

    Yo como usuario del módulo de Mantenimiento
    requiero una utilería que permita cancelar o terminar masivamente Reportes de Falla
    Para que pueda limpiar registros pendientes sin tener que procesarlos uno por uno.

    Background: Given que el usuario tiene acceso a la utilería de cancelación/terminación masiva de Reportes de Falla
        And que existen Reportes de Falla en estado Pendiente en el sistema

    # ─────────────────────────────────────────────
    # FLUJO PRINCIPAL — FILTRAR Y SELECCIONAR
    # ─────────────────────────────────────────────

    Scenario: Filtrar reportes por rango de fechas y obtener resultados
        Given que el usuario ingresa una fecha de inicio y una fecha fin válidas
        When el usuario aplica el filtro
        Then el sistema muestra únicamente los Reportes de Falla en estado Pendiente cuya fecha se encuentra dentro del rango indicado
        And ningún reporte con Orden de Servicio vinculada aparece en los resultados

    Scenario: Filtrar reportes por rango de fechas y unidad específica
        Given que el usuario ingresa un rango de fechas válido
        And selecciona una o más unidades del catálogo
        When el usuario aplica el filtro
        Then el sistema muestra solo los Reportes de Falla Pendientes que corresponden a las unidades seleccionadas dentro del rango de fechas

    Scenario: Seleccionar todos los registros del resultado
        Given que el listado de resultados muestra uno o más Reportes de Falla
        When el usuario activa la opción "Seleccionar todos"
        Then todos los registros visibles en el listado quedan marcados para procesar

    Scenario: Seleccionar registros de forma individual
        Given que el listado de resultados muestra varios Reportes de Falla
        When el usuario marca manualmente uno o más registros del listado
        Then solo los registros marcados quedan seleccionados para procesar
        And los registros no marcados permanecen sin selección

    # ─────────────────────────────────────────────
    # FLUJO PRINCIPAL — EJECUTAR ACCIÓN MASIVA
    # ─────────────────────────────────────────────

    Scenario: Cancelar masivamente los reportes seleccionados
        Given que el usuario tiene uno o más Reportes de Falla seleccionados
        And el usuario captura un motivo de cancelación
        When el usuario ejecuta la acción "Cancelar"
        Then el sistema muestra un mensaje de confirmación indicando cuántos registros serán cancelados
        And al confirmar, todos los registros seleccionados cambian a estado Cancelado
        And el sistema muestra un resumen indicando cuántos registros se procesaron correctamente

    Scenario: Terminar masivamente los reportes seleccionados
        Given que el usuario tiene uno o más Reportes de Falla seleccionados
        When el usuario ejecuta la acción "Terminar"
        Then el sistema muestra un mensaje de confirmación indicando cuántos registros serán terminados
        And al confirmar, todos los registros seleccionados cambian a estado Terminado
        And el sistema muestra un resumen indicando cuántos registros se procesaron correctamente

    # ─────────────────────────────────────────────
    # VALIDACIONES — FILTROS
    # ─────────────────────────────────────────────

    Scenario: Intentar aplicar filtro sin rango de fechas
        Given que el usuario no ha ingresado fecha de inicio ni fecha fin
        When el usuario intenta aplicar el filtro
        Then el sistema muestra un mensaje indicando que el rango de fechas es requerido
        And no se ejecuta ninguna consulta

    Scenario: El filtro no devuelve resultados
        Given que el usuario ingresa un rango de fechas en el que no existen Reportes de Falla Pendientes
        When el usuario aplica el filtro
        Then el sistema muestra un mensaje indicando que no se encontraron registros con los filtros seleccionados
        And los botones de acción masiva permanecen deshabilitados

    Scenario: Todos los reportes encontrados tienen Orden de Servicio vinculada
        Given que el usuario aplica filtros que solo coinciden con Reportes de Falla en estado Atendido
        When el sistema procesa el filtro
        Then el listado de resultados aparece vacío
        And el sistema informa que no hay reportes disponibles para cancelar o terminar

    # ─────────────────────────────────────────────
    # VALIDACIONES — EJECUCIÓN MASIVA
    # ─────────────────────────────────────────────

    Scenario: Intentar ejecutar acción sin haber seleccionado registros
        Given que el listado muestra resultados pero el usuario no ha seleccionado ningún registro
        When el usuario intenta ejecutar "Cancelar" o "Terminar"
        Then el sistema muestra un mensaje indicando que debe seleccionar al menos un reporte
        And no se ejecuta ninguna acción

    Scenario: Intentar cancelar sin capturar motivo de cancelación
        Given que el usuario tiene registros seleccionados
        And el usuario no captura un motivo de cancelación
        When el usuario intenta ejecutar la acción "Cancelar"
        Then el sistema muestra un mensaje indicando que el motivo de cancelación es requerido
        And no se cancela ningún registro

    Scenario: El usuario cancela la confirmación antes de ejecutar
        Given que el usuario tiene registros seleccionados y ejecuta una acción masiva
        When el sistema muestra el mensaje de confirmación y el usuario elige "No"
        Then no se realiza ningún cambio en los registros
        And el listado permanece con la selección actual

    # ─────────────────────────────────────────────
    # FLUJOS ALTERNATIVOS
    # ─────────────────────────────────────────────

    Scenario: Proceso masivo con resultados parcialmente exitosos
        Given que el usuario ejecuta una acción masiva sobre N registros seleccionados
        When durante el proceso uno o más registros no pueden procesarse
        Then el sistema completa la operación sobre los registros que sí pudieron procesarse
        And muestra un resumen indicando cuántos se procesaron correctamente y cuántos fallaron
        And los registros fallidos conservan su estado original

    Scenario: El usuario cambia los filtros después de haber seleccionado registros
        Given que el usuario tiene registros seleccionados en el listado
        When el usuario modifica los filtros y aplica una nueva búsqueda
        Then la selección anterior se limpia
        And el listado muestra los nuevos resultados sin registros marcados

    Scenario Outline: Ejecutar acción masiva con distintos volúmenes de registros
        Given que el listado de resultados contiene <cantidad> Reportes de Falla Pendientes
        And el usuario selecciona todos los registros
        When el usuario ejecuta la acción "<accion>"
        Then el sistema procesa todos los registros seleccionados
        And muestra un resumen con <cantidad> registros procesados

        Ejemplos:
        | cantidad | accion   |
        | 1        | Cancelar |
        | 10       | Cancelar |
        | 1        | Terminar |
        | 10       | Terminar |

    # ─────────────────────────────────────────────
    # PERMISOS
    # ─────────────────────────────────────────────

    Scenario: Usuario sin permiso no puede acceder a la utilería
        Given que el usuario no cuenta con el derecho de acceso a la utilería de cancelación/terminación masiva
        When intenta acceder a la utilería
        Then el sistema no muestra la opción en el menú o bloquea el acceso
        And no puede ejecutar ninguna acción masiva
