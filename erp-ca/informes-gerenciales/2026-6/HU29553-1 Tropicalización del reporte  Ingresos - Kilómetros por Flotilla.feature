Feature: Tropicalizacion del reporte "Ingresos / Kilómetros por Flotilla" del modulo de informes gerenciales

    Yo como usuario del reporte Ingresos / Kilómetros por Flotilla del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Ingresos / Kilómetros por Flotilla"

Scenario Outline: signo de quetzales en la seccion "Parametros"
    When el usuario ingrese a la seccion "Parametros"
    And consulte las <ColumnasConImporte>
    Then los importes en moneda nacional de las columnas se visualizan con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Dinero Enero       |
    | Dinero Febrero     |
    | Dinero Marzo       |
    | Dinero Abril       |
    | Dinero Mayo        |

Scenario Outline: signo de quetzales en la seccion "Parametros"
    When el usuario genera el reporte
    And consulte las <ColumnasConImporte>
    Then los importes en moneda nacional de las columnas se visualizan con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte         |
    | Objetivo en dinero Mensual |
    | Objetivo al 11/05/2026     |
    | Ventas al 11/05/2026       |
    | Ingreso/Km/Flotilla        |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Ingresos / Kilómetros por Flotilla" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Ingresos / Kilómetros por Flotilla" en el listado de reportes del modulo de informes gerenciales.