Feature: Tropicalizacion del reporte "Cobranza de Facturas por viaje" del modulo de cobranza

    Yo como usuario del reporte Cobranza de Facturas por viaje del modulo de cobranza
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Cobranza de Facturas por viaje"

Scenario: opciones disponibles en el filtro "Moneda"
    When el usuario consulte el filtro "Moneda"
    Then el filtro debe de estar adaptados hacia la moneda quetzales, quedando el filtro con las siguientes opciones
    | Moneda    |
    | Quetzales |
    | Dolares   |
    | Ambas     |

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    When visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
    | OpcionMoneda | titulo                                                                                               |
    | Quetzales    | Reporte de Cobranza de Facturas por Viaje al 07/05/2026 filtrando importes en Quetzales              |
    | Dólares      | Reporte de Cobranza de Facturas por Viaje al 07/05/2026 filtrando importes en Dolares                |
    | Ambas        | Reporte de Cobranza de Facturas por Viaje al 07/05/2026 filtrando movimientos en quetzales y dólares |

Scenario Outline: Mostrar en el titulo del archivo descargado la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <OpcionMoneda>
    And descarga el archivo .zip
    When visualice el nombre del archivo descargado del reporte
    Then el archivo debe de contar con el <TituloArchivo> de acuerdo a la seleccion.

    Examples:
    | OpcionMoneda | TituloArchivoitulo                                                             |
    | Quetzales    | CobranzadeFacturasporViaje-PDF-Excel-quetzales.08.15.zip                       |
    | Dólares      | CobranzadeFacturasporViaje-PDF-Excel-20260507_Dolares_15.12.18.zip             |
    | Ambas        | CobranzadeFacturasporViaje-PDF-Excel-20260507_quetzales_y_Dolares_15.05.35.zip |

Scenario Outline: Cambio de nombre a la columna "Total pesos"
    When el usuario genere el reporte con la opcion de moneda "AMBAS"
    Then la columna "Total pesos" ahora debe verse como "Total quetzales" 

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte las <ColumnaImporte>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"
    
    Example:
    | OpcionMoneda | ColumnaImporte  |
    | Quetzales    | 15 Días         |
    | Ambas        | 30 Días         |
    |              | 45 Días         |
    |              | +45 Días        |
    |              | Total Quetzales |

Scenario: Cambio de nombre al total por cliente en moneda nacional
    When el usuario genere el reporte con la opcion de moneda "AMBAS"
    And consulte el total por cliente
    Then el total "TOTAL DEL CLIENTE PESOS" ahora se visualiza como "TOTAL DEL CLIENTE QUETZALES"

Scenario Outline: Signo de quetzales en total por cliente
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte el total por cliente en moneda nacional
    Then los importes en quetzales de los totales se visualizan con el signo "Q"

    Example: 
    | OpcionMoneda |
    | Quetzales    |
    | Ambas        |

Scenario Outline: Cambio de nombre al Gran total por cliente en moneda nacional
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte el Gran total por cliente
    Then el total "GRAN TOTAL PESOS" ahora se visualiza como "GRAN TOTAL QUETZALES"

    Example: 
    | OpcionMoneda |
    | Quetzales    |
    | Ambas        |

Scenario Outline: Signo de quetzales en gran total por cliente
    When el usuario genere el reporte con la <OpcionMoneda>
    And consulte el Gran total por cliente en moneda nacional
    Then los importes en quetzales de los Grandes totales se visualizan con el signo "Q"

    Example: 
    | OpcionMoneda |
    | Quetzales    |
    | Ambas        |

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato HTML
    Given que el sistema exporta el reporte "Cobranza de Facturas por viaje" a HTML
    When el usuario abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el sistema exporta el reporte "Cobranza de Facturas por viaje" en formato Excel
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
    | formulas    |
    | Autosuma    |
    | Multiplicar |
    | Promedio    |

Scenario: Aplicar adecuaciones de moneda y etiquetas en el segundo plano del reporte
  Given que el reporte se genera en segundo plano con el formato Excel y PDF
  When el usuario abra el reporte generado
  Then las adecuaciones de los escenarios anteriores se reflejan en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Cobranza de Facturas por viaje" del módulo de cobranza en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion de la moneda 
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Cobranza de Facturas por viaje" en el listado de reportes del modulo de cobranza