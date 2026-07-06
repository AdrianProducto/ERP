Feature: Tropicalizacion del proceso de activos fijos del modulo de contabilidad.

    Yo como usuario del proceso de activos fijos del modulo de contabilidad
    Requiero que la moneda utilizada en el proceso sean quetzales
    para que el proceso este de acuerdo a las actividades del pais de guatemala.

Background: Given que el usuario accede al proceso de activos fijos en una base de datos de Guatemala.

Scenario: Mostrar signo de quetzales en campo MOI de depreciación contable
    When consulta la seccion "Datos generales"
    Then el campo MOI debe de mostrarse con el signo de quetzales.

Scenario: Mostrar signo de quetzales en depreciación acumulada de depreciación contable
  Given que el usuario accede a la pestaña "Datos para depreciación contable"
  When visualiza el campo "Depreciación acumulada"
  Then el campo debe mostrar el signo "Q"

Scenario: Mostrar signo de quetzales en depreciación acumulada de depreciación fiscal
  Given que el usuario accede a la pestaña "Datos para depreciación fiscal"
  When visualiza el campo "Depreciación acumulada"
  Then el campo debe mostrar el signo "Q"

Scenario: Mostrar signo de quetzales en depreciación acumulada actualizada de depreciación fiscal
  Given que el usuario accede a la pestaña "Datos para depreciación fiscal"
  When visualiza el campo "Depreciación acumulada actualizada"
  Then el campo debe mostrar el signo "Q"

Scenario: Mostrar signo de quetzales en columna importe del historial
  Given que el usuario accede a la función "Historial" dentro de activos fijos
  When consulta la columna "Importe"
  Then los importes deben mostrar el signo "Q"

Scenario: Validar que el signo de quetzales en pólizas contables desde historial continue mostrandose
  Given que el usuario consulta pólizas contables desde la función "Historial"
  When visualiza la columna "Tipo de cambio"
  Then la columna debe mostrar importes con signo "Q"

Scenario: Adaptar la funcion "Depreciar"
  When el usuario utilice la funcion "Depreciar" del proceso de activos fijos
  And consulta el archivo generado
  Then el archivo muestra los importes nacionales con signo de quetzales.

Scenario: Aplicar signo de quetzales en el layout de importacion de activos fijos
  Given que el usuario ingreso a la funcion de importacion del proceso de activos fijos
  And descargo el layout de importacion de la funcion
  When el usuario consulta el layout de importacion
  Then las columnas siguientes columnas del layout muestran el signo de quetzales:
  |ColumnasImportes                  |
  |MOI                               |
  |depreciación acumulada            |
  |depreciación acumulada actualizada|

Scenario: Mantener comportamiento actual del proceso de activos fijos para bases de datos de México
  Given que el usuario accede al proceso de activos fijos en una base de datos de México
  When consulta cualquiera de las pestañas de depreciación o la función "Historial"
  Then los campos monetarios deben mostrarse con el signo "$"
  And no deben aplicarse los cambios de visualización correspondientes a quetzales
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El proceso de activos fijos es visible en base de datos de guatemala.
  Given que el proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el proceso "Activos fijos" dentro del modulo de contabilidad.