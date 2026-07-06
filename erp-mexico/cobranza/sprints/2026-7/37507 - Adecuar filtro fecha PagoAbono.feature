Feature: Ajuste de filtros de fechas en proceso Pago/Abono

  Como usuario de cobranza
  Quiero que el proceso Pago/Abono muestre por default el rango de fechas del día actual
  Para evitar la carga completa del historial de facturas y mejorar el rendimiento del proceso

  Background:
    Given que el usuario ingresa al proceso "Pago/Abono"

  Scenario: Mostrar rango de fechas por default al ingresar al proceso
    When el sistema carga la pantalla del proceso
    Then el filtro "Fecha inicial" deberá mostrar del día actual
    And el filtro "Fecha final" deberá mostrar del día actual

  Scenario: Mantener rango de fechas por default al seleccionar un cliente
    Given que el usuario visualiza el rango de fechas por default del día actual
    When el usuario selecciona un cliente
    Then el filtro "Fecha inicial" deberá conservar el día actual
    And el filtro "Fecha final" deberá conservar el día actual
    And el sistema no deberá cambiar automáticamente a la fecha de la factura más antigua del cliente

  Scenario: Evitar carga completa del historial de facturas
    Given que el usuario ingresa al proceso "Pago/Abono"
    When el sistema consulta las facturas disponibles
    Then únicamente deberá cargar las facturas comprendidas dentro del rango de fechas del día actual
    And el sistema deberá evitar cargar el historial completo de facturas