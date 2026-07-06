Feature: integracion del tipo de licencia tipo A en catalogo de operadores del modulo de trafico

    Yo como usuario del catalogo de operadores
    requiero que dentro del catalogo se cuente con la opcion de registrar licencias tipo a
    para poder registrar las licencias con las que cuentan mis operadores

Scenario: Nuevo check "Licencia A" en catalogo de operadores
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    When el usuario ingrese al catalogo de operadores
    And consulte la seccion "Documentos de identidad"
    Then el sistema debe de contar con el nuevo check "Licencia A"
    And los campos deben de conservar la funcionalidad ya existente

Scenario: No se muestra check "Licencia A" en bases de datos de México
  Given que el usuario accede a una base de datos de México
  And ingresa al catalogo de operadores
  When el usuario consulte la seccion "Documentos de identidad" del catalogo
  Then el nuevo check "Licencia A" no es visible en el catalogo de operadores
  And el campo debe conservar la misma mascara y validaciones.

Scenario: integrar nueva columna "Licencia A" en funcion de importacion
    Given que el usuario ingresa a la funcion "Importar" del catalogo
    And descarga el layout de importacion
    When abre el layout de importacion
    Then el layout cuenta con la nueva columna "TipoLicenciaA"
    And la columna la puede visualizar de lado izquiero de la columna ya existente "TipoLicenciaB"

Scenario: Adaptacion de intrucciones en layout de importacion
    Given que el usuario ingresa a la funcion "Importar" del catalogo
    And descarga el layout de importacion
    When abre el layout de importacion
    Then el layout cuenta con una nueva fila de instruccion llamada "TipoLicenciaA" arriba de la fila "TipoLicenciaB"
    And la nueva instruccion es "VALOR 1 = SI 0 = NO"