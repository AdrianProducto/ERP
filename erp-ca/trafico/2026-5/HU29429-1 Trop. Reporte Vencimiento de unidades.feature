Feature: Tropicalizacion del reporte "Vencimiento de unidades" del modulo de trafico

    Yo como usuario del reporte Vencimiento de unidades del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: Background name
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Vencimiento de unidades"

Scenario: Cambio de nombre a columna "Vencimiento Placas Mex."
    When el usuario consulte la seccion de placas del reporte
    Then el reporte ahora muestra la columna "Vencimiento Placas Mex." como "Vencimiento Placas Nacionales".
    And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: Aplicacion de cambios en formato Excel
    When el usuario use la funcion "Exportar XLS"
    And consulte el documento generado
    Then la columna "Vencimiento Placas Mex." se visualiza como "Vencimiento Placas Nacionales".

Scenario: Aplicacion de cambios en formato PDF
    When el usuario use la funcion "Imprimir PDF"
    And consulte el documento generado
    Then la columna "Vto. Placas Mex." se visualiza como "Vto. Placas Nacionales".

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    When el usuario use la funcion "Imprimir PDF"
    And consulte el encabezado del reporte
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Vencimientos de unidades" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then la columna "Vencimiento Placas Mex." debe de conservar dicho nombre
  And el formato excel no debe presentar cambios en la columna "Vencimiento Placas Mex."
  And el formato PDF no debe presentar cambios en la columna "Vto. Placas Mex."
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Vencimiento de unidades" en el listado de reportes del modulo de trafico.