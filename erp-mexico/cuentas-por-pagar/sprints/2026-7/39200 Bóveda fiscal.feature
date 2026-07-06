Feature: Importar XML de tipo ingreso desde bóveda fiscal a pasivos del ERP
Como usuario del módulo Fiscal
Quiero consultar e importar XML de tipo ingreso desde la bóveda fiscal
Para generar pasivos de forma automática sin descargar ni registrar manualmente cada comprobante

Scenario: Usuario con derecho habilitado a XML Fiscal y módulo Fiscal contratado ve la opción
    Given que el cliente tiene contratado el módulo Fiscal
    And el usuario tiene el derecho a proceso de Pasivos "XML Fiscal"
    When el usuario accede al menú "Agregar" dentro de Pasivos
    Then se muestra la opción "XML Fiscal" en el botón "Agregar"

Scenario: Usuario sin el derecho habilitado no ve la opción
    Given que el cliente tiene contratado el módulo Fiscal
    And el usuario no tiene el derecho "XML a Pasivo" habilitado 
    When el usuario accede al menú "Agregar" dentro de Pasivos
    Then la opción "XML a Pasivo" no se muestra en el botón "Agregar"

Scenario: Cliente sin módulo Fiscal contratado no ve la opción
    Given que el cliente no tiene contratado el módulo Fiscal
    When el usuario accede al menú "Agregar" dentro de Pasivos
    Then la opción "XML a Pasivo" no está disponible


Background: El usuario puede consultar XML de tipo ingreso filtrando por fecha y por RFC
    Given que el usuario tiene acceso a la funcionalidad "XML a Pasivo"
    And el RFC receptor configurado en parámetros generales es "RFC_EMPRESA"

Scenario: Consulta positiva de todos los XML de ingreso por rango de fechas
    Given el usuario selecciona el radio "TODOS"
    And ingresa un rango de fechas
    And el tipo de comprobante está fijo como "Ingreso (I)"
    When el usuario ejecuta la consulta
    Then el sistema envía petición al servicio Hades con los filtros indicados
    And Hades consulta la bóveda y retorna los XML cuyo RFC receptor coincide con "RFC_EMPRESA"
    And se muestran únicamente los XML que no existen en el ERP
    And el listado contiene las columnas: Fecha, Emisor, RFC, Serie-Folio, Total


Scenario: Consultar positiva de XML filtrando por RFC de proveedor específico
    Given el usuario selecciona el radio "RFC"
    And ingresa el RFC del proveedor a consultar
    And ingresa un rango de fechas 
    When el usuario ejecuta la consulta
    Then el sistema retorna solo los XML cuyo RFC emisor coincide con el RFC indicado
    And se muestran únicamente los XML que no existen en el ERP
    And el listado contiene las columnas: Fecha, Emisor, RFC, Serie-Folio, Total

Scenario: Consulta negativa, sin resultados disponibles en la bóveda
    Given el usuario aplica filtros válidos
    When el sistema consulta la bóveda y no encuentra XML para los filtros indicados
    Then se muestra un mensaje informativo indicando que no hay XML disponibles para importar
    # No existe información en base a los filtros seleccionados.


Scenario: Error de comunicación con el servicio Hades durante la consulta
    Given el usuario aplica filtros válidos y ejecuta la consulta
    When el servicio Hades no responde o retorna un error
    Then se muestra un mensaje de error indicando que no fue posible conectar con la bóveda
    # No es posible ejecutar el proceso. Favor de intentar mas tarde

# ---- Validación 69-B del SAT (EDO/EFO) ---- # 
Background: El sistema advierte al usuario si un emisor está en la lista 69-B del SAT

Scenario: Emisor detectado en lista 69-B — usuario decide continuar
    Given que el listado contiene XML de un emisor registrado en la lista 69-B del SAT (EDO/EFO)
    When el sistema valida los RFC emisores contra la lista 69-B
    Then se muestra un mensaje de advertencia indicando que el emisor está en lista 69-B
    When el usuario decide continuar con la importación
    Then se procede a importar los XML seleccionados

Scenario: Emisor detectado en lista 69-B — usuario decide cancelar
    Given que el listado contiene XML de un emisor registrado en la lista 69-B del SAT (EDO/EFO)
    When el sistema valida los RFC emisores contra la lista 69-B
    Then se muestra un mensaje de advertencia indicando que el emisor está en lista 69-B
    When el usuario decide no continuar con la importación
    Then se cancela el proceso y no se genera ningún pasivo

# Selección e importación de XML 
Background: El usuario puede seleccionar uno, varios o todos los XML para generar pasivos

Scenario: Importar un XML individual y generar su pasivo
    Given que el listado de XML disponibles se muestra correctamente
    When el usuario selecciona un único XML y confirma la importación
    Then se genera un pasivo independiente en el ERP por ese XML
    And el pasivo queda marcado internamente como originado desde la bóveda


Scenario: Importar múltiples XML y generar un pasivo por cada uno
    Given que el listado de XML disponibles se muestra correctamente
    When el usuario selecciona varios XML y confirma la importación
    Then se genera un pasivo independiente en el ERP por cada XML importado
    And cada pasivo queda marcado internamente como originado desde la bóveda

Scenario: Importar todos los XML del listado
    Given que el listado de XML disponibles se muestra correctamente
    When el usuario selecciona todos los XML y confirma la importación
    Then se genera un pasivo independiente en el ERP por cada XML del listado
    And cada pasivo queda marcado internamente como originado desde la bóveda

# Registro automático de proveedor nuevo 
Background: Si el proveedor emisor no existe en el catálogo, el sistema lo registra automáticamente

Scenario: Proveedor emisor no existe en el catálogo al momento de importar
    Given que el usuario utiliza radio TODOS e importa un XML cuyo RFC emisor no existe en el catálogo de proveedores
    When el sistema procesa la importación
    Then el sistema registra automáticamente al proveedor usando el nombre y RFC del emisor del XML
    And el pasivo se genera asociado al proveedor recién creado

Scenario: Proveedor emisor ya existe en el catálogo al momento de importar
    Given que el usuario importa un XML cuyo RFC emisor ya existe en el catálogo de proveedores
    When el sistema procesa la importación
    Then el pasivo se genera asociado al proveedor existente sin crear un duplicado

# Detección y marcado de cancelaciones SAT 
Background: El sistema detecta cancelaciones ante el SAT y marca el pasivo correspondiente
    Scenario: Proceso periódico detecta un XML cancelado asociado a un pasivo
    Given que existe un pasivo originado desde la bóveda asociado a un XML
    And dicho XML ha sido cancelado ante el SAT
    When se ejecuta el proceso periódico de detección de cancelaciones (este proceso ya lo realiza el ERP)
    Then el pasivo muestra un indicador de que el CFDI ha sido cancelado ante el SAT

Scenario: La cancelación del pasivo en el ERP requiere acción manual del usuario
    Given que un pasivo tiene el indicador de CFDI cancelado ante el SAT
    When el sistema detecta la cancelación
    Then el sistema no cancela automáticamente el pasivo en el ERP
    And el usuario deberá realizar la cancelación del pasivo de forma manual