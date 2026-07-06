Feature: Adecuación a Addenda HEB V2 en Facturación

  Como usuario de Facturación
  Quiero que se realice una adecuación a Addenda HEB v2
  Para que la información del Origen del Viaje se incluya correctamente en el XML del CFDI

  Background:
    Given que el usuario tiene acceso al módulo de Facturación
    And que la Addenda HEB v2 está disponible en el sistema

  Scenario: Validar que los campos Código (numerico) y Nombre (alfanumerico) y acepta caracteres especiales
    Given que el usuario ha seleccionado "HEB V2" como Addenda
    And se ingresa información para los campos Código y Nombre de Remitente-Destinatario
    When se incluye siempre caracter especial, guión medio "9071-CAT Monterrey Secos"
    Then el sistema acepta el valor sin errores

  Scenario: Respetar mayúsculas y minúsculas en los campos
    Given que el usuario ha seleccionado "HEB V2" como Addenda
    When el usuario ingresa el valor "Monterrey secos" con combinación de mayúsculas y minúsculas
    Then el sistema conserva el valor exactamente como fue ingresado

  Scenario: Reflejar el valor del campo en el atributo XML "OrigenDelViaje"
    Given que el usuario ha seleccionado "HEB V2" como Addenda
    And ha ingresado el valor "9071-CAT Monterrey Secos" en los campos Código y Nombre de Remitente-Destinatario
    When el sistema genera el XML del CFDI
    Then el XML contiene el atributo "<add1:OrigenDelViaje>" con el valor "9071-CAT Monterrey Secos"
    And el atributo se encuentra dentro del nodo "<cfdi:Addenda>"
    