Feature: Poder generar factura desde viajes con la opción de seleccionar más clientes
    Yo como usuario de Tráfico,
    Quiero tener la opción de seleccionar más clientes al generar una factura desde el listado de Viajes,
    Para poder incluir los conceptos de facturación de otros viajes de otros clientes a una misma factura del cliente principal.

  Background:
    Given que existe un nuevo derecho llamado "Más Clientes" en el catálogo de derechos de usuario,
     And el derecho "Más Clientes" está habilitado para el perfil del usuario,
     And el usuario tiene acceso a la ventana de Factura por Viaje en el listado de Viajes

  Scenario: Acceso al panel de selección de clientes
    Given que el botón "Más Clientes" está visible y habilitado en la ventana de registro de factura por viaje
    When el usuario hace clic en "Más Clientes"
    Then se despliega un panel con el listado de clientes disponibles
    And el usuario puede seleccionar uno o varios clientes de la lista

  Scenario: La tabla de viajes se actualiza al confirmar la selección
    Given que el usuario ha seleccionado uno o más clientes en el panel de "Más Clientes"
    When el usuario confirma la selección
    Then la tabla de viajes se actualiza mostrando únicamente los viajes del cliente principal y de los clientes seleccionados
    And los filtros de búsqueda de viajes como fechas, tipo de viaje y viajes facturables se muestran visibles

  Scenario: El viaje original no puede desmarcarse
    Given que el usuario ingresó a la ventana de factura desde un viaje específico del listado de Tráfico
    When el usuario utiliza "Más Clientes" para seleccionar clientes adicionales
    Then el viaje original se mantiene marcado en la tabla de viajes
    And el usuario no puede desmarcar el viaje original bajo ninguna circunstancia

  Scenario: Los conceptos del viaje original se conservan al cambiar la selección
    Given que el viaje original está seleccionado y sus conceptos de facturación están cargados
    When el usuario cambia la selección de clientes desde "Más Clientes"
    Then los conceptos de facturación del viaje original se conservan
    And los importes totales (subtotal, impuestos, descuentos y total) se recalculan automáticamente

  Scenario: La factura se guarda con el cliente del viaje original como principal
    Given que el usuario ha seleccionado viajes del cliente original y de clientes adicionales
    When el usuario guarda la factura
    Then el cliente del viaje original se registra como cliente principal de la factura
    And los viajes de los clientes adicionales quedan asociados a la misma factura
    And los conceptos de facturación de todos los viajes seleccionados se registran correctamente

