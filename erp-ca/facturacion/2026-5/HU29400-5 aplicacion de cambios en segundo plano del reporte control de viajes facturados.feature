Feature: Tropicalización en generación en segundo plano del reporte "Control de Viajes Facturados"

    Como usuario del reporte "Control de viajes facturados"
    Requiero que el reporte en segundo plano cuente con los cambios previamente aplicados al reporte principal en la HU29400-3
    para que ambas versiones funcionen en sincronia

  Background:
    Given que el usuario se encuentra en una base de datos del país de Guatemala
    And el sistema genera el reporte en segundo plano al sobrepasar el máximo de registros

Scenario Outline: Título del reporte en segundo plano solo en Quetzales
    When el usuario genera el reporte con la opción de moneda "Quetzales" en <Formato>
    Then el título del reporte generado debe ser:
      "Reporte Control de Viajes Facturados del 01/01/2025 al 03/02/2026 en Quetzales"

    Example:
    | Formato |
    | Excel   |
    | PDF     |

Scenario Outline: Título del reporte en segundo plano en ambas monedas
    When el usuario genera el reporte con la opción de moneda "Ambas" en <Formato>
    Then el título del reporte generado debe ser:
      "Reporte Control de Viajes Facturados del 01/01/2025 al 03/02/2026 en Quetzales y Dólares"
    
    Example:
    | Formato |
    | Excel   |
    | PDF     |

Scenario: Visualización de moneda Quetzales en columna "Moneda Factura" en segundo plano
    When el usuario genera el reporte en <Formato>
    Then la columna "Moneda Factura" debe mostrar "Quetzales" en los registros correspondientes

    Example:
    | Formato |
    | Excel   |
    | PDF     |

Scenario: Visualización del símbolo Q en columna "Importe" en segundo plano
    When el usuario genera el reporte en <Formato>
    Then los importes en moneda Quetzales deben mostrarse con el símbolo "Q"

    Example:
    | Formato |
    | Excel   |
    | PDF     |

Scenario Outline: funcionamiento de formulas en Excel en segundo plano
  Given que el usuario exporta el reporte "control de viajes facturados" a Excel en segundo plano
  When abre el archivo generado
  Then las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Visualización de etiqueta NIT en PDF generado en segundo plano
    When el usuario genera el reporte en formato PDF
    Then la etiqueta "RFC" debe mostrarse como "NIT"

Scenario Outline: Mantener comportamiento actual del reporte para bases de datos de México
    Given que el usuario se encuentra dentro de una base de datos del pais de México
    When el sistema genera el reporte en segundo plano del <Formato> al sobrepasar el máximo de registros
    Then el reporte no muestra los cambios de la tropicalizacion a guatemala

    Example:
    | Formato |
    | Excel   |
    | PDF     |