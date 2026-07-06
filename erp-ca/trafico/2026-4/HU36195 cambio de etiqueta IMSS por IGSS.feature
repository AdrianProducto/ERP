Feature: Cambio de la etiqueta "No.IMSS" por "No.IGSS" en el catalogo de operadores

    Yo como usuario del catalogo de operadores
    requiero que la etiqueta No.IMSS sea cambiada por la etiqueta No.IGSS
    para que los usuarios del pais de Guatemala se sientan familiarizados con el contexto del campo.

Background: 
Given que el usuario se encuentra dentro de una base de datos del pais de Guatemala
And ingresa al catalogo de operadores del modulo de trafico

Scenario: cambio en nombre de etiqueta "No.IMSS" en base de datos de Guatemala
    When el usuario consulte la seccion "Informacion medica" del catalogo
    Then la etiqueta "No.IMSS" debe de mostrarse como "No.IGSS"
    And el campo debe conservar la misma mascara y validaciones 

Scenario: Mantener la misma etiqueta "No.IMSS" en bases de datos de México
  Given que el usuario accede a una base de datos de México
  And ingresa al catalogo de operadores
  When el usuario consulte la seccion "Informacion medica" del catalogo
  Then la etiqueta del numero de seguro social debe de continuar como "No.IMSS"
  And el campo debe conservar la misma mascara y validaciones.

Scenario: Cambio de columna en el layout de importacion
    Given que el usuario ingresa a la funcion "Importar" del catalogo
    When abre el layout de importacion
    Then la columna "NumeroIMSS" ahora debe de llamarse "NumeroIGSS"
    And lo ingresado se visualiza en el campo "No.IGSS" del registro ya importado

Scenario: Cambio en las instrucciones del layout de importacion
    Given que el usuario ingresa a la funcion "Importar" del catalogo
    When abre el layout de importacion
    And consulta las instrucciones del layout
    Then la fila de la instruccion "NumeroIMSS" ahora debe llamarse "NumeroIGSS"
