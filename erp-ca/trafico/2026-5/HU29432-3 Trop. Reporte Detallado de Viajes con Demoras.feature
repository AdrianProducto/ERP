Feature: Tropicalizacion del reporte "Detallado de Viajes con Demoras" del modulo de trafico

    Yo como usuario del reporte Detallado de Viajes con Demoras del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Detallado de Viajes con Demoras"

Scenario Outline: Lectura de moneda Quetzal en columnas con nombres de moneda
    When el usuario genere el reporte
    Then la columna "Moneda" muestra el dato "Quetzales" en los registros realizados en moneda quetzales

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    #Algunas de las columnas son dinamicas, es decir, el nombre de las columnas con importes varia dependiendo los registros del sistema
    Example: 
    | ColumnasConImporte   |
    | Kilómetros de Salida |
    | Kilómetros Entrada   |
    | Diesel litros        |
    | Importe diesel       |
    | Casetas efectivo     |
    | Anticipos            |
    | Extra                |
    | IAVE                 |
    | Peso Ida             |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Detallado de Viajes con Demoras" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | Reporte    | formulas    |
    | Clientes   | Autosuma    |
    | Operadores | Multiplicar |
    | Unidades   | Promedio    |

Scenario: Ajuste en reporte realizado manualmente
  Given que el reporte en excel fue realizado de manera manualmente
  When el usuario genere el reporte en formato excel
  Then el reporte debe de contar con la funcion generada previamente para una correcta implementacion de formulas en el formato excel

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en el formato Excel
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Detallado de Viajes con Demoras" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Detallado de Viajes con Demoras" en el listado de reportes del modulo de trafico.