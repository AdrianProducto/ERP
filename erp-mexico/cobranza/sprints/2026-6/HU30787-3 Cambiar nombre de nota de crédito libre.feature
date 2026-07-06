Feature: Cambiar nombre de nota de crédito libre
  Como usuario del módulo de Contabilidad
  Quiero que la nota de crédito libre cambie de nombre a nota de crédito PEMEX
  Para que haga sentido con la operación para facturas pemex

  Background: 
    Given el usuario se encuentra en el modulo de Contabilidad

  Scenario: Actualización en Parámetros generales de contabilidad
      Given el usuario se encuentra dentro de la configuracion de Parámetros Generales de contabilidad
      When accede a la pestaña de "Integración Web"
      Then debe mostrarse la leyenda "Prepólizas para Notas de Crédito PEMEX" en lugar de "Prepólizas para Notas de Crédito Libres"

  Scenario: Actualización en utileria Eliminación Masiva de Pólizas
      Given el usuario se encuentra dentro de la utileria Eliminación Masiva de Pólizas
      When despliega el combo Proceso
      Then debe mostrarse la leyenda "NOTAS DE CRÉDITO PEMEX" en lugar de "NOTAS DE CRÉDITO LIBRE"

  Scenario: Actualización en utileria Reprocesar Periodos
      Given el usuario se encuentra dentro de la utileria Reprocesar Periodos
      And especifica los filtros requeridos
      When el usuario solicita realizar la búsqueda
      Then El sistema debe mostrar en la columna "Proceso" debe mostrar "Notas de Crédito PEMEX" en lugar de "Notas de Crédito Libre"