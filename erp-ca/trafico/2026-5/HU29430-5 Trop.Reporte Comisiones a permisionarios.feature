Feature: Tropicalizacion del reporte "Comisiones a Permisionarios" del modulo de trafico

    Yo como usuario del reporte de Comisiones a Permisionarios del modulo de trafico
    Requiero que el reporte se encuentre adaptado en temas de moneda y/o fiscales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And genera el reporte "Comisiones a Permisionarios"

Scenario: Mostrar opción de importe convertido a Quetzales en filtro de moneda
  When visualiza el filtro "Moneda"
  Then debe mostrarse la opción "Importes convertidos a quetzales" en lugar de "Importes convertidos a pesos"
  And deben permanecer disponibles las opciones "Importes convertidos a quetzales", "Importes convertidos a Dolares" e "Importes en su moneda"

Scenario Outline: Mostrar en el titulo del reporte la moneda en base a la seleccion en la pantalla de filtros.
    Given que el usuario genero el reporte con la <Opcion moneda>
    When genere el reporte 
    And visualice el titulo del reporte
    Then el reporte debe de contar con el <titulo> de acuerdo a la seleccion.

    Examples:
      | Opcion moneda                    | titulo                                                                                              |
      | Importes convertidos a quetzales | Reporte de Comisiones a Permisionarios del 01/04/2026 al 16/04/2026 Importe Convertidos a Quetzales |
      | Importes convertidos a Dólares   | Reporte de Comisiones a Permisionarios del 01/04/2026 al 16/04/2026 Importe Convertidos a Dólares   |
      | Importes en su moneda            | Reporte de Comisiones a Permisionarios del 01/04/2026 al 16/04/2026 Importe en su Moneda            |

Scenario Outline: Lectura de moneda Quetzal en columnas de moneda
    When el usuario consulte la <ColumnaMoneda>
    Then la columna muestra el dato "Quetzales" en los registros realizados en moneda quetzales

    Example: 
    | ColumnaMoneda        |
    | Moneda               |
    | Moneda Permisionario |

Scenario Outline: Colocar signo de Quetzales en importes nacionales
    When el usuario consulte las <ColumnaImporte>
    And este generando el reporte con <OpcionMoneda>
    Then los importes en quetzales de las columnas se visualizan con el signo "Q"

    Example: 
    | ColumnaImporte       | OpcionMoneda                     |
    | Importe              | Importes convertidos a quetzales |
    | Subtotal             | Importes en su moneda            |
    | Tipo de Cambio Viaje |
    | Utilidad Final       |

Scenario: Cambio de nombre al total por moneda
    When el usuario consulte el total por moneda del reporte
    Then el total se llamara "Totales Quetzales" en lugar de "Totales Pesos"

Scenario: Cambio de nombre al total general por moneda
    When el usuario consulte el total general por moneda del reporte
    Then el total se llamara "Totales Generales Quetzales" en lugar de "Totales Generales Pesos"

Scenario Outline: Colocar signo de quetzales en total por quetzales
    When el usuario consulte el total "Totales Quetzales"
    Then el importe del total se mira con el signo de quetzales "Q"

Scenario Outline: Colocar signo de quetzales en total general por quetzales
    When el usuario consulte el gran total "Totales Generales Quetzales"
    Then el importe del gran total se mira con el signo de quetzales "Q"

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Comisiones a Permisionarios" a Excel con la opcion "Exportar XLS"
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
  Given que el usuario accede al reporte "Comisiones a Permisionarios" del módulo de trafico en una base de datos de México
  When genera el reporte
  Then los importes nacionales deben mostrarse con el signo "$" tanto en vista previa y en Excel
  And la columna moneda debe de mostrar solo informacion en pesos y dolares
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Comisiones a Permisionarios" en el listado de reportes del modulo de trafico.