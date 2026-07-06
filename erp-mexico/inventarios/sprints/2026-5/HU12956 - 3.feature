Feature: Validar información para la creación de Compras y pasivos desde la compra
    Yo como usuario de Inventarios,
    Quiero poder generar compras con la información correcta y validada de mis órdenes de compra,
    Para una mejor usabilidad del sistema y poder generar pasivos con la información correcta.

  Background:
    Given que el usuario tiene registros de órdenes de compra
      And la mejora de agregar el campo de impuesto IEPS al artículo ya fue implementada
      And existen registros de órdenes de compra en el que el impuesto IEPS está en el campo de impuesto tipo IVA

  Rule: Cada concepto dentro de un pasivo si es generado desde una Compra en el módulo de Inventarios representa el artículo descrito en la Compra

  Scenario: Generar una compra seleccionando órdenes de compra con el impuesto IEPS aplicado en su nuevo campo de impuesto tipo IEPS
    Given que el usuario está registrando una compra
      And el usuario selecciona ordenes de compra que tienen el impuesto IEPS en el nuevo campo de impuesto tipo IEPS
     When el sistema esté calculando los importes de las órdenes de compra seleccionadas
     Then el sistema calculará correctamente el importe del impuesto IEPS con base en el nuevo campo de impuesto tipo IEPS
      And el sistema calculará correctamente el importe total del impuesto IEPS incluyendo órdenes de compra que tengan artículos que sean combustibles
      And el sistema calculará correctamente el importe total de la compra sumando el importe de las órdenes de compra seleccionadas con el impuesto IEPS calculado

  Scenario: Generar Pasivo mediante una compra
    Given que tengo un registro de compra con órdenes de compra que tienen el impuesto IEPS en el nuevo campo de impuesto tipo IEPS
     When el usuario genere un pasivo desde la compra
     Then el sistema transferirá correctamente el importe del impuesto IEPS al concepto en el pasivo generado
      And el sistema transferirá correctamente el importe total de la compra al pasivo generado

