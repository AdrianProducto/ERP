@Jaqueline @HU42840 @ReportesFallaCancelacionMasiva
Feature: Utilería para Cancelación Masiva de Reportes de Falla

    Yo como usuario del módulo de Mantenimiento
    requiero una utilería que permita cancelar masivamente Reportes de Falla en estado Pendiente
    Para que pueda limpiar registros sin tener que cancelarlos uno por uno.

    Background: Given que el usuario tiene acceso a la utilería de cancelación masiva de Reportes de Falla
        And que existen Reportes de Falla en estado Pendiente en el sistema

    # ─────────────────────────────────────────────
    # FILTROS
    # ─────────────────────────────────────────────

    Scenario: Filtrar reportes por rango de fechas
        Given que el usuario ingresa una fecha de inicio y una fecha fin válidas
        When el usuario aplica el filtro
        Then el sistema muestra únicamente los Reportes de Falla en estado Pendiente dentro del rango indicado
        And ningún reporte con Orden de Servicio vinculada aparece en los resultados

    Scenario: Filtrar reportes por rango de fechas y unidad
        Given que el usuario ingresa un rango de fechas válido
        And selecciona una o más unidades del catálogo
        When el usuario aplica el filtro
        Then el sistema muestra solo los Reportes de Falla Pendientes de las unidades seleccionadas dentro del rango de fechas

    Scenario: Intentar filtrar sin rango de fechas
        Given que el usuario no ha ingresado fecha de inicio ni fecha fin
        When el usuario intenta aplicar el filtro
        Then el sistema muestra un mensaje indicando que el rango de fechas es requerido
        And no se ejecuta ninguna consulta

    Scenario: El filtro no devuelve resultados
        Given que el usuario ingresa un rango de fechas en el que no existen Reportes de Falla Pendientes
        When el usuario aplica el filtro
        Then el sistema muestra un mensaje indicando que no se encontraron registros con los filtros aplicados
        And el botón de cancelación masiva permanece deshabilitado

    # ─────────────────────────────────────────────
    # SELECCIÓN DE REGISTROS
    # ─────────────────────────────────────────────

    Scenario: Seleccionar todos los registros del resultado
        Given que el listado de resultados muestra uno o más Reportes de Falla
        When el usuario activa la opción "Seleccionar todos"
        Then todos los registros visibles en el listado quedan marcados para cancelar

    Scenario: Seleccionar registros de forma individual
        Given que el listado de resultados muestra varios Reportes de Falla
        When el usuario marca manualmente uno o más registros del listado
        Then solo los registros marcados quedan seleccionados
        And los registros no marcados permanecen sin selección

    Scenario: El usuario cambia los filtros después de haber seleccionado registros
        Given que el usuario tiene registros seleccionados en el listado
        When el usuario modifica los filtros y aplica una nueva búsqueda
        Then la selección anterior se limpia
        And el listado muestra los nuevos resultados sin registros marcados

    # ─────────────────────────────────────────────
    # EJECUCIÓN DE CANCELACIÓN MASIVA
    # ─────────────────────────────────────────────

    Scenario: Cancelar masivamente los reportes seleccionados
        Given que el usuario tiene uno o más Reportes de Falla seleccionados
        And el usuario captura un motivo de cancelación
        When el usuario ejecuta la acción "Cancelar"
        Then el sistema muestra un mensaje de confirmación indicando cuántos registros serán cancelados
        And al confirmar, todos los registros seleccionados cambian a estado Cancelado
        And el sistema muestra un resumen indicando cuántos registros se procesaron correctamente

    Scenario: El usuario cancela la confirmación antes de ejecutar
        Given que el usuario tiene registros seleccionados y ejecuta la cancelación masiva
        When el sistema muestra el mensaje de confirmación y el usuario elige "No"
        Then no se realiza ningún cambio en los registros
        And el listado permanece con la selección actual

    # ─────────────────────────────────────────────
    # VALIDACIONES
    # ─────────────────────────────────────────────

    Scenario: Intentar cancelar sin haber seleccionado registros
        Given que el listado muestra resultados pero el usuario no ha seleccionado ningún registro
        When el usuario intenta ejecutar la cancelación masiva
        Then el sistema muestra un mensaje indicando que debe seleccionar al menos un reporte
        And no se cancela ningún registro

    Scenario: Intentar cancelar sin capturar motivo de cancelación
        Given que el usuario tiene registros seleccionados
        And el usuario no captura un motivo de cancelación
        When el usuario intenta ejecutar la cancelación masiva
        Then el sistema muestra un mensaje indicando que el motivo de cancelación es requerido
        And no se cancela ningún registro

    Scenario: Proceso masivo con resultados parcialmente exitosos
        Given que el usuario ejecuta la cancelación masiva sobre varios registros seleccionados
        When durante el proceso uno o más registros no pueden cancelarse
        Then el sistema completa la operación sobre los registros que sí pudieron procesarse
        And muestra un resumen indicando cuántos se cancelaron correctamente y cuántos fallaron
        And los registros fallidos conservan su estado Pendiente

    # ─────────────────────────────────────────────
    # PERMISOS
    # ─────────────────────────────────────────────

    Scenario: Usuario sin permiso no puede acceder a la utilería
        Given que el usuario no cuenta con el derecho de acceso a la utilería de cancelación masiva
        When intenta acceder a la utilería
        Then el sistema no muestra la opción en el menú o bloquea el acceso
