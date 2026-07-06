Feature: Tropicalizacion del reporte "Situación de Cobranza" del modulo de cobranza

    Yo como usuario del reporte Situación de Cobranza del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Situación de Cobranza"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda    |
    | Quetzales |
    | Dólares   |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda | titulo                                                                                                                 |
    | Quetzales    | Reporte de Situación de Cobranza por Clientes al 06/05/2026 Movimientos en PESOS, Sucursal: MATRIZ, MONTERREY.......   |
    | Dólares      | Reporte de Situación de Cobranza por Clientes al 06/05/2026 Movimientos en DOLARES, Sucursal: MATRIZ, MONTERREY....... |

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la opcion de quetzales en el filtro de moneda
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example: ejemplo de algunas columnas que se pueden encontrar en el reporte que contienen importes
    | ColumnaImporte    |
    | Importe Facturado |
    | Vigente           |
    | 1 - 30 Días       |
    | 31 - 60 Días      |
    | Saldo Total       |

Scenario: Signo de quetzales en total por Clientes
    When el usuario genere el reporte con la opcion de quetzales en el filtro de moneda
    And consulte los totales por Clientes
    Then los importes de los totales se deben de visualizar con el signo de quetzales.

Scenario: Signo de quetzales en gran total
    When el usuario genere el reporte con la opcion de quetzales en el filtro de moneda
    And consulte el gran total del reporte
    Then los importes de los totales se deben de visualizar con el signo de quetzales.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Situación de Cobranza" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Situación de Cobranza" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Situación de Cobranza" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Situación de Cobranza" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Situación de Cobranza" en el listado de reportes del modulo de cobranza.