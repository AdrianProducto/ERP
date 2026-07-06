Feature: Tropicalización en generación en segundo plano del reporte "Descripción del material de carga de Carta Porte"

    Como usuario del reporte "Descripción del material de carga de Carta Porte"
    Requiero que el reporte en segundo plano cuente con los cambios previamente aplicados al reporte principal en la "HU29403-4"
    para que ambas versiones funcionen en sincronia

  Background:
    Given que el usuario se encuentra en una base de datos del país de Guatemala
    And el sistema genera el reporte en segundo plano al sobrepasar el máximo de registros

Scenario: Cambio de columna RFC a NIT en segundo plano
    When el sistema  genera el reporte en segundo plano
    Then la columna "RFC" debe mostrarse como "NIT"

 Scenario: Lectura correcta del NIT del cliente en segundo plano
    When el sistema  genera el reporte en segundo plano
    Then la columna "NIT" debe mostrar el NIT correspondiente al cliente de cada registro

Scenario Outline: Cambio de nombre de columnas a formato GTQ en segundo plano
  When el sistema  genera el reporte en segundo plano
  Then la columna "<original>" debe mostrarse como "<nuevo>"

Examples:
  | original        | nuevo         |
  | Importe M.N     | Importe GTQ   |
  | IVA M.N         | IVA GTQ       |
  | Retención M.N   | Retención GTQ |
  | Total M.N       | Total GTQ     |

Scenario: Visualización del símbolo Q en importes en segundo plano
    When el sistema  genera el reporte en segundo plano
    Then los importes en moneda Quetzales deben mostrarse con el símbolo "Q"

Scenario Outline: Mantener comportamiento actual del reporte para bases de datos de México
    Given que el usuario se encuentra dentro de una base de datos del pais de México
    When el sistema genera el reporte en segundo plano al sobrepasar el máximo de registros
    Then el reporte no muestra los cambios de la tropicalizacion a guatemala
