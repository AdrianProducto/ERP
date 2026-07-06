# Característica

Feature: Acceso al módulo de Envío de Formularios y búsqueda de cliente final

  Como administrador de Doble Check
  Quiero acceder a la sección "Envío de Formularios" desde el menú de Configuraciones
  Para poder localizar y seleccionar al cliente final que deseo configurar

  # Antecedentes
  Background:
    # Dado
    Given que el administrador tiene sesión iniciada en Doble Check
    # Y
    And que se encuentra en el menú lateral principal

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario: El administrador accede a la sección Envío de Formularios
    # Cuando
    When hace clic en "Configuraciones" en el menú lateral
    # Entonces
    Then el sistema despliega el submenú de opciones de configuración
    # Y
    And muestra la opción "Envío de Formularios" dentro de Configuraciones
    # Y
    And al seleccionarla, el sistema carga la pantalla de "Reglas de Envío"

  Scenario: El administrador busca un cliente 
    # Dado
    Given que el administrador se encuentra en la pantalla de "Reglas de Envío"
    # Cuando
    When escribe el nombre o RFC del cliente en el buscador superior
    # Entonces
    Then el sistema muestra un listado de clientes que coinciden con la búsqueda
    # Y
    And el administrador puede seleccionar al cliente deseado del listado

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: La búsqueda no arroja resultados
    # Dado
    Given que el administrador se encuentra en la pantalla de "Reglas de Envío"
    # Cuando
    When escribe un nombre o RFC que no corresponde a ningún cliente registrado
    # Entonces
    Then el sistema muestra un mensaje indicando que no se encontraron resultados
    # Y
    And no se habilitan paneles de formularios hasta que se seleccione un cliente válido
