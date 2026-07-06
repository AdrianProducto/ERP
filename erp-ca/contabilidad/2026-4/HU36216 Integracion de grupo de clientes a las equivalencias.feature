Feature: integracion del catalogo "Grupo de clientes" al catalogo de equivalencias.

    Yo como usuario del modulo de contabilidad
    requiero que el catalogo de grupo de clientes se integre al catalogo de equivalencias contables
    para que pueda realizar mi contabilidad de manera mas acorde a mis actividades

Background:
Given que el usuario se encuentra dentro de una base de datos del pais de guatemala

Scenario: Catalogo de grupos de clientes se encuentra visible en equivalencias contables
    When el usuario ingrese al catalogo "Equivalenvias contables"
    And consulte el campo "Catalogos"
    Then dentro del combo se debe de tener la opcion "Grupos de clientes"
    And debe de ser posible la asignacion de equivalencias a los registros del catalogo.

Scenario: El catalogo de grupos de clientes no se encuentra visible en equivalencias contables en BD de Mexico
    Given que el usuario se encuentra dentro de una base de datos del pais Mexico
    When ingrese al catalogo de "Equivalencias contables"
    And consulte el combo de Catalogos
    Then no se debe de visualizar la opcion "Grupos de clientes"
    And el catalogo debera de funcionar de manera habitual.