Feature: Tropicalizacion de la funcion "Base IMPAC" del proceso de activos fijos del modulo de contabilidad.

    Yo como usuario del proceso de activos fijos
    requiero que el reporte "Base IMPAC" se encuentre tropicalizado a la moneda de guatemala
    Para que la funcion se encuentre sincronizada con las actividades del pais de guatemala.

Background: Given que el usuario accede al proceso de activos fijos en una base de datos de Guatemala.

Scenario: Mostrar signo de quetzales en columnas de importes monetarios.
    When el usuario genere el reporte de base IMPAC
    And consulte las siguientes columnas:
    |Columnas con importes        |
    |M.O.I                        |
    |Dep. Acum. Contable          |
    |Depreciación Act. Ejercicio  |
    |Saldo x Ded.                 |
    |Depreciación Anual           |
    |Saldo Deduc. Actualizado     |
    |Depreciación Mensual         |
    |50% Deprec. Act. Anual       |
    |Depreciación en el ejercicio |
    |Base IMPAC Meses Uso         |
    Then los importes de las columnas las visualiza con el signo de quetzales "Q"

Scenario: Cambio de la etiqueta "RFC" por "NIT" en encabezado del reporte
    When el usuario consulte el encabezado del reporte generado
    Then el sistema muestra la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Base IMPAC" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los importes nacionales deben mostrar el signo "Q" de manera correcta
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

  Example: Formulas que el usuario podria aplicar en excel.
  |formulas    |
  |Autosuma    |
  |Multiplicar |
  |Promedio    |

Scenario: Mantener comportamiento actual del reporte base IMPAC para bases de datos de México
  Given que el usuario accede al proceso de activos fijos en una base de datos de México
  And utiliza la funcion "Base IMPAC"
  When el usuario genera el reporte
  Then los campos monetarios deben mostrarse con el signo "$"
  And no deben aplicarse los cambios de visualización en la etiqueta RFC del encabezado del reporte
  And el proceso debe conservar su funcionamiento actual sin afectaciones