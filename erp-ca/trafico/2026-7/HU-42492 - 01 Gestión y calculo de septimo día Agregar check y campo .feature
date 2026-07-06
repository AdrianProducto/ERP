Feature: Configuración de Clientes para el Cálculo de Séptimo Día
  Como administrador del catálogo de clientes
  Quiero poder activar el cálculo de séptimo día y definir su importe para cada cliente
  Para que el sistema sepa qué clientes participan en esta funcionalidad y cuánto cobrar

  Background:
    Given el usuario tiene permisos para modificar el catálogo de clientes
    And la pantalla de alta o modificación de clientes está abierta
    And La base de datos no esta configurada con el pais México o Estados Unidos.


  # ─── VISUALIZACIÓN DEL PARÁMETRO ───

  Scenario: Visualizar los nuevos campos de séptimo día en el catálogo de clientes
    Given el usuario tiene permisos para modificar el catálogo de clientes
    When la pantalla de alta o modificación de clientes está abierta
    And se encuentra en la pestaña de procesos especiales
    Then Se agregerá el nuevo apartado "Gestión para cobro fijo y séptimo"
    And debe aparecer la nueva casilla "Cálculo de séptimo día"
    And debe aparecer el nuevo campo con la etiqueta "Importe del séptimo día" inicialmente vacío y deshabilitado
    And ambos campos deben estar visibles en la sección de configuración del cliente


  # ─── ACTIVACIÓN DEL SÉPTIMO DÍA ───

  Scenario: Activar el séptimo día con un importe válido en un cliente nuevo
    When el usuario marca la casilla "Cálculo de séptimo día"
    And ingresa el importe "1,500.00" en el campo "Importe del séptimo día"
    And guarda el cliente
    Then el sistema muestra el mensaje "Se agregó el cliente correctamente"
    And el cliente queda configurado con el séptimo día activo y un importe de $1,500.00

  Scenario: Activar el séptimo día sin especificar el importe
    When el usuario marca la casilla "Cálculo de séptimo día"
    And NO ingresa ningún importe en el campo "Importe del séptimo día"
    And hace clic en guardar
    Then el sistema muestra el mensaje "El importe del séptimo día es obligatorio cuando está activo el cálculo"
    And el cliente NO se guarda

  Scenario: Activar el séptimo día con importe cero
    When el usuario marca la casilla "Cálculo de séptimo día"
    And ingresa "0.00" en el campo "Importe del séptimo día"
    And hace clic en guardar
    Then el sistema muestra el mensaje "El importe del séptimo día debe ser mayor a cero"
    And el cliente NO se guarda

  Scenario: Activar el séptimo día con importe negativo
    When el usuario ingresa "-500.00" en el campo "Importe del séptimo día"
    And hace clic en guardar
    Then el sistema muestra el mensaje "El importe debe ser un valor positivo"
    And el cliente NO se guarda

  Scenario: El campo de importe permanece oculto si el séptimo día no está activo
    When el usuario NO marca la casilla "Cálculo de séptimo día"
    Then el campo "Importe del séptimo día" debe aparecer deshabilitado 
    
  Scenario: Activar el séptimo día sin tener configurado un concepto de facturación marcado como séptimo
    Given no existe ningún concepto de facturación marcado como "séptimo día"
    When el usuario activa el séptimo día con un importe válido
    And guarda el cliente
    Then el sistema guarda el cliente correctamente
    And el sistema muestra una advertencia: "No existe un concepto de facturación configurado como séptimo día. Deberá configurarlo para poder generar los cobros"

  # ─── MODIFICACIÓN DE LA CONFIGURACIÓN ───

  Scenario: Modificar el importe del séptimo día en un cliente existente
    Given el cliente tiene activo el séptimo día con importe de $1,000.00
    When el usuario cambia el importe a $2,000.00
    And guarda los cambios
    Then el cliente queda con el importe actualizado a $2,000.00
    And el sistema muestra el mensaje "Se modificó el cliente correctamente"

  Scenario: Desactivar el séptimo día en un cliente que ya lo tenía activo
    Given el cliente tiene activo el séptimo día con importe de $1,500.00
    When el usuario desmarca la casilla "Cálculo de séptimo día"
    And guarda los cambios
    Then el cliente queda con el séptimo día desactivado
    And el campo "Importe del séptimo día" se limpia automáticamente
    And el sistema muestra el mensaje "Se modificó el cliente correctamente"

  Scenario: Cancelar la operación sin guardar
    Given el cliente NO tiene activo el séptimo día
    When el usuario activa el séptimo día con un importe de $1,500.00
    And cierra la pantalla sin guardar (cancela)
    Then el cliente conserva su configuración original sin el séptimo día activado