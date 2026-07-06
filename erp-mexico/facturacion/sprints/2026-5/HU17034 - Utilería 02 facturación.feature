Feature: Validaciones de importes en utilería 02 - Asociar facturas a viajes

  Como usuario de facturación
  Quiero validar que los importes de factura y viaje coincidan
  Para asegurar que la asociación se realice correctamente

  Background:
    Given existe la utilería "02 - Asociar facturas a viajes"
    And el usuario ha iniciado sesión en el sistema

  # Visualización de viajes relacionados
  Scenario: Mostrar todos los viajes al activar el check
    Given el usuario se encuentra en la utilería
    When activa el check "Mostrar viajes ya relacionados"
    Then el sistema debe mostrar todos los viajes que hayan sido asociados a facturas
    And debe incluir viajes que cuentan con facturas con pago, nota de crédito y otros procesos asociados

  # Restricción de desasociación
  Scenario: No permitir desasociar factura con procesos asociados
    Given una factura está asociada a un viaje
    And la factura cuenta con un proceso adicional (pago, nota de crédito, etc.)
    When el usuario intenta desasociar la factura del viaje
    Then el sistema debe impedir la acción
    And debe mostrar el mensaje:
      """
      La factura cuenta con un (proceso + folio) asociado, por lo cual no es posible desasociar del viaje. Debe eliminar el documento para poder desasociar.
      """

  # Parámetro de validación
  Scenario: Visualización del parámetro de validación
    Given el usuario accede a la configuración de la utilería
    Then debe existir el parámetro en facturación "Asociar facturas a viajes en base a importes en utilería 02"
    And debe mostrar un tooltip con el texto:
      """
      Para asociar considera que coincidan subtotal, impuestos y total de factura y viaje.
      """

  # Validación de importes al asociar
  Scenario: Asociación exitosa cuando coinciden importes
    Given el parámetro de validación está activo
    And el usuario selecciona una factura por concepto
    And el usuario selecciona un viaje
    And los importes de subtotal, impuestos y total coinciden entre factura y viaje
    When el usuario intenta asociar la factura al viaje
    Then el sistema debe permitir la asociación

  Scenario: No permitir asociación cuando no coinciden importes
    Given el parámetro de validación está activo
    And el usuario selecciona una factura por concepto
    And el usuario selecciona un viaje
    And los importes de subtotal, impuestos y total no coinciden entre factura y viaje
    When el usuario intenta asociar la factura al viaje
    Then el sistema debe impedir la asociación
    And debe mostrar el mensaje:
      """
      El viaje seleccionado no cuenta con el mismo subtotal, impuesto y total de la factura.
      """

  # Comportamiento sin parámetro activo
  Scenario: Permitir asociación sin validar importes cuando el parámetro está inactivo
    Given el parámetro de validación está inactivo
    And el usuario selecciona una factura y un viaje
    When el usuario intenta asociar la factura al viaje
    Then el sistema debe permitir la asociación sin validar importes