Feature: Modificación de conceptos de Carta Porte en el proceso de Sustituir Factura
  Como usuario de Tráfico/Facturación
  Quiero poder modificar los conceptos de facturación dentro de Cartas Porte
  Para poder sustituir facturas por viaje con motivo de cancelación 01 - Comprobante emitido con errores con relación

  Background:
    Given que el usuario inició el proceso de cancelación
    And seleccionó el motivo "01 - COMPROBANTE EMITIDO CON ERRORES CON RELACIÓN"
    And ingresa al proceso "Sustituir Factura" 
    And seleccionó el viaje al que se aplicará la sustitución de factura

  Scenario: Gestionar conceptos desde Editar Viaje / Carta Porte
    Given que el usuario da clic en el botón "Editar viaje"
    And accede al apartado "Conceptos de facturación" dentro de la Carta Porte
    And el usuario puede Agregar, modificar y eliminar un concepto
    Then el sistema permite realizar la acción correctamente

  Scenario: Validar que exista al menos un concepto para guardar
    Given que el usuario se encuentra en el apartado "Conceptos de facturación" dentro de Editar Viaje
    When el usuario elimina todos los conceptos existentes
    Then el sistema no permite guardar la información
    And muestra mensaje de error "Capture los conceptos a facturar"

  Scenario: Guardar conceptos modificados desde Editar Viaje
    Given que el usuario realizó modificaciones en el apartado "Conceptos de facturación" dentro de Editar Viaje
    When el usuario da clic en "Aceptar"
    Then el sistema muestra el mensaje "Recuerde que debe aceptar la captura de Sustituir Factura para que las modificaciones se graben en la base de datos."
    And el usuario da clic en "Aceptar" para confirmar el mensaje

  Scenario: Reflejar los conceptos modificados en Sustituir Factura
    Given que el usuario guardó modificaciones de conceptos desde Editar Viaje
    When regresa a la ventana de "Sustituir Factura"
    Then los conceptos modificados se reflejan en el apartado "Conceptos de Facturación" de dicha ventana

  Scenario: Cancelar (salir sin guardar) el proceso de Sustituir Factura descarta los cambios
    Given que el usuario realizó modificaciones en conceptos desde Editar Viaje
    When el usuario cancela/sale sin guardar el proceso de "Sustituir Factura"
    Then las modificaciones realizadas en los conceptos se pierden
    And no se graban en la base de datos

  Scenario: Gestionar conceptos directamente desde Sustituir Factura
    Given que el usuario se encuentra en el apartado "Conceptos de facturación" dentro de la ventana de Sustituir Factura
    When el usuario agrega, modifica o elimina conceptos
    Then el sistema permite realizar la acción correctamente

  Scenario: Las modificaciones desde Sustituir Factura no se reflejan en Editar Viaje
    Given que el usuario realizó modificaciones en el apartado "Conceptos de facturación" dentro de la ventana de Sustituir Factura
    When el usuario accede al botón "Editar viaje" dentro de la Carta Porte
    Then dichas modificaciones no se reflejan en el apartado "Conceptos de facturación" de Editar Viaje