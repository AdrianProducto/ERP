Feature: Tropicalizacion del reporte "Relación de Pagos Detallado" del modulo de cobranza

    Yo como usuario del reporte Relación de Pagos Detallado del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Relación de Pagos Detallado"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda                           |
    | Importes convertidos a Quetzales |
    | Importes convertidos a Dolares   |
    | Importes en su moneda            |

Scenario: Lectura de moneda quetzales en columnas de moneda
    When el usuario genere el reporte
    Then en la columna "Moneda" debe de verse la moneda "Quetzales" en los registros realizados con dicha moneda

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: ejemplo de algunas columnas que se pueden encontrar en el reporte que contienen importes
    | OpcionMoneda                     | ColumnaImporte                |
    | Importes convertidos a Quetzales | Tipo Cambio                   |
    | Importes en su moneda            | Importe                       |
    |                                  | IVA                           |
    |                                  | Total                         |
    |                                  | Impuestos Retenidos Federales |

Scenario Outline: Actualización de etiquetas de totales para moneda Quetzales en el reporte
    When el usuario genera el reporte con la <OpcionMoneda>
    And el reporte contiene etiquetas de totales relacionadas a moneda nacional
    Then la etiqueta "<EtiquetaActual>" debe visualizarse como "<NuevaEtiqueta>"

#Los totales son dinamicos, es decir, que puede que aparezcan mas totales o menos dependiendo de los filtros seleccionados
Examples: Ejemplos de totales en moneda nacional del reporte
    | OpcionMoneda                     | EtiquetaActual           | NuevaEtiqueta                |
    | Importes convertidos a Quetzales | TOTAL NO OBJETO EN PESOS | TOTAL NO OBJETO EN QUETZALES |
    | Importes en su moneda            | TOTAL EXENTO EN PESOS    | TOTAL EXENTO EN QUETZALES    |
    |                                  | TOTAL IVA 16% EN PESOS   | TOTAL IVA 16% EN QUETZALES   |
    |                                  | TOTAL PESOS              | TOTAL QUETZALES              |

Scenario Outline: Signo de quetzales en importes nacionales de los totales del reporte
    When el usuario genera el reporte con la <OpcionMoneda>
    And consulta los totales del reporte
    Then los importes de los <Totales> en moneda quetzales se visualizan con el signo "Q"

    Examples:
    | OpcionMoneda                     | Totales                      |
    | Importes convertidos a Quetzales | TOTAL NO OBJETO EN QUETZALES |
    | Importes en su moneda            | TOTAL EXENTO EN QUETZALES    |
    |                                  | TOTAL IVA 16% EN QUETZALES   |
    |                                  | TOTAL QUETZALES              |

Scenario: Cambio de nombre a la columna "RFC"
    When el usuario genere el reporte
    Then la columna "RFC" ahora debe se llamarse "NIT"

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Relación de Pagos Detallado" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el sistema genera el reporte "Relación de Pagos Detallado" de manera automatica a Excel
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Ajuste en reporte realizado manualmente
  Given que el reporte en excel fue realizado de manera manual
  When el usuario genere el reporte en formato excel
  Then el reporte debe de contar con la funcion generada previamente para una correcta implementacion de formulas en el formato excel

Scenario: Aplicar adecuaciones de moneda y etiquetas en el segundo plano del reporte
  When el reporte genera información en el segundo plano en el formato Excel por exceso de registros
  Then las adecuaciones de los escenarios anteriores sobre el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relación de Pagos Detallado" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relación de Pagos Detallado" en el listado de reportes del modulo de cobranza.