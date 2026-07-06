
Feature: API para consulta de horas de servicio consumidas por mecánico
  Como usuario del módulo de Mantenimiento
  Quiero un servicio web API que permita consultar, por periodo de fechas,
  las horas de servicio consumidas por cada mecánico
  Para visualizar dicha información basada en el proceso de Ordenes de servcio y reporte Kardex de unidad (reporte de servicio),
  considerando únicamente órdenes de servicio con estatus CERRADA.

  Background:
    Given que el servicio web de consulta de horas por mecánico está disponible
    And que la información se basa en el proceso de Ordenes de servcio y reporte de Mantenimiento "Kardex de unidad (reporte de servicio)"
    And que el servicio solo considera órdenes de servicio con estatus CERRADA

  Scenario: Consulta exitosa sin filtro de mecánico (todos los mecánicos)
    Given que envío el filtro FechaInicio "20260101" y FechaFinal "20260131"
    And no envío CodMecanicoInicio ni CodMecanicoFinal
    When se ejecuta el servicio web
    Then el servicio retorna en el encabezado FechaInicio "20260101" y FechaFinal "20260131"
    And el encabezado retorna TotalOS con el total de órdenes de servicio CERRADA encontradas en el periodo, sumando las de todos los mecánicos
    And la lista "Mecanicos" incluye a todos los mecánicos con OS cerrada dentro del periodo
    And cada mecánico muestra CodMecanico, Mecanico, TotalHoras y CantidadOS 
    And TotalHoras de cada mecánico corresponde a la suma de TiempoReparacion de sus órdenes de servicio
    And cada mecánico incluye el detalle "OrdenesServicio" con FolioOS, CodServicio, DescServicio y TiempoReparacion

  Scenario: Consulta exitosa filtrando un único mecánico (solo CodMecanicoInicio)
    Given que envío el filtro FechaInicio "20260101" y FechaFinal "20260131"
    And envío únicamente CodMecanicoInicio "00323"
    When se ejecuta el servicio web 
    Then el servicio filtra únicamente al mecánico con código "00323"
    And la lista "Mecanicos" contiene solo la información de ese mecánico
    And el código del mecánico se muestra conservando los ceros a la izquierda "00323"

  Scenario: Consulta exitosa filtrando un rango de mecánicos
    Given que envío el filtro FechaInicio "20260101" y FechaFinal "20260131"
    And envío CodMecanicoInicio "00100" y CodMecanicoFinal "00200"
    When ejecuto el servicio web
    Then el servicio retorna únicamente los mecánicos cuyo código está dentro del rango "00100" a "00200"
    And solo se incluyen órdenes de servicio con estatus CERRADA dentro del periodo seleccionado

  Scenario: Error al no enviar FechaInicio
    Given que no envío el filtro FechaInicio
    And envío FechaFinal "20260131"
    When ejecuto el servicio web
    Then el servicio no continúa con la consulta
    And muestra el mensaje de error "No se incluyó filtro FechaInicio, no es posible continuar."

  Scenario: Error al no enviar FechaFinal
    Given que envío FechaInicio "20260101"
    And no envío el filtro FechaFinal
    When ejecuto el servicio web
    Then el servicio no continúa con la consulta
    And muestra el mensaje de error "No se incluyó filtro FechaFinal, no es posible continuar."

  Scenario: Error cuando FechaFinal es menor a FechaInicio
    Given que envío FechaInicio "20260131"
    And envío FechaFinal "20260101"
    When ejecuto el servicio web
    Then el servicio no continúa con la consulta
    And muestra el mensaje de error "FechaFinal es menor a fecha inicio, favor de revisar."

  Scenario: No se encuentran órdenes de servicio con los filtros seleccionados
    Given que envío el filtro FechaInicio "20260101" y FechaFinal "20260131"
    And no existen órdenes de servicio con estatus CERRADA que cumplan con los filtros
    When ejecuto el servicio web
    Then el encabezado retorna TotalOS "0"
    And la lista "Mecanicos" se retorna vacía "[ ]"
    And muestra el mensaje "No existe información con los filtros seleccionados."

  Scenario: Los códigos mantienen ceros a la izquierda
    Given que envío el filtro FechaInicio "20260101" y FechaFinal "20260131"
    When ejecuto el servicio web
    Then los valores de CodMecanico, CodServicio y FolioOS se retornan conservando los ceros a la izquierda, por ejemplo "00323"

  Scenario: Solo se incluyen órdenes de servicio con estatus CERRADA
    Given que en el periodo consultado existen órdenes de servicio en estatus distinto a CERRADA
    And envío el filtro FechaInicio "20260101" y FechaFinal "20260131"
    When ejecuto el servicio web
    Then el resultado no incluye órdenes de servicio con estatus diferente a CERRADA
    And únicamente se consideran las órdenes de servicio con estatus CERRADA para el cálculo de TotalOS, CantidadOS y TotalHoras

  Scenario: Al consultar la información esta se muestra con paginación 
    Given que al seleccionar filtros con un rango muy amplio
    And envío el filtro FechaInicio "20260101" y FechaFinal "20261231"
    When ejecuto el servicio web
    Then se debe paginar la información para que no se sature la consulta
