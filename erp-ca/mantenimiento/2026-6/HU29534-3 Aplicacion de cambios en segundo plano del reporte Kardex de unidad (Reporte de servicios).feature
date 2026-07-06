Feature: Tropicalización en generación en segundo plano del reporte "Kardex de unidad Reporte de servicios" del modulo de mantenimiento

    Como usuario del reporte "Kardex de unidad Reporte de servicios"
    Requiero que el reporte en segundo plano cuente con los cambios previamente aplicados al reporte principal en la "HU29534-1"
    para que ambas versiones funcionen en sincronia

  Background:
    Given que el usuario se encuentra en una base de datos del país de Guatemala
    And el sistema genera el reporte en segundo plano al sobrepasar el máximo de registros

 Scenario: Visualización del signo de moneda quetzales en columnas del reporte
    Given que el usuario selecciona la moneda "Quetzales" en el filtro de moneda
    When el usuario genera el reporte "Kardex de unidad"
    Then las columnas "Costo M/Obra", "Costo Unitario", "Refacciones" y "Total" deben mostrar el signo "Q"
    And los grandes totales del reporte deben mostrar el signo "Q"

Scenario: Actualización del título del reporte según la moneda seleccionada
    Given que el usuario selecciona la moneda "Quetzales" en el filtro de moneda
    When el usuario genera el reporte "Kardex de unidad"
    Then el título del reporte debe hacer referencia a la moneda seleccionada
    And el título debe visualizarse con el formato "Reporte de kardex de unidad, Filtrado en: Quetzales"

Scenario: Aplicación de ajustes en el reporte resumido
    Given que el usuario selecciona la vista resumida del reporte
    And la moneda seleccionada es "Quetzales"
    When el usuario genera el reporte resumido
    Then las columnas monetarias deben mostrar el signo "Q"
    And los grandes totales deben mostrar el signo "Q"
    And el título del reporte debe mostrar la moneda seleccionada

 Scenario: Validación de ajustes en exportación Excel del reporte
    Given que el usuario genera el reporte con moneda "Quetzales"
    When el usuario exporta el reporte en formato Excel
    Then las columnas monetarias deben mostrar el signo "Q"
    And los grandes totales deben mostrar el signo "Q"
    And el título del reporte debe mostrar la moneda seleccionada
    And las formulas funcionan correctamente

Scenario: Validación de ajustes y cambio de etiqueta en exportación PDF del reporte
    Given que el usuario genera el reporte con moneda "Quetzales"
    When el usuario exporta el reporte en formato PDF
    Then las columnas monetarias deben mostrar el signo "Q"
    And los grandes totales deben mostrar el signo "Q"
    And el título del reporte debe mostrar la moneda seleccionada
    And la etiqueta "RFC" debe visualizarse como "NIT"

Scenario Outline: Mantener comportamiento actual del reporte para bases de datos de México
    Given que el usuario se encuentra dentro de una base de datos del pais de México
    When el sistema genera el reporte en segundo plano al sobrepasar el máximo de registros
    Then el reporte no muestra los cambios de la tropicalizacion a guatemala