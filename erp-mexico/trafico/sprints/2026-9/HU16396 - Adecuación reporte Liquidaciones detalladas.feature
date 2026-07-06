Feature: Adecuación del reporte de Liquidaciones Detalladas

  Como usuario del módulo de Tráfico
  Quiero que el reporte de Liquidaciones Detalladas muestre la información correcta en cada columna
  Para analizar la rentabilidad de las liquidaciones de forma confiable y tomar decisiones basadas en datos precisos.

  Background:
    Given existe una liquidación con información de ingresos, gastos, combustible, sueldos, casetas, maniobras y kilómetros recorridos
    And el usuario tiene acceso al reporte "Liquidaciones Detalladas"

  Scenario: Mostrar correctamente los kilómetros de la liquidación
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "KM LIQ." debe mostrar el valor del campo "KMS Reales"

  Scenario: Mostrar correctamente el rendimiento de la liquidación
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "REND." debe mostrar el resultado de Rendimiento real (en liquidaciones -> pestaña Rendimiento)

  Scenario: Mostrar correctamente los días de liquidación
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "DÍAS LIQ." debe mostrar el rango de días de la liquidación

  Scenario: Mostrar correctamente el ingreso de la liquidación
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "INGRESO" debe mostrar el valor registrado en el campo de ingresos

  Scenario: Mostrar correctamente el combustible de tractocamión
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "COMBUSTIBLE TR" debe sumar y mostrar el subtotal de gastos de viaje de Diesel en efectivo y crédito

  Scenario: Mostrar correctamente el combustible de thermo
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "COMBUSTIBLE TH" debe sumar y mostrar el subtotal de gastos de viaje de Diesel para thermo en efectivo y crédito

  Scenario: Calcular correctamente el porcentaje de combustible
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%COMBUSTIBLE" debe mostrar el resultado de "(Combustible TR / Ingreso) * 100"

  Scenario: Mostrar correctamente los sueldos de la liquidación
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "SUELDOS" debe mostrar el total de percepciones del operador correspondientes a la liquidación

  Scenario: Calcular correctamente el porcentaje de sueldos
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%SUELDOS" debe mostrar el resultado de "(Sueldos / Ingreso) * 100"

  Scenario: Mostrar correctamente el total de casetas
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "CASETAS" debe mostrar el subtotal de autopistas de la liquidación

  Scenario: Calcular correctamente el porcentaje de casetas
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%CASETAS" debe mostrar el resultado de "(Casetas / Ingreso) * 100"

  Scenario: Mostrar correctamente el importe de maniobras
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "MANIOBRAS" debe sumar y mostrar subtotal de los gastos de viaje marcados con el check "Considerar en reporte liquidaciones detalladas"

  Scenario: Calcular correctamente el porcentaje de maniobras
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%MANIOBRAS" debe mostrar el resultado de "(Maniobras / Ingreso) * 100"

  Scenario: Agregar columna Gastos de Viaje
    Given existen conceptos de gastos de viaje con nuevo check "Omitir en liquidaciones detalladas"
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then debe mostrarse la nueva columna "GASTOS DE VIAJE"
    And el importe debe ser la suma de subtotal de gastos de viaje 
    And debe excluir conceptos, como ejemplo: autopistas, IMSS, ISPT, bonos
    And cualquier gasto marcado con el nuevo check

  Scenario: Calcular correctamente la utilidad bruta
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "UTILIDAD BRUTA" debe mostrar el resultado de:
      """
      Ingreso - Combustible TR - Sueldos - Casetas - Maniobras
      """

  Scenario: Calcular correctamente el porcentaje de utilidad bruta
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%UTILIDAD BRUTA" debe mostrar el resultado de "(Utilidad Bruta / Ingreso) * 100"

  Scenario: Mostrar correctamente el indicador
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "INDICADOR" debe mostrar el mismo importe calculado en la columna "UTILIDAD BRUTA"

  Scenario: Calcular correctamente los gastos fijos
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "GTOS. FIJOS" debe mostrar el resultado de:
      """
      (Días LIQ. × 4,000) + (KM LIQ. × 1.8)
      """
    And KM LIQ. = campo KMS Reales

  Scenario: Calcular correctamente el porcentaje de gastos fijos
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%GTOS. FIJOS" debe mostrar el resultado de "(Gtos. Fijos / Ingreso) * 100"

  Scenario: Calcular correctamente la utilidad neta
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "UTILIDAD NETA" debe mostrar el resultado de:
      """
      Utilidad Bruta - Gtos. Fijos
      """

  Scenario: Calcular correctamente el porcentaje de utilidad neta
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "%UTILIDAD NETA" debe mostrar el resultado de "(Utilidad Neta / Ingreso) * 100"

  Scenario: Calcular correctamente la utilidad diaria
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "UTILIDAD DIARIA" debe mostrar el resultado de:
      """
      Utilidad Neta / Días LIQ.
      """

  Scenario: Calcular correctamente la venta por kilómetro (Venta x KM)
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "VENTA X KM" debe mostrar el resultado de:
      """
      Ingreso / KM LIQ.
      """
    And debe coincidir con el valor del campo "Ing. X KM"

  Scenario: Mostrar Origen y destino de todos los trayectos existentes en la liquidación
    When el usuario genera el reporte de Liquidaciones Detalladas 
    Then por cada trayecto existente se mostrará su origen y destino 
    And por cada trayecto se dará un salto de línea
      """
      Origen 1 / Destino 1
      Origen 2 / Destino 2 
      Origen 3 / Destino 3
      """

  Scenario: Mostrar correctamente los KM cargados y KM vacíos
    When el usuario genera el reporte de Liquidaciones Detalladas
    Then la columna "KM CARGADO / KM VACÍO" debe mostrar los valores registrados en el ERP
    And la suma del porcentaje kilómetros cargados y kilómetros vacíos debe ser igual a 100%