Feature: Nueva versión de Addenda HEB - Configuración de OrigenViaje

  Como usuario de Facturación
  Quiero configurar el atributo OrigenViaje considerando mayúsculas y minúsculas
  Para que la información se refleje correctamente en la nueva versión de la addenda HEB
  Y sin afectar la versión actual de la addenda.
  Para esto es requerido se integre un parámetro para habilitar pestaña Addenda HEB en el catálogo de remitente/destinatario


  Background:
    Given que el usuario accede al catálogo de Remitentes/Destinatarios
    And se habilita parámetro "Habilitar pestaña Addenda HEB"

  Scenario: Convivencia de versiones de addenda HEB
    Given que existe una versión actual de la addenda HEB
    When se implementa la nueva versión de addenda HEB v2
    Then la versión actual debe permanecer sin cambios
    And la nueva versión debe operar de forma independiente

  Scenario: Selección de versión de addenda
    Given que el usuario genera un comprobante
    When selecciona la versión de addenda HEB a utilizar
    Then debe poder elegir entre la versión actual y la nueva versión

  Scenario: Visualización de la pestaña Addenda HEB
    When el usuario consulta el detalle de un remitente
    Then debe visualizar una pestaña llamada "Addenda HEB"

  Scenario: Campos disponibles en pestaña Addenda HEB
    Given que el usuario se encuentra en la pestaña "Addenda HEB"
    Then debe visualizar el campo "Código"
    And debe visualizar el campo "Nombre"

  Scenario: Guardado correcto de información respetando formato
    Given que el usuario se encuentra en la pestaña "Addenda HEB"
    When captura "9071" en el campo "Código"
    And captura "CAT Monterrey Secos" en el campo "Nombre"
    And guarda la información
    Then el sistema debe almacenar los valores capturados
    And debe respetar mayúsculas y minúsculas en el campo "Nombre"


  Scenario: Uso de información configurada en nueva versión de addenda HEB
    Given que existe un remitente con datos en "Addenda HEB"
    And se selecciona la nueva versión de addenda HEB v2
    When se genera la addenda
    Then el sistema debe tomar el "Código" y "Nombre" desde esta pestaña

  Scenario: Formato correcto de OrigenViaje en nueva versión
    Given que el código es "9071"
    And el nombre es "CAT Monterrey Secos"
    And se utiliza la nueva versión de addenda HEB
    When se genera la addenda
    Then el atributo OrigenViaje debe ser "9071 CAT Monterrey Secos"
    And no debe contener guion medio
    And debe respetar mayúsculas y minúsculas

  Scenario: Valor fijo de Sucursal en nueva versión
    Given que se utiliza la nueva versión de addenda HEB v2
    When se genera la addenda
    Then el atributo Sucursal debe ser siempre "2160"


  Scenario: Comportamiento intacto en versión actual
    Given que se utiliza la versión actual de addenda HEB
    When se genera la addenda
    Then el comportamiento debe mantenerse sin cambios
    And no debe verse afectado por la nueva configuración



  Scenario: Intento de generar nueva versión sin configuración
    Given que el remitente no tiene información en pestaña "Addenda HEB"
    And se selecciona la nueva versión de addenda HEB v2
    When se genera la addenda
    Then el sistema no debe generar incluir nada en atributo OrigenViaje

  Scenario: Campo Código vacío
    Given que el usuario se encuentra en la pestaña "Addenda HEB"
    When deja vacío el campo "Código"
    And intenta guardar
    Then el sistema debe mostrar un mensaje de validación "El campo código es obligatorio"
    And no debe permitir guardar la información

  Scenario: Campo Nombre vacío
    Given que el usuario se encuentra en la pestaña "Addenda HEB"
    When deja vacío el campo "Nombre"
    And intenta guardar
    Then el sistema debe mostrar un mensaje de validación "El campo nombre es obligatorio"
    And no debe permitir guardar la información

  Scenario: Validación de formato sin guion medio
    Given que el usuario captura un nombre con guion medio
    And se utiliza la nueva versión de addenda HEB v2
    When se genera la addenda
    Then el atributo OrigenViaje no debe incluir guion medio



  Scenario Outline: Generación de OrigenViaje en nueva versión con distintos formatos
    Given que el código es "<codigo>"
    And el nombre es "<nombre>"
    And se utiliza la nueva versión de addenda HEB
    When se genera la addenda
    Then el atributo OrigenViaje debe ser "<resultado>"

    Examples:
      | codigo | nombre                  | resultado                    |
      | 9071   | CAT Monterrey Secos     | 9071 CAT Monterrey Secos     |
      | 1234   | cAt ejeMplo siN gracia  | 1234 cAt ejeMplo siN gracia  |
      | 5678   | Cat Monterrey Secos     | 5678 Cat Monterrey Secos     |