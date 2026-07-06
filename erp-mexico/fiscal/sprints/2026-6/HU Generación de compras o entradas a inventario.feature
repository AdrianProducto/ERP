# Característica
Feature: Generación de compras o entradas a inventario desde CFDI
  Como usuario de GM Fiscal
  Quiero generar compras o entradas a inventario a partir de un CFDI
  Para llevar la operación fiscal hacia procesos formales del ERP

  Background:
    Given que GM Fiscal puede interpretar conceptos del XML
    And que el ERP cuenta con catálogo de artículos y proveedores

  Scenario: Generar compra relacionada a una orden de compra autorizada
    Given que el proveedor del CFDI existe en el ERP
    And que los conceptos del XML tienen equivalencia con artículos del ERP
    And que existe una orden de compra autorizada previamente
    When el usuario solicita generar la compra
    Then el sistema crea la compra en ERP asociada a la orden autorizada
    And relaciona el UUID del CFDI con la compra generada

  Scenario: Generar entrada a inventario cuando la operación corresponde a almacén
    Given que el CFDI corresponde a una operación de inventario
    And que los conceptos del XML tienen equivalencia con artículos del ERP
    When el usuario confirma la generación de la entrada
    Then el sistema crea la entrada a inventario en ERP
    And conserva trazabilidad entre el XML y el movimiento de almacén

  Scenario Outline: Rechazar la operación cuando faltan validaciones operativas
    Given que el CFDI presenta la condición <condicion_invalida>
    When el usuario solicita generar la compra o entrada
    Then el sistema no genera el registro en ERP
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | condicion_invalida                     | mensaje_esperado                                                |
      | no existe equivalencia de conceptos    | No existe equivalencia entre conceptos del XML y artículos ERP  |
      | no existe orden de compra autorizada   | Es necesaria una orden de compra autorizada para continuar      |
      | UUID ya procesado                      | El CFDI ya fue utilizado previamente en un registro operativo   |
      | proveedor no validado                  | El proveedor debe validarse antes de generar la compra          |
