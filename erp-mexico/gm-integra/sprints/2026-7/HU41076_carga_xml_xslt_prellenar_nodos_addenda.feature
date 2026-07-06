Feature: Carga de archivo XML o XSLT para prellenar nodos al crear una versión de addenda
  Como administrador o soporte del sistema
  Quiero cargar un archivo XML de muestra o XSLT existente al crear una versión de addenda
  Para que el sistema genere la estructura de nodos automáticamente y reducir la captura manual

  Background:
    Given que el usuario tiene el rol "ADMINISTRADOR" o "SOPORTE"
    And existe un tipo de addenda registrado en el sistema
    And el usuario se encuentra en el formulario de creación de versión de dicho tipo

  # ── Detección de tipo de archivo ──────────────────────────────────────────

  Scenario: El sistema detecta automáticamente un XML de muestra
    Given el usuario carga un archivo cuyo elemento raíz no es xsl:stylesheet ni xsl:transform
    When el sistema procesa el archivo
    Then el sistema identifica el tipo como "xml-muestra"
    And construye los nodos recorriendo los elementos, atributos y texto del XML

  Scenario: El sistema detecta automáticamente un XSLT
    Given el usuario carga un archivo cuyo elemento raíz es xsl:stylesheet o xsl:transform
    When el sistema procesa el archivo
    Then el sistema identifica el tipo como "xslt"
    And extrae los nodos del interior del template con match="/"
    And extrae la configuración XSLT del stylesheet

  # ── Mapeo XML muestra → nodos ─────────────────────────────────────────────

  Scenario: XML de muestra con elementos, atributos y texto
    Given el usuario carga un XML de muestra con elementos que contienen atributos y texto interno
    When el sistema procesa el archivo
    Then por cada elemento XML se genera un nodo de tipo "elemento"
    And por cada atributo del elemento se genera un nodo de tipo "atributo" como hijo de dicho elemento
    And por cada contenido de texto se genera un nodo de tipo "texto" como hijo del elemento correspondiente

  # ── Mapeo XSLT → nodos ───────────────────────────────────────────────────

  Scenario: XSLT con xsl:for-each
    Given el usuario carga un XSLT que contiene instrucciones xsl:for-each en el template
    When el sistema procesa el archivo
    Then por cada xsl:for-each se genera un nodo de tipo "for-each"
    And el valor del nodo corresponde al atributo select de la instrucción
    And los elementos dentro del bucle se generan como hijos del nodo for-each

  Scenario: XSLT con xsl:attribute y xsl:value-of
    Given el usuario carga un XSLT que contiene instrucciones xsl:attribute y xsl:value-of
    When el sistema procesa el archivo
    Then por cada xsl:attribute se genera un nodo de tipo "atributo" con el nombre del atributo
    And su valor corresponde al select del xsl:value-of interno
    And por cada xsl:value-of directo en un elemento se genera un nodo de tipo "texto"
    And su valor corresponde al atributo select de la instrucción

  Scenario: XSLT con namespaces y configuración de output
    Given el usuario carga un XSLT con namespaces declarados en el stylesheet y elemento xsl:output
    When el sistema procesa el archivo
    Then la configuración stylesheetNamespaces contiene un registro por cada namespace declarado excepto el de xsl
    And la configuración output refleja los valores del elemento xsl:output

  Scenario: XSLT con elemento raíz en el template
    Given el usuario carga un XSLT cuyo template contiene un elemento raíz con namespaces y atributos
    When el sistema procesa el archivo
    Then rootTag contiene el nombre del elemento raíz
    And rootNamespaces contiene los namespaces declarados en ese elemento
    And rootSchemaLocation contiene el valor del atributo xsi:schemaLocation si existe
    And rootInlineAttrs contiene los demás atributos del elemento raíz

  # ── Flujo completo ────────────────────────────────────────────────────────

  Scenario: El usuario carga el archivo, ajusta nodos y guarda la versión
    Given el usuario cargó un archivo XML o XSLT válido
    And el sistema prellenó los nodos en el editor
    And el usuario revisó y ajustó los nodos según necesidad
    And el usuario completó los campos requeridos del formulario
    When el usuario guarda la versión
    Then se crea la versión con estado "borrador"
    And los nodos guardados corresponden a los capturados en el formulario
    And el sistema retorna la versión con su numeroVersion asignado

  Scenario: El usuario reemplaza el archivo cargado por otro
    Given el usuario ya cargó un primer archivo y ve los nodos prellenados
    When el usuario carga un segundo archivo diferente
    Then los nodos anteriores se reemplazan con los del nuevo archivo
    And la advertencia de truncado se actualiza si corresponde

  Scenario: El usuario descarta los nodos prellenados y captura manualmente
    Given el usuario cargó un archivo y ve los nodos prellenados
    When el usuario elige limpiar los nodos
    Then el editor de nodos queda vacío
    And el usuario puede agregar nodos manualmente desde cero
