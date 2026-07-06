Feature: Tropicalizacion del reporte de liquidaciones del modulo de trafico

    Yo como usuario del reporte de liquidaciones del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala
And  genera el "Reporte de liquidaciones"

Scenario: Adaptar columna "Moneda" para lectura de quetzales
    When el usuario seleccione la opcion "Detallado (Productividad)" en los filtros del reporte
    And  el usuario consulte la columna "Moneda"
    Then en la columna se debera de visualizar el dato "Quetzales" en los registros que corresponda  dicho tipo de moneda
    And en el caso de moneda extranjera debe de continuar mostrando "Dolares"
     And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario Outline: Mostrar signo de quetzales en columnas de importes nacionales.
    When el usuario visualice las <Columnas> con importer nacionales
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".
     And el proceso debe conservar su funcionamiento actual sin afectaciones

    Example:
    |Columnas     |
    |Ingresos     |
    |Egresos      |
    |Utilidad     |
    |Ingresos/Kms |

Scenario: Cambio de etiqueta "Liquidaciones en quetzales"
    When el usuario seleccione la opcion "Detallado (Productividad)" en los filtros del reporte
    And  el usuario consulte los grandes totales del reporte
    Then el reporte debe mostrar el gran total "Liquidaciones en pesos" como "Liquidaciones en quetzales"
    And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: Mostrar signo de quetzales en los totales del reporte.
    When el usuario seleccione la opcion "Detallado (Productividad)" en los filtros del reporte
    And  el usuario consulte el gran total "Liquidaciones en quetzales"
    Then el sistema debe de mostrar el importe del gran total con el signo de quetzales "Q".
    And el proceso debe conservar su funcionamiento actual sin afectaciones.

Scenario: No mostrar signo de moneda en grandes totales del reporte sin opcion "Detallado (Productividad)"
    When el usuario no seleccione la opcion "Detallado (Productividad)" en los filtros del reporte
    And el usuario consulte los grandes totales del reporte
    Then los grandes totales no cuentan con signos de moneda.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el "reporte de liquidaciones" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And la columna "Moneda" debe de mostrar la moneda correcta.
  And el gran total de moneda nacional debe se decir "Liquidaciones en quetzales"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al "reporte de liquidaciones" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel y PDF
  And la columna moneda debera de leer solo los datos Pesos y Dolares
  And el gran total de moneda nacional debe de seguir como "Liquidaciones en pesos"
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "reporte de liquidaciones" en el listado de reportes del modulo de trafico.


