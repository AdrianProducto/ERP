# language: es

Feature: Gestión de registros de combustible importados
  Como usuario de GM Integra
  Quiero consultar, buscar y eliminar registros de combustible importados
  Para corregir importaciones incorrectas sin generar duplicados en el ERP

  Background:
    Given el usuario tiene sesión activa en GM Integra
    And el usuario tiene acceso al módulo de logs de consumos de combustible

  # ─────────────────────────────────────────────
  # CONSULTA POR FECHA
  # ─────────────────────────────────────────────

  Scenario: Consultar registros de combustible de un día específico
    Given existen registros de combustible importados en el sistema
    When el usuario filtra por fecha del "2026-06-01" al "2026-06-01"
    Then el sistema muestra únicamente los registros cuya fecha de importación corresponde al 01/06/2026
    And los registros eliminados no aparecen en el listado

  Scenario: Consultar registros de un rango de fechas
    Given existen registros de combustible importados en distintas fechas
    When el usuario filtra por fecha desde el "2026-06-01" hasta el "2026-06-05"
    Then el sistema muestra todos los registros activos dentro de ese rango
    And los registros eliminados no aparecen en el listado

  Scenario: No existen registros para la fecha consultada
    Given no hay registros de combustible importados en la fecha indicada
    When el usuario filtra por fecha del "2026-06-03" al "2026-06-03"
    Then el sistema muestra el listado vacío
    And muestra un mensaje indicando que no se encontraron registros

  # ─────────────────────────────────────────────
  # BÚSQUEDA DE REGISTRO ESPECÍFICO
  # ─────────────────────────────────────────────

  Scenario: Buscar registro por número de tarjeta
    Given el listado de registros de combustible está visible
    When el usuario escribe el número de tarjeta "4152310000123456" en el campo de búsqueda
    Then el sistema muestra únicamente los registros cuya tarjeta coincide con "4152310000123456"

  Scenario: Buscar registro por número de comprobante
    Given el listado de registros de combustible está visible
    When el usuario escribe el número de comprobante "987654" en el campo de búsqueda
    Then el sistema muestra únicamente el registro cuyo número de comprobante es "987654"

  Scenario: Búsqueda sin resultados
    Given el listado de registros de combustible está visible
    When el usuario escribe un número de tarjeta que no existe en el sistema
    Then el sistema muestra el listado vacío
    And muestra un mensaje indicando que no se encontraron registros con ese criterio

  # ─────────────────────────────────────────────
  # VISIBILIDAD DE REGISTROS ELIMINADOS
  # ─────────────────────────────────────────────

  Scenario: Los registros eliminados no aparecen por defecto
    Given existen registros de combustible activos y eliminados en el sistema
    When el usuario consulta el listado sin activar la opción "Mostrar eliminados"
    Then el sistema muestra únicamente los registros activos
    And los registros con baja lógica no aparecen en la lista

  Scenario: Ver registros eliminados activando el check correspondiente
    Given existen registros de combustible activos y eliminados en el sistema
    When el usuario activa la opción "Mostrar eliminados"
    Then el sistema muestra tanto los registros activos como los eliminados
    And los registros eliminados se muestran con un indicador visual diferenciado (por ejemplo, tachados o en color gris)
    And se muestra quién eliminó el registro y en qué fecha

  # ─────────────────────────────────────────────
  # ELIMINACIÓN INDIVIDUAL — SOFT DELETE
  # ─────────────────────────────────────────────

  Scenario: Eliminar un registro que ya no existe en el ERP
    Given existe un registro de combustible activo en el sistema
    And el registro NO existe en el ERP de Tráfico
    When el usuario selecciona el registro y hace clic en "Eliminar"
    And confirma la eliminación en el modal de advertencia
    Then el sistema marca el registro como eliminado (baja lógica)
    And registra la fecha y hora de eliminación
    And registra el usuario que realizó la eliminación
    And el registro deja de aparecer en el listado por defecto

  Scenario: Intentar eliminar un registro que todavía existe en el ERP
    Given existe un registro de combustible activo con estatus "insertado exitosamente"
    And el registro EXISTE en el ERP de Tráfico
    When el usuario selecciona el registro y hace clic en "Eliminar"
    Then el sistema bloquea la eliminación
    And muestra el mensaje: "El registro todavía existe en el ERP. Bórrelo primero en Importación de combustible del módulo de Transporte antes de eliminarlo aquí"
    And el registro permanece activo sin cambios

  Scenario: Intentar eliminar cuando el ERP no responde
    Given existe un registro de combustible activo en el sistema
    And el servicio de verificación del ERP no está disponible
    When el usuario selecciona el registro y hace clic en "Eliminar"
    Then el sistema bloquea la eliminación por precaución
    And muestra un mensaje indicando que no fue posible verificar el estado del registro en el ERP
    And sugiere intentarlo nuevamente más tarde

  Scenario: Eliminar un registro que falló en la importación
    Given existe un registro de combustible con estatus "fallido" (no insertado en ERP)
    When el usuario selecciona el registro y hace clic en "Eliminar"
    And confirma la eliminación en el modal de advertencia
    Then el sistema marca el registro como eliminado sin consultar el ERP
    And el registro deja de aparecer en el listado por defecto

  Scenario: Cancelar la eliminación desde el modal de confirmación
    Given existe un registro de combustible activo en el sistema
    When el usuario selecciona el registro y hace clic en "Eliminar"
    And el modal de advertencia se muestra
    And el usuario hace clic en "Cancelar"
    Then el sistema cierra el modal sin realizar ningún cambio
    And el registro permanece activo en el listado

  # ─────────────────────────────────────────────
  # ELIMINACIÓN MASIVA
  # ─────────────────────────────────────────────

  Scenario: Eliminar múltiples registros que no existen en el ERP
    Given existen varios registros de combustible activos en el sistema
    And ninguno de los registros seleccionados existe en el ERP
    When el usuario selecciona 3 registros y hace clic en "Eliminar seleccionados"
    And confirma la eliminación en el modal de advertencia
    Then el sistema marca los 3 registros como eliminados
    And muestra un resumen: "3 registros eliminados correctamente"

  Scenario: Eliminación masiva con algunos registros bloqueados por el ERP
    Given existen varios registros de combustible activos en el sistema
    And 2 de los registros seleccionados existen en el ERP
    And 3 de los registros seleccionados NO existen en el ERP
    When el usuario selecciona los 5 registros y confirma la eliminación
    Then el sistema elimina únicamente los 3 registros que no existen en el ERP
    And muestra un resumen indicando: "3 registros eliminados, 2 bloqueados"
    And para cada registro bloqueado muestra el motivo: "Existe en el ERP de Tráfico"

  Scenario: Intentar eliminar en masa cuando todos los registros existen en el ERP
    Given el usuario selecciona 4 registros que todos existen en el ERP
    When el usuario confirma la eliminación masiva
    Then el sistema no elimina ningún registro
    And muestra el mensaje: "No se pudo eliminar ningún registro. Todos existen en el ERP de Tráfico"

  Scenario: Intentar ejecutar eliminación masiva sin seleccionar registros
    Given el listado de registros de combustible está visible con al menos un registro
    When el usuario hace clic en "Eliminar seleccionados" sin haber marcado ningún registro
    Then el sistema muestra un mensaje indicando que debe seleccionar al menos un registro
    And no realiza ninguna acción

  # ─────────────────────────────────────────────
  # CASOS BORDE
  # ─────────────────────────────────────────────

  Scenario: El listado tiene exactamente un registro y se elimina
    Given existe únicamente un registro de combustible activo en el sistema para la fecha consultada
    And el registro NO existe en el ERP
    When el usuario lo elimina y confirma
    Then el sistema muestra el listado vacío
    And muestra un mensaje indicando que no hay registros activos para esa fecha

  Scenario: Reimportación después de eliminar un registro fallido
    Given un registro de combustible fue eliminado porque tenía estatus "fallido"
    When el usuario ejecuta nuevamente el proceso de importación para el mismo día
    Then el sistema intenta insertar el registro en el ERP nuevamente
    And si la inserción es exitosa, crea un nuevo registro de log con estatus "insertado"

  Scenario: Un registro insertado en ERP se elimina correctamente tras borrarlo en Tráfico
    Given existe un registro con estatus "insertado exitosamente"
    And el usuario ya borró el consumo correspondiente en el Importación de combustible del módulo de Transporte del ERP
    When el usuario intenta eliminar el registro en GM Integra
    And el ERP confirma que el registro ya no existe
    And el usuario confirma la eliminación en el modal
    Then el sistema marca el registro como eliminado
    And la próxima importación del mismo día podrá insertar el consumo nuevamente en el ERP
