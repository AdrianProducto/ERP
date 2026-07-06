Feature: Almacenamiento y descarga de archivos de addenda desde el catálogo

Scenario: Almacenamiento del archivo al registrar una nueva addenda
    Given que el usuario GM se encuentra en el catálogo de addendas
    When selecciona un archivo .sql válido y confirma el registro
    Then el sistema debe almacenar el archivo en el sistema
    And vincularlo al registro correspondiente en la base de datos

Scenario: Descarga del archivo desde el catálogo
    Given que el usuario GM se encuentra en el catálogo de addendas
    And existe al menos una addenda registrada con archivo almacenado
    When localiza el registro en la tabla
    Then debe visualizar un botón de descarga en ese registro
    And al presionarlo, el sistema debe iniciar la descarga del archivo .sql original conservando su nombre

Scenario: Descarga disponible en cualquier base de datos
    Given que una addenda fue registrada en una base de datos del ERP
    And dicha base de datos cuenta con addendas cargadas
    When el usuario GM accede al catálogo que tenga addendas cargadas
    Then el botón de descarga debe estar disponible
    And el archivo descargado debe ser idéntico al original

Scenario: Visualización del ejemplo XML en modal
    Given que el usuario GM se encuentra en el catálogo de addendas
    And existe al menos una addenda registrada
    When presiona la opción de Ver ejemplo XML en un registro
    Then el sistema debe abrir una ventana modal
    And mostrar un ejemplo de cómo se vería la addenda dentro del nodo <cfdi:Addenda> del XML

Scenario: El flujo de asignación de clientes no se ve afectado
    Given que se han implementado los cambios de almacenamiento y descarga
    When el usuario utiliza el flujo de asignación de clientes a una addenda
    Then dicho flujo debe funcionar exactamente igual que antes de la implementación

Scenario: Botón de descarga deshabilitado para addendas sin archivo almacenado
    Given que existe una addenda registrada antes de esta mejora/adecuación
    And no cuenta con un archivo .sql almacenado en el sistema
    When el usuario localiza ese registro en el catálogo
    Then el botón de descarga debe aparecer deshabilitado
    And debe mostrar un mensaje o tooltip indicando que el archivo no está disponible
