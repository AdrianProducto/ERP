Feature: Tropicalizacion del reporte "Definidos por cliente" del modulo de trafico

    Yo como usuario del reporte Definidos por cliente del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
And ingresa al reporte "Definidos por cliente"

Scenario: Adaptacion del filtro "Moneda"
    When el usuario visualiza el filtro por moneda del reporte
    Then el sistema muestra las siguientes opciones
    | Filtro por moneda |
    | Quetzales         |
    | Dolares           |
    | Ambas             |

Scenario: Funcionamiento del filtro por moneda con nueva moneda "Quetzales"
    When el usuario genera el reporte con la opcion "Quetzales" del filtro moneda
    Then el reporte seleccionado muestra registros realizados en moneda quetzales.

Scenario: Funcionamiento del filtro por moneda "ambas" con nueva moneda "Quetzales"
    When el usuario genera el reporte con la opcion "Ambas" del filtro moneda
    Then el reporte seleccionado muestra registros realizados en moneda quetzales y en dolares

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte el reporte
    And este generando el reporte con <OpcionMoneda>
    Then los importes en quetzales de las columnas con importes se visualizan con el signo "Q"

    Examples:
    | OpcionMoneda |
    | Quetzales    |
    | Ambas        |

Scenario Outline: Comportamiento de columna "Moneda"
#Validar el motivo por el cual en las columnas moneda se mira el id y no el nombre de la moneda ¿Se puede arreglar? 
    When el usuario genera un reporte que cuenta con la columna "Moneda"
    And tiene seleccionada la <OpcionMoneda>
    Then La columna lee correctamente el dato "Quetzales" cuando el registro se encuentra realizado en dicha moneda

    Examples:
    | OpcionMoneda |
    | Quetzales    |
    | Ambas        |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Definidos por cliente" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las columnas de moneda debe de leer el tipo de moneda "Quetzales"
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Definidos por cliente" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa y en Excel
  And la columna moneda debe de mostrar solo informacion en pesos y dolares
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Definidos por cliente" en el listado de reportes del modulo de trafico.