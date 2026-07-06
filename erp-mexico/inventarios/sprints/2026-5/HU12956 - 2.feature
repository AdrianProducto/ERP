Feature: Agregar validaciones al momento de modificar OC
    Yo como usuario de Inventarios,
    Quiero poder modificar mis órdenes de compra respetando las nuevas validaciones aplicadas,
    Para una mejor usabilidad del sistema y cuidar la información.

  Background:
    Given que el usuario tiene registros de órdenes de compra
      And la mejora de agregar el campo de impuesto IEPS al artículo ya fue implementada
      And existen registros de órdenes de compra en el que el impuesto IEPS está en el campo de impuesto tipo IVA

  Scenario: Modificar un registro en donde estaba el impuesto IEPS en el campo de impuesto tipo IVA sin retenciones de IVA
    Given que ya existe un registro de una orden de compra
      And haya artículos que tienen impuestos tipo IEPS en el campo de impuesto IVA
     When el usuario vaya a modificar los artículos dentro de la orden de compra 
     Then el sistema transferirá el valor del impuesto IEPS que estaba en el campo de impuesto tipo IVA en el nuevo campo de tipo IEPS
      And el sistema asignará automáticamente el valor del impuesto IVA a "NO OBJETO"

  Scenario: Modificar un registro en donde estaba el impuesto IEPS en el campo de impuesto tipo IVA con retenciones de IVA
    Given que ya existe un registro de una orden de compra
      And haya artículos que tienen impuestos tipo IEPS en el campo de impuesto IVA
     When el usuario vaya a modificar los artículos dentro de la orden de compra
     Then el sistema transferirá el valor del impuesto IEPS que estaba en el campo de impuesto tipo IVA en el nuevo campo de tipo IEPS
      And el sistema asignará automáticamente el valor del impuesto IVA a "IVA 0%"
      And el sistema validará al guardar la modificación que si existe un valor de retención de IVA mayor al impuesto de IVA mostrará un mensaje de error diciendo
        '''
        El valor de la retención de IVA es mayor al importe de IVA.
        '''


