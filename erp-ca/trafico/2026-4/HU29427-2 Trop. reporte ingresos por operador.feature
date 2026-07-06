Feature: Tropicalizacion del reporte "Ingresos por operador"
    Yo como usuario del reporte de ingresos por operador del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o informacion fiscal
    Para que el reporte encaje con las actividades realziadas en el pais de guatemala.

Background: Given que el usuario se encuentra dentro de una base de datos configurado con el pais de Guatemala y genera el reporte "Ingresos por operador"

Scenario: Soportar moneda Quetzales en el reporte de ingresos por operador.
  Then el reporte debe soportar la moneda "Quetzales"
  And los importes nacionales deben mostrarse en quetzales

Scenario: Mostrar opción de importes en moneda Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a pesos" e "Importes en su moneda"

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <Opcion moneda>
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples:
        |Opcion moneda                    | titulo                                                                                                                     |
        |Importes convertidos a quetzales | Reporte ingresos por operador detallado del 01/03/2026 al 26/03/2026 por fecha de liquidación Importes convertidos a quetzales |
        |Importes convertidos a Dólares   | Reporte ingresos por operador detallado del 01/03/2026 al 26/03/2026 por fecha de liquidación Importes convertidos a dólares   |
        |Importes en su moneda            | Reporte ingresos por operador detallado del 01/03/2026 al 26/03/2026 por fecha de liquidación Importes en su moneda            |

Scenario: Mostrar signo de quetzales en columnas de importes.
    When el usuario visualice las siguientes columnas:
    |Columnas con importes |
    |Ingresos              |
    |Tipo de cambio        |
    |Sueldo operador       |
    |Comision por viaje    |
    |Estadia               |
    |Comision por objetivos|
    |Estadia Cambiar       |
    |Otras percepciones    |
    |Adeudo liq. anterior  |
    |pension alimenticia   |
    |diferencia gastos     |
    |prestamo personal     |
    |neto a pagar          |
    Then el sistema debe de mostrar los importes de las columnas con el signo de quetzales "Q".

Scenario: Cambio de nombre de columna "RFC" por "NIT"
    When el usuario mire el reporte generado
    Then el reporte debera de mostrar el nombre "NIT" en lugar de "RFC" en la columna que muestra el numero de identificacion fiscal.

Scenario: Cambio de nombre de columna "CURP" por "CUI"
    When el usuario mire el reporte generado
    Then el reporte debera de mostrar el nombre "CUI" en lugar de "CURP" en la columna que muestra el codigo unico de identificacion.

Scenario: Cambio de etiqueta en grandes totales de moneda nacional
    When el usuario visualice los <grandes totales> 
    Then el reporte debera de mostrarse con las <nuevas etiquetas>

    Examples: Nuevas etiqutas
        |grandes totales      | nuevas etiquetas         |
        |Total operador pesos | Total operador quetzales |
        |Total general pesos  | Total general quetzales  |

Scenario: Considerar los cambios en todos los tipos de reporte
    When el usuario seleccione la <Opcion> en el filtro "Tipo Reporte"
    Then el reporte debe de contar con todos los ajustes realizados en moneda y etiquetas.

    Example:
    |Opcion            |
    |Reporte Detallado |
    |Reporte Acumulado |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "ingresos por operador" a Excel
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And  las columnas de RFC y CURP deben de tener las nuevas etiquetas NIT y CUI
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "ingresos por operador" a PDF
    When abre el archivo generado
    Then los importes nacionales deben mostrar el signo "Q" de manera correcta
    And las columnas de RFC y CURP deben de tener las nuevas etiquetas NIT y CUI

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el suario exporta el reporte "Gastos de viaje por liquidacion" a PDF
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Ingresos por operador" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then el filtro "Moneda" debe conservar la opción "Importes convertidos a Pesos"
  And Las columnas deben de conservar el nombre "RFC" y "CURP"
  And los importes nacionales deben mostrarse con el signo "$" tanto en vista previa como en Excel
  And la etiqueta fiscal debe mostrarse como "RFC" en la version PDF
  
Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Ingresos por operador" en el listado de reportes del modulo de trafico.
   









