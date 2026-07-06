Feature: Tropicalizacion del reporte "Situación de la Empresa" del modulo de informes gerenciales

    Yo como usuario del reporte Situación de la Empresa del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Situación de la Empresa"

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Examples:
    | ColumnasConImporte |
    | Punto Intermedio   |
    | Meta               |

Scenario Outline: Signo de Quetzales en campos de "Parametros de medicion"
    Given que el usuario ingreso a la funcion "Parametros de medicion"
    When el usuario consulte <CamposConImporte>
    Then Los importes ingresados en los campos se visualizan con signo de quetzales "Q"

    Example: 
    | CamposConImporte       |
    | Costo por kilómetro    |
    | Ingreso por kilómetro  |
    | Utilidad por kilómetro |
    | Utilidad Bruta         |
    | Utilidad Bruta         |
    | Por facturar al día    |
    | Anticipos entregados   |
    | Gastos de viaje        |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Situación de la Empresa" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Situación de la Empresa" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Situación de la Empresa" en el listado de reportes del modulo de informes gerenciales.