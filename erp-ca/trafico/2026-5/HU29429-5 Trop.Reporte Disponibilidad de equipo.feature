Feature: Tropicalizacion del reporte "Disponibilidad de equipo" del modulo de trafico

    Yo como usuario del reporte Disponibilidad de equipo del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Disponibilidad de equipo"

Scenario: Cambio de nombre a columna "Placas MEX"
    When el usuario consulte la seccion de placas del reporte
    Then el reporte ahora muestra la columna "Placas MEX" como "Placas Nacionales".
    And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: Aplicacion de cambios en formato Excel
    When el usuario use la funcion "Exportar XLS"
    And consulte el documento generado
    Then la columna "Placas MEX" se visualiza como "Placas Nacionales".

Scenario: Aplicacion de cambios en formato PDF
    When el usuario use la funcion "Imprimir PDF"
    And consulte el documento generado
    Then la columna "Placas MEX" se visualiza como "Placas Nacionales".

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    When el usuario use la funcion "Imprimir PDF"
    And consulte el encabezado del reporte
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Cambio en etiqueta "Placas Mexicanas" del catalogo de unidades
    Given que el usuario ingresa al catalogo de unidades del modulo de trafico desde una base de datos de guatemala
    When el usuario consulta la seccion "Placas" del catalogo
    Then el campo "Placas mexicanas" ahora se muestra como "Placas nacionales"
    And el campo conserva las mismas validaciones y mascara actual.

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Disponibilidad de equipo" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then la columna "Placas MEX" debe de conservar dicho nombre
  And el campo "Placas Mexicanas" del catalogo de unidades debe de conservar dicho nombre

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Disponibilidad de equipo" en el listado de reportes del modulo de trafico.