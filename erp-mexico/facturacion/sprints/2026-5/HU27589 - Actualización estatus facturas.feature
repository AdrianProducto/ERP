Feature: Actualizar estatus de cancelación de facturas

  Como usuario de facturación con usuario GM
  Quiero poder modificar manualmente el estatus de una factura en estado "Pendiente de cancelación"
  Para permitir al cliente continuar con su operación sin esperar la respuesta del SAT

# Acceso y permisos
  Scenario: Acceso a la utilería solo para usuario GM
    Given el usuario es usuario GM
    When intenta acceder a la utilería
    Then el sistema debe permitir acceder a la utilería "Actualizar estatus de cancelación de facturas"

  Scenario: Acceso a la utileria para usuarios diferentes a GM
    Given el usuario no es usuario GM
    When navega por el sistema
    Then no debe visualizar la utilería "Actualizar estatus de cancelación de facturas"

  # Filtros
  Scenario: Visualización de filtros de fecha
    Given el usuario tiene rol GM
    When accede a la utilería
    Then debe visualizar un filtro "Fecha desde" con valor por defecto el primero del mes
    And debe visualizar un filtro "Fecha hasta" con valor por defecto el último del mes
    And debe visualizar el botón "Aplicar"

  Scenario: Búsqueda de facturas por rango de fechas
    Given el usuario ha seleccionado un rango de fechas válido
    When da clic en el botón "Aplicar"
    Then el sistema debe mostrar un listado de facturas dentro del rango seleccionado

  # Listado
  Scenario: Visualización del listado de facturas
    Given se realizó una búsqueda de facturas
    Then el listado debe contener las columnas:
      | Folio de factura |
      | Cliente |
      | Fecha factura |
      | Fecha cancelación |
      | Estatus actual |
    And debe permitir seleccionar una o varias facturas

  # Botón actualizar estatus
  Scenario: Habilitar botón actualizar estatus
    Given existen facturas en el listado
    When el usuario no ha seleccionado ninguna factura
    Then el botón "Actualizar estatus" no debe realizar ninguna función al dar clic

  Scenario: Función actualizar estatus al seleccionar facturas
    Given el usuario ha seleccionado al menos una factura
    Then el botón "Actualizar estatus" debe realizar las funciones para actualizar el estatus de la factura

  Scenario: Confirmación antes de actualizar estatus
    Given el usuario ha seleccionado facturas
    When da clic en el botón "Actualizar estatus"
    Then el sistema debe mostrar el mensaje:
      """
      ¿Esta seguro de continuar con el proceso?, este cambio no actualiza el estatus real ante el SAT.
      """

  Scenario: Actualización de estatus exitosa
    Given el usuario confirma la acción de actualizar estatus
    And las facturas seleccionadas no tienen sustituciones
    When el sistema procesa la actualización
    Then el estatus de las facturas debe actualizarse correctamente
    And el proceso debe registrarse en bitácora

  # Validaciones
  Scenario: No permitir actualización a facturas con sustituciones
    Given el usuario ha seleccionado una factura con sustituciones
    When intenta actualizar el estatus
    Then el sistema debe impedir la acción
    And debe mostrar un mensaje indicando que no es posible reactivar facturas con sustituciones

  Scenario: Registro en bitácora
    Given el usuario GM actualiza el estatus de una factura
    When la operación es completada
    Then el sistema debe guardar un registro en bitácora con los detalles del cambio
    