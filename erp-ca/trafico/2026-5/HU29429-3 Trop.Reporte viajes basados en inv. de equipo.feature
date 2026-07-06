Feature: Tropicalizacion del reporte "Viajes Basados en Inventario de Equipo" del modulo de trafico

    Yo como usuario del reporte Viajes Basados en Inventario de Equipo del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Viajes Basados en Inventario de Equipo"

Scenario: Cambio de nombre a la columna "Costo Pesos"
    When el usuario genere el reporte 
    And consulte la seccion de costos
    Then la columna "Costo Pesos" debe de llamarse "Costo Quetzales"

Scenario: Colocar signo de quetzales en importes nacionales
    When el usuario genere el reporte
    And  consulte la columna "Costo Quetzales"
    Then los importes de la columna se visualizan con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Viajes Basados en Inventario de Equipo" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Viajes Basados en Inventario de Equipo" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Viajes Basados en Inventario de Equipo" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Viajes Basados en Inventario de Equipo" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel y PDF
  And la columna "Costo Pesos" debe permanecer con dicho nombre
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Viajes Basados en Inventario de Equipo" en el listado de reportes del modulo de trafico.