Feature: Tropicalizacion del reporte "Cartas porte a revison" del modulo de trafico

    Yo como usuario del reporte de cartas porte a revision del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala
And  genera el reporte "Cartas porte a revision"

Scenario: Mostrar opción de importe convertido a Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a pesos" e "Importes en su moneda"

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <Opcion moneda>
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples:
      |Opcion moneda                    | titulo                                                                                 |
      |Importes convertidos a quetzales | Cartas porte a revisión del 01/03/2026 al 31/03/2026 convirtiendo importes a quetzales |
      |Importes convertidos a Dólares   | Cartas porte a revisión del 01/03/2026 al 31/03/2026 convirtiendo importes a dólares   |
      |Importes en su moneda            | Cartas porte a revisión del 01/03/2026 al 31/03/2026 importes en su moneda             |

Scenario: Adaptar columna "Moneda" para lectura de quetzales
    When el usuario consulte la columna "Moneda"
    Then en la columna se debera de visualizar el dato "Quetzales" en los registros que corresponda  dicho tipo de moneda
    And en el caso de moneda extranjera debe de continuar mostrando "Dolares"

Scenario Outline: Mostrar signo de quetzales en columnas de importes nacionales.
    When el usuario visualice las <Columnas> con importer nacionales
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".

    Examples:
      |Columnas  |
      |Total     |
      |IVA       |
      |Retencion |
      |subtotal  |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Cartas porte a revision" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And la columna "Moneda" debe de mostrar la moneda correcta.
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Examples: Formulas que el usuario podria aplicar en excel.
    |formulas    |
    |Autosuma    |
    |Multiplicar |
    |Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Cartas porte a revision" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta
    And la columna "Moneda" debe de mostrar la moneda correcta.

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Cartas porte a revision" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano
  Then las adecuaciones de moneda aplicadas en el reporte principal deben reflejarse también en el segundo plano
  And la columna moneda debe de estar adaptada.

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Cartas porte a revision" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el filtro "Moneda" debe conservar la opción "Importes convertidos a Pesos"
  And los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel y PDF
  And la columna moneda debera de leer solo los datos Pesos y Dolares
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Cartas porte a revision" en el listado de reportes del modulo de trafico.    