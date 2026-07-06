@trafico @usuario @folio-39506
Feature: Excluir trayectos no liquidables de la captura de egresos
  Como usuario de Tráfico
  Quiero que los trayectos marcados como no liquidables no puedan usarse en egresos
  Para evitar que se carguen gastos sobre trayectos que no deben liquidarse

  Background:
    Given que existe un trayecto marcado como "No liquidable"

  Scenario: Impedir seleccionar un trayecto no liquidable en gastos de viaje
    Given que el usuario captura un gasto de viaje
    When consulta los trayectos disponibles para asociar el gasto
    Then el trayecto marcado como "No liquidable" no aparece como seleccionable

  Scenario: Impedir seleccionar un trayecto no liquidable en anticipos
    Given que el usuario registra un anticipo
    When consulta los trayectos disponibles para asociar el anticipo
    Then el trayecto marcado como "No liquidable" no aparece como seleccionable

  Scenario: Impedir seleccionar un trayecto no liquidable en vales de combustible
    Given que el usuario captura un vale de combustible
    When consulta los trayectos disponibles para asociar el vale
    Then el trayecto marcado como "No liquidable" no aparece como seleccionable

  Scenario: Permitir seleccionar un trayecto liquidable en egresos
    Given que existe un trayecto marcado como "Liquidable"
    When el usuario consulta los trayectos disponibles para un gasto, anticipo o vale de combustible
    Then el trayecto "Liquidable" sí aparece como seleccionable