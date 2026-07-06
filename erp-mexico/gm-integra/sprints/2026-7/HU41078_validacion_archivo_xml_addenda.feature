Feature: Validación del archivo XML cargado en addendas
  Como sistema
  Quiero validar el archivo antes de procesarlo
  Para informar al usuario errores claros antes de continuar

  Background:
    Given el usuario se encuentra en el formulario de creación de versión de addenda

  Scenario: El usuario no adjunta ningún archivo
    Given el usuario envía la solicitud sin adjuntar ningún archivo
    When el sistema recibe la solicitud
    Then el sistema retorna un error 400
    And el mensaje indica que se requiere un archivo

  Scenario: El archivo XML está malformado
    Given el usuario carga un archivo con contenido XML inválido o incompleto
    When el sistema intenta procesarlo
    Then el sistema retorna un error 400
    And el mensaje indica que el archivo no es válido o está malformado

  Scenario: El XSLT no contiene el elemento raíz esperado
    Given el usuario carga un archivo que parece XSLT pero carece de xsl:stylesheet o xsl:transform
    When el sistema intenta procesarlo
    Then el sistema retorna un error 400
    And el mensaje indica que no se encontró el elemento raíz del stylesheet

  Scenario: El XSLT válido no contiene template con match igual a raíz
    Given el usuario carga un XSLT válido pero sin template con match="/"
    When el sistema procesa el archivo
    Then el sistema responde exitosamente con tipo "xslt"
    And el campo nodos es un arreglo vacío
    And la configuración XSLT se extrae correctamente del stylesheet
