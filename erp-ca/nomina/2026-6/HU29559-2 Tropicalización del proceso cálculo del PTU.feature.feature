Feature: Tropicalizacion del proceso "PTU" del modulo de nominas

    Yo como usuario del proceso de PTU del modulo de nominas
    Requiero que el proceso se encuentre adaptado al contexto del pais de guatemala 
    Para que el usuario se encuentre familiarizado con los registros que realizara

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al proceso de PTU del modulo de nominas

Scenario Outline: Signo de Quetzales en columnas con importes del Excel
    When el usuario genera el calculo del PTU
    And consulte las <ColumnasConImporte> del excel generado
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    Example:
    | ColumnasConImporte                                         |
    | Salario Devengado (Acumulado para PTU)                     |
    | Salario devengado definitivo (Tope 1.2 por PTUSindMasGano) |
    | Cantidad por días                                          |
    | Cantidad por importe                                       |
    | Total                                                      |

Scenario: Mantener comportamiento actual del proceso para bases de datos de México
  Given que el usuario accede al proceso "PTU" del módulo de nominas en una base de datos de México
  When consulte el proceso
  Then el Proceso no debe de presentar ningun cambio referente a la tropicalizacion
  And el Proceso  debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el Proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el Proceso "PTU" en el listado de Procesos del modulo de nominas