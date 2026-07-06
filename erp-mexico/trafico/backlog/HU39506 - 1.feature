@trafico @usuario @folio-39506
Feature: Terminar viajes asignados definiendo el estatus de viaje y si el trayecto es liquidable
  Como usuario de Tráfico
  Quiero indicar con qué estatus de viaje finalizan los trayectos y si serán liquidables o no
  Para gestionar con mayor precisión el cierre de los viajes asignados

  Background:
    Given que el usuario ingresa a la utilería "Terminar Viajes Asignados" de Tráfico
    And filtra los viajes por rango de fechas y ejecuta la búsqueda
    And el sistema muestra el listado de viajes asignados pendientes de terminar

  Scenario: Mostrar el selector de estatus de viaje junto al filtro de fecha
    Given que el usuario se encuentra en la pantalla de la utilería
    When observa los controles de captura
    Then el sistema muestra un control "Estatus de Viaje" ubicado a un lado del filtro de fecha
    And muestra la opción para definir si los trayectos serán "Liquidables" o "No liquidables"

  Scenario: Terminar los viajes seleccionados con el estatus de viaje elegido
    Given que el usuario selecciona un "Estatus de Viaje" en el control de la pantalla
    And marca uno o varios viajes del listado
    When ejecuta la utilería para terminar los viajes seleccionados
    Then todos los viajes seleccionados quedan terminados
    And cada viaje terminado queda con el "Estatus de Viaje" indicado por el usuario

  Scenario: Marcar los trayectos seleccionados como liquidables
    Given que el usuario indica que los trayectos serán "Liquidables"
    And marca los viajes del listado
    When ejecuta la utilería para terminar los viajes seleccionados
    Then los trayectos de los viajes terminados quedan registrados como "Liquidables"

  Scenario: Marcar los trayectos seleccionados como no liquidables
    Given que el usuario indica que los trayectos serán "No liquidables"
    And marca los viajes del listado
    When ejecuta la utilería para terminar los viajes seleccionados
    Then los trayectos de los viajes terminados quedan registrados como "No liquidables"

  Scenario: Exigir un estatus de viaje antes de terminar los viajes
    Given que el usuario marca viajes del listado
    And no selecciona ningún "Estatus de Viaje"
    When intenta ejecutar la utilería para terminar los viajes
    Then el sistema le solicita seleccionar un "Estatus de Viaje" antes de continuar
    And no termina los viajes seleccionados
