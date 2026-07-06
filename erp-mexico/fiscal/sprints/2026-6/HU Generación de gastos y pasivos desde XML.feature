# Característica
Feature: Generación de gastos y pasivos desde XML
  Como usuario de GM Fiscal
  Quiero generar gastos, pasivos u otros registros administrativos a partir de un CFDI XML
  Para convertir información fiscal en operaciones definitivas dentro del ERP sin reprocesos manuales

  Background:
    Given que GM Fiscal tiene acceso al XML del CFDI
    And que el ERP permite registrar gastos y pasivos
    And que existe control de duplicidad por UUID

  Scenario Outline: Generar correctamente un registro operativo desde un XML válido
    Given que el CFDI corresponde al tipo de operación <tipo_operacion>
    And que el proveedor <estado_proveedor> en el ERP
    And que el XML cumple con las reglas de deducibilidad
    When el usuario solicita generar el registro operativo
    Then el sistema crea el registro definitivo en ERP como <resultado_operacion>
    And relaciona el UUID del CFDI con el registro generado
    And deja trazabilidad documental del proceso

    Examples:
      | tipo_operacion | estado_proveedor | resultado_operacion |
      | gasto de viaje | existe           | gasto de viaje      |
      | pasivo         | existe           | pasivo              |
      | gasto general  | existe           | gasto general       |

  Scenario: Relacionar manualmente el viaje cuando el CFDI corresponde a gasto de viaje
    Given que el CFDI debe registrarse como gasto de viaje
    And que el viaje no puede inferirse automáticamente
    When el usuario captura el viaje relacionado
    Then el sistema permite continuar con la generación del gasto
    And el gasto queda asociado al viaje seleccionado

  Scenario Outline: Rechazar la generación cuando existen validaciones críticas incumplidas
    Given que el CFDI presenta la condición <condicion_invalida>
    When el usuario solicita generar el registro operativo
    Then el sistema rechaza la operación
    And muestra el mensaje <mensaje_esperado>
    And no crea ningún registro en ERP

    Examples:
      | condicion_invalida            | mensaje_esperado                                       |
      | UUID duplicado                | El CFDI ya fue procesado previamente                   |
      | proveedor no identificado     | Es necesario validar el proveedor antes de continuar   |
      | CFDI no deducible             | El CFDI no cumple con las reglas de deducibilidad      |
      | XML inconsistente             | El XML no contiene la información mínima requerida     |
