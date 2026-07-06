
Feature: Distribución de Ingresos por Trayecto en Liquidación 3 (Sueldo Base por Ruta/Trayecto)
  Como usuario del módulo de Tráfico
  Quiero integrar una nueva función para la liquidación 3 SUELDO BASE POR RUTA/TRAYECTO
  Para poder cumplir con la distribución de ingresos de cada trayecto

  Background:
    Given que existe activo check "Distribuir los ingresos por trayecto"
    And activa en catálogo "Rutas y Tarifas" la opción "Trayectos"
    And cada trayecto cuenta con una pestaña "Ingresos" donde se configura su distribución

  Scenario: Se incluye nuevo check con para nueva funcionalidad en liquidación 3
    Given Se agrega nuevo check de nombre "Priorizar Distribución en liquidación 3" 
    And se incluye en parámetros de Tráfico > pestaña General > Debajo de check "Distribuir los ingresos por Trayecto"
    And está desactivado por defecto

  Scenario: El check "Priorizar Distribución en liquidación 3" no tiene efecto si "Distribuir los ingresos por trayecto" está desactivado
    Given que el check "Distribuir los ingresos por trayecto" está desactivado
    When se intenta activar el check "Priorizar Distribución en liquidación 3"
    Then el check "Priorizar Distribución en liquidación 3" no debe afectar el cálculo de la liquidación

  Scenario: El check "Priorizar Distribución en liquidación 3" se habilita cuando "Distribuir los ingresos por trayecto" está activo
    Given que el check "Distribuir los ingresos por trayecto" está activo
    When se activa el check "Priorizar Distribución en liquidación 3"
    Then el sistema debe habilitar el nuevo funcionamiento por trayecto en liquidación 3 SUELDO BASE POR RUTA/TRAYECTO

  Scenario: La liquidación 3 funciona en base a los ingresos distribuidos la pestaña Ingresos de cada trayecto
    Given que el check "Priorizar Distribución en liquidación 3" está activo
    And un trayecto tiene configurada una distribución de ingresos en el Catálogo Rutas y Tarifas → Trayectos → pestaña Ingresos
    When se genera la liquidación 3 SUELDO BASE POR RUTA/TRAYECTO para dicho trayecto
    Then el importe asignado debe corresponder exactamente a la distribución configurada en la pestaña Ingresos

  Scenario: La distribución se respeta cuando los trayectos de un mismo viaje quedan en distintas liquidaciones
    Given que el check "Priorizar Distribución en liquidación 3" está activo
    And una carta porte/viaje tiene una factura de $10,000.00 con 3 trayectos configurados de la siguiente manera:
      | Trayecto   | Distribucion |
      | Trayecto 1 | 5000.00      |
      | Trayecto 2 | 3000.00      |
      | Trayecto 3 | 2000.00      |
    When el Trayecto 1 y el Trayecto 2 se incluyen en la liquidación "folio1"
    And el Trayecto 3 se incluye en la liquidación "folio2"
    Then la distribución de ingresos de la liquidación "folio1" debe ser $8,000.00
    And la distribución de ingresos de la liquidación "folio2" debe ser $2,000.00

  Scenario: Carta porte/viaje cuentan con n trayectos y se liquidan solo los que cuentan con llegada
    Given que una carta porte/viaje cuenta con varios trayectos
    And de estos solo algunos cuentan con llegada
    And estos se muestran en la liquidación
    Then al liquidar se distribuye el ingreso que se tiene configurado

  Scenario: Carta porte/viaje cuentan con n trayectos y no tienen salida o llegada
    Given que una carta porte/viaje cuenta con varios trayectos 
    When los trayectos no tienen salida o llegada 
    And estos no aparecen en la liquidación
    Then no es posible liquidar los trayectos 

  Scenario: Los trayectos que no contaban con salida o llegada ahora cuentan con llegada 
    Given que los trayectos que no tenían salida o llegada se asigna su llegada 
    And ya se muestran en la liquidación 
    Then al liquidar se distribuye el ingreso que se tiene configurado

  Scenario: Concepto de facturación incluido en el cálculo de ingresos de la liquidación
    Given que un concepto de facturación tiene activo el check "Incluir en el Cálculo de los Ingresos en la Liquidación"
    When se genera la liquidación 3 SUELDO BASE POR RUTA/TRAYECTO
    Then el sistema no debe ejecutar el proceso de cálculo de liquidación que se utiliza actualmente para dicho concepto
    And el importe del concepto de facturación debe omitirse
    And es como si el check "Incluir en el Cálculo de los Ingresos en la Liquidación" estuviese desactivado

  Scenario: Validar funcionamiento de reporte 15 Reporte de liquidaciones
    Given se encuentra activo check "Priorizar Distribución en liquidación 3" 
    And en reporte 15 se activa check "Ingresos por trayecto"
    When se ejecuta el reporte 
    Then el reporte mostrará la información de distribución de ingreso de cada trayecto

  Scenario: Se desactiva check "Priorizar Distribución en liquidación 3" 
    Given que se desactiva el check cuando se habían creado liquidaciones con la opción activa
    Then las liquidaciones creadas con estatus abierta y cerrada deben permanecer intactas y respetar sus importes
    And reporte 15 con check activo "Ingresos por trayecto" muestra la información normal del reporte 
  