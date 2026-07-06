Feature: Visualización de gastos de viaje en el reporte 35 Relación de nómina

  Como usuario de Tráfico
  Quiero visualizar en PDF, Excel y HTML en el reporte 35 Relación de nómina toda la información proveniente de Gastos de viaje 
  Para identificar correctamente los conceptos utilizados y sus importes dentro de cada liquidación.

  Background:
    Given que existe una liquidación con gastos de viaje registrados
    And que el reporte 35 Relación de nómina se encuentra disponible

  Scenario: Mostrar detalle de gastos cuando el check "Ver detalle en Gastos" está activo
    Given que el usuario activa el check "Ver detalle en Gastos"
    When genera el reporte 35 Relación de nómina
    Then el sistema debe mostrar el detalle de los gastos de viaje asociados a la liquidación

  Scenario: Mostrar todos los conceptos de gastos de viaje existentes en la liquidación
    Given que la liquidación contiene múltiples conceptos de gastos de viaje
    When el usuario consulta el reporte 35 Relación de nómina
    Then el sistema debe mostrar todos los conceptos de gastos de viaje registrados en la liquidación

  Scenario: Incluir conceptos default del sistema en el detalle de gastos
    Given que existen conceptos default configurados en el sistema
    And dichos conceptos fueron utilizados en la liquidación
    When el usuario genera el reporte 35 Relación de nómina
    Then el sistema debe incluir los conceptos default dentro del detalle de gastos de viaje

  Scenario: Mostrar el importe correspondiente de cada concepto de gasto
    Given que existen conceptos de gastos de viaje con importes registrados
    When el usuario genera el reporte 35 Relación de nómina
    Then el sistema debe mostrar el importe correspondiente de cada concepto de gasto

  Scenario: Mostrar subtotal, IVA y total de gastos en los totales de cada liquidación
    Given que la liquidación contiene gastos de viaje con cálculo de subtotal, IVA y total
    When el usuario genera el reporte 35 Relación de nómina con check activo
    Then el sistema debe mostrar el subtotal de gastos en la sección de totales de la liquidación
    And debe mostrar el IVA de gastos en la sección de totales de la liquidación
    And debe mostrar el total de gastos en la sección de totales de la liquidación

  Scenario: Mostrar subtotal, IVA y total de gastos en el gran total del reporte
    Given que el reporte contiene una o más liquidaciones con gastos de viaje
    When el usuario genera el reporte 35 Relación de nómina
    Then el sistema debe mostrar el subtotal acumulado de gastos en el gran total
    And debe mostrar el IVA acumulado de gastos en el gran total
    And debe mostrar el total acumulado de gastos en el gran total