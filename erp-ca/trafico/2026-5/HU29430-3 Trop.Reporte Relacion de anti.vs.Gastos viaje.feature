Feature: Tropicalizacion del reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto" del modulo de trafico

    Yo como usuario del reporte de Relación de Anticipos Vs Gastos por Viaje Trayecto del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And genera el reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto"

Scenario: Opcion de Quetzales en filtro "Convertido a"
    When el usuario consulte el filtro "Convertido a"
    Then en el filtro se visualiza la opcion "Quetzales" en lugar de "Pesos"
    And en el filtro quedan solo las opciones de "Quetzales" y "Dolares"

Scenario: Funcionamiento de filtro "Convertido a" con nueva moneda Quetzales.
    When el usuario seleccione la opcion "Quetzales" en el filtro "Convertido a"
    Then el reporte se generara con registros convertidos a la moneda Quetzales.

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        | OpcionMoneda | titulo                                                                                                                      |
        | Quetzales    | Relación de Anticipos Vs Gastos por Viaje Trayecto del 01/04/2026 al 16/04/2026, ordenado por viaje, Convertido a Quetzales |
        | Dolares      | Relación de Anticipos Vs Gastos por Viaje Trayecto del 01/04/2026 al 16/04/2026, ordenado por viaje, Convertido a Dólares   |

Scenario: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la opcion de convertir a "Quetzales"
    And consulte las siguientes columnas:
    | Columnas con importes |
    | Subtotal              |
    | IVA                   |
    | IEPS                  |
    | ISR                   |
    | Retencion IVA         |
    | Traslado Local        |
    | Retencion Local       |
    | Total                 |
    Then los importes en quetzales de las columna se visualizan con el signo "Q"

Scenario Outline: Colocar signo de quetzales en grandes totales
    When el usuario genere el reporte con la opcion de convertir a "Quetzales"
    And el usuario consulte el <GranTotal>
    Then los importes se visualizan con el signo de quetzales "Q"

    Example: 
    | GranTotal         |
    | Totales Anticipos |
    | Totales Gastos    |
    | Diferencia        |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el filtro "Convertido a" debe conservar las opciónes "Pesos" y "Dolares"
  And los importes nacionales deben mostrarse con el signo "$" tanto en vista previa, en Excel y PDF
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relación de Anticipos Vs Gastos por Viaje Trayecto" en el listado de reportes del modulo de trafico.