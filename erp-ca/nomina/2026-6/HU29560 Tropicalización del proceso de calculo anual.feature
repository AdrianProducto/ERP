Feature: Tropicalizacion del proceso "calculo anual" del modulo de nominas

    Yo como usuario del proceso de calculo anual del modulo de nominas
    Requiero que el proceso se encuentre adaptado al contexto del pais de guatemala 
    Para que el usuario se encuentre familiarizado con los registros que realizara

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al proceso de calculo anual del modulo de nominas

Scenario Outline: Signo de Quetzales en columnas con importes nacionales
    When el usuario ingrese a la <Funcion>
    And genera el calculo del anual
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example:
    | Funcion   | ColumnasConImporte      |
    | Agregar   | Ingresos Totales        |
    | Modificar | Base Gravada Acumulada  |
    | Consultar | Base Gravada Proyectada |
    |           | Base Gravada Proyectada |
    |           | Impuesto Anual          |

Scenario: Ocultar columna "Art. 152"
    When el usuario ingrese a la <Funcion>
    And el usuario ejecute la funcion "Revision y calculo"
    And consulte las columnas generadas en el proceso
    Then la columna "Art. 152" no es visible para los usuarios

    Example:
    | Funcion   |
    | Agregar   |
    | Modificar |
    | consultar |

Scenario: Ocultar la funcion "Formato 37"
    When el usuario ingrese a la funcion "Agregar"
    And consulte las funciones del proceso
    Then la funcion "Formato 37" no es visible para los usuarios

    Example:
    | Funcion   |
    | Agregar   |
    | Modificar |
    | consultar |

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el calculo anual a Excel con la funcion "Excel"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Mantener comportamiento actual del proceso para bases de datos de México
  Given que el usuario accede al proceso "calculo anual" del módulo de nominas en una base de datos de México
  When consulte el proceso
  Then el Proceso no debe de presentar ningun cambio referente a la tropicalizacion
  And el Proceso  debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el Proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el Proceso "calculo anual" en el listado de Procesos del modulo de nominas