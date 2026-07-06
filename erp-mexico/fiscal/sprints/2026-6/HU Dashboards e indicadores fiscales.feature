# Característica
Feature: Dashboards e indicadores fiscales
  Como usuario de GM Fiscal
  Quiero consultar indicadores y tableros fiscales
  Para dar seguimiento al cumplimiento, detectar riesgos y tomar decisiones

  Background:
    Given que GM Fiscal cuenta con información fiscal consolidada
    And que existen filtros de consulta disponibles para análisis

  Scenario Outline: Consultar indicadores fiscales con filtros aplicados
    Given que el usuario consulta el dashboard con el filtro <filtro_aplicado>
    When el sistema procesa la consulta
    Then muestra los indicadores de <tipo_indicador>
    And presenta resultados consistentes con el filtro aplicado

    Examples:
      | filtro_aplicado | tipo_indicador               |
      | periodo         | cumplimiento de timbrado     |
      | proveedor       | estatus fiscal por proveedor |
      | tipo de CFDI    | distribución por tipo CFDI   |
      | deducibilidad   | deducible y no deducible     |
      | estatus         | documentos por estatus CFDI  |
      | forma de pago   | distribución por forma de pago |

  Scenario: Consultar indicadores fiscales sugeridos por stakeholder
    Given que existe información fiscal suficiente para analítica
    When el usuario consulta indicadores avanzados
    Then el sistema puede mostrar métricas como IVA, ISR provisional, pólizas vs REP y EFOS

  Scenario Outline: Mostrar respuesta controlada cuando no hay información suficiente para el tablero
    Given que la consulta del dashboard presenta la condición <condicion_consulta>
    When el usuario solicita ver indicadores
    Then el sistema responde con <mensaje_esperado>
    And mantiene estable la visualización del dashboard

    Examples:
      | condicion_consulta     | mensaje_esperado                                          |
      | sin datos del periodo  | No existe información para los filtros seleccionados      |
      | cálculo fuera de alcance | El indicador solicitado requiere una definición adicional |
      | error de integración   | No fue posible obtener la información para el dashboard   |
