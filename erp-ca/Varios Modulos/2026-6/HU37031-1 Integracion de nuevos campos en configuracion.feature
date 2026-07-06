Feature: Configuración de servicios de timbrado para Guatemala

  Como sistema
  Quiero aplicar configuraciones específicas para el país de Guatemala
  Para asegurar el correcto funcionamiento del timbrado de documentos conforme a sus requerimientos
  
Background: 
    Given que el usuario ingresa a los parametros generales del sistema
    And la base de datos pertenece a guatemala

Scenario: Creación y visualización de nuevos campos
    When el usuario consulta a la sección "Usuario Servicios de Timbrado/Servicios WEB"
    Then deben existir los campos "LlaveWS" y "TokenSigner"
    And deben de tener una mascara alfanumerica
    And visualizarse abajo del check "Manejo de varios centros de trabajo IMSS"
    And estos campos deben estar visibles en la sección correspondiente

Scenario: Visualizacion de campos nuevos por usuarios comunes/administradores
    Given que los campos "LlaveWS" y "TokenSigner" existen en el sistema
    When un usuario comun o administrador ingresen a los parametros generales del sistema
    Then los campos "LlaveWS" y "TokenSigner" no se visualizan

Scenario: Visualizacion de campos nuevos por usuario GM
    Given que los campos "LlaveWS" y "TokenSigner" existen en el sistema
    When el usuario GM ingresa a los parametros generales del sistema
    Then los campos "LlaveWS" y "TokenSigner" se visualizan

Scenario: Envío de credenciales al servicio de timbrado
    Given que el usuario ha capturado valores en los campos "LlaveWS" y "TokenSigner"
    When se realiza el proceso de timbrado de documentos
    Then el sistema debe enviar los valores capturados al webservice de timbrado de guatemala
    And el servicio debe utilizar estos valores para completar el timbrado correctamente

Scenario: El check "Habilitar timbrado de documentos" es visible en parámetros generales
  Given que el usuario ha iniciado sesión con un rol de administrador del sistema
  And el usuario navega al módulo de configuracion
  When el usuario accede al proceso de parametros generales
  Then el sistema muestra un control de tipo checkbox
  And el checkbox tiene la etiqueta "Habilitar timbrado de documentos" visible a su lado derecho
  And el check se encuentra activo por defecto

Scenario Outline: Generación de documento con check de timbrado desactivado
    Given que el check "Habilitar timbrado de documentos" está en estado "Desactivado"
    When el usuario genera un <Documento>
    Then el sistema no muestra ninguna pregunta de confirmación relacionada al timbrado
    And el sistema no ejecuta ninguna validación fiscal referente al timbrado
    And el documento es generado exitosamente sin intentar timbrar
    And el flujo continúa sin interrupciones ni mensajes de error relacionados con intentos de timbrado

    Example:
    | Documento       |
    | Facturas        |
    | Nota de credito |
    | Nota de debito  |

Scenario Outline: Generación de documento con timbrado activado
    Given que el check "Habilitar timbrado de documentos" está en estado "Activado"
    When el usuario genera un <Documento>
    Then el sistema muestra una pregunta de confirmación para timbrar el documento
    And si el usuario confirma, el documento es timbrado correctamente
    And se ejecutan las validaciones fiscales correspondientes al timbrado

    Example:
    | Documento       |
    | Facturas        |
    | Nota de credito |
    | Nota de debito  |

 Scenario: No aplicación de cambios en bases de datos de México
    Given que la base de datos pertenece a México
    When el usuario accede a la sección "Usuario Servicios de Timbrado/Servicios WEB" de parametros generales
    Then no deben existir los campos "LlaveWS" y "TokenSigner"
    And el proceso de timbrado debe utilizar las credenciales tradicionales configuradas.