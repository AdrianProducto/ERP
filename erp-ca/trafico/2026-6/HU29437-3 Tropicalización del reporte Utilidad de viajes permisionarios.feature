Feature: Tropicalizacion del reporte "Utilidad de viajes permisionarios" del modulo de trafico

    Yo como usuario del reporte Utilidad de viajes permisionarios del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Utilidad de viajes permisionarios"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda                           |
    | Importes convertidos a Quetzales |
    | Importes convertidos a Dólares   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda                     | titulo                                                                                                                         |
    | Importes convertidos a Quetzales | Reporte Utilidades por Viaje permisionarios del 01/12/2025 al 05/05/2026 por viajes, todos e importes convertidos a Quetzales. |
    | Importes convertidos a Dólares   | Reporte Utilidades por Viaje permisionarios del 01/12/2025 al 05/05/2026 por viajes, todos e importes convertidos a dólares.   |

Scenario: Lectura de moneda quetzales en columna de moneda
    When el usuario genere el reporte
    Then en la columna "Moneda" debe de verse la moneda "Quetzales" en los registros realizados con dicha moneda

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: 
    | OpcionMoneda                     | ColumnaImporte |
    | Importes convertidos a Quetzales | SUBTOTAL       |
    | Importes convertidos a Dólares   | IVA            |
    |                                  | Retención      |
    |                                  | Total          |
    |                                  | TIPO CAMBIO    |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Utilidad de viajes permisionarios" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Utilidad de viajes permisionarios" a Excel
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genere información en el segundo plano en PDF y Excel
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Utilidad de viajes permisionarios" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Utilidad de viajes permisionarios" en el listado de reportes del modulo de trafico