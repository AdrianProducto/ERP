# Característica
Feature: Validaciones y cumplimiento fiscal
  Como usuario de GM Fiscal
  Quiero ejecutar validaciones fiscales sobre CFDI y proveedores
  Para prevenir riesgos antes de que impacten la operación o la contabilidad

  Background:
    Given que GM Fiscal dispone de reglas fiscales configuradas para validación
    And que existen catálogos fiscales y listas de referencia vigentes

  Scenario Outline: Validar cumplimiento fiscal de un CFDI antes de procesarlo
    Given que el CFDI presenta la regla fiscal <regla_fiscal>
    When el sistema ejecuta la validación fiscal
    Then el resultado de cumplimiento es <resultado_validacion>
    And se muestra el detalle de la validación al usuario

    Examples:
      | regla_fiscal              | resultado_validacion |
      | deducibilidad válida      | cumplido             |
      | tasa SAT válida           | cumplido             |
      | opinión positiva          | cumplido             |
      | proveedor en EFOS         | incumplido           |

  Scenario: Aplicar validaciones específicas del sector transporte
    Given que el CFDI corresponde a una operación del sector transporte
    When el sistema evalúa reglas fiscales especializadas
    Then aplica la validación conforme a las reglas definidas para ese sector

  Scenario Outline: Restringir el avance de procesos cuando se detectan riesgos fiscales
    Given que la validación fiscal detecta la condición <condicion_riesgo>
    When el usuario intenta continuar con el proceso
    Then el sistema responde con <resultado_control>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | condicion_riesgo           | resultado_control | mensaje_esperado                                          |
      | proveedor EFOS             | bloqueo           | El proveedor presenta riesgo fiscal y no puede procesarse |
      | opinión de cumplimiento negativa | advertencia  | La opinión de cumplimiento del proveedor es negativa      |
      | tasa fiscal inconsistente  | bloqueo           | El CFDI contiene tasas o impuestos inconsistentes         |
