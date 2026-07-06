Feature: Agregar nueva opción de aplicar impuesto tipo IEPS en las órdenes de compra
    Yo como usuario de Inventarios,
    Quiero poder aplicar el impuesto tipo IEPS en los artículos al hacer una orden de compra,
    Para un mejor control de los impuestos en mis compras.

  Background:
    Given que están los artículos registrados en el sistema en su catálogo
      And el usuario tiene acceso al módulo de Inventarios y al módulo de Compras

  Scenario: Registrar una orden de compra aplicando el impuesto tipo IEPS al artículo
    Given que el usuario haya asignado al proveedor al que se le hará la orden de compra
      And el usuario va a escoger los artículos a comprar
     When el usuario esté especificando los detalles del artículo
      And el usuario observe la nueva opción para aplicar el impuesto tipo IEPS en la sección de impuestos del artículo
      And el usuario seleccione la opción de aplicar el impuesto tipo IEPS
     Then el usuario podrá escoger el porcentaje del impuesto tipo IEPS según los tipos de IEPS registrados en el catálogo de impuestos
      And el sistema debe aplicar el impuesto tipo IEPS al importe del artículo
      And el sistema mostrará el resultado del importe total de IEPS aplicado al listado de artículos en la orden de compra

  Scenario: Registrar una orden de compra aplicando diferentes impuestos
    Given que el usuario haya asignado al proveedor al que se le hará la orden de compra
      And el usuario va a escoger los artículos a comprar
     When el usuario esté especificando los detalles del artículo
      And el usuario quiera asignar un impuesto de IVA
      And el usuario quiera asignar un impuesto de IEPS
     Then el sistema debe mostrar sólamente los impuestos tipo IVA registrados del catálogo de Impuestos al querer asignar el IVA del artículo
      And el sistema debe mostrar sólamente los impuestos tipo IEPS registrados del catálogo de Impuestos al querer asignar el IEPS del artículo
      And el sistema debe aplicar ambos impuestos al importe del artículo
      And el sistema mostrará el resultado del importe total de IVA e IEPS aplicado al listado de artículos en la orden de compra

  Scenario: Registrar una orden de compra de un artículo tipo combustible
    Given que el usuario haya asignado al proveedor al que se le hará la orden de compra
      And el usuario va a escoger los artículos a comprar
     When el usuario escoja un artículo de tipo "Combustible"
      And el usuario esté especificando los detalles del artículo
     Then el usuario no podrá asignar un impuesto tipo IEPS al artículo
      And el sistema permitirá asignar un impuesto tipo IVA al artículo que sólo muestre los impuestos tipo IVA registrados del catálogo de Impuestos
      And el sistema calculará automáticamente el impuesto tipo IEPS según el factor asignado al proveedor desde el catálogo de Proveedores IEPS de Cuentas por Pagar
      And el sistema mostrará el resultado del importe total de IVA e IEPS aplicado al listado de artículos en la orden de compra



