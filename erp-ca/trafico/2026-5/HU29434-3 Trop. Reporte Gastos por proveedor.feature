Feature: Tropicalizacion del reporte "Gastos por proveedor" del modulo de trafico

    Yo como usuario del reporte Gastos por proveedor del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Gastos por proveedor"

Scenario: Lectura de moneda Quetzal en columna "Moneda
    When el usuario genere el reporte
    Then la columna "Moneda" muestra el dato "Q" en los registros realizados en moneda quetzales

Scenario Outline: Signo de Quetzale en columnas con importes
    When el usuario genere el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

    Example:
    | ColumnasConImporte |
    | Importe            |
    | IVA                |
    | IEPS               |
    | ISR                |
    | Retención IVA      |
    | Traslado Local     |
    | Retención Local    |
    | Total              |

Scenario: Cambio a la etiqueta total "TOTAL PESOS"
    When el usuario genere el reporte
    Then la etiqueta "TOTAL PESOS" debe de decir "TOTAL QUETZALES"

Scenario: Cambio a la etiqueta total "Total General Pesos"
    When el usuario genere el reporte
    Then la etiqueta "Total General Pesos" debe de decir "Total General Quetzales"

Scenario Outline: Signo de Quetzale en grandes totales del reporte
    When el usuario genere el reporte
    And consulte los grandes totales "Total General Quetzales" y "TOTAL QUETZALES"
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

Scenario: Cambio a la etiqueta total "Importe Pesos" en reporte acumulado
    When el usuario genere el reporte con la opcion "Acumulado" seleccionado
    Then la etiqueta "Importe Pesos" debe de decir "Importe Quetzales"

Scenario: Cambio a la etiqueta total "Total x Dia Pesos" en reporte acumulado
    When el usuario genere el reporte con la opcion "Acumulado" seleccionado
    Then la etiqueta "Total x Dia Pesos" debe de decir "Total x Dia Quetzales"

Scenario: Cambio a la etiqueta total "Total General Pesos" en reporte acumulado
    When el usuario genere el reporte con la opcion "Acumulado" seleccionado
    Then la etiqueta "Total General Pesos" debe de decir "Total General Quetzales"

Scenario: Signo de Quetzale en columnas con importes en reporte acumulado
    When el usuario genere el reporte con la opcion "Acumulado" seleccionado
    And consulte la columna "Importe Quetzales"
    Then la columna muestra los importes de los registros realizados en quetzales con el signo "Q"

Scenario Outline: Signo de Quetzale en grandes totales del reporte acumulado
    When el usuario genere el reporte con la opcion "Acumulado" seleccionado
    And consulte los grandes totales "Total x Dia Quetzales" y "Total General Quetzales"
    Then las columnas muestran los importes de los registros realizados en quetzales con el signo "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el sistema exporta el reporte "Gastos por proveedor" a Excel de manera automatica
  When el usuario abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las etiquetas se encuentran tropicalizadas a quetzales
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Gastos por proveedor" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Gastos por proveedor" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda y etiquetas
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el "Gastos por proveedor" en el listado de reportes del modulo de trafico.