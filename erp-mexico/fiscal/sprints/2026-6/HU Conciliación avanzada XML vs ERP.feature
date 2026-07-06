# Característica
Feature: Conciliación avanzada XML vs ERP
  Como usuario de GM Fiscal
  Quiero comparar a detalle la estructura de un CFDI contra la información del ERP
  Para identificar diferencias reales y clasificar correctamente cada documento

  Background:
    Given que GM Fiscal tiene acceso al XML del CFDI y al registro correspondiente del ERP
    And que la conciliación básica por UUID ya fue realizada o es posible identificar el documento

  Scenario Outline: Conciliar correctamente un CFDI a nivel estructural
    Given que el CFDI y el ERP coinciden en <bloque_conciliado>
    When el sistema ejecuta la conciliación avanzada
    Then el resultado de conciliación del documento es <resultado_conciliacion>
    And el comparativo muestra el detalle de los campos evaluados

    Examples:
      | bloque_conciliado     | resultado_conciliacion |
      | cabecera              | conciliado correcto    |
      | impuestos             | conciliado correcto    |
      | conceptos             | conciliado correcto    |
      | relaciones CFDI       | conciliado correcto    |

  Scenario Outline: Detectar diferencias por bloque de información
    Given que existen diferencias en <bloque_diferencia> entre el XML y el ERP
    When el sistema ejecuta la conciliación avanzada
    Then el documento queda clasificado como <resultado_conciliacion>
    And el sistema resalta las diferencias por campo

    Examples:
      | bloque_diferencia | resultado_conciliacion     |
      | cabecera          | conciliado con diferencias |
      | impuestos         | conciliado con diferencias |
      | conceptos         | conciliado con diferencias |
      | relaciones CFDI   | no conciliado              |

  Scenario: Filtrar documentos por tipo de inconsistencia
    Given que existen documentos con distintos resultados de conciliación
    When el usuario filtra por tipo de inconsistencia
    Then el sistema muestra solo los CFDI que cumplen con el criterio seleccionado

  Scenario: Mostrar comparación detallada XML SAT vs ERP
    Given que un CFDI tiene diferencias detectadas
    When el usuario consulta el detalle de conciliación
    Then el sistema muestra un comparativo campo a campo entre XML SAT y ERP
    And resalta visualmente los campos con discrepancias
