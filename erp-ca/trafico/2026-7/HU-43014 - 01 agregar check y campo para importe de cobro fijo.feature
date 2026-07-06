Feature: Configuración del Cobro Fijo en el Catálogo de Clientes
  Como administrador del catálogo de clientes
  Quiero poder activar el cobro fijo para una unidad dedicada y definir su importe
  Para que el sistema sepa qué clientes participan en este esquema de cobro y cuánto cobrar por día

  Background:
    Given el usuario tiene permisos para modificar el catálogo de clientes
    And la pantalla de alta o modificación de clientes está abierta
    And la Base de datos esta configurada con el pais Guatemala, Costa Rica o Nicaragua.

  Scenario: Visualizar los nuevos campos de cobro fijo en el catálogo de clientes
    Given la funcionalidad de cobro fijo ha sido implementada en el sistema
    When el usuario abre un cliente existente en la pantalla de modificación
    And se encuentra en la pestaña "Procesos Especiales" en el apartado "Gestion para cobro fijo y séptimo"
    Then debe aparecer la nueva casilla "Cobro fijo diario"
    And debe aparecer el nuevo campo con etiequeta "Importe del cobro fijo" inicialmente vacío y deshabilitado
    And ambos campos deben estar visibles en la sección de configuración del cliente

  # ─── ACTIVACIÓN ───

  Scenario: Activar el cobro fijo con un importe válido
    When el usuario marca la casilla "Cobro fijo diario"
    And ingresa el importe "$800.00" en el campo "Importe del cobro fijo"
    And guarda el cliente
    Then el cliente queda configurado con cobro fijo activo y un importe de $800.00
    And el sistema muestra el mensaje "Se agregó/modificó el cliente correctamente"

  Scenario: Activar el cobro fijo sin especificar el importe
    When el usuario marca la casilla "Activar cobro fijo diario"
    And NO ingresa ningún importe en el campo "Importe del cobro fijo"
    And hace clic en guardar
    Then el sistema muestra el mensaje "El importe del cobro fijo es obligatorio cuando está activo el cobro fijo diario"
    And el cliente NO se guarda

  Scenario: Activar el cobro fijo con importe cero
    When el usuario marca la casilla "Activar cobro fijo diario"
    And ingresa "$0.00" en el campo "Importe del cobro fijo"
    And hace clic en guardar
    Then el sistema muestra el mensaje "El importe del cobro fijo debe ser mayor a cero"
    And el cliente NO se guarda

  Scenario: El campo de importe permanece bloqueado si el cobro fijo no está activo
    When el usuario NO marca la casilla "Activar cobro fijo diario"
    Then el campo "Importe del cobro fijo" debe aparecer deshabilitado (no se puede modificar)

  # ─── MODIFICACIÓN ───

  Scenario: Modificar el importe del cobro fijo en un cliente existente
    Given el cliente tiene activo el cobro fijo con importe de $800.00
    When el usuario cambia el importe a $1,000.00
    And guarda los cambios
    Then el cliente queda con el importe actualizado a $1,000.00
    And los viajes generados con anterioridad conservan el importe original

  Scenario: Desactivar el cobro fijo en un cliente que ya lo tenía activo
    Given el cliente tiene activo el cobro fijo con importe de $800.00
    When el usuario desmarca la casilla "Activar cobro fijo diario"
    And guarda los cambios
    Then el cliente queda con el cobro fijo desactivado
    And el campo "Importe del cobro fijo" se limpia automáticamente

  Scenario: Cancelar la operación sin guardar
    Given el cliente NO tiene activo el cobro fijo
    When el usuario activa el cobro fijo con un importe de $800.00
    And cierra la pantalla sin guardar (cancela)
    Then el cliente conserva su configuración original sin el cobro fijo activado