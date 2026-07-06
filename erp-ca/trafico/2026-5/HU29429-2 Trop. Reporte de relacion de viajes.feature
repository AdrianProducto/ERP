Feature: Tropicalizacion del reporte "Relación de Viajes para Uso de Tráfico" del modulo de trafico

    Yo como usuario del reporte Relación de Viajes para Uso de Tráfico del modulo de trafico
    Requiero que el reporte se encuentre adaptado para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Relación de Viajes para Uso de Tráfico"

Scenario: Ajuste en filtro "Convertir Moneda"
    When el usuario consulte el filtro "Convertir Moneda"
    And abra el combo "Convertir"
    Then el combo debe de contar con las siguientes opciones:
    |Convertir          |
    |Dolares a Quetzales|
    |Quetzales a dolares|
    And el filtro debe de continuar con la misma logica de conversion pero orientado a quetzales.

Scenario: Signo quetzal en el campo "T.C"
    When el usuario consulte el filtro "Convertir Moneda"
    Then el campo "T.C." debe de visualizarse con signo de quetzales "Q"

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <Opcion moneda>
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples: 
        |Opcion moneda       | titulo                                                                                                                                   |
        |Dolares a Quetzales | Reporte de relación de viajes para uso de tráfico del 01/04/2026 al 08/04/2026 convirtiendo importes a Quetzales del cliente TRANSPORTES |
        |Quetzales a dolares | Reporte de relación de viajes para uso de tráfico del 01/04/2026 al 08/04/2026 convirtiendo importes a dólares del cliente TRANSPORTES   |

Scenario Outline: Colocar signo de quetzales en columnas de importes nacionales.
    When el usuario genere el reporte con la opcion "Dolares a Quetzales"
    Then las <columnas> de importes se deberan de ver con el signo de quetzales "Q"
    And mostrar las conversiones de manera correcta.

    Examples:
        | columnas         |
        | Flete            |
        | Repartos         |
        |Suma de conceptos | 

Scenario Outline: Funcionamiento habitual para importes en dolares
    When el usuario genere el reporte con la opcion "Quetzales a Dolares"
    Then las <columnas> de importes deberan de continuar viendose con el signo "$"
    And mostrar las conversiones de manera correcta.

    Examples:
        | columnas         |
        | Flete            |
        | Repartos         |
        |Suma de conceptos |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Relación de Viajes para Uso de Tráfico" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Relación de Viajes para Uso de Tráfico" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Relación de Viajes para Uso de Tráfico" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Aplicar adecuaciones de moneda en el segundo plano del reporte
  When el reporte genera información en el segundo plano en los formatos PDF y Excel
  Then las adecuaciones de moneda aplicadas en el reporte principal deben reflejarse también en el segundo plano

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Relación de Viajes para Uso de Tráfico" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el filtro "Convertir Moneda" debe conservar las opciónes "Dolares a Pesos" y "Pesos a dolares"
  And los importes nacionales deben mostrarse con el signo "$" tanto en vista previa, en Excel y PDF y su segundo plano
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  And el excel debe de seguir generandose con signo "$"
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Relación de Viajes para Uso de Tráfico" en el listado de reportes del modulo de trafico.