# language: es

Feature: HU-40582 Tipo de cambio del viaje en importación de combustible — tomar TC desde proviajes

  Como operador del sistema GM Integra
  Quiero que al importar gastos de combustible asociados a un viaje
  el tipo de cambio se tome de la tabla proviajes del ERP en lugar del tipo de cambio del día
  Para que el costo del consumo sea consistente con el TC vigente al momento del viaje documentado

  Background:
    # Dado
    Given que existe una implementación activa con proceso "Importar Gastos de Combustible" configurado

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  Scenario Outline: El TC se toma de proviajes cuando el consumo tiene viaje asociado
    # Dado
    Given que tiene el viaje <viaje> registrado en el campo correspondiente
    # Y
    And que la tabla proviajes del ERP tiene registrado el tipo de cambio <tc_proviajes> para ese viaje
    # Cuando
    When el sistema ejecuta la importación de gastos de combustible
    # Entonces
    Then el consumo se inserta usando el tipo de cambio <tc_proviajes>

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES)

  @validacion
  Scenario: El consumo sin número de viaje no se importa
    # Dado
    Given que el consumo no tiene número de viaje registrado
    # Cuando
    When el sistema procesa ese consumo
    # Entonces
    Then no realiza la importación de ese consumo

  @validacion
  Scenario: La tabla proviajes no tiene TC — se usa el registro más reciente de la tabla tipo de cambio
    # Dado
    Given que tiene el viaje VJ-2026-999 registrado en el campo correspondiente
    # Y
    And que la tabla proviajes no retorna tipo de cambio para ese viaje
    # Y
    And que la tabla tipo de cambio tiene al menos un registro
    # Cuando
    When el sistema intenta obtener el TC desde la tabla proviajes
    # Entonces
    Then el consumo se inserta usando el TC más reciente de la tabla tipo de cambio
    # Y
    And el proceso continúa con los demás consumos sin interrumpirse

  @validacion
  Scenario: La tabla proviajes no tiene TC y la tabla tipo de cambio no tiene registros — se importa con TC en cero
    # Dado
    Given que tiene el viaje VJ-2026-999 registrado en el campo correspondiente
    # Y
    And que la tabla proviajes no retorna tipo de cambio para ese viaje
    # Y
    And que la tabla tipo de cambio no tiene ningún registro
    # Cuando
    When el sistema intenta obtener el TC
    # Entonces
    Then el consumo se inserta usando tipo de cambio en cero
    # Y
    And el proceso continúa con los demás consumos sin interrumpirse
