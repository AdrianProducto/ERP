Feature: Tropicalizacion del reporte "Detalle de Liquidaciones" del modulo de trafico

    Yo como usuario del reporte Detalle de Liquidaciones del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Detalle de Liquidaciones"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones:
    | Moneda    |
    | Quetzales |
    | Dolares   |

Scenario: Funcionamiento del filtro "Moneda" con nueva moneda Quetzales
  When el usuario selecciona la nueva moneda "Quetzles" en el filtro "Moneda"
  Then el reporte debera de mostrar registros realizados en la moneda quetzales

Scenario Outline: Mostrar en el encabezado del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario selecciono la opcion "Quetzales" en el filtro de moneda
    When genere el reporte 
    And visualice el encabezado del reporte
    Then el reporte debe de mostrar en el encabezado "Tipo de Moneda" la nueva nueva moneda Quetzal.

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en el formato Excel
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Detalle de Liquidaciones" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Detalle de Liquidaciones" en el listado de reportes del modulo de trafico.