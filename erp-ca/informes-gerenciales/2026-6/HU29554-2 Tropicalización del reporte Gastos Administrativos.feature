Feature: Tropicalizacion del reporte "Gastos Administrativos" del modulo de informes gerenciales

    Yo como usuario del reporte Gastos Administrativos del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Gastos Administrativos"

Scenario: Nueva opcion "Quetzales" en filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then en el combo aparecera la opcion "Quetzales" en lugar de pesos
    And en el combo se visualizaran solo las siguientes opciones:
    | Moneda    |
    | QUETZALES |
    | DOLARES   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda | titulo                                                                      |
    | QUETZALES    | Reporte de gastos administrativos del 01/01/2026 al 31/01/2026 en quetzales |
    | DOLARES      | Reporte de gastos administrativos del 01/01/2026 al 31/01/2026 en dolares   |

Scenario Outline: Signo de Quetzales en filas con importes
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte las <FilasConImporte>
    Then las filas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    #La mayor parte de las filas del reporte son dinamicas, es decir que el nombre de las columnas puede variar dependiendo los filtros seleccionados   
    Examples:
    | FilasConImporte                       |
    | SALDO INICIO AL 1 DE ENERO 2026       |
    | INGRESOS COBRADOS AL 31 DE ENERO 2026 |
    | INGRESO TOTAL                         |
    | GASTOS OPERATIVOS                     |
    | GASTOS ADMINISTRATIVOS                |

Scenario: Signo de Quetzales en "TOTAL GASTO OPERATIVO"
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte el "TOTAL GASTO OPERATIVO"
    Then los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

Scenario: Signo de Quetzales en "TOTAL DE LOS GASTOS"
    When el usuario genera el reporte con la moneda "Quetzales" en el filtro de moneda
    And consulte el "TOTAL DE LOS GASTOS"
    Then los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

Scenario: Ajuste a la descripcion general de las condiciones del reporte
    Given que el usuario ingresa a la condiciones del reporte
    When consulte la descripcion general de las descripciones
    Then contara con la siguientes descripcion 
    "El reporte de proporciona un resumen financiero de los ingresos y gastos relacionados con las operaciones comerciales de la empresa durante
     el periodo Mayo-2026 del 1 al 12 de Mayo del 2026 en moneda quetzales."

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Gastos Administrativos" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Gastos Administrativos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Gastos Administrativos" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Gastos Administrativos" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Gastos Administrativos" en el listado de reportes del modulo de informes gerenciales.